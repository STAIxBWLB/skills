# Site Design References

디자인 패턴 레퍼런스. 새 프로젝트 제작 시 참고용.

---

## Dark EdTech Landing

- **분석일**: 2026-04-05
- **카테고리**: AI 교육 플랫폼 (EdTech)
- **스택**: Dark-only, 풀스크린 섹션 기반, 한국어 메인
- **핵심 키워드**: atmospheric-gradient, stat-counter, person-centric-hero, decorative-typography

### Color System

| Token                | Value                  | 용도                          |
| -------------------- | ---------------------- | ----------------------------- |
| `--bg-base`          | #0a0a1a                | 페이지 배경 (deep navy-black) |
| `--bg-surface`       | rgba(255,255,255,0.04) | 카드/섹션 배경 (반투명)       |
| `--bg-surface-hover` | rgba(255,255,255,0.07) | 카드 hover                    |
| `--accent`           | #3B82F6                | Primary blue                  |
| `--accent-glow`      | rgba(59,130,246,0.3)   | Glow/border accent            |
| `--accent-teal`      | #06B6D4                | Secondary (gradient 끝)       |
| `--text-primary`     | #FFFFFF                | 헤드라인                      |
| `--text-secondary`   | #94A3B8                | 본문/서브텍스트               |
| `--text-muted`       | #64748B                | 캡션/라벨                     |
| `--border`           | rgba(255,255,255,0.08) | 카드 보더                     |

특징: 사실상 3색 시스템 (black + blue + white). 보조색 없이 톤 차이만으로 계층 구분.

### Typography

| 요소            | Font           | Size                        | Weight | 비고               |
| --------------- | -------------- | --------------------------- | ------ | ------------------ |
| Hero headline   | Pretendard     | clamp(2.5rem, 5vw, 3.5rem)  | 700    | 중앙 정렬, 2-3줄   |
| Section title   | Pretendard     | clamp(1.75rem, 3vw, 2.5rem) | 700    |                    |
| Sub-heading     | Pretendard     | 1.125rem                    | 500    | secondary color    |
| Body            | Pretendard     | 1rem                        | 400    | line-height 1.7    |
| Stat number     | Pretendard     | clamp(3rem, 8vw, 5rem)      | 800    | 가로 3열           |
| Stat label      | Pretendard     | 0.875rem                    | 500    | muted color        |
| Decorative      | Brush/Script   | ~8rem                       | —      | "Facilitator" 앵커 |
| English display | Geometric Sans | clamp(2rem, 4vw, 3rem)      | 600    | About hero         |

### Layout Patterns

#### 풀스크린 섹션 구조

```
[Header — sticky, blur backdrop]
[Hero — 중앙 정렬, 원형 프로필 + 헤드라인 + 스탯]
[Features — 4-card 그리드 (2x2)]
[Philosophy — 텍스트 중심, 좌우 패딩 넓게]
[Comparison — 비교표 매트릭스]
[Achievements — 숫자 강조 + 아이콘 그리드]
[Testimonials — 인용 + 프로필]
[Trust bar — 기업 로고 가로 나열]
[CTA — 풀폭 배경 + 버튼]
[Footer — 다크, 미니멀]
```

#### 섹션 간 분리

- 배경색 교대: pure black ↔ slightly lighter navy ↔ gradient accent
- 수직 패딩: `6rem 0` ~ `8rem 0` (섹션 간 충분한 호흡)
- divider 없음 — 배경색 차이로만 구분

### Component Templates

#### stat-counter (신뢰 시그널 3열)

```css
.stat-counter {
  display: flex;
  justify-content: center;
  gap: 4rem;
  padding: 2rem 0;
}
.stat-counter__item {
  text-align: center;
}
.stat-counter__number {
  font-size: clamp(3rem, 8vw, 5rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1;
  background: linear-gradient(135deg, #ffffff 60%, #94a3b8);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
.stat-counter__label {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-muted);
  margin-top: 0.5rem;
}

@media (max-width: 640px) {
  .stat-counter {
    gap: 2rem;
  }
  .stat-counter__number {
    font-size: clamp(2rem, 12vw, 3rem);
  }
}
```

