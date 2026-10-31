---
name: skill-mine
description: >
  여러 Claude Code 세션에 걸쳐 반복되는 업무 지시를 찾아 새 스킬 후보로 뽑을 때
  (스킬 채굴, skill mine, 반복 패턴 감지, /skill-mine): 세션 로그의 사용자
  프롬프트를 사전 매칭과 지식그래프(graphify + networkx + Leiden)로 묶어 순위를
  매긴 스킬 후보 마크다운 리포트를 만든다. LLM·API 호출 없이 로컬·결정론적으로 동작.
---

# skill-mine — 지식그래프 기반 프롬프트 패턴 → 스킬 후보 (LLM-free)

## 언제 사용

- 사용자가 "자주 반복되는 업무를 스킬로 뽑아달라" / "스킬 채굴" / "반복 패턴 감지" 등을 요청할 때
- 주기적으로 (주 1회 권장) 최근 프롬프트 corpus에서 누락된 스킬 후보를 발굴할 때
- 대상은 세션 1건이 아니라 여러 세션에 걸친 반복 패턴
- `/vault-graph` 와 동일한 NetworkX/Leiden 파이프라인을 재사용하므로 vault 그래프 리포트와 일관성 유지

## 전제

- Claude Code 세션 로그가 `~/.claude/projects/` 아래에 존재
- `~/.maru/env/.venv` 에 `graphifyy`, `networkx`, `pyyaml` 설치
- workspace root의 `project-registry.yaml` 최신 (PII 마스킹 + 엔티티 사전)
- **API key 불필요** — 전면 로컬 동작

## 파이프라인 (4단계, 모두 로컬·결정론적)

### 1. Extract (stdlib)
JSONL → 순수 user prompt (tool_result, slash command, system-reminder, 인터럽트 마커, wrapper 전부 제외; 길이 10~2000자). 완전 중복 dedup.

### 2. Materialize (사전 매칭)
각 프롬프트 → virtual wiki note (markdown + wiki-link). 매칭 대상:
- `~/.maru/skills/skill-mine/scripts/skill_miner/vocab/actions.yaml` — 한·영 동사 사전
- `~/.maru/skills/skill-mine/scripts/skill_miner/vocab/objects.yaml` — 한·영 객체 사전
- `work/project-registry.yaml` — people/orgs/keywords/acronyms (SSOT)

PII 마스킹: 사람명 → `[PERSON]`, 이메일 → `[EMAIL]`, 절대경로 → `[PATH]`.

### 3. GraphBuild (`skill_miner/wiki_graph.py`)
- `extract_wiki()` → nodes/edges 추출 (markdown wiki-link 파서)
- `build_graph()` → NetworkX `Graph`
- `detect_communities()` → Leiden (seed=42) / Louvain fallback
- `find_god_nodes()`, `find_surprising_connections()`, `compute_community_stats()`

### 4. Analyze & Report
커뮤니티별 스킬 후보 추출:
- 합격: prompt 멤버 ≥ 3 AND novelty ≥ 0.3
- label = `{top_action}-{top_object}` (kebab-case)
- triggers = 커뮤니티 내 최빈 vocab 노드 8개 (kind 중복 제거)
- cohesion = 내부 엣지 밀도
- novelty = 1 − 기존 스킬 카탈로그 trigger Jaccard 최대값
- rank = `log₂(size) × (unique_days/day_span) × cohesion × novelty`

출력: `_meta/reports/skill-candidates-YYMMDD.md`

## 실행 커맨드

