# Skills bundle guidance

This repository ships portable prompt and reference files through Maru OTA.
Keep identity and machine-specific paths in workspace configuration, preserve
unknown record fields, and make changes through the issue, branch, and PR
workflow.

Bundle structure and conventions are in `AGENTS.md` and `README.md`; runtime
installations are derived copies, so implement changes in this source repo.

Verification: run `make skills-verify` from the repository root. A successful
run prints `skills-verify ok: <N> skills, <M> tracked files` and exits zero. Review
LinkedIn setup changes against `REVIEW.md`, especially evidence boundaries,
idempotent writes, and on-demand cadence behavior.

Common pitfalls: a source filename date is not a publication date; a public
URL is not evidence of the owner's action; a profile proposal is not a live
snapshot. Preserve explicit user decisions instead of asking for them again.
