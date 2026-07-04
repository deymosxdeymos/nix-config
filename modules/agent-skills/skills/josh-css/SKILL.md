---
name: josh-css
description: "Apply Josh Comeau's CSS for JavaScript Developers course guidance: cascade, layout, positioning, stacking, component CSS, flexbox, responsive CSS, typography/media, grid, animations, and visual polish. Use when writing, reviewing, or explaining CSS/UI code."
---

# Josh CSS Skill

Use this skill for CSS, layout, responsive design, animation, and UI polish work that should follow Josh W Comeau's **CSS for JavaScript Developers** mental models.

## Reference map

Full local course notes are in this skill's `reference/` directory. `reference/course-summary.md` is a subagent-generated full-course compressed summary created after reading all CSS for JS markdown files. Read it first for broad guidance, then read the relevant module file before detailed work:

- `reference/course-summary.md` — complete-course summary: mental models, module-by-module rules, pitfalls, and implementation checklist.
- `reference/css-for-js-00-recap.md` — selectors, media queries, pseudo-classes/elements, color, units, typography, browser debugging.
- `reference/css-for-js-01-rendering-logic-1.md` — inheritance, cascade, block/inline axes, box model, flow layout, width/height algorithms, margin collapse.
- `reference/css-for-js-02-rendering-logic-2.md` — relative/absolute/fixed/sticky positioning, containing blocks, stacking contexts, z-index, portals, overflow, scroll containers, hidden content.
- `reference/css-for-js-03-components.md` — styled-components, global/dynamic styles, vendor prefixes, component libraries, breadcrumbs/buttons, dynamic tags, escape hatches.
- `reference/css-for-js-04-flexbox.md` — flex directions/alignment, grow/shrink, `flex` shorthand, constraints, wrapping, gap, ordering, recipes.
- `reference/css-for-js-05-responsive-css.md` — mobile testing, media queries, container queries, breakpoints, CSS variables/fragments, `calc`, viewport units, clamp, responsive/fluid typography.
- `reference/css-for-js-06-typography-and-media.md` — text rendering/overflow, font stacks, web fonts/loading/optimization, icons, images, object-fit/position, aspect-ratio, responsive images, backgrounds.
- `reference/css-for-js-07-css-grid.md` — grid mental model, flow/layout modes, construction, alignment, areas, tracks/lines, fluid grids, full-bleed, overflow, subgrid.
- `reference/css-for-js-08-animations.md` — transforms, transitions, keyframes, fill modes, styled-components animation, performance, design, orchestration, accessibility, 3D transforms.
- `reference/css-for-js-09-little-big-details.md` — filters, border radius, shadows, colors/accessibility, gradients, mobile UX, pointer events, clipping, optical alignment, scroll, focus, `:has`.
- `reference/css-for-js-bonus.md` — intro Figma and React notes.

## Core CSS mental models

- Treat CSS as a constraint system with algorithms, not a bag of properties.
- Before changing CSS: identify the active layout mode, inspect computed styles/cascade, inspect box model/flex/grid overlays, then change the smallest relevant declaration.
- When debugging overflow, sticky, or z-index, inspect scroll containers, containing blocks, stacking contexts, and intrinsic/min-content constraints.
- Know which properties inherit and which do not. Use inheritance intentionally for typography/color.
- Cascade resolution: origin/importance, specificity, source order. Prefer low-specificity, composable selectors before reaching for `!important`.
- Think in logical axes: block vs inline direction; avoid assuming horizontal/vertical when writing robust layout.
- Box model: content + padding + border + margin. Prefer `box-sizing: border-box` for predictable sizing.

## Layout guidance

- Flow layout is the default; use it when content naturally stacks.
- Width/height algorithms matter: `width: auto`, percentages, min/max constraints, and intrinsic sizes interact.
- Avoid fixed heights for dynamic content unless clipping/scrolling is intentional.
- Understand margin collapse; use padding, border, flex/grid gap, or flow-root when collapse is unwanted.
- Positioning:
  - `relative` nudges visually without changing document flow and can create a positioning context.
  - `absolute` positions against its containing block; often the nearest positioned ancestor, but transforms, filters, containment, and related properties can also create containing blocks.
  - `fixed` is viewport-relative unless captured by transformed/contained/filter ancestors; test on mobile.
  - `sticky` requires scroll room, an inset such as `top`, and compatible overflow ancestors.
- Stacking contexts isolate z-index. If z-index "doesn't work", inspect parents for stacking-context triggers rather than using bigger numbers.
- Manage overflow deliberately; clipping can break shadows, focus rings, popovers, and sticky positioning.
- Choose hidden-content techniques deliberately: `display: none`, `visibility: hidden`, opacity, offscreen positioning, `aria-hidden`, `inert`, and visually-hidden utilities differ for layout, focus, and screen readers.
- Prevent accidental horizontal scroll; suspicious causes include `100vw`, fixed widths, long words/URLs, images, and flex/grid min-content constraints.

