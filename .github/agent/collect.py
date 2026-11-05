#!/usr/bin/env python3
"""Build the text the reviewer reads: the pull request, and its diff.

Everything here comes from the GitHub API as *data*. The pull request's tree is never checked out
and none of its code is run — that is what makes the `pull_request_target` trigger in
`.github/workflows/review.yml` safe, and it is the property to preserve before adding anything here.

Two economies matter for the result: the diff is ordered so that code and configuration come first,
and the bodies of generated and locked files are replaced by the line they already occupy in the file
list. A localization pull request here is thirty `.arb` files, and a reviewer that spends its whole
window on them never sees `lib/`.

Standard library only, so this runs on a stock runner with no install step.
"""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys

# A diff bigger than this is a diff nobody reads; the file list above it carries the shape.
MAX_DIFF = int(os.environ.get("REVIEW_DIFF_LIMIT", "60000"))

# Bodies that are generated or locked: the file list says they changed, the diff adds nothing.
OMITTED_BODY = (
    re.compile(r"(^|/)pubspec\.lock$"),
    re.compile(r"^lib/src/localization/generated/"),
    re.compile(r"(^|/)build/"),
)

# Configuration and prose first, then the template locale, then the code, then the translations.
RANKED = {
    "pubspec.yaml": 0,
    "l10n.yaml": 0,
    "analysis_options.yaml": 0,
    "LICENSE": 0,
    "README.md": 1,
    "CHANGELOG.md": 1,
}


def gh(*args: str) -> str:
    """Run the GitHub CLI and return its stdout, failing loudly rather than silently."""
    result = subprocess.run(("gh", *args), capture_output=True, text=True, check=False)
    if result.returncode != 0:
        raise SystemExit(
            f"gh {' '.join(args)} failed ({result.returncode}): {result.stderr.strip()[:400]}"
        )
    return result.stdout


def rank(path: str) -> int:
    if path in RANKED:
        return RANKED[path]
    if path.startswith(".github/"):
        return 0
    if path == "l10n/en.arb":
        return 1
    if path.startswith(("lib/", "test/")):
        return 2
    if path.startswith("example/"):
        return 3
    if path.startswith("l10n/"):
        return 4
    return 5


def split_diff(text: str) -> list[tuple[str, str]]:
    """One entry per file, in the diff's own order, keyed by the file's new path."""
    chunks = re.split(r"(?m)^diff --git ", text)
    files: list[tuple[str, str]] = []
    for chunk in chunks[1:]:
        first_line = chunk.split("\n", 1)[0]
        match = re.match(r"a/(.+) b/(.+)$", first_line)
        path = match.group(2) if match else first_line
        files.append((path.strip(), "diff --git " + chunk))
    return files


def is_binary(chunk: str) -> bool:
    return "Binary files " in chunk or "\nGIT binary patch\n" in chunk


def version_lines(chunk: str) -> list[str]:
    """The added and removed lines of `pubspec.yaml`, so the decision can tell whether only the
    version moved or a dependency or the SDK bound did too."""
    lines = []
    for line in chunk.split("\n"):
        if line.startswith(("+++", "---")):
            continue
        if line.startswith(("+", "-")):
            lines.append(line[:200])
    return lines


def main(argv: list[str]) -> int:
    out_md = "change.md"
    out_meta = "meta.json"
    for flag, value in zip(argv, argv[1:]):
        if flag == "--out-md":
            out_md = value
        elif flag == "--out-meta":
            out_meta = value

    repo = os.environ["REPO"]
    number = os.environ["PR"]

    pr = json.loads(gh("api", f"repos/{repo}/pulls/{number}"))
    files = [
        json.loads(line)
        for line in gh(
            "api",
            "--paginate",
            "--jq",
            ".[]",
            f"repos/{repo}/pulls/{number}/files?per_page=100",
        ).splitlines()
        if line.strip()
    ]

    try:
        diff = gh("pr", "diff", number)
    except SystemExit as error:
        print(f"warning: the diff could not be read ({error})", file=sys.stderr)
        diff = ""

    chunks = split_diff(diff)
    pubspec = next((body for path, body in chunks if path == "pubspec.yaml"), "")

    ordered, omitted = [], []
    for path, body in chunks:
        if any(pattern.search(path) for pattern in OMITTED_BODY) or is_binary(body):
            omitted.append(path)
        else:
            ordered.append((rank(path), path, body))
    ordered.sort(key=lambda item: (item[0], item[1]))

    included, spent, truncated = [], 0, False
    for _, _, body in ordered:
        if spent + len(body) > MAX_DIFF:
            truncated = True
            continue
        spent += len(body)
        included.append(body)
    dropped = len(ordered) - len(included)
    if dropped:
        truncated = True

    author = pr.get("user") or {}
    head_repo = pr["head"].get("repo") or {}
    meta = {
        "number": pr["number"],
        "title": pr["title"],
        "author": author.get("login", "unknown"),
        "author_type": author.get("type", "User"),
        "author_association": pr.get("author_association", "NONE"),
        "fork": head_repo.get("full_name") != repo,
        "base_ref": pr["base"]["ref"],
        "base_sha": pr["base"]["sha"],
        "head_label": pr["head"].get("label", ""),
        "additions": pr["additions"],
        "deletions": pr["deletions"],
        "changed_files": pr["changed_files"],
        "labels": [label["name"] for label in pr.get("labels", [])],
        "files": [
            {
                "path": entry["filename"],
                "status": entry["status"],
                "additions": entry["additions"],
                "deletions": entry["deletions"],
            }
            for entry in files
        ],
        "pubspec_lines": version_lines(pubspec),
        "diff_truncated": truncated,
        "diff_omitted": omitted,
    }
    return _write(meta, pr, included, omitted, dropped, spent, out_md, out_meta)


def _write(
    meta: dict,
    pr: dict,
    included: list[str],
    omitted: list[str],
    dropped: int,
    spent: int,
    out_md: str,
    out_meta: str,
) -> int:
    listing = "\n".join(
        f"- {entry['status']}: {entry['path']} (+{entry['additions']} -{entry['deletions']})"
        for entry in meta["files"]
    )
    notes = ""
    if omitted:
        notes += (
            "\nBodies left out, they are generated or locked: "
            + ", ".join(omitted[:12])
            + (" and more" if len(omitted) > 12 else "")
            + "\n"
        )
    if dropped:
        notes += f"\nThe diff below is capped at {MAX_DIFF} characters; {dropped} file(s) are not shown, but the file list above is complete.\n"

    markdown = f"""# Pull request #{meta['number']}

Title: {meta['title']}
Author: {meta['author']} ({meta['author_association']}, from a fork: {'yes' if meta['fork'] else 'no'})
Branch: {meta['head_label']} into {meta['base_ref']}
Size: +{meta['additions']} -{meta['deletions']} across {meta['changed_files']} file(s)
Labels: {', '.join(meta['labels']) or 'none'}

## The description

{pr.get('body') or '(no description)'}

## Every file the pull request touches

{listing or '(no files)'}
{notes}
## The diff
"""

    with open(out_md, "w", encoding="utf-8") as handle:
        handle.write(markdown)
        handle.write("\n```diff\n")
        handle.write("\n".join(included))
        handle.write("\n```\n")

    with open(out_meta, "w", encoding="utf-8") as handle:
        json.dump(meta, handle, indent=1)
        handle.write("\n")

    print(
        f"read {meta['changed_files']} file(s), {spent} characters of diff"
        + (f", {len(omitted)} generated or locked file(s) omitted" if omitted else "")
        + (", truncated" if dropped else "")
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
