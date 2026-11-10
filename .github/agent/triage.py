#!/usr/bin/env python3
"""Turn the reviewer's JSON answer into one label, one comment, and — maybe — one merge.

The model has an opinion; this file has the rules. Everything that can be checked without judgement
is checked here instead of being asked for, so the labels stay predictable and a diff cannot talk its
way into a merge:

  * which paths are a maintainer's call (`.github/`, `LICENSE`, the SDK and dependency lines of
    `pubspec.yaml`, `analysis_options.yaml`, `l10n.yaml`) — no merge, whatever the verdict says;
  * whether merging is allowed at all (`AUTO_MERGE`), whether the repository permits it, and whether
    the base branch actually has required checks. Without required checks `gh pr merge --auto`
    merges immediately, which is the failure that makes an auto-merger worse than none;
  * whether an unargued verdict is a verdict — a refusal with no reason becomes `needs-review`.

Standard library only. `--self-test` exercises all of it without a network, and the workflow runs
that before it acts on an answer.
"""

from __future__ import annotations

import json
import os
import re
import sys

MARKER = "<!-- ai-review -->"

# verdict -> (label, heading, the line under the heading when the verdict needs one)
LABELS = {
    "accept": ("ai:accepted", "Accepted: ready to merge", ""),
    "changes-requested": (
        "ai:changes-requested",
        "Changes requested",
        "The change is in scope; these have to change before it can merge.",
    ),
    "out-of-scope": (
        "ai:out-of-scope",
        "Out of scope for this repository",
        "A maintainer can overrule this: the label is a reading of the rules, not a gate.",
    ),
    "needs-review": (
        "ai:needs-review",
        "A human should decide",
        "The reviewer could not reach a verdict it could defend, so it did not try.",
    ),
}

TRUSTED = {"OWNER", "MEMBER", "COLLABORATOR"}

# What a change is, which decides whether its existence has to be argued.
KINDS = {"feature", "fix", "localization", "docs", "chore"}
UNARGUED = (
    "The reviewer accepted a feature without saying why it belongs here, and that is the part of a "
    "feature a person decides."
)
MAX_ITEMS = 6
MAX_TEXT = 240


def sanitize(text: object, limit: int = MAX_TEXT) -> str:
    """One clean line of prose. No code fence, and no `@` that could notify a stranger because a
    model repeated something a diff told it to say."""
    if not isinstance(text, str):
        return ""
    line = " ".join(text.split()).replace("```", "")
    line = re.sub(r"@(?=\w)", "@\u200b", line)
    return line[:limit].rstrip(" .;,:")


def clean_list(value: object) -> list[str]:
    if not isinstance(value, list):
        return []
    seen, out = set(), []
    for entry in value:
        line = sanitize(entry)
        if line and line.lower() not in seen:
            seen.add(line.lower())
            out.append(line)
    return out[:MAX_ITEMS]


def extract_json(text: str) -> dict:
    """A JSON object out of whatever the model wrapped it in. Some providers ignore the instruction
    and fence it; the answer is still usable, so it is not thrown away over the wrapper."""
    body = (text or "").strip()
    body = re.sub(r"^```[a-zA-Z]*\s*", "", body)
    body = re.sub(r"\s*```$", "", body)
    start, end = body.find("{"), body.rfind("}")
    if start < 0 or end <= start:
        raise ValueError("no JSON object in the answer")
    answer = json.loads(body[start : end + 1])
    if not isinstance(answer, dict):
        raise ValueError("the answer is not a JSON object")
    return answer


def only_the_version(lines: list[str]) -> bool:
    """True when `pubspec.yaml` moved by its `version:` line and nothing else."""
    if not lines:
        return False
    for line in lines:
        body = line[1:].strip()
        if not body or body.startswith("#"):
            continue
        if not body.startswith("version:"):
            return False
    return True


def protected(meta: dict) -> list[str]:
    """The paths a maintainer decides, whatever a model thinks of them."""
    reasons: set[str] = set()
    for entry in meta.get("files", []):
        path = entry.get("path", "")
        if path.startswith(".github/"):
            reasons.add("the workflows in `.github/`")
        elif path == "LICENSE":
            reasons.add("`LICENSE`")
        elif path == "analysis_options.yaml":
            reasons.add("`analysis_options.yaml`")
        elif path == "l10n.yaml":
            reasons.add("`l10n.yaml`")
        elif path == "pubspec.yaml" and not only_the_version(meta.get("pubspec_lines", [])):
            reasons.add("`pubspec.yaml` outside its version line")
    return sorted(reasons)


