# Josh Comeau Joy of React — Compressed Skill-Source Summary

Purpose: source material for rewriting `/home/deymos/.agents/skills/josh-react/SKILL.md`. This summary compresses all requested course markdown files into actionable React implementation guidance, mental models, pitfalls, and module-by-module rules.

## Global React Mental Models

- **React elements are UI descriptions, not DOM nodes.** JSX compiles to `React.createElement(...)`; React compares element snapshots and mutates the DOM only where needed.
- **Rendering is not painting.** A re-render means React recalculates a snapshot/reconciles; it may produce zero DOM edits and zero repaint.
- **State changes are the root trigger.** Updating state re-renders the component that owns that state and its descendants. Children do not re-render “because props changed”; they re-render because an ancestor rendered, unless memoized.
- **Each render is a snapshot in time.** Constants, props, state, and effect closures belong to one render. Async callbacks/effects can observe stale values unless dependencies or state-setter callbacks are used correctly.
- **Data flows down.** Props are tunnels downward. When siblings need shared state, lift state to the nearest common ancestor. Use context when the same prop must be threaded repeatedly through intermediaries.
- **Components own markup + logic + styles.** Prefer component-oriented organization over file-type separation. `App` is the home base showing application structure.
- **Single source of truth.** Avoid duplicating/deriving the same fact in multiple state variables. Generate UI from shared data arrays where possible.
- **Least privilege.** Keep state/authority as local and narrow as possible; do not give consumers or children broader control than needed.

## Module 1 — React Fundamentals

### Core guidance
- JSX is JavaScript with expression slots. Use `{...}` to insert expressions, not statements.
- Components must start with a capital letter. Lowercase JSX is compiled as a built-in HTML tag.
- Props are function parameters for components; destructure them and use defaults where useful.
- `children` is the prop for nested JSX content; use it for component APIs that wrap arbitrary content.
- Use fragments (`<>...</>`) to return multiple siblings without adding DOM pollution.
- Iterate with `.map()` over arrays of data; React can render arrays of elements.
- Keys identify element identity across renders. Put `key` on the top-level element returned from the `.map()` callback. `key` is not a normal prop.
- Conditional rendering options:
  - `if` / early variable assignment for clearer branching.
  - `condition && <Thing />` only when left side is guaranteed boolean.
  - ternary for either/or UI.
- For ranges/repeated grids, a simple readable `range()` helper is preferred over clever one-liners.
- CSS Modules are the course’s baseline styling pattern: component owns related CSS, import `styles`, apply module classes.

### Pitfalls / rules
- JSX attributes are camelCased (`onClick`, `className`, `htmlFor`). Avoid reserved HTML names like `class` and `for` in JSX.
- Inline styles use objects and camelCased CSS property names; treat inline styles as an escape hatch, often useful for CSS variables/dynamic one-offs but not primary styling.
- JSX whitespace can disappear around inline elements. Use `{' '}` where needed; Prettier often inserts this.
- With `&&`, values like `0` and `NaN` can leak into UI. Golden rule: left side should evaluate to `true` or `false` explicitly, e.g. `items.length > 0 && ...`.
- Prefer `VisuallyHidden` text over `aria-label` where visible-equivalent screen-reader content is possible.

## Module 2 — Working With State

### Core guidance
- React event handlers are passed as function references: `onClick={handleClick}`, not `onClick={handleClick()}`. Wrap in an arrow when arguments are needed.
- React’s event system handles cleanup/optimization; use JSX event props instead of manual DOM listeners for normal UI events.
- `useState` returns `[value, setter]`; the setter schedules the next render. Current render’s value does not change synchronously.
- Name computed next values clearly (`nextCount`, `nextUser`) when using them immediately after setting state.
- Use lazy initializer functions for expensive initial state, e.g. reading localStorage once: `useState(() => readInitialValue())`.
- Controlled inputs bind React state to form controls: `value`/`checked` plus `onChange`.
- Prevent native form navigation/reload with `event.preventDefault()` when handling submissions in React.
- Props vs state: props are received from parents; state is owned internally and changed by the component.
- Update complex state immutably. Create new arrays/objects rather than mutating existing references.
- Generate dynamic IDs with `crypto.randomUUID()` or equivalent at creation time, not during render.
- Lift state up when multiple components need to read/write the same state.
- Component instances each own their own hook state; rendering the same component twice creates independent state.
- State management choice mental model: React state for local UI, context for broadly needed app state, specialized server-state tools (SWR/React Query/etc.) for remote cached data, external stores only when genuinely useful.

