# Josh Comeau CSS for JS — Compressed Skill-Source Summary

Source files read in full from `/home/deymos/Documents/react-anki`: `css-for-js-00-recap.md` through `css-for-js-09-little-big-details.md`, plus `css-for-js-bonus.md`.

## Course-level mental models

- CSS is a layout/rendering language with algorithms, not a bag of properties. Prefer understanding the algorithm in play: cascade, inheritance, flow layout, positioned layout, flex, grid, typography, images, animation, scrolling.
- Most CSS bugs come from invisible context: containing blocks, stacking contexts, formatting contexts, scroll containers, intrinsic sizes, default min sizes, inheritance, and browser/device constraints.
- Build from semantic HTML and native browser affordances first; add CSS for presentation, layout, polish, and state. Preserve accessibility while adding visual detail.
- Treat components as APIs. Encapsulate styles, expose intentional props/variants, preserve escape hatches, and avoid scattering the same styling decision across multiple files.
- Responsive CSS is not just viewport breakpoints. Use intrinsic layout, CSS variables, `calc()`, `clamp()`, container queries, fluid sizing, and feature queries.
- Animation and visual polish should support user intent. Prefer composited transforms/opacity, respect motion preferences, and keep interactions fast, predictable, and accessible.

## Module 0 — Fundamentals Recap

### Guidance
- Know CSS syntax vocabulary: selector, declaration block, declaration, property, value.
- Media queries gate declarations by conditions such as viewport width and interaction capabilities. Use them as conditional branches in CSS, but do not make everything breakpoint-driven.
- Selectors express matching rules. Use classes for most styling; reserve complex selectors for genuinely structural/stateful styling.
- Pseudo-classes target state or structural relationships (`:hover`, `:focus`, `:checked`, `:first-child`, etc.). Pseudo-elements create styleable virtual sub-elements (`::before`, `::after`, `::placeholder`, selection-related pseudo-elements).
- Combinators encode relationships: descendant, child, adjacent sibling, general sibling. They are powerful but couple CSS to DOM shape.
- Colors can be named, hex, RGB(A), HSL(A), and newer color functions where supported. Prefer HSL/LCH-style thinking for systematic hue/saturation/lightness adjustments.
- Units have different reference frames: `px` absolute-ish CSS pixels, `%` relative to context, `em` relative to current font size, `rem` relative to root, viewport units relative to viewport.
- Typography basics include font family, weight, size, line-height, letter-spacing, and alignment. Unitless `line-height` scales better with font size.
- Browser DevTools are part of the workflow: inspect computed styles, box model, cascade winners, layout overlays, responsive emulation, and accessibility states.

### Pitfalls / rules
- Specificity and source order often explain “CSS not working”; inspect the cascade before adding `!important`.
- Pseudo-elements often require `content`, even if empty.
- `%`, `em`, and viewport units can resolve against surprising ancestors/contexts.
- Complex selectors and DOM-dependent combinators make refactors fragile.

## Module 1 — Rendering Logic I: Flow, Box Model, Sizing, Collapse

### Guidance
- CSS has built-in declarations via user-agent stylesheets and inheritance. Text-related properties often inherit; layout/box properties usually do not.
- Cascade resolution depends on origin/importance, specificity, and source order. CSS-in-JS injection order can matter.
- Think in logical axes: block direction and inline direction vary by writing mode; modern properties like `margin-block`, `padding-inline`, `inset-*` map to the document flow.
- Box model: content, padding, border, margin. Use `box-sizing: border-box` globally for predictable authored dimensions.
- Padding is inside the border and contributes to box size; percentage padding resolves from inline/container width, enabling aspect-ratio hacks historically.
- Borders affect layout size unless accounted for; outlines do not take space and are useful for focus/debugging.
- Margins create outside spacing and can collapse vertically in flow layout. Prefer margins for sibling spacing, padding for internal breathing room.
- Flow layout lays block elements vertically and inline content horizontally; inline elements ignore width/height and vertical margin effects in many contexts.
- Width algorithms differ: block elements auto-fill available inline space; inline elements shrink-wrap content; `width: fit-content`, `min-content`, `max-content`, and intrinsic sizing reveal constraints.
- Height behaves differently from width: `height: auto` is content-driven; percentage heights require a definite parent height chain.
- Margin collapse happens only in normal flow, block axis, between adjacent vertical margins or parent/first/last child in specific conditions; it does not cross padding/border/flex/grid/positioned contexts.

