# AGENTS.md

Codex adapter only. Do not duplicate project rules here.

- Scope: this directory and descendants.
- Local source files: `README.md`, `SKILL_INDEX.md`, and skill-local `SKILL.md` files.
- This repo is the public skills repo. Do not include personal IDs, secrets, institution-specific private context, or workspace-only data in skill packages.
- Shared runtime and helpers live in `env/` and `lib/`; use `lib/`, not `_lib/`.
- Verify installer changes with `./install.sh -n` and `./install-codex.sh -n`.