### Forms cheatsheet / pitfalls
- Inputs should remain either controlled or uncontrolled for their lifetime; do not switch.
- Text/textarea/select: use `value` + `onChange`.
- Checkbox/radio: use `checked` + `onChange`; radio groups need a shared `name`.
- Range input values are strings; convert to numbers when numeric logic is required.
- Generate select options/radio choices from one array of options to avoid duplicated sources of truth.
- Avoid mutating arrays/objects in state; mutation can prevent React from seeing meaningful changes and can corrupt snapshots.
- Key gotchas: unstable/random keys during render reset state and break identity. Use stable data IDs. Index keys are only acceptable for static/non-reordered lists.

## Module 3 — Hooks, Effects, Fetching, Memoization

### Hooks and refs
- Rules of Hooks:
  - Call hooks only inside React components or custom hooks.
  - Call hooks unconditionally at the top level, in the same order every render; never inside conditionals/loops/nested functions.
- `useId` creates stable unique IDs, especially for accessible form label/input relationships. Do not use it for list keys.
- `useRef` is a persistent mutable box (`ref.current`) that does not trigger re-renders. Primary use: DOM node references; also useful for non-visual mutable values.

### Effects
- Side effects include DOM synchronization, timers, subscriptions, localStorage, network requests, observers, etc.
- `useEffect` runs after render to synchronize React with external systems. Dependency arrays describe which render values the effect depends on.
- Respect the effect lint rules. Missing dependencies usually mean stale closures or incorrectly modeled effects.
- Empty dependency array means “run after first mount” for that component instance, but in Strict Mode development effects may mount/cleanup/remount.
- Cleanup functions remove event listeners, intervals, observers, and subscriptions. React calls cleanup before dependency-change reruns and on unmount.
- Never make the effect callback itself `async`; React expects either nothing or a cleanup function, not a Promise. Define and invoke an inner async function instead.
- For stale state updates in async/effect callbacks, use the state-setter callback form when needed: `setCount(current => current + 1)`. Default to direct setters when no stale-value risk; use callback form intentionally.
- Strict Mode intentionally double-invokes render/effects in development to reveal bugs. Leave it on; fix cleanup/idempotency issues rather than disabling it.

### Custom hooks
- Treat custom hooks as reusable hook “combos” that package state/effects/refs behind a focused API.
- Custom hooks must follow the same hook rules and should return the minimal useful data/actions.
- Useful examples from course direction: persistent state, interval handling, scroll/listener utilities.

### Data fetching
- Fetch-on-event: run `fetch` inside the event handler, use `try/catch`, validate response status, stringify JSON body for POST, and encode query parameters.
- Fetch-on-mount is thornier; prefer a library like SWR for mount-time remote data because it handles loading, error, caching, and revalidation patterns.
- If manually fetching on mount, manage loading/error state and avoid async effect callbacks.
- LocalStorage values are strings; serialize/parse with JSON when storing booleans/objects. SSR frameworks need different handling because `window` is absent on the server.

### Re-renders and memoization
- Every state update re-renders the owner and descendants. React prioritizes correctness/stale-UI avoidance over minimizing renders.
- `React.memo(Component)` memoizes a component render result and skips descendant render when props/state are unchanged. Use as-needed for measured performance problems, not everywhere.
- `useMemo` caches expensive computations or stabilizes object/array references passed to memoized children. Dependencies are cache invalidation.
- `useCallback` stabilizes function references for memoized children/effect dependencies; it is not a blanket optimization.
- Object/array/function equality is by reference. Fresh literals/functions created during render break memo boundaries unless memoized.
- React Compiler may automate much memoization, but the underlying mental model still matters.

## Module 4 — Component Design

### Component API design
- Think of components on a spectrum: app-specific components, reusable product components, and generic design-system/library primitives. Avoid rigid taxonomy debates.
- Design systems are rules/tokens/components that define brand behavior; component APIs should encode allowed flexibility.
- Prop delegation: collect unspecified props (`...delegated`) and spread them onto the underlying element so consumers can pass native attributes/data attributes/event handlers.
- Spread order controls authority/conflicts:
  - Hardcoded props after `{...delegated}` override consumer props.
  - `{...delegated}` after hardcoded props lets consumers override.
  - Choose intentionally based on how much power consumers should have.