### Pitfalls / rules
- Do not set fixed heights for dynamic content unless clipping/scrolling is intentional.
- Use margin consistently in one direction for layout rhythm to avoid collapse confusion.
- `width: 100%` can overflow when combined with padding/border unless `border-box` is active.
- Inline elements are not mini-blocks; use `inline-block`, flex, or grid when dimensions/vertical spacing matter.

## Module 2 — Rendering Logic II: Positioning, Stacking, Overflow

### Guidance
- Relative positioning visually offsets an element without moving its layout slot. It can also create a positioning context for absolutely positioned descendants.
- Absolute positioning removes an element from normal flow and positions it against its containing block. Use `position: relative` on the intended parent when needed.
- Center absolute children with opposing insets plus auto margins or transform-based centering; understand whether centering is layout-based or visual.
- Containing blocks are determined by positioning, transforms, filters, containment, and other properties—not only the nearest parent.
- Stacking contexts isolate z-index comparisons. Created by positioned elements with z-index, opacity under 1, transforms, filters, isolation, etc. Compare z-index only within the same stacking context.
- Manage z-index with a small scale/tokens and avoid arbitrary huge values. Portals can escape local stacking/overflow constraints for modals/tooltips.
- Fixed positioning is viewport-relative unless captured by transformed/contained ancestors. It is useful for persistent UI but can behave differently on mobile.
- Overflow creates clipping and scroll containers. `overflow: hidden/auto/scroll` has layout and accessibility implications.
- Horizontal overflow is commonly caused by `100vw`, fixed widths, long words/URLs, images, grid/flex min-content behavior, or negative margins.
- Sticky positioning toggles between relative and fixed behavior within the nearest scroll container; it requires inset values and enough scroll room.
- Hidden content choices differ: `display: none`, `visibility: hidden`, opacity, offscreen positioning, `aria-hidden`, and visually-hidden utilities have different layout/accessibility effects.

### Pitfalls / rules
- If z-index “doesn’t work,” look for stacking contexts, not larger numbers.
- If sticky “doesn’t work,” inspect overflow ancestors and required `top`/`bottom` inset.
- Avoid using overflow clipping as a casual clearfix; it can break shadows, focus rings, sticky, and popovers.
- Portaled elements need deliberate focus management, accessibility attributes, and layering strategy.

## Module 3 — Components and CSS-in-JS

### Guidance
- The course surveys styling approaches and focuses on styled-components patterns: colocated styles, scoped generated class names, dynamic props, theming/global styles, and component APIs.
- Use styled-components for component-scoped CSS with real CSS syntax, nesting, pseudo-selectors, and interpolation.
- Global styles are for resets, root tokens, fonts, and truly app-wide rules—not component details.
- Dynamic styles should be driven by semantic props/variants, not arbitrary implementation flags. Keep prop APIs stable and intentional.
- Vendor prefixing is normally handled by tooling; know when browser support requires fallbacks or feature queries.
- Component libraries should offer consistent primitives: Button, Breadcrumbs, ProgressBar, Select, IconInput, etc., with variants, states, disabled/loading behavior, and accessible markup.
- Escape hatches are sometimes necessary (`className`, `style`, `as`, transient props), but should not replace a thoughtful component API.
- Single source of styles: avoid duplicating spacing/color/typography logic across variants; use tokens, helper functions, and composition.

### Pitfalls / rules
- Avoid leaking styling-only props to the DOM; use transient props or filtering.
- Do not overuse the polymorphic `as` prop if it compromises semantics/accessibility.
- CSS-in-JS runtime/injection order can affect cascade; keep global/reset/theme order deterministic.
- Performance is usually fine, but avoid generating lots of unique styles per render when CSS variables or inline variables would suffice.

