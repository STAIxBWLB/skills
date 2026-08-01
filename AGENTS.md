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
