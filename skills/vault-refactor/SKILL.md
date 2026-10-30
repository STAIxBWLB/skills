---
name: vault-refactor
trigger: /vault-refactor
description: Restructure notes, split/merge, improve titles, reorganize MOCs (with mandatory approval gate)
---

# /vault-refactor [target]

> Before the first vmem call, read `lib/vault_adapter.md` §Runtime Discovery and bind the vmem vault id for the workspace `vault.path`; pass it as `vault` on every vmem tool call and as the `<vault>` argument of every `vmem` CLI command.

Restructure vault content for better organization. **Never auto-executes** — always presents a structured plan and waits for explicit user approval.

## Operations

- **split [note]**: Break a note into multiple atomic notes
- **merge [note1] [note2]**: Combine related notes
- **rename [note]**: → use `/vault-rename` (atomic rename + reference propagation); this skill only proposes the better title
- **moc [domain]**: Reorganize a domain MOC
- **promote [topic]**: Create topic MOC from tag cluster (20+ notes threshold)

## Process

1. Analyze target for refactoring opportunity
2. **Present approval gate** (see format below)
3. On explicit accept → execute
4. Update all affected wiki links via `vmem_patch` (bidirectional); a merge that retires a note uses `vmem_supersede(old, next)` or the two-step `vmem_delete`. expect: vmem refuses an edit or delete that would newly break an inbound link or MOC topic
5. Run `/vault-lint note=<path>` on each affected note
6. `EXTRACT` events in `log` come from the vmem writes themselves (structure change — `ingest-chain.md` §비표준 TYPE 처리)
7. Commit the vault submodule, then bump the parent pointer

## Approval Gate Format

Before any write, present this block to the user:

```
REFACTOR PROPOSAL
=================
operation: split | merge | rename | moc | promote
target: <path or note name>

plan:
  - action 1: <describe — source path → dest path>
  - action 2: <describe>
  - ...

affected notes: <count> (<list if ≤10>)
affected wiki-links: <count>
broken link risk: <low | medium | high>
reversibility: <easy | hard — explain why>

side effects:
  - <MOC updates>
  - <glossary mentions>
  - <task file impacts>

Accept: [y]es, [n]o, [d]etails, [m]odify
```

**Non-negotiable**: Do not write anything until the user explicitly says `y` or equivalent. `m` opens iteration — re-plan and re-present. `d` shows full affected list.

## Vault Access

**vmem MCP only** for all reads and writes:
- `vmem_read` / `vmem_read_many`
- `vmem_create` for new notes
- `vmem_patch` for targeted edits (preferred for link updates), `vmem_append` for new section content
- `vmem_move` for renames (rewrites vault-wide links itself; preview, then `confirm: true` with the fingerprint)
- `vmem_delete` for deletions (preview lists backlinks; then `confirm: true` with the fingerprint)

Filesystem access (Read/Write/Edit/Bash) is forbidden on vault paths.

## Log Append

Every vmem write appends its own default `log` line (`vmem_patch`/`vmem_move`/`vmem_delete` take no `log` argument). After the batch, add one summary line with `vmem_log_append(type: "EXTRACT", project: "-", source: "refactor:<operation>", note: "<summary> (N notes, M links)")` (no direct log-file append):

```
YYYY-MM-DD HH:MM  EXTRACT  -  refactor:<operation>  — <summary> (N notes, M links)
```

- `<operation>`: split | merge | rename | moc | promote
- `<summary>`: one-line describing the change

vmem records one default line per write plus this one summary line.

## Guards

- **NEVER auto-execute** — approval gate is mandatory
- All wiki links must be updated (no broken links after)
- Bidirectional links maintained
- MOC references updated
- If any step fails, attempt rollback via `vmem_patch` reverse edits; if rollback fails, record `failed: <reason>` with `vmem_log_append` and stop

## Output

- Proposed changes with reasoning (approval gate block)
- On accept: execution report (per-note status)
- `/vault-lint note=` results for all affected notes
- log append confirmation
