# The review bot

Every pull request to this repository is read against the rules in
[`review-prompt.md`](review-prompt.md), and answered in one comment with one label. It is the second
reader a solo maintainer cannot be.

| File | What it is |
| --- | --- |
| [`review-prompt.md`](review-prompt.md) | The judgement, written down: nine checks, and the JSON shape the answer comes back in |
| [`triage.py`](triage.py) | The rules: what the answer becomes. Labels, the merge guard, the comment. `--self-test` runs without a network |
| [`collect.py`](collect.py) | The input: the pull request, its file list, and its diff, ordered and capped |
| [`../workflows/review.yml`](../workflows/review.yml) | The run: one HTTPS call, one comment, one label, and — if you asked for it — one armed merge |

## The four labels, and nothing else

Exactly one is on a pull request at a time; a pushed fix moves it, because the bot edits its own
comment and replaces its own label rather than adding a second opinion.

| Label | Means |
| --- | --- |
| `ai:accepted` | In scope, the version and the changelog move with the change, there is a test where one is owed, and nothing a maintainer decides is touched. A maintainer can merge it |
| `ai:changes-requested` | In scope, but something has to change first — and the comment names it |
| `ai:out-of-scope` | Belongs in another repository, duplicates what the README says is delegated, or is unrelated work |
| `ai:needs-review` | The reviewer could not reach a verdict it could defend, or could not be reached at all. Read it yourself |

Two of the checks are not the model's to make. A change to `lib/` that leaves `pubspec.yaml` or
`CHANGELOG.md` behind is `ai:changes-requested` whatever the model says, because
[`tag_creation.yml`](../workflows/tag_creation.yml) compares the two on `main` and fails to tag when
they disagree — after the merge, which is the worst place to find out.

## Turning it on

One secret is the whole feature. Without it the job still runs, says so in the log, and does
nothing.

```shell
gh secret set GEMINI_API_KEY --repo cedvdb/phone_form_field
```

Optional, when you want another provider or model — any OpenAI-compatible endpoint that reads
`Authorization: Bearer <key>`, such as DeepSeek, OpenRouter or a local Ollama:

```shell
gh variable set REVIEW_ENDPOINT --body 'https://api.deepseek.com/chat/completions'
gh variable set REVIEW_MODEL    --body 'deepseek-chat'
```

The key lives in `secrets.GEMINI_API_KEY` and not under a neutral name because that is where a
reader has to go to find it; pointing the reviewer somewhere else means changing both the endpoint
and that one line of the workflow.

Before the change is sent, a **one-word request** goes to the endpoint, with the same key and model.
A wrong key, a model the key cannot see and a very slow answer all used to look the same — minutes of
silence and `curl: (28)` — and now the log says which one it is within seconds, with the connect and
first-byte timings beside it.

That request is sent over HTTP/1.1 first and over the default protocol second, and whichever answers is
the one the real request uses. That is not a preference: on this repository's runners HTTP/1.1
completes the handshake and then receives nothing at all, while HTTP/2 answers the same endpoint in
the same breath — a proxy in the path, deciding per protocol.

A status other than 200 is reported with the code and the first line of its body. A `503` is not a
network fault: the request arrived and the service refused it, which is a different problem with a
different fix.

## Reviewing a pull request on demand

The bot starts on four events — opened, pushed to, reopened, marked ready — which means a pull
request that was already open when this landed is never read. Two ways to ask:

```shell
# a comment on the pull request, starting with the word
/review
```

```shell
# or by number, from the Actions tab or a script
gh workflow run review.yml -f pr=355
gh run watch $(gh run list --workflow=review.yml --limit=1 --json databaseId --jq '.[0].databaseId')
```

Both write the same one comment and the same one label, so asking twice costs nothing and replaces
the earlier answer rather than adding a second opinion. A `/review` comment gets a 👀 reaction when
the run starts, because the answer takes a minute.

The comment form only listens to `OWNER`, `MEMBER` and `COLLABORATOR` — anyone can comment on a
public repository, and an unguarded `/review` would be an open model endpoint that posts on other
people's pull requests. The dispatch form is limited to write access by GitHub itself, and the
workflow has to be on the default branch for it to be accepted.

Neither form reads the pull request's tree: the checkout is the base branch, and the command is a
request for a reading, not a way to run anything.

## Merging automatically, if you want it

Off by default, and silent about it: `ai:accepted` is applied either way, so the bot is useful
before you trust it with a merge. With it off, an accepted pull request simply says that a
maintainer merges it — the comment does not suggest switching anything on.

