---
name: vault_adapter
description: Vault access rules for public vault-facing skills. Skills discover paths from workspace.config.yaml and use the vmem MCP tools for vault markdown.
type: spec
---

# Vault Adapter Rules

## Purpose

This spec is the shared access contract for vault-facing skills. It is a policy document, not a Python module.

## Runtime Discovery

At the start of a vault-facing workflow:

1. Find `workspace.config.yaml` by walking up from the current working directory.
2. Read these keys when present:
   - `vault.path`
   - `vault.log_file`
   - `ssot.project_registry`
   - `ssot.rules`
   - `ssot.glossary`
   - `ssot.people`
   - `ssot.ingest_chain` (log TYPE set and normalization table)
3. If a key is missing, ask for the workspace-local value instead of hardcoding a personal path.
4. Bind the vmem vault id: run `vmem vaults list --json` and take the id whose `path` equals the canonical `vault.path`. Pass that id as `vault` on **every** vmem call. If no registered vault matches, or more than one does, stop and report it; an omitted `vault` falls back to the first personal vault, which may be a different vault.

## Access Rules

### Vault Markdown

All vault writes go through vmem, which validates before it saves (schema, enums, MOC topics, links, secrets, PII):

- `notes/*.md`: the vmem MCP write tools below.
- `ops/` and `reports/` files: the CLI `vmem report <vault> <ops/...|reports/...> --body -` (no MCP tool writes them).
- Root docs (`AGENTS.md` and similar) are not agent-writable; change them only on the user's explicit maintenance instruction.

Reads: `notes/` through `vmem_read` / `vmem_read_many` / `vmem_search` / `vmem_list` (they address flat notes only). `ops/`, `reports/` and root docs are read with read-only filesystem access. Do not use filesystem write/edit, shell redirection or another MCP server for any vault file.

**Write results**: a receipt with `ok: true` and `applied: true` saved its changes. `refused: true` usually means nothing was written, but check `applied`, `changes` and `logged`: a rollback or cleanup failure can return `refused: true` with `applied: true` and persisted bytes. In that case stop, report the receipt, and reconcile the note and log before any retry.

Declared exceptions (machine I/O, not agent writes):

| Path | Writer / reader | Why |
|---|---|---|
| `ops/sessions/last-sync-timestamp` | fs read/write by vault-sync | plain file, not a note |

Typical mappings:

| Operation | vmem tool |
|---|---|
| Read note / several notes | `vmem_read` (frontmatter, body, sha256), `vmem_read_many` (<=20) |
| Search / list | `vmem_search`, `vmem_list` |
| Links / neighbourhood | `vmem_links`, `vmem_graph_neighbors` |
| Create note | `vmem_create` |
| Edit body | `vmem_patch` (exact old/new text), `vmem_append` (into an H2 section) |
| Edit frontmatter or tags | `vmem_set_frontmatter` |
| Typed relation link | `vmem_link` |
| Supersede | `vmem_supersede` |
| Move / delete | `vmem_move`, `vmem_delete`: call once for `{preview, fingerprint}`, then again with `confirm: true` and that fingerprint |
| MOCs / stats | `vmem_mocs`, `vmem_status` |
| Lint / graph reports | `vmem_lint` (`write: true` saves `reports/lint-*.md`), `vmem_graph_build` |
| Dry validation | `vmem_check` |

Pass `expectedSha` (from `vmem_read`) on edits that must not race another writer. Every successful write changes the note's sha256, so re-read before the next `expectedSha` edit of the same note.

### Workspace SSOT

Workspace-local operational files are not vault markdown. They may be read or edited through normal filesystem tools:

- `workspace.config.yaml`
- `project-registry.yaml`
- files under the workspace rules directory
- skill source files in this repo

## Log Append

vmem owns the vault log (`vault.log_file`). Every vmem write appends one attributed line itself:

- `vmem_create`, `vmem_link`, `vmem_supersede` accept an optional `log` argument (`{type, project, source, dest?, note}`) that sets that line's TYPE, project and note.
- `vmem_patch`, `vmem_append`, `vmem_set_frontmatter`, `vmem_move`, `vmem_delete` take no `log` argument (calls carrying it are rejected) and record a default line (`EXTRACT`/`ROUTE`/`RETHINK  -  vmem:<op> → path`).
- `vmem_lint(write: true)` and `vmem_graph_build` record `LINT` / `GRAPH`; `vmem report` records a default `EXTRACT` line.
- When a workflow's contract needs a TYPE the write did not record (for example a LEARN line for an update), add exactly that event with `vmem_log_append`. Do not add an event the write already recorded.

Do not append to the log with `>>` or any other filesystem write.

```text
YYYY-MM-DD HH:MM  TYPE  project  source → dest  — note
```

`TYPE` is workspace-defined (`ssot.ingest_chain`): the canonical set is `INGEST ROUTE EXTRACT CONNECT DIGEST LEARN LINT TASK GRAPH SYNC RETHINK SOURCE`; historical non-standard TYPEs are interpreted via that rule's normalization table and must not be written anew (structure changes such as rename/refactor log as `EXTRACT`). vmem refuses a TYPE outside the set.

## Summary To Vault Fields

When promoting a source summary into a vault note, copy source-derived fields instead of regenerating them:

| Vault note field | Source summary field | Rule |
|---|---|---|
| `description` | `description` | Required, non-empty, concise |
| `domain` | `domain` | Required, workspace-defined domain enum |
| `topics` | `topics` | Required, at least one wiki link, **and every `[[target]]` must already exist as a MOC note in vault** (MOC = note where `type: moc` or a domain hub like `projects.md`, `research.md`, `operations.md`, `teaching.md`, `people.md`, `ai-practice.md`). |
| `source` | `source` | Preserve source identity |
| `project` | `project` | Map via project registry when available |

If required fields are missing, fail before writing. Do not synthesize blank or guessed values. expect: vmem refuses a missing `description`, `type` or `domain`, an enum value outside the vocabulary, and a `topics` entry that is not an existing MOC.

**MOC enforcement on `topics`**: `topics` carries hub navigation only. Concept/keyword tags (e.g., `credit-recognition`, `partnership-mapping`, `duty-model`) belong in body text, not in `topics`. vmem refuses a `topics` entry that does not resolve to an existing MOC. If a needed MOC does not exist, ABORT: a MOC is created separately with a `vmem_create type: moc` call on the user's instruction, never implicitly by an extract. Never silently copy unknown wiki-links from summary.md into vault notes.

## Project Registry Pattern

1. Load `ssot.project_registry` from `workspace.config.yaml`.
2. Score workspace-defined signals such as people, acronyms, keywords, orgs, and tags.
3. Use a clear match when the top score passes the workspace threshold.
4. If ambiguous, use registry disambiguation fields or ask the user.
5. If still unresolved, record the source as unclassified and continue only when the calling workflow allows it.

## Boundary

- Work files: filesystem tools.
- Vault markdown: vmem MCP only.
- Cloud mirrors or synced copies: do not edit directly from vault skills.
