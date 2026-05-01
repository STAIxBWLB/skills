# Bootstrap Glossary Prompt

Paste this into Claude or any capable LLM with your repository attached as context. The model will produce a glossary draft you can review and copy into your vault.

---

You are helping me build a glossary of named entities for my workspace. I have a multi-project codebase. Your task: extract all acronyms, organizations, projects, and recurring named concepts into a structured glossary.

**Sources to read** (in priority order):
1. README.md files at every project root
2. `package.json`, `pyproject.toml`, `Cargo.toml` — for project names and authors
3. Top-level docs in `_sys/`, `docs/`, or similar
4. CHANGELOG, ROADMAP, ARCHITECTURE files if present

**Skip**:
- node_modules, .venv, build artifacts
- vendor code, third-party SDKs
- Generated files

**Output format** (markdown):

```markdown
## Acronyms
| Acronym | Expansion | Notes |
|---------|-----------|-------|
| ... | ... | source: README.md line N |

## Organizations
| Short | Full name | Domain | Notes |
|-------|-----------|--------|-------|

## Projects
| ID | Name | Status | Path |
|----|------|--------|------|

## People
| Name | Role | Affiliation | Notes |
|------|------|-------------|-------|
```

**Rules**:
- Acronyms = 2+ uppercase letters appearing 3+ times
- Skip generic ones (API, CLI, HTTP, JSON, REST) unless project-specific
- Project ID = repo folder name (kebab-case)
- For each entry, include the file:line where you first found it
- If two acronyms collide (e.g. "AI" appears in 5 contexts), list each context as separate row

After producing the table, ask me which entries to keep before finalizing.
