# Contributing to STAIxBWLB/skills

Thanks for considering a contribution.

## Scope

This catalog holds **generic, shareable** Claude Code skills. Skills must:

1. **Work without personal context** — no hardcoded names, emails, institutions, or project IDs. If a skill needs a knowledge base (e.g. design tokens, glossary), reference it abstractly via templates or env config.
2. **Be self-documenting** — `SKILL.md` must explain what it does, when it triggers, and what files it expects.
3. **Avoid runtime secrets** — no API keys, no service account tokens, no private endpoints.
4. **Be lint-clean** — no broken wiki-links, no orphan references to private vault notes.

## Anti-scope (not accepted here)

- Skills tied to specific people, organizations, email domains, or institutions
- Skills depending on private vaults, internal Slack/Telegram channels, or non-public docs
- Skills with embedded credentials, API tokens, or signed URLs
- Skills that scrape or post to external services without explicit user consent flows

## Skill structure

```
skills/<name>/
├── SKILL.md            # required: frontmatter + body
├── references/         # optional: lookup tables, catalogs, design data
├── scripts/            # optional: helper scripts
├── templates/          # optional: file templates the skill fills
└── runtime/            # optional: small runtime artifacts (not generated builds)
```

`SKILL.md` frontmatter:

```yaml
---
name: skill-name
description: One-sentence description used by Claude to decide relevance. Be specific.
triggers: [keyword1, keyword2, ...]   # optional but encouraged
---
```

## Vault dependencies

If a skill references vault-style notes (e.g. design tokens, glossary), include:
- A schema description in `SKILL.md` ("expects note `glossary.md` with sections `acronyms`, `institutions`")
- A starter template under `docs/templates/` so new users can scaffold one quickly

Do **not** assume the user has Obsidian. Note references should also work with plain markdown folders.

## Pull request checklist

- [ ] Skill works in isolation (no hidden dependency on author's private repo)
- [ ] `SKILL.md` description is concrete and discriminating
- [ ] No personal names, emails, or org-specific context
- [ ] No secrets in scripts or references
- [ ] Tested with a fresh `~/.claude/skills/` symlink

## License

By contributing you agree your contribution is licensed under MIT (see `LICENSE`).