#### atmospheric-hero (대기감 gradient hero)

```css
.atmospheric-hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: hidden;
}
.atmospheric-hero::before {
  content: "";
  position: absolute;
  top: -20%;
  left: 50%;
  translate: -50% 0;
  width: 140%;
  height: 70%;
  background: radial-gradient(
    ellipse at 50% 30%,
    rgba(59, 130, 246, 0.15) 0%,
    rgba(6, 182, 212, 0.08) 30%,
    transparent 70%
  );
  filter: blur(60px);
  pointer-events: none;
}
.atmospheric-hero__profile {
  width: 6rem;
  height: 6rem;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid rgba(255, 255, 255, 0.1);
  margin-bottom: 2rem;
}
.atmospheric-hero__title {
  font-size: clamp(2.5rem, 5vw, 3.5rem);
  font-weight: 700;
  line-height: 1.2;
  max-width: 720px;
}
```

#### decorative-heading (brush/script 앵커 타이포)

```css
.decorative-heading {
  font-family: "Playfair Display", "Noto Serif KR", serif;
  /* 또는 brush/script 계열: 'Caveat', 'Dancing Script', 'Satisfy' */
  font-size: clamp(5rem, 15vw, 10rem);
  font-weight: 400;
  letter-spacing: -0.02em;
  color: var(--text-primary);
  opacity: 0.9;
  text-align: center;
  line-height: 1;
  padding: 4rem 0;
  /* 선택: gradient text */
  /* background: linear-gradient(135deg, #FFFFFF 40%, #64748B);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent; */
}
```

#### person-card (팀 소개 프로필)

```css
.person-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 1rem;
}
.person-card__photo {
  width: 5rem;
  height: 5rem;
  border-radius: 50%;
  object-fit: cover;
  border: 1.5px solid rgba(255, 255, 255, 0.1);
}
.person-card__name {
  font-size: 1.125rem;
  font-weight: 700;
}
.person-card__role {
  font-size: 0.875rem;
  color: var(--text-secondary);
}
.person-card__credentials {
  font-size: 0.8125rem;
  color: var(--text-muted);
  line-height: 1.6;
}
```

#### comparison-matrix (경쟁 비교표)

```css
.comparison-matrix {
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  border-collapse: collapse;
}
.comparison-matrix th {
  font-size: 0.875rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted);
  padding: 1rem;
  border-bottom: 1px solid var(--border);
}
.comparison-matrix td {
  padding: 1rem;
  border-bottom: 1px solid var(--border);
  font-size: 0.9375rem;
}
.comparison-matrix .highlight {
  color: var(--accent);
  font-weight: 600;
}
```

### Motion

| 패턴           | CSS                                                   | 비고                 |
| -------------- | ----------------------------------------------------- | -------------------- |
| Section reveal | `translateY(30px) → 0, opacity 0 → 1, 600ms ease-out` | IntersectionObserver |
| Card hover     | `translateY(-2px), border-color → accent-glow`        | 300ms ease           |
| Stat count-up  | JS counter animation, 2s duration                     | 뷰포트 진입 시       |
| Hero gradient  | Static radial, no animation                           | 성능 우선            |

### 적용 가이드

**적합한 프로젝트 유형:**

- AI/EdTech 랜딩 페이지
- 교육 기관/프로그램 소개 사이트
- 인물(교수진/팀) 중심 소개 페이지
- 신뢰 지표(수료생 수, 만족도) 강조 필요 시

**기존 프로젝트 적용 시나리오:**

- `rise.jeju.ai` — stat-counter (참여 학생 수, 협력 기업 수), person-card (교수진)
- `halla.ai` — atmospheric-hero (학과 소개), stat-counter (취업률, 재학생)
- 새 EdTech 프로젝트 — 전체 구조 참조

### 기존 프로젝트 대비 장단점

