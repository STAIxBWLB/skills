SKILL.md is the instruction source for this skill. This file is background for maintainers; it holds no directives.

# Ship background

## OCR policy scope

The OCR review gate in `references/ocr-review-gate.md` applies only when the
discovered lifecycle rule requires it. This portable skill does not impose one
workspace's OCR policy on repositories that do not ask for it.

## Why the review receipt carries both SHAs

GitHub's `commit_id` on a pull-request review proves only which head the
reviewer saw. It cannot prove which base the reviewer used, so the gate also
compares the head and base SHAs written in the review report.

## Pointer propagation

Nested submodules take more than one pointer commit. Skipping an intermediate
level leaves the outermost repository pointing at a stale commit. Pointer
commits are the one step that deliberately walks upward, because losing that
step is the failure this skill was written to prevent.

Pointer commit scopes and verbs differ per repository and per submodule, which
is why the convention is read from recent history. The body carries the PR
reference because the ancestor repository has no other record of which PR a
pointer moved for.

## Deploy detection

One workspace can mix several deploy types (dispatch-only workflows, tag
releases, push-triggered workflows, platform git integration, local CLI
deploys), so the skill detects the type per repository instead of assuming one.