## Module 4 — Flexbox

### Guidance
- Flexbox is one-dimensional layout along a primary axis. `flex-direction` chooses main/cross axes; `justify-content` aligns along main, `align-items`/`align-self` along cross.
- Alignment is contextual: axis direction changes with row/column and writing mode.
- Flex grow/shrink distribute positive/negative free space. Items have base sizes, min sizes, and constraints before distribution.
- `flex` shorthand combines grow, shrink, and basis. Common useful values: `flex: 1` for equal columns that can grow/shrink; explicit `flex: 0 0 auto` when preserving intrinsic size.
- Constraints like `min-width`, `max-width`, `min-height`, and `max-height` participate in the algorithm.
- Wrapping creates multiple flex lines; alignment between lines uses `align-content` only when extra cross-axis space exists.
- Use `gap` for spacing between flex children instead of margins when possible.
- `order` changes visual order but not DOM/tab/screen-reader order; use sparingly.
- Flex is ideal for rows of controls, nav bars, centering, split layouts, and distributing items along one axis.

### Pitfalls / rules
- Flex items have an automatic min size; `min-width: 0` / `min-height: 0` often fixes overflow/truncation inside flex children.
- `flex: 1` is shorthand with non-obvious basis behavior; use longhand when precision matters.
- Visual reordering can harm accessibility and keyboard navigation.
- Do not force grid-like two-dimensional layout with flex if CSS Grid fits better.

## Module 5 — Responsive CSS

### Guidance
- Test on real mobile devices when possible; browser emulation is useful but incomplete. Include the viewport meta tag for mobile layouts.
- Media queries can target width, height, orientation, hover, pointer, reduced motion, color scheme, print, etc. Interaction queries help avoid hover-only mobile UX.
- Breakpoints should come from content/layout needs, not device names. Use a small tokenized breakpoint scale when useful.
- CSS variables are live, inherited custom properties. Use them for theme tokens, responsive values, component configuration, and JS/CSS bridges.
- Variable fragments can compose partial values, but readability matters.
- `calc()` enables mixed-unit math and custom-property-driven formulas.
- Viewport units have mobile browser chrome issues; know `svh`, `lvh`, `dvh` where supported, and avoid accidental `100vw` horizontal scroll.
- `clamp(min, preferred, max)` is core for fluid sizes, spacing, and typography.
- Responsive typography should keep readable line lengths and scale smoothly without extremes.
- Fluid design combines intrinsic layout, fluid type/space, and constraints; not everything needs breakpoints.
- Container queries let components respond to their container rather than viewport. They require a containment context and work best for reusable components.
- Killer pattern: define responsive tokens/custom properties at container/viewport boundaries, then consume them throughout component styles.
- Feature queries (`@supports`) allow progressive enhancement and fallbacks.

### Pitfalls / rules
- Avoid device-specific breakpoints and pixel-perfect assumptions.
- `100vw` includes scrollbar width in many browsers; use `100%` or account for overflow.
- Custom properties inherit and can be invalid at computed-value time; provide fallbacks and scope intentionally.
- Container queries query containers, not arbitrary ancestors; establish `container-type`/`container-name` deliberately.

## Module 6 — Typography and Media

### Guidance
- Text rendering varies by OS/browser/font smoothing; design for robust readability rather than exact pixel parity.
- Text overflow tools include wrapping, hyphenation, `overflow-wrap`, truncation with ellipsis, line clamping, and preserving/preventing whitespace.
- Print-style/magazine layouts can use columns, floats, and careful typographic rhythm, but must preserve reading flow.
- CSS multi-column layout can create masonry-like effects, but ordering is column-first and control is limited.
- Text styling includes emphasis, decoration, shadows, case, spacing, and OpenType/variant features; use sparingly for legibility.
- Font stacks should include appropriate fallbacks and generic families. System stacks offer performance and native feel.
- Web fonts require loading strategy: `@font-face`, formats, weights/styles, `font-display`, preloading when justified.
- Font loading UX balances FOIT/FOUT and layout shift. Match fallback metrics when possible.
- Optimize fonts by serving only needed weights/styles/subsets and using modern formats.
- Variable fonts pack axes into one file and allow fluid/interactive weight/width/slant changes, but require browser support and careful performance.
- Icons can be SVG, icon fonts, inline components, or images. SVG is generally preferred for accessibility, styling, and sharpness.
- Images need intrinsic dimensions, responsive sizing, appropriate formats, alt text, lazy loading, and object fitting.
- `object-fit` and `object-position` control replaced-element cropping; `aspect-ratio` reserves predictable space.
- Images inside flex/grid may need min-size or width rules to prevent distortion/overflow.
- Responsive images use `srcset`, `sizes`, and `picture` for resolution switching and art direction.
- Background images are decorative by default; important content should be real images with alt text.