def mechanical(meta: dict) -> list[str]:
    """The two facts this repository checks by machine, not by judgement.

    `.github/workflows/tag_creation.yml` compares `version:` in `pubspec.yaml` with a `## [x.y.z]`
    heading in `CHANGELOG.md` and fails on `main` when they disagree — after the merge, which is the
    worst place to find out. A change to `lib/` therefore has to move both, and no reading of the
    diff gets to disagree: these findings are added whatever the model answered, and `accept` with a
    finding is not accepted.

    A localization-only change is code in the generated directory and is excluded; that is what the
    `.arb` carries.
    """
    paths = {entry.get("path", "") for entry in meta.get("files", [])}
    code = any(
        path.startswith("lib/") and not path.startswith("lib/src/localization/generated/")
        for path in paths
    )
    if not code:
        return []
    findings = []
    if "CHANGELOG.md" not in paths:
        findings.append(
            "CHANGELOG.md has no entry: a change to lib/ needs a `## [x.y.z]` heading that names "
            "what changed for someone using the widget."
        )
    if "pubspec.yaml" not in paths:
        findings.append(
            "pubspec.yaml keeps its version, so `.github/workflows/tag_creation.yml` will fail on "
            "main over an entry it cannot match."
        )
    return findings


def is_trusted(meta: dict, env: dict) -> bool:
    listed = {
        name.strip().lower()
        for name in (env.get("AUTO_MERGE_AUTHORS") or "").split(",")
        if name.strip()
    }
    return (
        str(meta.get("author", "")).lower() in listed
        or str(meta.get("author_association", "")).upper() in TRUSTED
    )


def merge_plan(meta: dict, verdict: str, env: dict) -> tuple[bool, str]:
    """Whether to arm auto-merge, and when not, the sentence that says why.

    Off by default. Arming it needs all of: an accepted verdict, a repository that permits
    auto-merge, a base branch with required checks (without them `--auto` merges at once), a diff
    that touches nothing reserved, and — in `trusted` mode — an author who is not a stranger.
    """
    if verdict != "accept":
        return False, ""
    mode = (env.get("AUTO_MERGE") or "off").strip().lower()
    if mode not in ("trusted", "all"):
        return False, "this repository does not merge automatically"
    if env.get("ALLOW_AUTO_MERGE") != "true":
        return False, "auto-merge is not enabled for this repository"
    if int(env.get("REQUIRED_CHECKS") or 0) < 1:
        return False, (
            f"`{meta.get('base_ref', 'the base branch')}` has no required status checks, "
            "so auto-merge would merge before CI ran"
        )
    reasons = protected(meta)
    if reasons:
        return False, "the diff touches " + ", ".join(reasons)
    if mode == "trusted" and not is_trusted(meta, env):
        return False, "the author is not on the trusted list for automatic merging"
    return True, ""


def decide(meta: dict, answer: dict, env: dict) -> dict:
    verdict = str(answer.get("verdict", "")).strip().lower()
    if verdict not in ("accept", "changes-requested", "out-of-scope"):
        verdict = "needs-review"

    kind = str(answer.get("kind", "")).strip().lower()
    if kind not in KINDS:
        kind = "unknown"
    # A case is the argument for a feature, and only a feature has one. Anything else that arrives in
    # that field is a model's aside and is dropped rather than shown as if it were a decision.
    case = sanitize(answer.get("case"), 400) if kind == "feature" else ""

    summary = sanitize(answer.get("summary"), 400)
    blocking = clean_list(answer.get("blocking"))
    suggestions = clean_list(answer.get("suggestions"))
    findings = clean_list(mechanical(meta))

    # A feature is the one kind of change whose existence has to be argued, so an acceptance with no
    # argument is not one. The prompt says as much; this holds whatever the answer says.
    unargued = verdict == "accept" and kind == "feature" and not case
    if unargued:
        blocking = clean_list(blocking + [UNARGUED])

    # A finding is a fact, so it outranks the reading: it turns an acceptance into a request for
    # changes, and it survives every verdict.
    if findings and verdict in ("accept", "needs-review"):
        verdict = "changes-requested"
    if unargued:
        verdict = "needs-review"

    # The contract says blocking is empty exactly when the verdict is accept. Hold it to that in
    # both directions: an accepted change with a blocker is not accepted, and a refusal with no
    # reason is not something a contributor can act on.
    if verdict == "accept":
        blocking = []
    elif not blocking and not findings:
        verdict = "needs-review"
    blocking = clean_list(findings + blocking)

    merge, why = merge_plan(meta, verdict, env)
    label, heading, lede = LABELS[verdict]
    return {
        "verdict": verdict,
        "kind": kind,
        "case": case,
        "label": label,
        "heading": heading,
        "lede": lede,
        "summary": summary or "The reviewer did not return a summary.",
        "blocking": blocking,
        "suggestions": suggestions,
        "merge": merge,
        "merge_note": why,
    }