- Delegate `className`/styles carefully. Allow style hooks when legitimate, but do not let consumers break semantic guarantees unless intended.
- Forward refs for “supercharged” wrappers around native elements so parent code/libraries can access DOM nodes.
- Polymorphic components should preserve semantic correctness. Example: action => `<button>`, navigation => `<a href>`. Do not choose tags by visual appearance.
- Restrict polymorphism when only some tags are valid, e.g. list component renders only `ul` or `ol`.
- Heading levels should reflect document outline, not font size. Pages should have one broad `h1`; sections/subsections use `h2`, `h3`, etc.

### Composition patterns
- Compound components can create ergonomic APIs for related pieces, but DIY versions are tricky; understand them mainly to consume libraries confidently.
- Slots: accept React elements as props for flexible insertion points. Component should retain control over props applied to slotted icons/content when needed (e.g. clone/size icon rather than burdening consumer).
- Context is “internal props.” Use it when a prop is repeatedly passed through intermediaries or represents shared app-wide settings. Context updates re-render consumers.
- Provider components should own their context state and export clean provider/context APIs. Split providers by concern (theme, playback rate, user, etc.).
- Context performance: changing context value re-renders all consumers. Move unrelated state out, split contexts/providers, and avoid broad values where only narrow consumers need updates.

### Accessibility / modal rules
- Interactive action elements should be buttons unless they navigate, then anchors.
- Modals/dialogs need correct markup, focus trapping, focus restoration, scroll locking, Escape close, backdrop close, and screen-reader-friendly structure.
- Prefer using unstyled accessible primitive libraries (Radix, Reach-like tools) for complex patterns such as dialogs, accordions, tooltips, etc., then style them.

## Module 5 — Happy Practices

### Key practices
- Keys are identity controls, not just warning suppressors. Changing keys can intentionally reset component state; stable keys preserve state.
- Derive state instead of storing redundant state. If a value can be calculated from props/state during render, usually calculate it rather than store it.
- Lift content up: pass rendered content/children into lower components to prevent unnecessary re-render coupling and preserve composition flexibility.
- Single source of truth: for any changing fact, one owner should be authoritative.
- Principle of Least Privilege: expose narrow callbacks/intents instead of broad setters when children only need specific actions. Prefer `onAddTodo(text)` over passing `setTodos` to arbitrary children.
- `useReducer` is useful for complex state transitions, especially when several actions update related state. Reducers centralize transition logic and work well with action objects/switch statements.
- Immer lets you write mutation-looking logic while producing immutable updates. Use for deeply nested/complex updates; understand that immutable output still matters.
- `useImmer` is a convenience hook for Immer-powered state updates.
- Portals render UI outside the normal DOM parent while preserving React ownership/context; useful for modals/toasts/overlays.
- Refs revisited: escape hatch for imperative work; do not use refs as hidden state that should drive rendering.
- Error boundaries catch render-time errors in descendant trees and display fallback UI; they do not replace ordinary error handling for events/fetches.

### Pitfalls
- Do not mirror props into state unless there is a specific reset/edit-buffer reason.
- Do not pass setter functions widely by default; it grants too much power and couples children to parent state shape.
- Do not over-reduce simple independent state; `useState` is often simpler.

## Module 6 — Full Stack React / Next.js

### Rendering mental models
- Client-side rendering ships minimal HTML plus JS; browser builds UI after JS loads.
- Server-side rendering sends formed HTML/CSS for faster initial content, then hydration attaches interactivity.
- Hydration requires server-rendered markup to match the client’s initial render. Mismatches cause errors and/or UI lies.
- “SSR” is an umbrella: per-request SSR, static generation, ISR, streaming SSR, etc.; each trades freshness, speed, and complexity.
- React Server Components (RSC) allow components to run only on server and avoid shipping their JS. In Next App Router, components are Server Components by default.
- Client Components require `'use client'`, but still render on the server during SSR. Therefore `window`, `localStorage`, viewport reads, etc. cannot be used directly during render.

