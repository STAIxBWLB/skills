# Skill behavior evals

Repeatable behavior checks for skills. Each case runs a skill headless against a
fixture workspace and grades the resulting file-tree diff. `evals/` is repo
plumbing: it is outside `BUNDLE_PATHS` and never ships in the OTA bundle.
Runs are manual or on demand; CI does not call them.

## Run

```sh
CLAUDE_CODE_OAUTH_TOKEN=... make skills-eval                 # all cases, 3 runs each
make skills-eval EVAL_ARGS="--case draft-writer/negative --runs 1"
make skills-eval EVAL_ARGS="--variant control --variant current"
make skills-eval EVAL_ARGS="--variant <git-ref> --variant current"
```

Options for `evals/run.mjs` (pass through `EVAL_ARGS`):

- `--case <skill>/<case>`: repeatable; default is every `evals/*/*/expect.json`.
- `--runs <n>`: runs per case and variant, default 3. Runs are serial.
- `--variant <v>`: repeatable, default `current`. `current` installs the skill
  from the working tree, `control` installs nothing, and any other value is a
  git ref whose `skills/<skill>` (and `lib/`, when the ref has it) is installed. Use a ref and `current` together
  for a before/after comparison of a skill edit.
- `--budget <usd>`: per-run cap passed to `claude --max-budget-usd`, default `0.50`.
- `--model <m>`, `--timeout <seconds>` (default 600).
- `--agent <executable>`: replaces the host CLI; used by the self-test below.

## Authentication

The runner never reads the real config dir or keychain. Live runs need
`ANTHROPIC_API_KEY` or `CLAUDE_CODE_OAUTH_TOKEN` (from `claude setup-token`) in
the environment; without one it exits 2 before running anything.

## Isolation

Each run gets a fresh temp dir (refused if it sits inside a git work tree)
holding a copy of the case fixture, a `HOME` that holds only the bundle `lib/`
(see below), and an isolated `CLAUDE_CONFIG_DIR`. The skill under test is the
only other addition, loaded as the session plugin `eval:<skill>`. The CLI runs with `--restricted` (file tools
confined to the fixture, no shell or web tools), `--tools
Read,Write,Edit,Glob,Grep,Skill`, `--strict-mcp-config` with no servers,
`--permission-prompts none`, and the budget cap. The child environment carries
only `PATH`, `HOME`, `TMPDIR`, `LANG`, `CLAUDE_CONFIG_DIR`, and the credential.
Built-in CLI skills remain available; account plugins, hooks, user/project/local
settings, and memory do not load (managed settings, if a host has any, still
apply). Reads outside the fixture are refused except for the variant's bundle
`lib/`, copied to `$HOME/.maru/skills/_builtin/lib/` (the installed path skills
name) and passed with `--add-dir`; a write there falls outside the fixture and
counts as forbidden. The control gets no `lib/`.

## Cases

`evals/<skill>/<case>/` holds:

- `fixture/`: the workspace copied into each run.
- `prompt.md`: the headless prompt.
- `expect.json`: optional `description`, `allowed` and `forbidden` path
  prefixes (non-empty strings), and `required` outputs. A change is a
  forbidden action when it hits a `forbidden` prefix or falls outside every
  `allowed` prefix. Each `required` entry matches new files
  by `pattern` (regex), checks `count`, and applies `contains` and `absent`
  regexes (multiline) to each match; a match that is a symlink or other special
  entry fails without being read. Unknown keys are rejected.

## Results

stdout is a table per case and variant: first-try pass, passes out of N,
forbidden actions summed over runs, runs that invoked `eval:<skill>`, mean
duration, and total cost from the CLI result. Per-run failures print to stderr.
Each run keeps `ws/`, `transcript.jsonl`, `stderr.txt`, and `grade.json` under
the printed artifacts dir.

Bad arguments and malformed cases (expect.json schema or regexes, missing
fixture, prompt, or skill for a variant) exit 2 before any run. After the
runs: exit 1 when any run performs or attempts a forbidden write (final tree
diff plus every Write/Edit call in the transcript, resolved to the on-disk
path, so a reverted write still counts); else 2 when a run did not execute
cleanly (agent exit, timeout, auth failure, a result message with `is_error`
or a non-`success` subtype such as an exhausted budget, skill not loaded);
else 1 when a non-control case/variant passes 0 of N runs;
else 0. The control variant is a baseline and is expected to fail its cases.
These codes are those of `node evals/run.mjs`; `make skills-eval` reports any
non-zero exit as make's own failure.

## Self-test

The grader is checked without model calls:

```sh
make skills-eval EVAL_ARGS="--agent evals/selftest/violate.sh --runs 1"   # must fail
make skills-eval EVAL_ARGS="--agent evals/selftest/comply.sh --runs 1"    # must pass
```