| 비교 항목     | 신규 Reference                | 기존 프로젝트          | 판정                         |
| ------------- | ----------------------------- | ---------------------- | ---------------------------- |
| Hero gradient | Atmospheric (자연스러운 감쇠) | Cursor-reactive mesh   | 신규 가벼움, 기존 인터랙티브 |
| 신뢰 시그널   | stat-counter 3열 효과적       | 없음                   | **신규 채택**                |
| CTA 강조      | 약함 (시각적으로 묻힘)        | btn-glow/solid 강력    | **기존 유지**                |
| 카드 깊이     | dark-on-dark 구분 약함        | 3-tier card (halla.ai) | **기존 유지**                |
| 모션          | 기본 fade-in                  | 3D tilt, bento hover   | **기존 유지**                |
| 브랜드 타이포 | Decorative heading 개성적     | Sans 통일 (개성 부족)  | **신규 채택**                |
| 팀 소개       | person-card 원형 사진         | 없음                   | **신규 채택**                |
| 비교표        | comparison-matrix             | 없음                   | **신규 채택**                |
| 컬러 시스템   | 3색 극단 단순                 | 5-7색 체계적           | 상황에 따라                  |
| 반응형        | 단순 스택                     | 체계적 spacing scale   | **기존 유지**                |

---

## Linear-style Dark SaaS

- **분석일**: 2026-04-05
- **카테고리**: 프리미엄 다크 SaaS (Linear, Vercel, Raycast 계열)
- **스택**: Dark-only, gradient glow, 미니멀 정보 구조
- **핵심 키워드**: linear-gradient-glow, glass-card, spotlight-hero, subtle-grid, command-palette

### Color System

| Token | Value | 용도 |
|-------|-------|------|
| `--bg-base` | #0a0a0a ~ #111111 | 페이지 배경 (pure dark) |
| `--bg-surface` | rgba(255,255,255,0.03) | 카드 배경 (거의 투명) |
| `--bg-surface-hover` | rgba(255,255,255,0.06) | 카드 hover |
| `--bg-elevated` | rgba(255,255,255,0.08) | 강조 영역 |
| `--accent` | #7C5CFC ~ #5B5BD6 | Primary (indigo/violet 계열) |
| `--accent-glow` | rgba(124,92,252,0.15) | Glow 효과 |
| `--accent-gradient` | `linear-gradient(135deg, #7C5CFC, #5B5BD6, #3B82F6)` | 버튼/배지 gradient |
| `--text-primary` | #EDEDED ~ #F5F5F5 | 헤드라인 (pure white 아님) |
| `--text-secondary` | #A0A0A0 | 본문 |
| `--text-muted` | #666666 | 라벨/캡션 |
| `--border` | rgba(255,255,255,0.06) | 미묘한 border |

특징: **pure black 배경 + 극도로 낮은 contrast border** (0.06 opacity). 카드 구분은 border보다 glow로. Violet/indigo accent가 blue 대비 더 프리미엄한 느낌.

### Typography

| 요소 | Font | Size | Weight | 비고 |
|------|------|------|--------|------|
| Hero headline | Inter/Geist | clamp(3rem, 6vw, 5rem) | 500-600 | 가벼운 weight가 특징 |
| Section title | Inter/Geist | clamp(1.5rem, 3vw, 2.25rem) | 500 | 간결한 한 줄 |
| Body | Inter/Geist | 0.9375rem (15px) | 400 | line-height 1.6 |
| Label/Badge | Mono or Sans | 0.75rem | 500 | uppercase, letter-spacing 0.05em |
| Code | JetBrains Mono | 0.875rem | 400 | 제품 시연 코드 |

특징: **weight 500-600이 주력** (700 아님). 타이트한 letter-spacing (`-0.02em`~`-0.04em`). 한 폰트 패밀리로 전체 통일 (display/body 분리 없음).

### Layout Patterns

#### Spotlight Hero