### Pitfalls / rules
- Do not rely on exact text metrics across platforms.
- Ellipsis requires the correct combination of overflow, whitespace, and constrained width.
- Avoid serving unused font weights/styles; fonts are performance-sensitive.
- Always set dimensions/aspect ratios for media when possible to reduce layout shift.
- Use real `<img>` for meaningful content; CSS backgrounds are not accessible content.

## Module 7 — CSS Grid

### Guidance
- Grid is two-dimensional layout. Define explicit tracks, place items into cells/areas, and let auto-placement fill the rest.
- Grid and flex solve different problems: grid for rows + columns / page structure; flex for one-dimensional distribution.
- Construct grids with `grid-template-columns/rows`, `fr`, `minmax()`, `repeat()`, named lines, and auto tracks.
- Alignment can happen at item level (`justify-items`, `align-items`, `place-items`) or grid level (`justify-content`, `align-content`, `place-content`).
- Grid areas create readable layout maps but can obscure line-level precision.
- Tracks and lines are first-class. Negative line numbers count from the end; named lines/areas improve readability.
- Auto-fit/auto-fill with `minmax()` creates fluid responsive grids without media queries.
- Grid dividers can be created with gap backgrounds, pseudo-elements, or borders depending on semantics and wrapping needs.
- Recipes include two-line centering, sticky sidebars/layouts, full-bleed content inside constrained wrappers, and managing overflow.
- Grid quirks include default min-content constraints; use `minmax(0, 1fr)` or `min-width: 0` to allow shrinking.
- Subgrid lets children align to parent grid tracks; useful for card lists/forms but comes with support and mental-model gotchas.
- Dynamic layouts can combine grid, CSS variables, and component/container state.

### Pitfalls / rules
- `1fr` can still respect min-content and overflow; `minmax(0, 1fr)` is often safer.
- Auto-fill and auto-fit differ in whether empty tracks remain.
- Source/reading order still matters; do not use grid placement to scramble semantic order.
- Subgrid inherits track sizing from parent; it is not a fully independent nested grid.

## Module 8 — Animations

### Guidance
- Transforms modify visual rendering without affecting layout. Translate, scale, rotate, skew, and transform-origin are core primitives.
- Transitions animate property changes between states. Define property, duration, easing, and delay; prefer explicit properties over `all`.
- Keyframe animations define independent timelines. Use for looping, multi-step, or mount/attention animations.
- Fill modes control before/after keyframe styles; understand `none`, `forwards`, `backwards`, `both`.
- Dynamic updates in React/CSS-in-JS often use CSS variables, data attributes, or state-driven classes rather than regenerating keyframes unnecessarily.
- styled-components can define/reuse keyframes and compose animation styles, but avoid excessive per-render style generation.
- Animation performance: prefer `transform` and `opacity`; layout/paint-heavy properties are costly. Use DevTools performance tools for real problems.
- Design animations with purpose: communicate cause/effect, spatial relationships, state change, and hierarchy.
- Action-driven animation responds to user events; orchestration sequences/staggers multiple elements.
- Accessibility: respect `prefers-reduced-motion`, avoid vestibular triggers, keep focus/reading stable, and do not hide essential state in motion only.
- 3D transforms introduce perspective, transform-style, backface visibility, and rendering-context complexity.
- Browser rendering uses layout, paint, compositing; transforms can create layers but overusing layer promotion is wasteful.

