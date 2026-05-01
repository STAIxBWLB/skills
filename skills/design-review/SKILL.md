---
name: design-review
description: "우리 디자인 시스템 기준으로 코드 검수 + polish + 개선 로드맵. /polish(시각적 품질 향상), /audit(token 일관성 검사), /distill(불필요한 CSS 제거), /roadmap(프로젝트별 개선 로드맵). 트리거: /polish, /audit, /distill, /roadmap, 디자인 리뷰, design review, UI 검수, 디자인 검수, 코드 리뷰 디자인, CSS 정리, 스타일 검수, 디자인 개선, 다음 할 일"
---

# Design Review 스킬

우리 디자인 시스템 기준으로 UI 코드를 검수하고 개선한다.
`design-system` 스킬의 references/를 참조하여 판단 기준 적용.

## 4가지 모드

### `/polish` — 시각적 품질 향상

기존 컴포넌트의 spacing, typography, color를 미세 조정하여 시각적 완성도를 높인다.

**수행 항목**:
1. spacing 일관성 확인 (padding/margin/gap 패턴)
2. font-weight/size 계층 확인 (h1 > h2 > h3 > body 명확한 차이)
3. color contrast 미세 조정 (text-secondary가 충분히 구분되는지)
4. hover/transition 효과 일관성 (같은 유형의 요소는 같은 효과)
5. border-radius 일관성 (컴포넌트 유형별 radius 통일)
6. 그라디언트 방향/색상 정지점 일관성

**출력**: 개선 제안 목록 + 코드 수정

### `/audit` — Token 일관성 검사

design-tokens.md 기준으로 hardcoded 값을 탐지하고 token 미사용을 경고한다.

**수행 항목**:
1. Hardcoded color 탐지 → CSS variable 또는 Tailwind 유틸리티로 변환 제안
2. Hardcoded font-family → `var(--font-sans)` 등으로 변환
3. Hardcoded spacing/radius → token 또는 Tailwind 유틸리티 사용
4. Dark mode 토큰 누락 (light만 정의하고 dark 미정의)
5. 프로젝트 간 토큰 불일치 탐지
6. 사용하지 않는 CSS custom property 탐지

**출력**: 이슈 목록 (severity: error/warning/info) + 수정 제안

### `/distill` — 불필요한 CSS 제거

CSS/클래스를 단순화하고 중복을 제거한다.

**수행 항목**:
1. 미사용 CSS 클래스 탐지 (HTML/Astro에서 참조되지 않는 클래스)
2. 중복 속성 제거 (같은 속성이 여러 곳에서 재정의)
3. shorthand 변환 가능한 속성 (padding-top + padding-bottom → padding)
4. 불필요한 `!important` 제거
5. vendor prefix 정리 (autoprefixer가 처리하는 것은 제거)
6. Tailwind 유틸리티로 대체 가능한 커스텀 CSS

**출력**: 제거/변환 목록 + 코드 수정

### `/roadmap` — 프로젝트별 디자인 개선 로드맵

해당 프로젝트의 디자인 성숙도와 개선 우선순위를 Phase별로 제시한다.
단순 검수가 아니라 "다음에 뭘 개선할지" 가이드하는 모드.

**수행 항목**:
1. `design-system/references/project-status.md`에서 현재 상태 수치 로드
2. `references/improvement-roadmaps.md`에서 해당 프로젝트의 Phase별 로드맵 로드
3. 현재 코드베이스를 스캔하여 각 Phase 항목의 실제 진척도 확인
4. 완료된 항목은 ✅, 미완료는 ⬜로 체크리스트 형태 출력
5. 다음 작업 추천 (가장 임팩트 큰 미완료 항목)

**사용법**: `/roadmap [project]`
- `/roadmap staixbwlb` — staixbwlb.com 로드맵
- `/roadmap halla.ai` — halla.ai 로드맵
- `/roadmap rise` — rise.jeju.ai 로드맵
- `/roadmap youngjoon` — youngjoon-lee.com 로드맵
- `/roadmap` (인자 없음) — 현재 작업 디렉토리에서 프로젝트 자동 감지

**출력 형식**:
```
## [프로젝트명] 디자인 로드맵 (현재 X.X/5 → 목표 Y.Y)

### Phase 1 — [Phase 이름]
- ⬜ 항목 1 (미완료 — 현재 상태 설명)
- ✅ 항목 2 (완료)
- ⬜ 항목 3 (미완료)

### Phase 2 — [Phase 이름]
...

### 다음 추천 작업
> [가장 임팩트 큰 미완료 항목 + 구체적 실행 방법]
```

## 워크플로우

1. **프로젝트 감지**: 작업 디렉토리에서 프로젝트 판별
2. **CSS 파일 스캔**: `global.css`, 컴포넌트 `.astro` 파일의 `<style>` 블록
3. **design-system references 로드**: `design-tokens.md`, `component-patterns.md` 참조
4. **모드별 검사 실행**
5. **결과 출력**: 이슈 목록 + 수정 코드

## 프로젝트별 검수 기준

### youngjoon-lee.com
- Legacy alias(`--bg-primary`) → 신규 토큰(`--color-bg-primary`) 마이그레이션 진행 여부
- Light/dark 양쪽 토큰 정의 확인
- `@theme` 토큰과 `:root` 토큰 간 일관성

### staixbwlb.com
- Dark-only이므로 light mode 토큰 불필요
- `@theme`에 모든 토큰이 정의되어 있는지 확인
- Bento variant 색상 일관성

### rise.jeju.ai
- 모듈화된 CSS 파일 간 토큰 일관성
- `variables.css`에 정의된 토큰이 실제 사용되는지
- Fortify-inspired 토큰 체계 준수

### halla.ai
- Jeju basalt 테마 색상 일관성
- card 3종(card, card-flat, card-bento) 간 스타일 규칙 일관성
- Dark mode 전환 시 모든 컴포넌트 대응 확인

## Severity 기준

| Level | 기준 | 예시 |
|-------|------|------|
| **error** | 시각적 깨짐 또는 접근성 위반 | contrast ratio < 4.5:1, 누락된 dark mode |
| **warning** | 일관성 미준수 | hardcoded color, token 미사용 |
| **info** | 개선 가능 | shorthand 변환, 미사용 클래스 |

## Reference

이 스킬은 다음 파일을 참조한다:
- `design-system/references/design-tokens.md` — 토큰 기준
- `design-system/references/component-patterns.md` — 컴포넌트 패턴 기준
- `design-system/references/project-variants.md` — 프로젝트별 기준
- 이 스킬의 `references/review-checklist.md` — 검수 항목 상세
- 이 스킬의 `references/improvement-roadmaps.md` — 프로젝트별 개선 로드맵
- `design-system/references/project-status.md` — 프로젝트별 현재 상태 스냅샷
