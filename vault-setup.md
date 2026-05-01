# Vault Setup (Optional)

Most skills in this catalog are self-contained — install and they work. Four skills get richer when paired with a small **vault**: a folder of structured markdown notes that several skills read and update across sessions.

This guide is **opt-in**. If you only use `hwpx`, `pptx-toolkit`, `xlsx-toolkit`, `gaejosik`, the slide-deck prompts, or run `design-init` once per project, skip this entirely.

## When to scaffold a vault

| Skill | Vault file it reads/writes | Required? |
|-------|---------------------------|-----------|
| `design-system` | `design-tokens.md`, `project-variants.md` | Recommended for multi-project work |
| `design-motion` | `motion-library.md` | Recommended |
| `design-review` | `improvement-roadmaps.md` | Recommended for project tracking |
| (cross-skill) | `glossary.md` | Recommended if you have many acronyms / orgs |

Obsidian is **not required** — a flat folder of markdown files works the same. The skills only care that the path exists and the files are well-formed markdown.

## Minimal setup

```bash
# 1. Choose a vault location (anywhere on disk)
export VAULT="$HOME/Documents/vault"
mkdir -p "$VAULT/notes"

# 2. Seed with the templates from this repo
cp docs/templates/*.md "$VAULT/notes/"

# 3. Tell the skills where to find it (one of):

# Option A: environment variable (per-shell)
export CC_SKILLS_VAULT="$VAULT"

# Option B: workspace.config.yaml at your workspace root
cp workspace-config.example.yaml ./workspace.config.yaml
# then edit the paths.vault entry to match $VAULT
```

When a skill triggers in a directory inside that workspace, it walks up to find `workspace.config.yaml` and reads the vault location from it.

## Templates

Each template is a starter you fill in over time. Skills will append entries to them as you use them.

| Template | Used by | Holds |
|----------|---------|-------|
| `templates/glossary.md` | cross-skill | Entity dictionary — acronyms, organizations, projects |
| `templates/design-tokens.md` | `design-system` | Tailwind v4 `@theme` tokens with project variants |
| `templates/motion-library.md` | `design-motion` | CSS animation pattern catalog |
| `templates/improvement-roadmaps.md` | `design-review` | Per-project polish / audit / distill backlog |

## Bootstrap from existing code

If you already have one or more projects but no vault, the prompts in `docs/prompts/` extract a starting vault from your codebase:

| Prompt | Output |
|--------|--------|
| `prompts/bootstrap-glossary.md` | `glossary.md` populated from your README files |
| `prompts/bootstrap-design-tokens.md` | `design-tokens.md` populated from your existing CSS |

Each is a self-contained instruction you paste into Claude / ChatGPT with the relevant repo as context.

## Obsidian (optional)

If you happen to use Obsidian:

1. Open the vault folder in Obsidian.
2. Enable the **Local REST API** plugin (or any MCP-bridge plugin) for programmatic access.
3. Set `vault.access: obsidian-mcp` in `workspace.config.yaml`.

Skills will then route writes through MCP (preserving Obsidian's index integrity) and direct reads for plain YAML / markdown configs.

## Privacy

The vault is local. Nothing leaves your machine unless you commit and push it yourself. The shipped templates contain no real data — only headings and example rows.
