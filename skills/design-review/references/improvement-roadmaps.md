# 프로젝트별 디자인 개선 로드맵

프로젝트별 디자인 성숙도 분석 기반 개선 우선순위.
`/roadmap [project]` 실행 시 이 파일을 참조하여 Phase별 가이드 제공.

최종 분석일: 2026-04-05

---

## youngjoon-lee.com (4.2/5 → 4.8 목표)

31 Astro 컴포넌트 | Light+Dark | Space Grotesk + Pretendard

### Phase 1 — Quick Wins

- **Legacy alias 정리**: `--bg-primary`, `--text-primary` 등 old alias → `--color-bg-primary`, `--color-text-primary` 통합. 현재 이중 정의로 유지보수 비용 발생
- **Hardcoded gradient**: BentoGrid.astro 내 gradient 색상 → `var(--color-accent)` 계열 token으로 교체
- **불필요한 :root 중복**: `@theme`과 `:root` 모두에 같은 값이 정의된 토큰 → `@theme` 단일화

### Phase 2 — Components

- **Animation 통일**: CountUp.astro easing → 전역 `--ease-out-expo` 또는 reveal-delay 시스템과 통일
- **InitiativeScroller timing**: animation-duration/delay가 컴포넌트별로 다름 → `--duration-normal`, `--delay-stagger` 패턴으로 정렬
- **Card hover 일관성**: ProjectCard와 BentoCard의 hover transform 스케일/시간 통일

### Phase 3 — Polish

- **Props 문서화**: 컴포넌트 JSDoc props (@param, @example) 추가
- **prefers-reduced-motion**: 8개 keyframe animation에 reduced-motion 대응 추가 (grain, mesh, ribbon, tilt, reveal, countup, scroller, glow-pulse)
- **Font loading 최적화**: `font-display: swap` 확인 + preload hint

### Phase 4 — Modern CSS (신규)

- **CSS nesting 채택**: global.css 내 중첩 selector → `&` nesting으로 전환
- **Easing/Duration 토큰화**: 15+ 곳의 `cubic-bezier(0.16, 1, 0.3, 1)` → `var(--ease-spring)`, `0.3s` → `var(--duration-normal)`
- **Relative color syntax**: gradient 내 rgba 하드코딩 → `rgb(from var(--color) r g b / alpha)`
- **`@utility` 마이그레이션**: `.text-gradient` 등 커스텀 유틸리티 → `@utility` directive로 전환

### 완료 기준
- Legacy alias 0개
- Hardcoded color 0개
- reduced-motion coverage 100%
- Easing/Duration 토큰 사용률 100%

---

## staixbwlb.com (2.8/5 → 4.0 목표)

25 Astro 컴포넌트 | Dark-only | 87 hardcoded colors

### Phase 1 — Critical (접근성 + Token화)

- **접근성 기반 구축**:
  - skip-link 추가 (main content로 점프)
  - 모든 interactive 요소에 `aria-label` 확인
  - `:focus-visible` 스타일 전역 추가 (현재 없음)
  - color contrast ratio 4.5:1 미달 요소 수정
- **87개 hardcoded color token화**:
  - `#111111` → `var(--color-bg-surface)`
  - `#1a1a2e` → `var(--color-bg-deep)`
  - `#00ff88` → `var(--color-accent-primary)`
  - `rgba(255,255,255,0.1)` → `var(--color-border-subtle)`
  - 등 전체 매핑 테이블 생성 후 일괄 변환

### Phase 2 — System

- **Animation 중앙화**: ServiceCard/Hero/PipelineDiagram의 animation-delay → CSS variable `--stagger-delay` 기반으로 통일. `calc(var(--stagger-delay) * var(--i))` 패턴
- **미사용 legacy token 제거**: `--color-emerald`, `--color-violet` 등 정의만 있고 참조 없는 token 삭제
- **Bento card 시스템화**: 각 bento variant(feature/stat/image)의 padding/border/shadow를 공통 base + variant override로 구조화