### Pitfalls / rules
- Avoid `transition: all`; unexpected properties may animate and hurt performance.
- Animating layout properties (`width`, `height`, `top`, `left`, margins) can be expensive; use transform illusions when possible.
- `will-change` is a temporary hint, not a blanket optimization.
- Always provide reduced-motion alternatives for significant movement.
- Transform creates containing blocks/stacking contexts that can affect fixed/absolute children and z-index.

## Module 9 — Little Big Details

### Guidance
- CSS filters manipulate rendered pixels (`blur`, `brightness`, `contrast`, etc.). Use carefully; they can be expensive and affect stacking/rendering.
- Color manipulation requires contrast awareness. Choose accessible foreground/background combinations and test real states.
- Blur and backdrop filters are visually powerful but performance/browser-support-sensitive; provide fallbacks.
- Border radius has geometric behavior. Nested radii should account for padding/offsets; circular/elliptical shapes depend on dimensions.
- Shadows communicate elevation and lighting. Layered shadows often look more natural; contoured/single-sided/inset shadows solve specific visual problems.
- Selection colors and accent colors let native UI match brand while preserving contrast.
- Gradients include linear, radial, conic, easing/smoothing techniques, and dead-zone fixes. Use color-stop control for polish.
- Mobile UX improvements include avoiding hover-only controls, improving touch targets, handling pointer capabilities, and disabling accidental text selection only when appropriate.
- `pointer-events` can allow clicks to pass through decorative layers, but can also break interaction expectations.
- `clip-path` creates custom clipping shapes; combine with pseudo-elements and shadows carefully because clipping also clips shadows.
- Optical alignment sometimes differs from mathematical alignment; adjust icons/text/shapes visually for perceived balance.
- Scrolling tools include smooth behavior, scroll snapping, scrollbar styling, scroll optimization, and overflow management.
- Focus improvements: use `:focus-visible` for keyboard-friendly focus styling, `:focus-within` for parent styling, and custom outlines that remain visible and accessible.
- Floats are mostly legacy for layout, but still useful for text wrapping around media; understand clearfix/flow interactions.
- `:has()` enables parent/relational styling and powerful state-driven selectors; use progressively and mind performance/readability.

### Pitfalls / rules
- Do not remove focus outlines without a visible accessible replacement.
- Visual polish must not reduce contrast, hit targets, keyboard access, or motion safety.
- Backdrop/filter/blur effects can be expensive; test on lower-powered devices.
- Clipping and overflow can cut off shadows, focus rings, and positioned children.
- Smooth scrolling and scroll snapping should not fight user control or accessibility settings.

## Bonus — Intro to Figma / Intro to React

- Figma material supports translating design specs into CSS: spacing, typography, colors, component variants, constraints, and exportable assets.
- React intro supports using the CSS material in component-driven UI: props/state, component composition, styling APIs, and declarative rendering.

## Implementation rules for rewriting `SKILL.md`

- Emphasize diagnostic reasoning: identify layout mode, inspect computed styles, then change the smallest relevant rule.
- Include module-indexed source guidance so the skill can answer “where in the course this comes from.”
- Preserve Josh-style practical heuristics: content-driven breakpoints, intrinsic/fluid layout, tokens/custom properties, accessible components, and performance-aware animation.
- Prioritize modern CSS primitives: logical properties, flex/grid gap, `minmax()`, `clamp()`, container queries, `aspect-ratio`, `object-fit`, `:focus-visible`, `:has()`, reduced-motion queries.
- State when a technique is an escape hatch or has tradeoffs: portals, overflow clipping, z-index scales, `will-change`, backdrop filters, visual reordering, hidden content, complex selectors.
- For component/CSS-in-JS advice, require semantic props, no DOM prop leakage, deterministic global style order, and accessible polymorphism.
- For validation advice, recommend DevTools checks: cascade/computed panel, box model, flex/grid overlays, layers/performance, mobile emulation plus real-device testing, accessibility/focus testing, contrast checks, and reduced-motion testing.
