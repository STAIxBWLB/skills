---
name: vault-update
trigger: /vault-update
description: Refresh an outdated note with new context while preserving core insight (vmem MCP only)
---

# /vault-update [note]

Update a note with new information while preserving original meaning. This is the single-note leaf; batch discovery of notes that need updating is `/vault-sync` (its "update" proposals run this procedure).

## Input
- note: filename or path in `notes/`

## Process

1. Read target note via `vmem_read` (keep its `sha256` for `expectedSha`)
2. Identify what's changed (new context, superseded info, additional evidence)
3. Draft the update:
   - preserve core insight
   - add new content in an explicit section (e.g., `## Update YYYY-MM-DD`) OR inline-revise with preservation
4. Apply via vmem:
   - minor edit → `vmem_patch(path, oldString, newString, expectedSha)`
   - new section → `vmem_append(path, section: "Update YYYY-MM-DD", markdown)`
   - major rewrite → there is no overwrite tool: patch section by section, or create a replacement note with `vmem_create` and retire the old one with `vmem_supersede(old, next)`
   - frontmatter change → `vmem_set_frontmatter(path, set, unset, expectedSha)`
   - expect: vmem refuses a stale `expectedSha`, an invalid frontmatter value, a new unresolved wiki link and an edit inside `## Topics`
5. Check connected notes (via `vmem_links(path)` and `vmem_search`); propose cascading updates if needed
6. Record update in note body (timestamp or changelog line)
7. Run `/vault-lint note=<path>` on updated note
8. vmem logs every write; pass `log: {type: "CONNECT", ...}` when wiki-links changed, otherwise the default `EXTRACT` line is kept

## Vault Access

**vmem MCP only**. No filesystem Read/Write/Edit on vault paths. Use:

| Operation | vmem tool |
|-----------|---------|
| Read | `vmem_read` |
| Full rewrite | section `vmem_patch` calls, or `vmem_create` + `vmem_supersede` |
| Append | `vmem_append` |
| Targeted edit | `vmem_patch` |
| Frontmatter and tags | `vmem_set_frontmatter` |
| Search for impact | `vmem_links`, `vmem_search` |

## Quality Gates

- Original insight must be preserved OR explicitly superseded with `status: superseded` frontmatter + link to replacement note
- All existing wiki-links must remain valid
- New wiki-links added where relevant
- Changelog/timestamp line appended to body when content changes materially

## Log Append

If wiki-links or MOC membership changed, append:

```
YYYY-MM-DD HH:MM  CONNECT  <project>  notes/<note>.md  — updated: <summary>
```

If only body text or frontmatter changed (no link impact), **do not append** — /vault-update is not an ingest chain stage, so body-only edits stay silent.

## Output

- Summary of changes made
- Connected notes reviewed (and any cascading proposals)
- note-level `/vault-lint` result
- log append status (if applicable)