### Phase 3 — Enhance

- **i18n 접근성**: `<html lang>` 속성 동적 설정, `<link hreflang>` 추가
- **Bento card keyboard nav**: Tab + Arrow key 네비게이션 지원 (roving tabindex 패턴)
- **prefers-reduced-motion**: 3D tilt, glow-pulse, stagger animation 대응

### Phase 4 — Modern CSS (신규)

- **Relative color syntax로 토큰화 가속**: 87 hardcoded 중 rgba() 패턴 → `rgb(from var(--color) r g b / alpha)` 일괄 변환 가능
- **CSS nesting 도입**: 컴포넌트 CSS를 nesting으로 리팩터
- **`@theme extend` 전환**: 기존 `@theme {}` → `@theme extend {}` (Tailwind 기본값 보존)
- **`@starting-style`**: 3D tilt, bento hover에 entry animation 추가

### 완료 기준
- Hardcoded color 0개 (87 → 0)
- skip-link + focus-visible 존재
- 모든 interactive 요소 keyboard 접근 가능
- CSS nesting 채택

---

## halla.ai (4.3/5 → 4.7 목표)

18 Astro 컴포넌트 | Light+Dark | Outfit + Pretendard | 16 .dark rules | 4 CSS 모듈

### Phase 1 — Structure ✅ (완료 2026-03-22)

- ✅ **Skip-link 추가**: BaseLayout에 bilingual skip-link + `<main id="main-content">`
- ✅ **global.css 모듈 분리**: 1072줄 → 4 모듈 (global 49 + base 115 + components 658 + utilities 169)

### Phase 2 — Dark Mode 정리 ✅ (완료 2026-03-22)

- ✅ **`.dark` rule 정리**: 47 → 16 (inline `dark:` 전환 + CSS nesting 통합)
- ✅ **Card 컴포넌트 추출**: Card.astro (default/flat/bento), 16개 페이지 전환

### Phase 3 — Consistency ✅ (완료 2026-03-22)

- ✅ **Button outline dark variant**: `dark:text-accent`, `dark:border-accent/60` 추가
- ✅ **prefers-reduced-motion 확대**: 3요소 → 8요소 (film-grain, card-shimmer, stat-enter, img)
- ⬜ **Spacing scale 정리**: `@theme`에 spacing token 미정의, 컴포넌트별 임의 padding 사용 중

### Phase 4 — Next (신규)

- **Hardcoded color 토큰화**: ~25개 hardcoded hex 잔존 (dark text `#e2e8f0`, `#f1f5f9`, `#cbd5e1`, `#94a3b8`, `#64748b` + gradient `#22d3ee`, `#38bdf8`). `@theme`에 semantic token 등록 후 일괄 치환
- **Spacing token 도입**: `@theme`에 `--spacing-*` 정의 후 컴포넌트에 적용
- **Prose `.prose` 중복 선언 병합**: components.css에 `.prose` 블록 2개 연속 → 하나로 병합
- **`.glow-card-light` legacy alias 제거**: 빈 rule, 참조 없음
- **Header transparent dark 명시**: transparent 상태 dark mode에서도 white text 고정이나 명시적 dark rule 없음

### 완료 기준
- ✅ global.css 단일 파일 → 4 모듈
- ✅ `.dark` rule 47 → 16
- ✅ Card 컴포넌트 base 1개 + variant 3개
- ✅ skip-link + focus-visible + reduced-motion (8요소)
- ⬜ Hardcoded color 25 → 0
- ⬜ Spacing token 체계 도입

### Phase 5 — Modern CSS (신규)

- **CSS nesting**: components.css의 중첩 selector → nesting 전환
- **Relative color syntax**: 25개 hardcoded hex 중 투명도 변형 → `rgb(from var(--color) r g b / alpha)`
- **Easing/Duration 토큰**: `cubic-bezier()` 하드코딩 → `var(--ease-spring)`, `var(--duration-reveal)` 등
- **Container queries**: Card.astro에 `@container` 도입 (variant별 반응형)