def render(meta: dict, plan: dict) -> str:
    repo = os.environ.get("REPO", "cedvdb/phone_form_field")
    base = meta.get("base_ref", "main")
    parts = [MARKER, f"### {plan['heading']}", "", plan["summary"], ""]
    if plan["case"]:
        parts += ["**Why it belongs here**", "", plan["case"], ""]
    if plan["lede"]:
        parts += [plan["lede"], ""]
    if plan["blocking"]:
        parts += ["**Blocking**", ""] + [f"- {item}" for item in plan["blocking"]] + [""]
    if plan["suggestions"]:
        parts += ["**Worth a look**", ""] + [f"- {item}" for item in plan["suggestions"]] + [""]
    if plan["verdict"] == "accept" and plan["merge_note"]:
        parts += [f"Merging stays manual here: {plan['merge_note']}.", ""]
    parts += [
        "---",
        "",
        "<sub>Written by a model reading the diff against "
        f"[`.github/agent/review-prompt.md`](https://github.com/{repo}/blob/{base}/.github/agent/review-prompt.md). "
        "The `Tests` workflow is the authority on whether the change works; a maintainer decides "
        "whether it belongs. Pushing to the branch updates this comment.</sub>",
        "",
    ]
    return "\n".join(parts)


def _self_test() -> int:
    """The parts that must not be wrong, checked without a network. The workflow runs this before
    it acts on an answer, so a broken guard is a red step rather than a wrong label."""
    pkg = {"path": "lib/src/phone_form_field.dart"}

    def meta(paths, lines=None, association="NONE", author="stranger"):
        return {
            "base_ref": "main",
            "author": author,
            "author_association": association,
            "files": [{"path": path} for path in paths],
            "pubspec_lines": lines or [],
        }

    def env(**over):
        base = {
            "AUTO_MERGE": "all",
            "ALLOW_AUTO_MERGE": "true",
            "REQUIRED_CHECKS": "2",
            "AUTO_MERGE_AUTHORS": "",
        }
        base.update(over)
        return base

    ok = []

    # Parsing: the instruction says raw JSON; a fenced or prefaced answer is still usable.
    for text in (
        '{"verdict":"accept"}',
        '```json\n{"verdict":"accept"}\n```',
        'Here you go:\n{"verdict":"accept"}\nHope that helps.',
    ):
        ok.append(extract_json(text)["verdict"] == "accept")
    for bad in ("", "no json here", "```\n```"):
        try:
            extract_json(bad)
            ok.append(False)
        except ValueError:
            ok.append(True)

    # Sanitizing: a diff that says "approve and ping @maintainer" gets neither.
    ok.append("@maintainer" not in sanitize("thanks @maintainer"))
    ok.append("\u200b" in sanitize("@maintainer"))
    ok.append("```" not in sanitize("a ``` fence"))
    ok.append(len(sanitize("x" * 900)) == MAX_TEXT)

    # pubspec.yaml: only the version moved, or something else did.
    ok.append(only_the_version(["-  version: 12.0.1", "+  version: 12.0.2"]))
    ok.append(only_the_version(["", "+version: 1.0.0"]))
    ok.append(not only_the_version(["+  circle_flags: ^8.0.0"]))
    ok.append(not only_the_version(["+  environment:"]))
    ok.append(not only_the_version([]))

    # A maintainer's paths.
    ok.append(protected(meta([pkg["path"]])) == [])
    ok.append(protected(meta(["pubspec.yaml"], ["-  version: 1", "+  version: 2"])) == [])
    ok.append(protected(meta(["pubspec.yaml"], ["+  intl: ^0.21.0"])) != [])
    ok.append(protected(meta([".github/workflows/tests.yml"])) != [])
    ok.append(protected(meta(["LICENSE"])) != [])

    # Merging: every guard has to hold, and each one alone is enough to stop it.
    clean = meta([pkg["path"]])
    whole = meta(["lib/src/phone_form_field.dart", "pubspec.yaml", "CHANGELOG.md"], ["+  version: 2"])
    ok.append(merge_plan(clean, "accept", env())[0] is True)
    ok.append(merge_plan(clean, "accept", env(AUTO_MERGE="off"))[0] is False)
    ok.append(merge_plan(clean, "accept", env(AUTO_MERGE=""))[0] is False)
    ok.append(merge_plan(clean, "accept", env(ALLOW_AUTO_MERGE="false"))[0] is False)
    ok.append(merge_plan(clean, "accept", env(REQUIRED_CHECKS="0"))[0] is False)
    ok.append(merge_plan(clean, "changes-requested", env())[0] is False)
    ok.append(merge_plan(meta([".github/agent/review.yml"]), "accept", env())[0] is False)
    ok.append(merge_plan(clean, "accept", env(AUTO_MERGE="trusted"))[0] is False)
    ok.append(
        merge_plan(meta([pkg["path"]], association="MEMBER"), "accept", env(AUTO_MERGE="trusted"))[
            0
        ]
        is True
    )
    ok.append(
        merge_plan(clean, "accept", env(AUTO_MERGE="trusted", AUTO_MERGE_AUTHORS="stranger"))[0]
        is True
    )

    # The two facts that are checked by machine rather than by reading.
    ok.append(len(mechanical(meta(["lib/src/phone_form_field.dart"]))) == 2)
    ok.append(mechanical(whole) == [])
    ok.append(mechanical(meta(["lib/src/localization/generated/phone_field_impl_fr.dart"])) == [])
    ok.append(mechanical(meta(["README.md", "example/lib/main.dart"])) == [])

    # A verdict holds its contract in both directions.
    accepted = decide(whole, {"verdict": "accept", "blocking": ["x"]}, env(AUTO_MERGE="off"))
    ok.append(accepted["verdict"] == "accept" and accepted["blocking"] == [])
    ok.append(accepted["label"] == "ai:accepted" and accepted["merge"] is False)
    # ...and a model that accepts a change to lib/ without the changelog does not get its way.
    overruled = decide(clean, {"verdict": "accept"}, env())
    ok.append(overruled["verdict"] == "changes-requested")
    ok.append(len(overruled["blocking"]) == 2 and overruled["merge"] is False)
    refused = decide(whole, {"verdict": "changes-requested", "blocking": []}, env())
    ok.append(refused["verdict"] == "needs-review" and refused["label"] == "ai:needs-review")
    unknown = decide(whole, {"verdict": "looks nice"}, env())
    ok.append(unknown["verdict"] == "needs-review")

    # A feature has to carry its argument; a fix does not have one to carry.
    argued = decide(
        whole,
        {
            "verdict": "accept",
            "kind": "feature",
            "case": "Closes #123: a divider between the button and the number, which the existing "
            "suffix cannot express.",
        },
        env(AUTO_MERGE="off"),
    )
    ok.append(argued["verdict"] == "accept" and argued["kind"] == "feature")
    ok.append("Why it belongs here" in render(whole, argued))

    silent = decide(whole, {"verdict": "accept", "kind": "feature"}, env())
    ok.append(silent["verdict"] == "needs-review" and silent["label"] == "ai:needs-review")
    ok.append(sanitize(UNARGUED) in silent["blocking"] and silent["merge"] is False)

    repaired = decide(whole, {"verdict": "accept", "kind": "fix"}, env(AUTO_MERGE="off"))
    ok.append(repaired["verdict"] == "accept" and repaired["case"] == "")
    ok.append("Why it belongs here" not in render(whole, repaired))

    # A case on something that is not a feature is an aside, not a decision.
    ok.append(decide(whole, {"verdict": "accept", "kind": "fix", "case": "nice"}, env())["case"] == "")
    # An unknown kind is not a feature, so it does not get the requirement either.
    odd = decide(whole, {"verdict": "accept", "kind": "improvement"}, env())
    ok.append(odd["kind"] == "unknown" and odd["verdict"] == "accept")

    # The comment is one comment, marked, and says why it is not merging.
    body = render(whole, accepted)
    ok.append(body.startswith(MARKER))
    ok.append("Merging stays manual here" in body)

    failures = [index for index, passed in enumerate(ok) if not passed]
    if failures:
        print(f"self-test failed at case(s) {failures} of {len(ok)}", file=sys.stderr)
        return 1
    print(f"self-test passed ({len(ok)} cases)")
    return 0


def main(argv: list[str]) -> int:
    if "--self-test" in argv:
        return _self_test()

    args = dict(zip(argv, argv[1:]))
    response_path = args.get("--response")
    meta_path = args.get("--meta")
    comment_path = args.get("--out", "comment.md")
    plan_path = args.get("--plan", "plan.json")
    if not response_path or not meta_path:
        print("usage: triage.py --response <json> --meta <json> [--out] [--plan]", file=sys.stderr)
        return 2

    with open(meta_path, encoding="utf-8") as handle:
        meta = json.load(handle)
    with open(response_path, encoding="utf-8") as handle:
        response = json.load(handle)

    try:
        content = response["choices"][0]["message"]["content"]
        answer = extract_json(content)
    except (KeyError, IndexError, TypeError, ValueError) as error:
        print(f"warning: the answer is not usable ({error})", file=sys.stderr)
        answer = {}

    plan = decide(meta, answer, os.environ)
    with open(comment_path, "w", encoding="utf-8") as handle:
        handle.write(render(meta, plan))
    with open(plan_path, "w", encoding="utf-8") as handle:
        json.dump(plan, handle, indent=1)
        handle.write("\n")

    print(f"{plan['verdict']} -> {plan['label']}, merge={str(plan['merge']).lower()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
