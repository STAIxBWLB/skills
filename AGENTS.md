# AGENTS.md

Guidance for AI agents working in this repository.

- This repo is the OTA skill bundle source for the Maru app
  (`STAIxBWLB/maru`). The repo root is the bundle root.
- **Bundle content**: `skills/`, `envs/`, `lib/`, `docs/`,
  `manifest.json`, `SKILL_INDEX.md`. Everything else is repo plumbing and
  must never be referenced from bundle content.
- `manifest.json` is the source of truth for the skill list; keep
  `SKILL_INDEX.md` in sync by hand.
- Skill rules: frontmatter `name` == directory name, `description`
  required, filenames NFC-normalized, no symlinks, no runtime junk
  (`__pycache__`, `.DS_Store`, `.venv`, ...). `make skills-verify` enforces
  all of it — run it before every PR.
- Skills here are prompts and references for AI runtimes, not app code.
  Do not add executables that assume a specific machine; portable
  Python/Node helpers go in `lib/` or `envs/default/`.
- Releases are automatic on push to `main` (see README.md). Never hand-edit
  the `skills-channel` prerelease or its assets.
- `minAppVersion` in `manifest.json` changes only when a bundle needs newer
  app code, and is coordinated with a Maru app release.
- Commit messages: Conventional Commits, English (e.g.
  `feat(skills): add draft-writer`).
- Keep identity and machine-specific paths in workspace configuration, and
  preserve unknown record fields.
- Runtime installations are derived copies: implement changes in this source
  repo through the issue, branch, and PR workflow.

## Verification

Run `make skills-verify` from the repository root. A successful run prints
`skills-verify ok: <N> skills, <M> tracked files` and exits zero. Review
LinkedIn setup changes against `REVIEW.md`, especially evidence boundaries,
idempotent writes, and on-demand cadence behavior.

## Common pitfalls

- A source filename date is not a publication date.
- A public URL is not evidence of the owner's action.
- A profile proposal is not a live snapshot.
- Preserve explicit user decisions instead of asking for them again.
