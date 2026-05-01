# 디자인 선호도 인터뷰 가이드

design-init의 5단계 선호도 인터뷰에서 사용하는 선택지 → 파라미터 매핑.

---

## Step 1 → TYPE 결정

| 선택지 | TYPE | INTENSITY 기본값 |
|--------|------|-----------------|
| 문서/교육 사이트 | docs | 1-2 |
| 랜딩 페이지 | landing | 3-4 |
| 포트폴리오/쇼케이스 | portfolio | 4-5 |
| 웹 앱 | app | 2-3 |
| 기관/대학 공식 | landing | 3 |

## Step 2 → 참조 프로젝트 매핑

기존 프로젝트를 참조하면 해당 프로젝트의 설정을 베이스로 사용.

| 참조 프로젝트 | INTENSITY | DARKNESS | Color Preset | 특성 |
|-------------|-----------|---------|-------------|------|
| youngjoon-lee.com | 5 | both | Blue-Cyan | Space Grotesk, grain, mesh, ribbon, bento, 3D tilt |
| staixbwlb.com | 5 | dark | Blue-Cyan | Bold bento, 3D tilt, neon text, dark-only |
| halla.ai | 4 | both | Jeju | Outfit display, basalt theme, 3-card system |
| rise.jeju.ai | 3 | light | Indigo | Clean, modular CSS, information-focused |
| 새로운 방향 | (Step 3) | (Step 3) | (Step 4) | 직접 설정 |

### 참조 프로젝트 선택 시 scaffold 생성 방법

1. 해당 프로젝트의 `global.css` 구조를 템플릿으로 복제
2. 프로젝트 고유 요소(프로젝트명, 특정 컴포넌트 스타일) 제거
3. 토큰 시스템과 기본 유틸리티는 유지
4. Step 4에서 색상 커스터마이즈 가능
5. Step 5에서 접근성 수준 조정

## Step 3 → INTENSITY + DARKNESS 결정

"새로운 방향" 선택 시에만 진행.

### 분위기 → INTENSITY

| 분위기 | INTENSITY | 설명 |
|--------|-----------|------|
| 미니멀/클린 | 1-2 | 최소 장식, 콘텐츠 집중, whitespace 활용 |
| 전문적/신뢰감 | 3 | 적절한 시각 효과, 기관/기업 사이트에 적합 |
| 모던/세련된 | 4 | 강한 시각적 인상, glow/blur/gradient 효과 |
| 대담/실험적 | 5 | 풀 인터랙션, 3D, particle, bento, neon |

### 밝기 → DARKNESS

| 선택지 | DARKNESS | 참고 |
|--------|---------|------|
| 밝은 느낌 | light | rise.jeju.ai 패턴 |
| 어두운 느낌 | dark | staixbwlb.com 패턴 |
| 둘 다 지원 | both | youngjoon-lee.com, halla.ai 패턴 |

## Step 4 → Color Preset

| Preset | Primary | Accent | 특성 |
|--------|---------|--------|------|
| Blue-Cyan (default) | #2563eb | #22d3ee | 범용, 기존 프로젝트 공통 |
| Jeju | #0ea5e9 | #22d3ee + ember #f97316 | 바다/현무암 테마, depth 색상 포함 |
| Indigo | #2f4cb3 | #4af2c8 | 전문적, 기관 사이트 |
| 직접 지정 | (사용자 입력) | (사용자 입력) | primary hex + accent hex |

### 커스텀 색상 지정 시 자동 생성

사용자가 primary + accent hex를 지정하면:

1. **@theme 토큰 자동 생성**:
   - `--color-primary`: 지정 색상
   - `--color-primary-light`: lightness +15%
   - `--color-primary-dark`: lightness -15%
   - `--color-accent`: 지정 accent
   - `--color-accent-muted`: opacity 50%

2. **Light/dark 팔레트 파생** (DARKNESS=both 시):
   - Light: primary를 accent로, 밝은 배경
   - Dark: primary를 glow/border로, 어두운 배경

3. **Semantic token 매핑**:
   - `--color-bg-primary` → light/dark 분기
   - `--color-text-primary` → contrast 보장
   - `--color-border-*` → primary 기반 opacity 변형

## Step 5 → 접근성 수준 결정

| 질문 | 답변 | 적용 |
|------|------|------|
| 한국어 사이트? | 예 | `:lang(ko) { word-break: keep-all; overflow-wrap: break-word; }` |
| | 아니오 | 한글 설정 생략 |
| 공공기관 접근성? | 예 | WCAG AA 전체 + KWCAG 추가 규칙 |
| | 아니오 | 기본 접근성 (skip-link, focus-visible, reduced-motion) |

### 접근성 수준별 포함 요소

| 요소 | 기본 | 공공기관 |
|------|------|---------|
| skip-link | ✓ | ✓ |
| :focus-visible | ✓ | ✓ |
| prefers-reduced-motion | ✓ | ✓ |
| ::selection 색상 | ✓ | ✓ |
| aria-label 가이드 | | ✓ |
| color contrast AA (4.5:1) | ✓ | ✓ |
| color contrast AAA (7:1) | | ✓ |
| font-size minimum 14px | | ✓ |
| line-height minimum 1.5 | | ✓ |
| target size minimum 44px | | ✓ |
| 키보드 전용 네비게이션 | | ✓ |

---

## INTENSITY × DARKNESS × TYPE 매트릭스 (주요 조합)

| TYPE | INTENSITY | DARKNESS | 결과 특성 |
|------|-----------|---------|----------|
| docs | 1 | light | Starlight 기본, prose 중심 |
| docs | 2 | both | 깔끔한 문서 + dark mode toggle |
| landing | 3 | light | rise.jeju.ai 스타일, section divider, scroll reveal |
| landing | 4 | both | halla.ai 스타일, glow-border card, header blur |
| landing | 3 | light + 기관 | rise.jeju.ai + 공공기관 접근성 강화 |
| portfolio | 5 | dark | staixbwlb.com 스타일, bento, 3D tilt, neon |
| portfolio | 5 | both | youngjoon-lee.com 스타일, 전체 효과 |
| app | 2 | both | 기능 중심, 미니멀 UI, sidebar layout |
| app | 3 | dark | 대시보드, data-dense, dark 기본 |