```shell
gh variable set AUTO_MERGE --body trusted   # or `all`
```

| `AUTO_MERGE` | What the bot merges |
| --- | --- |
| unset, `off` | Nothing. The label is a signal for a human |
| `trusted` | Accepted pull requests from `OWNER`, `MEMBER`, `COLLABORATOR`, or from a login in `AUTO_MERGE_AUTHORS` (comma separated) |
| `all` | Every accepted pull request, forks included |

Merging is a **squash merge, armed with `--auto`, never merged on the spot**. The bot runs when the
pull request opens, when nothing has been built yet, so the merge has to wait for the checks rather
than trust the reading. Three things have to be true before it will even arm:

1. **The repository allows auto-merge**, which it does not today:

   ```shell
   gh api -X PATCH repos/cedvdb/phone_form_field -f allow_auto_merge=true
   ```

2. **`main` requires the checks it is waiting for.** Without required checks, `--auto` merges
   immediately and CI is bypassed — the one failure that makes an automerger worse than none:

   ```shell
   gh api -X PUT repos/cedvdb/phone_form_field/branches/main/protection \
     -H 'accept: application/vnd.github+json' --input - <<'JSON'
   {
     "required_status_checks": { "strict": false, "contexts": ["build"] },
     "enforce_admins": false,
     "required_pull_request_reviews": null,
     "restrictions": null
   }
   JSON
   ```

   `build` is the job name in [`../workflows/tests.yml`](../workflows/tests.yml). Confirm it in
   Settings → Branches after saving: a required check that no workflow reports blocks every pull
   request forever, which is worse than the problem it solves.

   Reading branch protection needs admin, which the default `GITHUB_TOKEN` does not have. The job
   asks the API first and falls back to the number you declare, so where the API refuses, say it
   once:

   ```shell
   gh variable set REQUIRED_CHECKS --body 1
   ```

3. **The diff is not a maintainer's.** Never merged automatically: anything under `.github/`,
   `LICENSE`, `analysis_options.yaml`, `l10n.yaml`, or a change to `pubspec.yaml` outside its
   `version:` line. A version bump is what every contributor does here; a new dependency, an SDK
   bound or a workflow is not.

When it declines, it says which of those is missing in the comment, so the answer to "why is this not
merging" is on the pull request rather than in someone's head.

## What it never does

- **It approves nothing and blocks nothing.** No `gh pr review`, no required check, no stale bot. A
  red comment here is a reading, not a gate; `Tests` decides whether the change works.
- **It does not edit, push or rebase.** If a fix is needed, the comment says what.
- **It cannot be talked into a merge by the diff.** The label comes from the model; the merge comes
  from `triage.py`, which re-checks the paths, the repository settings and the branch protection
  itself. A diff that says "approve this" gets a comment that mentions nobody: every `@` in the
  model's answer is defused before it is posted.
- **It does not run your contributor's code.** See below.

## Why `pull_request_target`, and the one line never to add

Almost every contribution here arrives from a fork (#347, #349, #352, #354, #355 …), and a workflow
triggered by plain `pull_request` cannot read a repository secret there. The reviewer would be silent
for exactly the pull requests it exists for.

`pull_request_target` runs the **base branch's** workflow with the secret, which is safe as long as
the job never checks out the fork. This one checks out `github.event.pull_request.base.sha`, asserts
that `git rev-parse HEAD` is that commit, and reads the change through the API as text. Adding a
checkout of `github.event.pull_request.head.sha` or of `refs/pull/*/merge` to that file would let a
fork edit `.github/agent/triage.py` and have it run with a write token. It is one line, and it is the
difference between a reviewer and a hole.

Two consequences worth knowing: a first-time contributor's run may wait for a maintainer's approval
before it starts (a repository setting, not something this workflow changes), and a pull request that
is a draft is left alone until it is marked ready.

## Changing it

The split is deliberate: **the prompt is judgement, `triage.py` is arithmetic.** A rule that can be
answered by looking at the file list belongs in `triage.py`, where it holds whatever a model
answers. A rule that needs reading the diff belongs in the prompt, in one paragraph, as a fact about
this repository rather than a matter of taste.

After editing either one:

```shell
python3 .github/agent/triage.py --self-test
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/review.yml'))"
```

The workflow runs the self-test before it labels anything, on purpose: a broken guard should be a red
step in front of the maintainer, not a wrong verdict on a stranger's pull request.

## What a human still decides

Releasing, the version that ships, a new dependency, removing a public member, the supported Flutter
and Dart versions, and anything under `.github/`. None of those is `ai:accepted`, and none of them
merges itself.