```css
.spotlight-hero {
  position: relative;
  min-height: 80vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  overflow: hidden;
}
/* 상단 중앙에서 퍼지는 원형 spotlight */
.spotlight-hero::before {
  content: '';
  position: absolute;
  top: -30%;
  left: 50%;
  translate: -50% 0;
  width: 80%;
  height: 60%;
  background: radial-gradient(
    ellipse at 50% 50%,
    rgba(124, 92, 252, 0.12) 0%,
    rgba(91, 91, 214, 0.06) 40%,
    transparent 70%
  );
  filter: blur(80px);
  pointer-events: none;
}
/* 배경 도트 그리드 패턴 */
.spotlight-hero::after {
  content: '';
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(255,255,255,0.05) 1px, transparent 1px);
  background-size: 24px 24px;
  pointer-events: none;
}
```

#### Glass Card (반투명 카드)

```css
.glass-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.06);
  border-radius: 1rem;
  padding: 2rem;
  position: relative;
  overflow: hidden;
  transition: border-color var(--duration-normal, 300ms) var(--ease-out);

  &:hover {
    border-color: rgba(255, 255, 255, 0.12);
  }

  /* 상단 gradient line (카드 위쪽 1px 밝은 선) */
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 10%;
    right: 10%;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
  }
}
```

#### Feature Grid (3열 아이콘 + 텍스트)

```
[Spotlight Hero — headline + sub + badge + CTA 2개]
[Logo Bar — 파트너/사용 기업 가로 나열, opacity 0.4]
[Feature Grid — 3x2 또는 2x3 glass-card, 아이콘 + 제목 + 설명]
[Product Demo — 스크린샷/동영상 + 코드 예시]
[Testimonial — 인용 + 회사 로고]
[Pricing — 3-column glass-card (free/pro/enterprise)]
[CTA — gradient 배경 + 한 줄 text + 버튼]
[Footer — 4-column 링크, 미니멀]
```

### Component Templates

#### Gradient Badge

```css
.gradient-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.375rem 0.875rem;
  border-radius: 9999px;
  font-size: 0.8125rem;
  font-weight: 500;
  background: linear-gradient(135deg, rgba(124,92,252,0.15), rgba(59,130,246,0.1));
  border: 1px solid rgba(124,92,252,0.2);
  color: #b4a0ff;
}
```

#### Gradient CTA Button

```css
.btn-gradient {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 500;
  font-size: 0.9375rem;
  color: white;
  background: linear-gradient(135deg, #7C5CFC, #5B5BD6);
  transition: opacity var(--duration-fast, 150ms), transform var(--duration-fast, 150ms);

  &:hover {
    opacity: 0.9;
    transform: translateY(-1px);
  }
  &:active {
    transform: scale(0.98);
  }
}
```

### Motion

| 패턴 | CSS | 비고 |
|------|-----|------|
| Section reveal | `translateY(20px) → 0, opacity 0 → 1, 500ms ease-out` | 거리 작음 (20px) |
| Card hover | `border-color 0.06 → 0.12, 300ms` | 미묘한 변화만 |
| Hero glow pulse | `opacity 0.1 ↔ 0.15, 4s ease-in-out infinite` | 아주 느린 호흡 |
| Logo bar scroll | `translateX infinite 30s linear` | Ribbon과 동일 |
| Button press | `scale(0.98), 100ms` | Micro-interaction |

특징: **미묘함이 핵심**. 큰 transform 없음. glow의 미세한 변화로 "살아있는" 느낌.

### 적용 가이드

**적합한 프로젝트**: staixbwlb.com (dark-only, 프리미엄 SaaS 느낌)

**채택할 패턴**:
- `glass-card` — staixbwlb.com의 기존 bento-card를 보완하는 가벼운 대안
- `spotlight-hero` — atmospheric-hero의 변형으로, 도트 그리드 배경 추가
- `gradient-badge` — 태그/라벨에 gradient accent 적용
- `btn-gradient` — btn-solid의 violet 변형
- **미묘한 glow 모션** — 현재 staixbwlb.com의 과도한 3D tilt를 줄이고 glow 중심으로

**채택하지 않을 패턴**:
- Inter/Geist 폰트 (우리는 Space Grotesk + Pretendard 유지)
- 극도로 낮은 border contrast (우리 프로젝트는 좀 더 가시적인 구분 유지)

### 기존 프로젝트 대비 장단점

