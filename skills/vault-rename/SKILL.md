---
name: vault-rename
description: Safely rename a vault note and update all references across vault + extract/sync SKILL.md. Handles vmem_move (vault-wide link rewrite) + grep refs + skill patches + graph invalidate + log event in one workflow.
trigger: /vault-rename
---

# /vault-rename [old-name] [new-name]

> Before the first vmem call, read `lib/vault_adapter.md` §Runtime Discovery and bind the vmem vault id for the workspace `vault.path`; pass it as `vault` on every vmem tool call and as the `<vault>` argument of every `vmem` CLI command.

Atomic vault note rename with full reference propagation. Implements 2026-04-22 Rethink M7 (JSIF→JIUCC 사례의 18 파일 수동 patch 이슈 해소).

## Input
- **old-name**: existing note name (without `.md` extension), e.g. `jsif-aws-green-bio-amazon-rfp-consortium`
- **new-name**: new note name (without `.md` extension), e.g. `jiucc-aws-green-bio-amazon-rfp-consortium`

## When to invoke

- 네이밍 오타·정정 (정오자)
- Acronym 변경 (JSIF → JIUCC 같은 브랜드 정정)
- Scope 변경 (예: `rise-program` → `rise-y2-program`)
- registry `vault_note` 교체 과정에서 노트명 shift 필요 시

**Do NOT use for**: 내용 개편·분할·병합 (→ `/vault-refactor` 사용)

## Process

### Step 1: Pre-flight 검증

1. `vmem_read(path: "old-name")` — old note 존재 확인
2. `vmem_read(path: "new-name")` — new 이름 충돌 확인 (vmem_move도 기존 대상이 있으면 V08로 거부)
   - 존재 시 ABORT, 사용자에게 보고 (merge 의도면 `/vault-refactor` 권고)
3. 변경 영향 범위 grep 수행 (Step 2 병행)

### Step 2: 참조 탐색 (vault + skill)

```bash
# vault 전체 참조 (wiki-link + frontmatter)
Search "{{old-name}}" in the configured vault path
# skill SKILL.md (work-side 방법론 문서)
Search "{{old-name}}" in the workspace skills directory
```

결과 파일 목록을 사용자에게 제시:
```
REFERENCES FOUND (N files)
  vault notes: [...]
  vault reports: [...]  (다음 /vault-graph build에서 자동 재생성 가능)
  ops/sessions: [...]
  skill files: [...]
```

### Step 3: Confirm (user approval gate — MANDATORY)

```
RENAME PROPOSAL
===============
old: notes/{{old}}.md
new: notes/{{new}}.md

References to patch: N files
- vault patches (MCP): M files
- skill patches (filesystem Edit): K files
- auto-regenerated on next /vault-graph build: reports/*.json, graph-report-*.md

Internal note updates:
- H1 title line
- description frontmatter (if contains old-name)

Accept: [y]es, [n]o
```

### Step 4: Execute (on accept)

1. **Rename note**: `vmem_move(from: "old-name", to: "new-name")` → `{preview, fingerprint}` 확인 후 `vmem_move(from, to, confirm: true, fingerprint)`. vmem이 vault 전체의 wiki/heading/block/embed 링크와 frontmatter wiki 참조를 같은 쓰기에서 새 stem으로 바꾸고 log에 ROUTE 한 줄을 남긴다. expect: vmem refuses a stale fingerprint, an existing destination and a non-kebab-case stem
2. **Internal updates** on the renamed note (re-read for a fresh sha256 first):
   - H1 line (`# old name` → `# new name`): `vmem_patch` (body)
   - `description` if it contains old-name: `vmem_set_frontmatter(path, set: {description: ...})` (frontmatter is not patchable text; `vmem_patch` refuses it)
3. **Plain-text mentions** (vault, MCP): 링크는 1단계에서 이미 바뀌었다. 링크가 아닌 본문 언급만 남으면:
   ```
   for each remaining plain-text occurrence:
     vmem_patch(path, oldString: "<occurrence with enough context to be unique>", newString: "<same text with new-name>")
   ```
   (`vmem_patch`는 정확히 한 군데만 바꾼다. replaceAll 없음)
4. **Batch patch references** (~/.maru/skills, filesystem):
   ```
   for each skill file with references:
     Edit(path, old-name, new-name, replace_all: true)
   ```
5. **Graph invalidation**: `reports/graph-report-*.md` + `reports/vault-graph.json` 정리 불필요, 다음 `/vault-graph build`에서 자동 재생성 — stale 여부는 L11이 7일 임계로 탐지

### Step 5: Verify

1. `Grep old-name` 재실행 — 잔여 매치 확인
2. **허용되는 잔여**:
   - `log` 내 이력 이벤트 (e.g. "old → new" 정정 기록)
   - `reports/vault-graph.json` (다음 build에서 재생성)
   - Meeting 원본 파일명 (`work/meetings/.../04-02 회의 - JSIF-AWS...md`) — 물리 파일명 변경은 별도 의사결정
3. **의도되지 않은 잔여 존재** → 사용자에게 보고 + 추가 패치 여부 확인

### Step 6: log event

`vmem_move`가 `ROUTE  -  notes/{{old}}.md → notes/{{new}}.md` 한 줄을 이미 남긴다. 4단계 skill 파일 수정 결과를 기록해야 하면 `vmem_log_append(type: "EXTRACT", project: "-", source: "notes/{{old}}.md", dest: "notes/{{new}}.md", note: "renamed, N files updated")`를 쓴다. log 파일 직접 append 금지.

## Safety Rules

- **vmem_move 거부·실패 시 ABORT** — 참조 patch 단계 진입 금지
- **Patch 도중 일부 실패** → 성공분 기록 + 실패 목록 사용자 보고, 자동 롤백 없음 (감사 가능한 부분 진척 우선)
- **설치 스킬 인식**: `~/.claude/skills/` 및 `~/.codex/skills/`는 canonical `~/.maru/skills/`를 가리키는 symlink 설치 대상이다. 편집은 canonical에서 수행한다.
- **vault 쓰기는 vmem MCP만** (notes/·reports/·ops/). log도 vmem이 기록한다
- **skill 파일은 Filesystem Edit** (`.claude/skills/`·`~/.maru/skills/`는 vault 외부)

## Quality Gates

- Move_note 성공 확인
- 참조 patch 성공률 ≥95% (5% 이내 skill·legacy 경로는 Step 5에서 사용자 확인)
- EXTRACT event 기록 (`— renamed`; rename은 구조 변경이라 `EXTRACT`로 기록, `ingest-chain.md` §비표준 TYPE 처리의 `RENAME → EXTRACT` 매핑과 정합)
- Graph 재빌드 권장 (7일 내 `/vault-graph build`)

## Output

- Step 3 Proposal 블록
- Step 4 실행 결과 요약 (N files patched)
- Step 5 verify 결과 (잔여 매치 목록)
- Step 6 log append 확인

## Related

- **/vault-refactor** — 노트 내용 개편·분할·병합 (rename 이상의 구조적 변경)
- **/vault-graph build** — rename 후 7일 내 재빌드 권장
- **/vault-lint** — L01(dead wiki-link) · L10(`project:` 값 검증) · L11(graph stale) 연동
- 근거: 2026-04-22 Rethink M7 (ops/methodology/260422-rethink-report.md §T2)