```bash
cd <workspace-root>

# 기본: 최근 30일 corpus, 전체 파이프라인
~/.maru/skills/skill-mine/scripts/run.sh \
  ~/.maru/skills/skill-mine/scripts/skill_miner/run.py --days 30

# 최근 7일만
~/.maru/skills/skill-mine/scripts/run.sh \
  ~/.maru/skills/skill-mine/scripts/skill_miner/run.py --days 7

# 단계별
~/.maru/skills/skill-mine/scripts/run.sh \
  ~/.maru/skills/skill-mine/scripts/skill_miner/run.py --stage extract
~/.maru/skills/skill-mine/scripts/run.sh \
  ~/.maru/skills/skill-mine/scripts/skill_miner/run.py --stage materialize
~/.maru/skills/skill-mine/scripts/run.sh \
  ~/.maru/skills/skill-mine/scripts/skill_miner/run.py --stage graph
~/.maru/skills/skill-mine/scripts/run.sh \
  ~/.maru/skills/skill-mine/scripts/skill_miner/run.py --stage analyze

# 캐시 재사용 (상위 단계 그대로, 하위만 재실행)
~/.maru/skills/skill-mine/scripts/run.sh \
  ~/.maru/skills/skill-mine/scripts/skill_miner/run.py --from-cache

# 임계치 조정
~/.maru/skills/skill-mine/scripts/run.sh \
  ~/.maru/skills/skill-mine/scripts/skill_miner/run.py --min-size 2 --min-novelty 0.2
```

출력:
- `_meta/reports/.cache/prompts-YYMMDD.jsonl`
- `_meta/reports/.cache/virtual-vault-YYMMDD/notes/*.md`
- `_meta/reports/.cache/prompts-graph-YYMMDD.json`
- `_meta/reports/skill-candidates-YYMMDD.md` ← 최종 리포트

## 결과 해석 가이드

**God nodes** — 그래프 전체에서 가장 많이 연결된 vocab 노드. 워크스페이스의 공통 "어휘". 상위에 `object--document` · `action--plan` · `action--create` 가 나오면 사용자가 최근 문서·계획 업무에 집중하고 있다는 뜻.

**Candidates** — 커뮤니티 하나 = 한 워크플로우 패턴. `rank` 가 높을수록 재사용 가치 ↑.
- `novelty > 0.7`: 기존 스킬과 거의 겹치지 않음 → 신규 스킬 유력
- `novelty 0.3~0.7`: 기존 스킬 확장 여지 → overlap 섹션 확인
- `cohesion > 0.3`: 커뮤니티 결속도 ↑, 패턴 명확
- `unique_days > 1`: 단발성 아님

**Surprising connections** — 커뮤니티 경계를 넘나드는 vocab 엣지. 교차 영역 스킬 아이디어의 힌트.

**Rejected** — size<3 또는 novelty<threshold. 리포트 관찰용.

## 후속 작업

1. **승격** (수동): 적합한 후보 1건 선택 → SKILL.md 본문 작성 → 해당 스킬 소스 repo에 issue·PR로 추가 (런타임 설치본 직접 수정 금지)
2. **확장**: 기존 스킬과 overlap 이 높으면 해당 스킬의 description / triggers 에 새 표현 추가
3. **거부**: 의미 없는 클러스터면 무시
4. **사전 보강**: god_nodes 에 기대한 어휘가 안 보이면 `scripts/skill_miner/vocab/actions.yaml` / `objects.yaml` 에 표제어 추가

## 비용·성능

- API 비용: **$0** (LLM 호출 없음)
- 처리 시간: 30일 corpus (~35 프롬프트) 약 1~2초
- 재현성: seed=42 고정 시 100% 결정론적
- 확장성: 300일 corpus (~1000 프롬프트)도 초 단위

## 관련 파일

- 스크립트: `~/.maru/skills/skill-mine/scripts/skill_miner/` (extract/materialize/graph_build/analyze/run + vocab)
- 그래프 primitives: `skill_miner/wiki_graph.py`
- 관련 스킬: `vault-graph`

## 다음 단계 (선택 구현)

- `~/.maru/skills/_drafts/YYMMDD-<slug>/SKILL.md` 템플릿 기반 자동 드래프트 (후보 → 뼈대)
- `synonyms.yaml` — `object:inbox` ≡ `object:수신함` 병합
- incremental mode (`--since <last-run>`) — 신규 프롬프트만 처리