| 비교 항목 | Linear-style | 기존 프로젝트 | 판정 |
|-----------|-------------|--------------|------|
| 카드 구분 | Glass + glow (미묘) | Border + shadow (명확) | **기존 유지** (한국 사용자 가독성) |
| Hero | Spotlight + dot grid | Cursor-reactive mesh | **신규 참조** (옵션으로) |
| Badge | Gradient badge | Tag pill (단색) | **신규 채택** (staixbwlb.com) |
| 버튼 hover | Scale 0.98 (미묘) | TranslateY -2px | 상황에 따라 |
| Font weight | 500 주력 | 600-700 주력 | **기존 유지** (한국어 가독성) |
| 모션 강도 | 최소 (glow만) | 중간 (tilt, shimmer) | **기존 유지** |

---

## Premium University Department

- **분석일**: 2026-04-05
- **카테고리**: 명문 대학 학과/연구소 (Stanford HAI, MIT CSAIL 계열)
- **스택**: Light 기본, 제도적 신뢰감, 연구 쇼케이스 중심
- **핵심 키워드**: institutional-trust, research-showcase, faculty-grid, news-feed, whitespace-heavy

### Color System

| Token | Value | 용도 |
|-------|-------|------|
| `--bg-base` | #FFFFFF | 순백 배경 |
| `--bg-surface` | #F7F8FA ~ #F5F5F5 | 섹션 교대 배경 |
| `--bg-accent-subtle` | #EEF2FF ~ #F0F9FF | 강조 섹션 (매우 연한 primary) |
| `--color-primary` | #8C1515 (Stanford) / #1B365D (navy) | 기관 브랜드색 |
| `--color-primary-dark` | 15-20% 어두운 변형 | Hover/active |
| `--text-primary` | #1A1A1A ~ #111827 | 헤드라인 (거의 블랙) |
| `--text-secondary` | #4B5563 ~ #6B7280 | 본문 |
| `--text-muted` | #9CA3AF | 날짜/캡션 |
| `--border` | #E5E7EB | 구분선 |
| `--accent` | #2563EB ~ #0369A1 | CTA/링크 |

특징: **기관 브랜드색 1개 + 중립 그레이 시스템**. 화려한 gradient 없음. 신뢰감 = 절제.

### Typography

| 요소 | Font | Size | Weight | 비고 |
|------|------|------|--------|------|
| Hero headline | Serif (Source Serif, Georgia) | clamp(2.5rem, 4vw, 3.5rem) | 700 | **Serif가 핵심** — 학술 권위 |
| Section title | Sans (Noto Sans, Inter) | clamp(1.5rem, 2.5vw, 2rem) | 600 | |
| Card title | Sans | 1.125rem | 600 | |
| Body | Sans | 1rem (16px) | 400 | line-height 1.75 (학술 문서 수준) |
| Date/Meta | Sans | 0.8125rem | 400 | muted color |
| Overline | Sans | 0.75rem | 600 | uppercase, letter-spacing 0.08em, primary color |

특징: **Serif (hero) + Sans (body) 이중 체계**가 학술 기관의 표준. Overline(`RESEARCH` / `NEWS` 같은 섹션 라벨)이 정보 구조를 명확히 함.

### Layout Patterns

```
[Header — 로고 + mega-menu nav, white solid]
[Hero — 풀폭 이미지/동영상 + overlay headline + overline 라벨]
[Mission — 2-column (텍스트 + 이미지), 넓은 whitespace]
[Research Areas — 3-column cards (이미지 + 제목 + 발췌)]
[Faculty Grid — 4-column 프로필 (사진 + 이름 + 직함 + 연구분야)]
[News Feed — 3-column (featured 1 large + 2 small)]
[Events — 리스트형 (날짜 블록 + 제목 + 장소)]
[Partners/Sponsors — 로고 그리드]
[CTA — 배경색 primary + 흰 텍스트 + 버튼]
[Footer — 다단 링크 + 기관 정보 + SNS]
```

### Component Templates

#### Faculty Profile Card

