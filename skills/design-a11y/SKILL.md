---
name: design-a11y
description: "한국어 웹 접근성 + Tailwind v4 특화 접근성 검수. KWCAG 2.2 기반 한국 웹콘텐츠 접근성 지침 준수 검사. 공공기관/대학 사이트 요건 포함. 트리거: 접근성, accessibility, a11y, 웹접근성, /fixing-accessibility, WCAG, 접근성 검수, 접근성 테스트, 키보드 접근성, 스크린리더, 색상 대비"
---

# Design A11y 스킬

한국어 웹 접근성 + Tailwind v4 특화 접근성 검수 스킬.
한국 웹콘텐츠 접근성 지침 2.2 (KWCAG) 기반으로 대학 관련 사이트의 접근성을 보장한다.

## 대상 사이트 접근성 요구 수준

| 사이트 | 요구 수준 | 이유 |
|--------|----------|------|
| halla.ai | **높음** | 대학 학과 공식 사이트, 공공기관 준함 |
| rise.jeju.ai | **높음** | 대학 사업 공식 사이트, 공공기관 준함 |
| youngjoon-lee.com | 보통 | 개인 사이트, 자율 |
| staixbwlb.com | 보통 | 기업 사이트, 자율 |
| ai-systems-2026 | 보통 | 교육 자료, Starlight 기본 접근성 활용 |

## 검사 카테고리

### 1. 색상 대비 (Color Contrast)

- WCAG AA 기준: 일반 텍스트 **4.5:1**, 대형 텍스트 **3:1**
- 대형 텍스트: 18pt(24px) 이상 또는 14pt(18.67px) bold 이상

**검사 대상**:
- text-primary / bg-primary 조합
- text-secondary / bg-primary 조합
- text-muted / bg-surface 조합
- 버튼 텍스트 / 버튼 배경
- 링크 색상 / 배경
- placeholder 텍스트 (4.5:1 아닌 3:1로 완화 가능하나 권장은 4.5:1)

**프로젝트별 주의점**:
- staixbwlb.com: dark-only에서 `#666666` (text-tertiary) on `#080808` → 약 3.7:1 (AA 미달)
- halla.ai dark: `#64748b` (muted) on `#050a18` → 확인 필요

### 2. 키보드 접근성

- 모든 인터랙티브 요소에 키보드 접근 가능
- Tab 순서가 시각적 순서와 일치
- `:focus-visible` outline 제공 (모든 프로젝트 확인)
- Skip link 제공 (`.skip-link`)
- 모달/드롭다운: focus trap 구현
- Escape 키로 모달/메뉴 닫기

### 3. 시맨틱 HTML

- `<nav>`: 내비게이션 영역
- `<main>`: 주요 콘텐츠 (페이지당 1개)
- `<article>`: 독립적 콘텐츠
- `<section>`: 의미 있는 그룹 (heading 동반)
- `<aside>`: 부가 콘텐츠
- `<header>` / `<footer>`: 페이지/섹션 머리/꼬리
- heading 계층: h1 → h2 → h3 순서 (건너뛰지 않음)

### 4. ARIA 레이블

- 이미지: `alt` 속성 필수 (장식용은 `alt=""` + `aria-hidden="true"`)
- 아이콘 버튼: `aria-label` 제공
- 현재 페이지 표시: `aria-current="page"`
- 열림/닫힘: `aria-expanded`
- 로딩 상태: `aria-busy="true"` 또는 `aria-live="polite"`
- 한글 `aria-label` 사용 (한국어 사이트)

### 5. 한글 타이포그래피 접근성

- `line-height` 최소 1.5 (권장 1.7~1.8)
- `letter-spacing` 과도하지 않음 (0 또는 약간 마이너스)
- `word-break: keep-all` (한글 어절 단위 줄바꿈)
- `overflow-wrap: break-word` (긴 URL 등 처리)
- 본문 `font-size` 최소 16px (권장 17px)
- `:lang(ko)` 또는 `html lang="ko"` 설정

### 6. 애니메이션 접근성

- `prefers-reduced-motion: reduce` 대응 필수
  - 모든 `animation-duration: 0.01ms`
  - 모든 `transition-duration: 0.01ms`
  - scroll reveal 요소 즉시 visible
  - parallax 효과 비활성화
- 자동 재생 콘텐츠: 정지 버튼 제공
- 깜빡이는 콘텐츠: 3회/초 이하

### 7. 폼 접근성

- `<label>` 연결 (`for` + `id`)
- 에러 메시지: `aria-describedby` + `aria-invalid`
- 필수 필드: `required` + `aria-required="true"`
- 자동완성: `autocomplete` 속성
- 한국어 placeholder: 설명 텍스트로 사용하지 않음 (별도 label 필수)

### 8. 이미지/미디어

- 의미 있는 이미지: 상세한 `alt` 텍스트 (한국어)
- 장식 이미지: `alt=""` + `role="presentation"` 또는 CSS background
- SVG: `role="img"` + `aria-label` 또는 `<title>` 태그
- 동영상: 자막 제공 (한글)

### 9. 인터랙티브 패턴 접근성

네이티브 HTML 요소 + ARIA로 JS 최소화.

- **Dialog/Modal**: `<dialog>` 사용 → `showModal()` 자동 focus trap, Escape 닫기, `aria-modal="true"` 자동. backdrop 클릭 닫기 시에도 focus 복원 확인
- **Popover**: `[popover]` + `[popovertarget]` 사용 → 네이티브 light-dismiss, focus 자동 관리. `aria-expanded` 수동 추가 권장
- **Accordion**: `<details>` + `<summary>` → 네이티브 `aria-expanded` 제공. `name` 속성으로 exclusive accordion. `list-style: none` + 커스텀 indicator
- **Tabs**: `role="tablist"` + `role="tab"` + `role="tabpanel"`. `aria-selected`, `aria-controls`/`aria-labelledby` 쌍 필수. Arrow keys 탭 전환 (JS 필요)
- **Toast/Notification**: `role="status"` + `aria-live="polite"` (일반 알림) 또는 `role="alert"` + `aria-live="assertive"` (에러/긴급). 자동 닫힘 시 충분한 표시 시간 (5초+)
- **Dropdown Menu**: `role="menu"` + `role="menuitem"`. `aria-haspopup="true"` + `aria-expanded`. Escape 닫기, Arrow keys 탐색
- **Tooltip**: `role="tooltip"` + `aria-describedby`. hover + focus 둘 다 표시. Escape로 닫기 가능

## 워크플로우

1. HTML/Astro 파일 스캔
2. 카테고리별 검사 수행
3. 이슈 목록 출력 (severity: critical/major/minor)
4. 수정 코드 제안

## Severity 기준

| Level | 기준 |
|-------|------|
| **critical** | KWCAG 필수 항목 위반, 콘텐츠 접근 불가 |
| **major** | WCAG AA 미달, 일부 사용자 불편 |
| **minor** | 모범 사례 미준수, 개선 권장 |

## Reference

- `references/kr-a11y-standards.md` — 한국 웹접근성 인증 기준 요약
- `design-system/references/design-tokens.md` — 색상 토큰 (contrast 계산용)
