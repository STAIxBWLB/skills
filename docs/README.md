# `docs/` — Skill Reference Material

Reference documents for the skills in this catalog. Skills load these on demand; humans can read them as standalone guides.

## Top-level guides

| File | Purpose |
|------|---------|
| `design-skills-overview.md` | Map of design-related skills (this catalog + complementary external plugins), shared design language, and anti-AI-slop principles |
| `design-skills-workflows.md` | Practical workflows: skill-selection matrix, recipes (quick polish / full audit / premium upgrade), and combination patterns |
| `graphify-usage.md` | Build a knowledge graph of any markdown vault or code repo with `build-graph.py` (Leiden communities + god nodes + surprising connections) |
| `vault-setup.md` | Optional: how to scaffold a minimal markdown "vault" so multi-skill knowledge (design tokens, glossary, motion library, roadmaps) can be shared across skills |

> The sample `workspace.config.yaml` lives at the repo root: [`../workspace-config.example.yaml`](../workspace-config.example.yaml). Skills walk up from CWD to find it.

## Subdirectories

- **`slide-decks/`** — Curated visual style prompts (Anti-Gravity, Comic Story, Premium Mockup, Vitamin Pop, etc.) usable with Canva, NotebookLM, or LLM-driven slide generation. See `slide-decks/README.md` for the full catalog.
- **`templates/`** — Markdown starter templates for vault notes (`design-tokens.md`, `glossary.md`, `motion-library.md`, `improvement-roadmaps.md`).
- **`prompts/`** — Self-contained LLM prompts to bootstrap a vault from an existing codebase (`bootstrap-glossary.md`, `bootstrap-design-tokens.md`).

## Privacy

All content here is intentionally generic. No personal data, project-specific paths, or institutional context. Anything machine-specific lives in your local `workspace.config.yaml` (gitignored by convention).