## Component and CSS-in-JS guidance

- Use styled-components/course CSS-in-JS guidance as a vehicle, not a requirement; preserve semantic HTML and accessible component APIs.
- Keep global styles limited to resets, root tokens, fonts, and truly app-wide rules.
- Drive variants with semantic props and tokens, not arbitrary implementation flags.
- Avoid leaking style-only props to the DOM; use transient props or prop filtering.
- Use `as`, `className`, `style`, and other escape hatches sparingly and deliberately; do not compromise semantics/accessibility.
- Prefer CSS variables for highly dynamic values to avoid generating many unique runtime styles.
- Keep a single source of styles for spacing, color, typography, and variants via tokens, helpers, and composition.

## Flexbox guidance

- Use flexbox for one-dimensional distribution/alignment.
- Remember main vs cross axis depends on `flex-direction`.
- `justify-content` distributes along the main axis; `align-items` aligns along the cross axis.
- `flex` shorthand controls grow, shrink, and basis; prefer explicit values when behavior matters.
- Use `gap` for spacing between flex children instead of child margins when possible.
- Watch min-content constraints; flex children may need `min-width: 0` or `min-height: 0` to shrink.
- Avoid visual reordering with `order` when it would conflict with DOM, focus, or screen-reader order.

## Grid guidance

- Use grid for two-dimensional page/component layout.
- Define tracks with `fr`, `minmax()`, `repeat()`, and named areas/lines when they clarify intent.
- When `1fr` tracks overflow because of min-content sizing, use `minmax(0, 1fr)` or set child `min-width: 0`.
- Use grid for full-bleed layouts, card grids, sticky sidebars, and magazine/news layouts.
- Use `auto-fit`/`auto-fill` with `minmax()` for fluid grids; remember `auto-fill` preserves empty tracks while `auto-fit` collapses them.
- Keep source order accessible; don't use visual placement to scramble reading/focus order.
- Consider subgrid when children need to align to ancestor tracks; remember subgrid inherits parent track sizing.

## Responsive guidance

- Design mobile-first unless the project has a strong reason not to.
- Confirm the viewport meta tag for mobile layouts.
- Use breakpoints where the layout breaks, not arbitrary device names.
- Prefer fluid values with `clamp()`, `min()`, `max()`, `calc()`, CSS variables, viewport units, and container queries.
- Use container queries for component responsiveness when viewport queries are too coarse; remember they query established containers, not arbitrary ancestors.
- Use feature queries (`@supports`) for progressive enhancement and fallbacks.
- Use interaction media queries (`hover`, `pointer`) so touch devices are not stuck with hover-only UX.
- Treat `100vw` as suspicious; it can include scrollbar width and create horizontal overflow.
- Know mobile viewport unit tradeoffs: `svh`, `lvh`, and `dvh` solve different browser-chrome problems; test on real devices.
- Test on real/mobile browsers for viewport units, safe areas, touch targets, hover/pointer capabilities, and scroll issues.

## Typography and media guidance

- Optimize font loading to reduce invisible text and layout shift; serve only needed weights/styles/subsets.
- For web fonts, consider FOIT/FOUT, `font-display`, preloads, fallback metric matching, variable-font tradeoffs, and modern formats/subsets.
- Use robust font stacks and unitless `line-height` for scalable typography.
- Handle overflow for long words, titles, and user-generated content with wrapping, hyphenation, ellipsis, or line clamp as appropriate.
- For images, set dimensions/aspect ratio to prevent layout shift.
- Use real `<img>`/`picture` markup with alt text for meaningful content; CSS backgrounds are decorative by default.
- Use `srcset`, `sizes`, and `picture` for responsive images/art direction when file size or crop choice matters.
- Use `object-fit`/`object-position` for cropping; serve responsive images when file size matters.

## Animation and polish guidance

- Prefer transform/opacity animations for performance; avoid animating layout-heavy properties unless necessary.
- Use transitions for simple state changes; keyframes for multi-step or autonomous motion.
- Prefer explicit transition properties; avoid `transition: all`.
- Know keyframe fill modes (`none`, `forwards`, `backwards`, `both`) when mount/end states matter.
- Treat 3D transforms as a separate rendering model: perspective, transform-style, backface visibility, stacking/containing-block side effects, and browser quirks matter.
- Use `will-change` only as a temporary, measured hint, not a blanket optimization.
- Choose easing/duration to communicate physical intent. Fast interactions should feel responsive.
- Respect `prefers-reduced-motion`; significant motion needs a reduced alternative.
- Validate visible `:focus-visible` outlines, contrast for all states, hit targets, hover alternatives on touch, and reduced-motion behavior.
- Use `:focus-within` for parent styling and never remove outlines without an accessible replacement.
- Polish details: selection/accent colors, shadows that match light source, optical alignment, nested border-radius math, mobile tap targets, scroll snapping/scrollbar styling, filters/backdrop-filter fallbacks, and `:has()` where it simplifies stateful selectors.
