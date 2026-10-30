---
name: vault-connect
trigger: /vault-connect
description: Find and create wiki link connections between vault notes
---

# /vault-connect [note]

> Before the first vmem call, read `lib/vault_adapter.md` §Runtime Discovery and bind the vmem vault id for the workspace `vault.path`; pass it as `vault` on every vmem tool call and as the `<vault>` argument of every `vmem` CLI command.

Find relationships between a note and existing vault notes, create wiki links.

## Input
- note: filename or path of a note in vault/notes/
- entities_hint (optional): list of 인물/기관 names from source summary.md — used as wiki-link candidate seeds in step 2 first pass

## Process

0. **Graph Report + Smart Connections 사전 조회** (있으면):
   a. `vault/reports/graph-report-YYMMDD.md`가 7일 이내 존재 시 읽기 → 대상 노트의 community 소속 확인, surprising connections 중 미연결 항목 우선 연결 후보로 설정
   b. Obsidian Smart Connections 플러그인이 활성 상태면 대상 노트의 semantic neighbors 상위 5개를 추가 연결 후보로 포함 (키워드 매칭으로 놓치는 cross-domain 연결 보완)
   c. 위 후보를 Step 2의 검색 결과와 병합 (중복 제거)
1. Read the target note completely (`vmem_read`; `vmem_links` shows its current in/out links)
2. Search vault/notes/ for related notes by:
   - **entities_hint first pass** (if provided): for each entity name, search `glossary.md`, `people.md`, and vault/notes/ titles for exact or fuzzy matches. These are highest-priority link candidates since they're pre-identified by summaries or source metadata.
   - **Backref seeds** (if present in target frontmatter): `relatedMeetings`, `relatedTasks`, `source_doc` / `meetingSourcePath` (context-enrichment §4) are pre-identified origins — treat their resolved `[[targets]]` as high-priority bidirectional link candidates.
   - Title keyword matching
   - Description similarity
   - Shared topics/MOCs
   - Same domain or cross-domain relevance
   - Project affinity via registry: if source is from work/, read `<workspace-root>/project-registry.yaml` to identify project, then prioritize sibling notes sharing the same `vault_note` topic as connection candidates

> **Registry fallback**: when project registry scoring < 3 → content-based similarity → prompt user. SSOT: `<workspace-root>/_meta/rules/project-registry-scoring.md`
3. For each discovered relationship:
   - Determine relationship type (supports, contradicts, extends, applies-to, context-for)
   - `vmem_link(from, to, relation, context, log: {type: "CONNECT", project, source: "notes/<x>.md", dest: "notes/<y>.md", note: "linked [[y]] (<relation>)"})` adds the typed link to both notes (bidirectional by default) and skips a side that already links the target
   - expect: vmem refuses a relation outside `supports | contradicts | extends | applies-to | context-for` and an unknown or ambiguous note; an already-linked pair returns `unchanged: true`
4. Update relevant MOCs if new connections span topics (`vmem_append` into the MOC's list section)
5. **CONNECT events in vault/log** come from each `vmem_link` call (ingest chain audit trail)
6. Report connections made and any cross-domain patterns discovered

## Log Append (Step 5 — REQUIRED)

Every wiki link /vault-connect creates produces one `log` line, written by `vmem_link` itself; set its content with the `log` argument. Never append to the log file directly.

**Format** (see `<workspace-root>/_meta/rules/ingest-chain.md` §"vault/log 포맷"):

```
YYYY-MM-DD HH:MM  CONNECT  <project>  <vault/notes/x.md>  — linked `[[a]]`, `[[b]]`, `[[c]]`
```

- `<project>`: project id from the target note's source registry classification, or `-` if unclassified
- `<vault/notes/x.md>`: target note being connected
- "linked target list": list of newly created wiki-link targets (cap at 5; if more, use overflow style with "+N more" suffix)

**No connections made**: no line is written (an `unchanged: true` link writes nothing). Report zero-connection runs in chat output instead.

**Bidirectional links**: one `vmem_link` call updates both notes and writes one line.

**Failure**: inspect each refused receipt's `applied`, `changes` and `logged`. With `applied: false` nothing was written: report its issues and keep the links that succeeded. With `applied: true` the write partly persisted: stop, report the receipt and reconcile the notes and log before any retry (`lib/vault_adapter.md` §Write results).

**Vault access**: vmem MCP only.

## Quality Gates

- Every connection must have stated reasoning
- Bidirectional: if A links to B, B should link to A
- Don't force connections — quality over quantity
- **CONNECT event appended to log for every run with ≥1 link created**

## Output
- List of connections made with reasoning
- Cross-domain patterns noted (if any)
- Updated MOCs (if any)
- log append status