```css
.faculty-card {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}
.faculty-card__photo {
  width: 100%;
  aspect-ratio: 1;
  object-fit: cover;
  border-radius: var(--radius-md, 0.5rem);
  filter: grayscale(10%);
  transition: filter var(--duration-normal, 300ms);

  &:hover { filter: grayscale(0); }
}
.faculty-card__name {
  font-size: 1.125rem;
  font-weight: 600;
  color: var(--text-primary);
}
.faculty-card__title {
  font-size: 0.875rem;
  color: var(--text-secondary);
}
.faculty-card__research {
  font-size: 0.8125rem;
  color: var(--text-muted);
  line-height: 1.5;
}
```

person-card(원형 사진, 다크)과 비교: faculty-card는 **정사각형 사진 + 라이트 모드** — 더 학술적.

#### News Card (featured)

```css
.news-card {
  display: grid;
  grid-template-rows: auto 1fr;
  gap: 1rem;
  border-radius: var(--radius-lg, 0.75rem);
  overflow: hidden;
  background: var(--bg-surface, #f7f8fa);
}
.news-card__image {
  width: 100%;
  aspect-ratio: 16/9;
  object-fit: cover;
}
.news-card__body {
  padding: 1.25rem;
}
.news-card__overline {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--color-primary);
  margin-bottom: 0.5rem;
}
.news-card__title {
  font-size: 1.25rem;
  font-weight: 600;
  line-height: 1.3;
  color: var(--text-primary);
  margin-bottom: 0.5rem;
}
.news-card__date {
  font-size: 0.8125rem;
  color: var(--text-muted);
}
```

#### Overline Label

```css
.overline {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--color-primary, #2563eb);
}
```

이 패턴은 모든 프로젝트에 적용 가능 — 섹션 라벨, 카테고리 표시에 유용.

### Motion

| 패턴 | CSS | 비고 |
|------|-----|------|
| Section reveal | `translateY(24px) → 0, opacity 0 → 1, 600ms ease-out` | 표준 |
| Card hover | `translateY(-2px) + subtle shadow elevation` | 300ms ease |
| Image hover | `grayscale(10%) → grayscale(0)` | Faculty 사진 |
| 페이지 전환 | 없음 (전통적 full reload) 또는 View Transitions (fade) | |

특징: **최소 모션**. 학술 기관 사이트는 화려한 애니메이션보다 ��텐츠 가독성 우선.

### 적용 가이드

**적합한 프로젝트**: rise.jeju.ai (기관 사이트), halla.ai (학과 공식)

**채택할 패턴**:
- `faculty-card` — rise.jeju.ai, halla.ai 교수진 소개에 적합
- `news-card` + `overline` — rise.jeju.ai 뉴스/공지 섹션에 적합
- **Serif hero headline** — halla.ai의 Outfit과 병용하여 hero에만 Serif 적용 검토
- **Overline label** — 모든 프로젝트의 섹션 라벨에 즉시 적용 가능
- **bg-accent-subtle** — 연한 primary 색상의 배경 섹션 (rise.jeju.ai에 적합)

**채택하지 않을 패턴**:
- 전통적 mega-menu (우리 사이트는 Astro 기반 간결한 nav 유지)
- Full reload 페이지 전환 (View Transitions 사용)
- 과도한 whitespace (한국어 사이트는 정보 밀도가 더 높은 편)

### 기존 프로젝트 대비 장단점

| 비교 항목 | University | 기존 프로젝트 | 판정 |
|-----------|-----------|--------------|------|
| Hero | 이미지 풀폭 + overlay | Gradient mesh/atmospheric | 상황에 따라 |
| 교수진 표시 | Faculty card (정사각) | Person card (원형, 다크) | **신규 채택** (라이트 사이트용) |
| 뉴스/공지 | News card + overline | 없음 | **신규 채택** |
| Overline 라벨 | uppercase + primary color | 없음 | **신규 채택** (전체) |
| 타이포 | Serif hero + Sans body | Sans 통일 | **신규 참조** (halla.ai hero) |
| 모션 | 최소 | 중간~높음 | **기존 유지** |
| 배경 교대 | white ↔ subtle gray | gradient ↔ solid | 상황에 따라 |