---

## rise.jeju.ai (3.8/5 → 4.2 목표)

17 CSS files | Light-only | 4 page CSS (통합 완료) | Indigo/Teal palette

### Phase 1 — Consolidation ✅ (완료 2026-03-22)

- ✅ **19개 page-specific CSS → 4개 통합**: list-page, detail-page, program-detail, major-detail
- ✅ **benefits-section.css hardcoded color 제거**: 17개 → 0개
- ✅ **중복 CSS import 정리**: 22개 컴포넌트 레벨 중복 import 제거

### Phase 2 — Tokens ✅ (완료 2026-03-22)

- ✅ **미사용 token 정리**: 14개 미사용 토큰 제거, 현재 미사용 0
- ✅ **모든 raw color → CSS variable**: 305개 hardcoded color 토큰화, 3개 one-off만 잔존
- ✅ **border-radius → token 전환**: 모든 표준 radius 값 토큰화
- ⬜ **Spacing token 도입**: padding/margin은 복합값 많아 가독성 유지를 위해 보류

### Phase 3 — Accessibility ✅ (완료 2026-03-22)

- ✅ **skip-link 추가**: BaseLayout에 bilingual skip-link + `<main>` landmark
- ✅ **`:focus-visible` 전역**: primary color outline + mouse user focus 제거
- ✅ **`prefers-reduced-motion`**: 모든 animation/transition 비활성화

### Phase 4 — Next (신규)

- **Dark mode 토큰 시스템**: 기존 semantic 토큰에 dark variant 정의 (즉시 적용하지 않아도 토큰 준비)
- **Component 패턴 표준화**: btn-primary shadow를 토큰화, card-footer border 수정 등 소규모 polish
- **CSS 중복 패턴 추출**: program-detail.css(8,000줄) 내 반복 hero/overview/card 패턴 → 공통 클래스 추출
- **Animation 체계화**: `[data-animate]` 시스템을 더 다양한 효과로 확장 (fade-left, scale-in 등)

### 완료 기준
- ✅ Page-specific CSS 19 → 4
- ✅ Hardcoded color ~0
- ✅ 미사용 token 0
- ✅ 접근성 3대 기능 구비
- ⬜ Dark mode 토큰 준비
- ⬜ program-detail.css 공통 패턴 추출

### Phase 5 — Modern CSS (신규)

- **CSS nesting**: 17개 CSS 파일에 nesting 적용 (이미 scroll-driven 사용 중, 확장)
- **Scroll-driven animations 확장**: 기존 progress bar 외에 section reveal에 `animation-timeline: view()` 적용
- **Easing/Duration 토큰**: `[data-animate]` 시스템에 토큰 적용
- **`@utility` 마이그레이션**: utilities.css 내 커스텀 클래스 → `@utility` 전환

---

## koica-tiu (신규 — 선도 프로젝트)

모던 CSS 기능을 가장 적극적으로 채택한 프로젝트. 다른 프로젝트의 참조 역할.

### 현재 채택 현황 (2026-04-05)

- ✅ `@theme extend` 사용
- ✅ CSS nesting 전면 사용
- ✅ Relative color syntax (20+ 사용)
- ✅ `text-wrap: pretty` / `text-wrap: balance`
- ⬜ Easing/Duration 토큰 (`var(--ease-spring)` 등) 미도입
- ⬜ Container queries 미도입
- ⬜ `@utility` 미사용
- ⬜ `@starting-style` 미사용

### 다음 단계

- **Easing/Duration 토큰 도입**: 기존 `cubic-bezier()` 값 → 토큰 전환
- **`@utility` 도입**: 커스텀 유틸리티 클래스 마이그레이션
- **다른 프로젝트로 패턴 전파**: relative color syntax, CSS nesting 가이드를 design-system 참조로 문서화 (완료)
