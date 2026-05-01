---
description: CSS animation pattern catalog — scroll-reveal, hover, transitions, micro-interactions
type: reference
domain: design
topics: [motion, animation, css]
---

# Motion Library

> Used by `design-motion` skill to recommend reusable animation patterns instead of generating new ones each project.

## Pattern format

Each pattern lives under its own H2 section with:
- **When**: trigger condition
- **CSS**: minimal implementation
- **Variants**: project-specific tweaks (link via wiki style)

## scroll-reveal

**When**: element enters viewport, reveal once.

```css
.reveal {
  opacity: 0;
  transform: translateY(1rem);
  transition: opacity 600ms ease, transform 600ms ease;
}
.reveal.in-view {
  opacity: 1;
  transform: none;
}
```

```js
const io = new IntersectionObserver(entries => {
  for (const e of entries) if (e.isIntersecting) e.target.classList.add('in-view');
}, { threshold: 0.15 });
document.querySelectorAll('.reveal').forEach(el => io.observe(el));
```

**Variants**: stagger via `transition-delay` per child (50ms increment).

## glow

**When**: hover on primary CTA, ambient pulse on hero.

```css
@keyframes glow {
  0%, 100% { box-shadow: 0 0 0 0 currentColor; }
  50%      { box-shadow: 0 0 24px 0 currentColor; }
}
.cta { animation: glow 2400ms ease-in-out infinite; opacity: 0.85; }
```

## film-grain

**When**: hero overlays for editorial/cinematic feel.

```css
.grain::after {
  content: '';
  position: absolute; inset: 0;
  pointer-events: none;
  background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><filter id="n"><feTurbulence baseFrequency="0.9"/></filter><rect width="100%" height="100%" filter="url(%23n)" opacity="0.1"/></svg>');
  mix-blend-mode: overlay;
}
```

## (add more patterns following the same shape)

---

## Naming conventions

- Pattern name: kebab-case, descriptive (avoid `effect1`, `cool-thing`)
- One concept per pattern (don't combine grain+vignette)
- Always include CSS minimum + JS only if essential
- Variants belong in the project's CSS, not here
