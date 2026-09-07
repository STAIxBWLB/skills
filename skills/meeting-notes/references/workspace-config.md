# Workspace Config

```yaml
meeting_notes:
  root: ~/workspace/work/meetings
  filename_template: "YYMMDD-meeting-{slug}.md"
  guides:
    quick_start: _guides/QUICK_START.md
    glossary: _guides/GLOSSARY.md
    people: _guides/PEOPLE.md
  hooks:
    task_skill: task-management
    vault_extract_skill: vault-extract
    vault_connect_skill: vault-connect
    enrichment: context   # optional: enable context-enrichment (entity resolution + bundle)
```

When `hooks.enrichment` is set, the skill also reads `ssot.context_enrichment`
and the `context.*` lookup paths (people/glossary fast caches plus the canonical
vault MOCs) to resolve entities and assemble the project context bundle before
drafting. See `_meta/rules/context-enrichment.md`.

The skill also reads `io.providers` to pick a calendar command for the
work-schedule lookup (workflow step 3). Provider names are runtime values;
any of them may be absent, in which case the lookup is skipped and noted.

The public skill must not store participant lists, private project names, or
workspace-specific account values.
