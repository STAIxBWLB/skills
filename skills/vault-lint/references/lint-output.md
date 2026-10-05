# Lint 출력 노트 구조

`vault/reports/lint-YYMMDD.md` 구조. vault 스코프 섹션(L01·L02·L03·L09·L10·L11·L12)은 스크립트 출력을 그대로 붙이고, work 스코프 섹션(L04·L06·L07·L08)은 에이전트가 채운다.

```markdown
---
type: report
generated: YYYY-MM-DDTHH:MM
scope: full
summary:
  errors: N
  warnings: N
---

# Lint Report YYYY-MM-DD

## 요약

- error: N건
- warn: N건
- scope: full

## L01 — dead wiki-link (error, N건)

- `notes/foo.md`: `[[missing-target]]` → 대상 노트 없음. 추정: `[[foo-bar]]`
- ...

## L02 — 필수 frontmatter 누락 (error, N건)

- `notes/bar.md`: `type` 필드 없음
- ...

## L03 — orphan (warn, N건)

- `notes/baz.md`: in-link 0, topics 0

## L04 — stale seed (warn, N건)

- `work/scratchpad/ideation/seeds/2025-11-15-foo.md`: 146일 미갱신

## L06 — 신 스키마 불일치 (warn, N건)

- `work/projects/rise/admin/260101-report-summary.md`: frontmatter 없음 (구 포맷)

## L07 — 명명 규칙 (warn, N건)

- `work/projects/foo/Report Draft.md`: 공백 포함, 소문자 아님

## L08 — 한글 파일명 (error, N건)

- `work/projects/bar/보고서.pdf`

## L09 — 로그 포맷 (warn, N건)

- `log:42`: TYPE `FOO` 미등록 (정규 12종·정규화표 모두 없음)
- `log:1798`: 구조 위반 (불릿 접두, 시각 컬럼 누락)

정보: legacy TYPE 45건 (정규화표 등재), 최종 사용 2026-07-19, 신규 발생 없음

## L10 — project 미등록 (warn, N건)

- `notes/xyz.md`: `project: unknown-project` (registry 없음)

## L11 — graph report staleness (warn, N건)

- `vault/reports/graph-report-260406.md`: 7일 초과 (최신: 260406, 현재: 260413). `/vault-graph build` 재실행 권장

## L12 — island community (warn, N건)

- island community (2 notes): `soohyon-kim`, `ki-young-park` — `/vault-connect` 필요

nodes 446 / edges 2457 / communities 9; singleton 6개: `brain-personal-ai`, `christopher-manning`, ...

## 제안 조치

- L01: wiki-link 수정 또는 대상 노트 생성 (`/vault-extract`)
- L02: `~/.maru/skills/_builtin/lib/vault_adapter.md` 정책에 맞춰 frontmatter 보강
- L03: `/vault-connect` 재실행 또는 topics 추가
- L11: `/vault-graph build` 재실행으로 graph report 갱신
- L12: `/vault-connect` 재실행으로 island community 노트에 cross-community wiki-link 추가
- L06: 신 스키마로 점진 마이그레이션 (수동)
- L08: 파일명 영문화 (즉시 수정 권장)
```
