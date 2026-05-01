---
name: design-system
description: "5개 웹사이트 프로젝트의 공통 디자인 시스템 reference + 코드 규칙 강제. 컴포넌트 개발, 디자인 토큰 조회, Tailwind v4 @theme 규칙 가이드. 트리거: 디자인 시스템, 컴포넌트, design system, component, design token, 디자인 토큰, UI 컴포넌트, 스타일 가이드"
---

# Design System 스킬

5개 웹사이트 프로젝트의 공통 디자인 시스템을 관리하고, 새 컴포넌트 개발 시 일관성을 보장한다.

## 대상 프로젝트

| Project           | 경로                       | 모드              | Display Font  | Body Font                  |
| ----------------- | -------------------------- | ----------------- | ------------- | -------------------------- |
| youngjoon-lee.com | personal/me                | light+dark        | Space Grotesk | Pretendard Variable        |
| staixbwlb.com     | personal/STAIxBWLB         | dark-only         | Space Grotesk | Pretendard Variable        |
| rise.jeju.ai      | projects/rise/rise-jeju-ai | light             | Pretendard    | Noto Sans KR + Albert Sans |
| halla.ai          | teaching/halla-ai          | light+dark        | Outfit        | Pretendard Variable        |
| ai-systems-2026   | teaching/courses           | Starlight default | —             | —                          |

## 프로젝트 감지

작업 디렉토리 또는 파일 경로로 프로젝트를 자동 감지:

- `personal/me` 또는 `youngjoon-lee` → youngjoon-lee.com
- `personal/STAIxBWLB` 또는 `staixbwlb` → staixbwlb.com
- `rise/rise-jeju-ai` 또는 `rise.jeju` → rise.jeju.ai
- `halla-ai` 또는 `halla.ai` → halla.ai
- `courses` 또는 `ai-systems` → ai-systems-2026

## 핵심 원칙

### 1. Token-first 개발

- 새 컴포넌트에 hardcoded 색상값 사용 금지
- 반드시 CSS custom property 또는 Tailwind @theme 토큰 참조
- 프로젝트별 토큰은 `references/design-tokens.md` 참조

### 2. Tailwind v4 @theme 방식

- `tailwind.config.js` 사용하지 않음 — 모든 설정은 CSS `@theme {}` 블록에 inline
- `@custom-variant dark` 사용 (class-based dark mode)
- `@plugin` directive로 플러그인 로드

### 3. 컴포넌트 일관성

- 공통 컴포넌트 패턴은 `references/component-patterns.md` 참조
- 프로젝트별 변형은 `references/project-variants.md` 참조
- Astro 컴포넌트: `.astro` 파일에 scoped style 또는 global utility class

### 4. 반응형

- Mobile-first 설계
- Breakpoints: `sm:640px`, `md:768px`, `lg:1024px`, `xl:1280px`
- Container max-width: 1200px (halla.ai), 80rem (rise.jeju.ai)
- Container queries (`@container`) 사용 권장: 카드/위젯 컴포넌트 레벨 반응형

### 5. 모던 CSS 우선

신규 코드에서 모던 CSS 기능 적극 활용:
- **CSS nesting** — `&` 기반 네이티브 nesting (koica-tiu 선도)
- **Relative color syntax** — `rgb(from var(--color) r g b / 0.25)` (하드코딩 rgba 대체)
- **`color-mix()`** — 동적 색상 블렌딩
- **`@theme extend`** — 기존 Tailwind 기본값 유지하면서 토큰 추가 (신규 프로젝트 권장)
- **`@utility`** — 커스텀 유틸리티에 variant 지원 부여
- **`has-*` / `not-*`** — :has() 기반 조건부 스타일링
- **Easing/Duration 토큰** — `var(--ease-spring)`, `var(--duration-normal)` 사용

## 워크플로우

### 새 컴포넌트 생성

1. 프로젝트 감지 → 해당 variant 확인
2. `references/design-tokens.md`에서 color/font/spacing/easing/duration 토큰 조회
3. `references/component-patterns.md`에서 유사 패턴 참조 (인터랙티브 패턴 포함)
4. Tailwind v4 유틸리티 + CSS custom property 조합으로 구현
5. 모던 CSS 활용: CSS nesting, relative color syntax, container queries 적용
6. Dark mode 대응 확인 (해당 프로젝트가 지원하는 경우)

### 기존 컴포넌트 수정

1. 현재 사용 중인 토큰/클래스 확인
2. hardcoded 값 → token 변환 여부 판단
3. `references/tailwind-v4-rules.md` 준수 확인

## Reference 파일

- `references/design-tokens.md` — color, font, spacing, shadow, easing, duration, z-index, oklch 토큰
- `references/component-patterns.md` — Card, Button, Hero, Header + Modal, Tabs, Accordion 등 인터랙티브 패턴
- `references/project-variants.md` — 프로젝트별 변형 상세
- `references/tailwind-v4-rules.md` — Tailwind v4 전체 기능 + 모던 CSS 통합 가이드 (@theme extend, @utility, container queries, CSS nesting, relative color 등)
- `references/site-references.md` — 외부 사이트 디자인 분석 레퍼런스
- `references/skill-routing.md` — 15+ 디자인 스킬 라우팅 가이드 + 충돌 해결 규칙
- `references/project-status.md` — 프로젝트별 디자인 성숙도 스냅샷
