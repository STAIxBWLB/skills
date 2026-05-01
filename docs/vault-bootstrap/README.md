# Vault Bootstrap

Most skills in this catalog are **self-contained** — install and they work. A few benefit from a small "vault" of structured markdown notes for cross-skill knowledge (design tokens, project variants, glossary).

This guide helps you scaffold a minimal vault if you want richer integration. **Obsidian is optional** — a flat folder of markdown files works the same.

## When you need a vault

| Skill | Vault note used | Required? |
|-------|----------------|-----------|
| design-system | `design-tokens.md`, `project-variants.md` | Recommended for multi-project work |
| design-init | (none) | No |
| design-motion | `motion-library.md` | Recommended |
| design-review | `improvement-roadmaps.md` | Recommended for project tracking |
| All others | (none) | No |

If you only use `hwpx`, `pptx-toolkit`, `xlsx-toolkit`, `gaejosik`, slide-deck prompts, or `design-init` for new projects, **skip this guide entirely**.

## Minimal setup

```bash
# 1. Choose a vault location (anywhere)
export VAULT="$HOME/Documents/vault"
mkdir -p "$VAULT/notes"

# 2. Copy templates
cp docs/vault-bootstrap/*.md "$VAULT/notes/"

# 3. Tell skills where to find it (one of):
#    - Set env: export CC_SKILLS_VAULT=$VAULT
#    - Or: drop workspace-config.yaml at your workspace root
cp docs/vault-bootstrap/workspace-config.example.yaml ./workspace.config.yaml
```

Then in your workspace, when a skill triggers, Claude reads `workspace.config.yaml` to find the vault root.

## Templates

- `glossary-template.md` — entity dictionary (acronyms, organizations, projects)
- `design-tokens-template.md` — Tailwind v4 `@theme` tokens with project variants
- `motion-library-template.md` — CSS animation pattern catalog
- `improvement-roadmaps-template.md` — per-project polish/audit/distill backlog

## Bootstrap prompts

If you have existing projects but no vault, run these LLM prompts to seed it from your codebase:

- `prompts/bootstrap-glossary.md` — extract acronyms and orgs from README files
- `prompts/bootstrap-design-tokens.md` — extract design tokens from existing CSS

Each prompt is a self-contained instruction you paste into Claude/ChatGPT with your repo as context.

## Obsidian users

If you do use Obsidian:
1. Open the vault folder in Obsidian
2. Enable **Local REST API** plugin (or **MCP plugin**) for programmatic access
3. Set `vault.access: obsidian-mcp` in `workspace.config.yaml`

Skills will use the MCP path for writes (preserves index integrity) and direct reads for yaml configs.

## Privacy

The vault is local-only. Nothing leaves your machine unless you explicitly commit and push. Templates contain no real data.