### Next.js App Router rules
- Use `page.js` for routes and `layout.js` for shared shells.
- Keep as little code as possible in Client Components. Move only interactive/stateful/browser-dependent pieces behind `'use client'` boundaries.
- Styled/client-only libraries may require small Client wrapper components.
- Routing includes static routes, dynamic segments, links, and programmatic navigation.
- Metadata API supplies route metadata/SEO.
- Use import aliases for cleaner project structure.
- Production build can differ from dev; validate with `npm run build` and local production start.
- Deployment: managed providers like Netlify simplify hosting; troubleshoot by reproducing production builds locally.

### SSR gotchas and browser APIs
- Never read `window`/`document`/`localStorage` during server render. Options:
  - defer to `useEffect` when it can wait,
  - use cookies/server-readable data for first render when UI must be truthful immediately,
  - render SSR-safe fallback only if it does not lie or cause unacceptable flash.
- Course exercise rule: persisted cart must not flash “empty” when saved items exist; choose SSR-compatible persistence/initialization.
- Media query/viewport state must avoid server crashes and hydration mismatch.
- LocalStorage is client-only; cookies can be read server-side and are better for SSR-critical preferences like theme.

### Data, cache, Suspense, streaming
- Rendering strategies should match data freshness needs. Static/ISR/per-request each have appropriate use cases.
- React cache can dedupe server-side requests per render/request so repeated data calls log/fetch once.
- Suspense mental model: draw a boundary around UI that cannot continue until async work is ready (“rock concert: show starts when all required bandmates are ready”).
- Suspense consolidates loading states and, in SSR, enables streaming: send ready shell first, stream slow chunks later.
- Place Suspense boundaries to improve perceived performance and avoid layout shifts. Sometimes group slow components under one boundary to avoid jarring staggered jumps.
- Fallbacks should match layout shape where possible (skeletons for cards, spinner for isolated comments).
- Lazy loading/dynamic imports split bundles. Use for code not needed immediately or heavy client libraries; understand it solves JS download timing, while streaming solves HTML/data timing.
- In Next, dynamic imports/lazy client components can avoid server crashes from browser-only modules.

### Dark mode
- Instant theme toggles need sub-100ms response. For SSR-compatible dark mode, prefer cookies + early CSS variables/class setup so first paint is correct.
- `prefers-color-scheme` and user preference need clear precedence.

## Module 7 — Motion / Framer Motion

### Core guidance
- Framer Motion has rebranded to Motion; imports should use `motion/react` in current projects.
- `motion.div`, `motion.button`, etc. are components created from lowercase tag helpers; the normal “component starts capitalized” rule doesn’t apply to property access like `motion.div`.
- Use Motion for spring-based UI animation rather than CSS transitions when animating React state/layout changes.
- For value animations, use `initial={false}` when animation should not happen on mount.
- Layout animations: add `layout` and let Motion animate between bounding boxes using transforms. Prefer CSS to determine final layout; Motion animates the transition.
- Shared layout animations move an element visually between positions using stable layout identity (`layoutId`) and grouping where needed.
- Motion measures bounding boxes, not internal text glyphs. Shrink-wrap elements around content to avoid awkward paragraph/text distortion.
- Animate layout-affecting changes with transforms for performance; avoid manually animating width/height when Motion layout animation can handle it.

### Accessibility and reduced motion
- Motion should improve continuity, not block usability. Test with OS/browser “Reduce Motion”.
- Use `MotionConfig` reduced-motion settings and CSS `prefers-reduced-motion` for CSS-based animations.
- Ensure UI remains clear and usable with animations disabled; toggles should jump instantly rather than animate.

### Troubleshooting layout animation
- If text distorts, isolate text in a non-layout child or shrink-wrap.
- Ensure stable keys/layoutIds and correct grouping when elements move between lists.
- Use layout animations for all participating moving elements, including close buttons or sibling controls that otherwise snap.
- If animations run unexpectedly due to unrelated DOM changes, investigate layout roots/groups and component boundaries.

## Project — Blog

- Project functions as a final boss integrating course concepts in a Next.js blog.
- Uses MDX for interactive content inside markdown. MDX is powerful for content-heavy interactive sites; avoid it when plain content/simple CMS needs do not justify complexity.
- Recommended MDX approach in course: `next-mdx-remote` as a flexible middle ground without bringing its own bundler.
- Project includes Framer/Motion import update: use `motion/react`.
- Be careful not to bikeshed minor visual details at the expense of substantive behavior.
- Suspense is not always required for fast server work; optimize based on measured bottlenecks and UX.
- Next navigation prefetch improves performance but can make data stale; disable prefetch when fresh data is critical.
- Continued growth advice: avoid tutorial hell by doing unguided practice and building projects.

## Project — Toast

- Toasts are non-blocking status updates. Use dialogs for urgent, blocking attention/focus-trapping; use toasts for non-urgent feedback.
- Required architecture likely uses `ToastProvider`, `ToastShelf`, and individual toast components.
- Toast system should support adding/removing messages, visual variants, dismissal, and placement without blocking page interaction.
- Use portals where appropriate for overlay/shelf positioning.
- Prefer building enough yourself to understand dependencies; third-party components are fine if you could recreate the underlying pattern.
- Unguided practice goal: spend real time extending/refining beyond guided solution.

## Project — Word Game / Wordle

- Project emphasizes strategy and mindset: use provided resources incrementally instead of waiting until the end to watch all solutions.
- Local dev uses Parcel; WSL users should keep files inside Linux filesystem for file watching/dev server reliability.
- Implementation concerns include controlled form input for guesses, validation, keyboard handling, derived game status, and rendering rows/cells from data.
- Guess validation uses exactly five letters; regex pattern like `[a-zA-Z]{5}` may supplement `minLength`/`maxLength` because browser behavior can vary.
- Keep game state as single source of truth: answer, guesses, current guess, status. Derive cell statuses and win/loss display from that state.

## Cross-Course Implementation Rules for a Josh-React Skill

1. Start by identifying state ownership. Keep state local unless multiple components need it; then lift to nearest common ancestor; use context only for repeated prop threading/shared app concerns.
2. Derive everything possible during render. Store only authoritative changing facts.
3. Treat renders as pure snapshot calculations. Put side effects in event handlers or effects, with cleanup.
4. Honor hook rules and effect dependency linting. Missing dependencies require a design reason, not suppression by default.
5. Preserve immutability for state updates. Use copying or Immer for nested updates.
6. Use stable keys from data identity. Never use random keys generated during render; use index keys only for static lists.
7. Design components around semantic HTML and accessibility first, styling second.
8. Use prop delegation/ref forwarding intentionally for reusable components; spread order is an API power decision.
9. Prefer composition (`children`, slots, compound APIs) over broad configuration when it keeps ownership clear.
10. Do not prematurely memoize. Use `React.memo`, `useMemo`, and `useCallback` for expensive work, stable references into memoized children, or measured render issues.
11. In Next/RSC, default to Server Components and isolate client interactivity. Client Components still SSR, so browser APIs cannot run during render.
12. Avoid hydration lies. First client render must match server output, or use server-readable persistence like cookies for SSR-critical UI.
13. Use Suspense boundaries to group slow async UI and improve streaming/loading UX; use skeletons/fallbacks that avoid layout shift.
14. Lazy-load heavy/non-immediate client code; distinguish bundle splitting from data/HTML streaming.
15. Respect reduced motion. Use Motion for continuity and layout transitions, but make disabled-motion states fully usable.

## High-Value Pitfall Checklist

- `onClick={fn()}` invokes immediately; use `onClick={fn}` or arrow.
- State setters schedule next render; do not expect current variable to update immediately.
- Controlled/uncontrolled input switching causes warnings/bugs.
- LocalStorage stores strings and is unavailable during SSR.
- Mutating state objects/arrays corrupts React’s snapshot model.
- `key` is special, not a prop; unstable keys reset component instances.
- `0 && <Thing />` renders `0`; make condition boolean.
- Effects without cleanup leak listeners/timers/observers.
- Async effect callbacks return Promises; wrap async work inside effect instead.
- Stale closures arise because each render is a snapshot; use dependencies or setter callback form.
- Strict Mode double-runs development code; fix idempotency/cleanup.
- Fresh object/array/function props defeat `React.memo` unless memoized.
- Passing raw setters broadly violates least privilege and couples children to parent internals.
- Context changes re-render consumers; split providers/values by concern.
- Client Components in Next still run on server for SSR; no browser globals during render.
- Hydration mismatches often come from time/random/browser-only values in initial render.
- Motion layout animation depends on bounding boxes, stable identity, and all moving pieces participating.
