---
name: josh-react
description: "Apply Josh Comeau's Joy of React course guidance: React fundamentals, state, hooks, component design, happy practices, full-stack React/Next.js, Motion formerly Framer Motion, and course projects. Use when writing, reviewing, teaching, or debugging React/Next.js code in this style."
---

# Josh React Skill

Use this skill for React/Next.js implementation, review, refactoring, debugging, or explanations that should follow the mental models and practices from Josh W Comeau's **Joy of React**.

## Reference map

Full local course notes are in this skill's `reference/` directory. `reference/course-summary.md` is a subagent-generated full-course compressed summary created after reading all Joy of React markdown files. Read it first for broad guidance, then read the relevant module file before detailed work:

- `reference/course-summary.md` — complete-course summary: mental models, module-by-module rules, pitfalls, and implementation checklist.
- `reference/joy-of-react-module1.md` — React fundamentals: JSX, components, props, children, fragments, iteration, keys, conditionals, styling, CSS Modules.
- `reference/joy-react-02-state.md` — events, `useState`, async updates, forms, controlled inputs, props vs state, mutation bugs, dynamic keys, lifting state.
- `reference/joy-react-03-hooks.md` — `useId`, hooks rules, refs, effects, cleanup, stale values, custom hooks, fetching, memoization.
- `reference/joy-react-04-component-design.md` — component spectrum, prop delegation, refs, polymorphism, compound components, slots, context, modals, unstyled libraries.
- `reference/joy-react-05-happy-practices.md` — keys as reset lever, deriving state, lifting content, single source of truth, least privilege, `useReducer`, Immer, portals, error boundaries.
- `reference/joy-react-06-full-stack-react.md` — SSR/hydration/RSC, Next.js routing, metadata, rendering strategies, cache, Suspense, lazy loading, dark mode.
- `reference/joy-react-07-framer-motion.md` — Motion basics, layout/shared-layout animations, groups, accessibility, Next.js motion disabling.
- `reference/joy-react-project-blog.md`, `reference/joy-react-project-toast.md`, `reference/joy-react-project-wordle.md` — project-oriented patterns.

## Core React mental models

- React elements are UI descriptions, not DOM nodes. JSX compiles to element descriptions; React reconciles snapshots and mutates the DOM where needed.
- Rendering is not painting. A re-render may produce no DOM edits and no visual repaint.
- State updates re-render the component that owns the state and its descendants. Children do not re-render merely “because props changed” unless memoization changes behavior.
- Model UI as a pure function of state. Keep render logic pure; do side effects in event handlers or effects.
- Prefer component-oriented organization: components own related markup, logic, and styles. CSS Modules are the course baseline for styling fundamentals.
- Use JSX expression slots deliberately. JSX accepts expressions, not statements; attributes are `className`, `htmlFor`, and camelCased event/style props.
- Use fragments when a component needs sibling elements without extra DOM.
- When mapping arrays, use stable semantic keys from data. Avoid indexes except for static, never-reordered lists; never generate random keys during render.
- Conditional rendering choices: `if` for larger branches, ternary for either/or UI, and `&&` only when the left side is explicitly boolean (`count > 0 && ...`) to avoid rendering `0`.

## State, events, and forms

- Event handlers are function references: `onClick={handleClick}`, not `onClick={handleClick()}`. Use an arrow when passing arguments.
- `useState` setters schedule the next render; the current render’s variable does not update synchronously.
- Keep state minimal. Derive values during render when possible instead of storing duplicated derived state.
- Treat state as immutable. Copy arrays/objects or use Immer for complex nested updates.
- Lift state to the lowest common owner; keep state private unless other components truly need it.
- Prefer least-privilege callbacks (`onAddTodo(text)`) over passing broad setters to children.
- Prefer controlled form fields when React owns the value. Do not switch an input between controlled and uncontrolled during its lifetime.
- Forms cheatsheet: text/textarea/select use `value`; checkbox/radio use `checked`; radio groups need shared `name`; range values are strings; generate options from data to preserve single source of truth.
- Use `defaultValue`/`defaultChecked` for intentionally uncontrolled initial values, not as a substitute for controlled state.
- Use `useId` for stable accessible IDs, especially labels/inputs; do not use it for list keys.
- Use lazy initializer functions for expensive initial state or client-only one-time reads such as localStorage in non-SSR contexts.

## Hooks and effects

- Call hooks only at the top level of React components or custom hooks, unconditionally and in the same order every render.
- Use refs for DOM access or mutable instance-like values that should not trigger a render.
- Effects are for synchronizing with external systems, not ordinary derivations.
- Respect effect dependency lint rules. Missing dependencies usually indicate stale closures or a mis-modeled effect.
- Always clean up subscriptions, timers, observers, requests, and global listeners.
- Never make the effect callback itself `async`; define and invoke an inner async function instead.
- Avoid stale closures with correct dependencies, state-setter callbacks, refs, or restructuring.
- Strict Mode double-invokes render/effects in development to reveal bugs. Fix cleanup/idempotency rather than disabling it.
- Memoization (`memo`, `useMemo`, `useCallback`) is an optimization tool, not a default. Use it for expensive work, stable references into memoized children, or measured render issues.
- React 19 Actions are not deeply covered by the local Joy of React notes; do not assume they replace controlled inputs or ordinary form/state fundamentals.

## Component design and accessibility

- Start simple. Reach for richer APIs only when usage demands flexibility.
- Prefer composition (`children`, slots, narrow callbacks) over boolean-prop explosions.
- Prop delegation is useful for wrapper components, but spread order is an API power decision; handle conflicts and style/class merging intentionally.
- For reusable primitives, expose DOM refs intentionally. In React 19 accept `ref` as a prop; use `forwardRef` for React 18/older code.
- Use polymorphism only when semantic element choice matters. Actions should be `<button>`; navigation should be `<a href>`.
- Heading levels follow document outline, not font size.
- Use compound components for ergonomic related-piece APIs; use context as “internal props” when many descendants need shared data/actions or prop threading becomes noisy.
- Context updates re-render consumers; split providers/values by concern, avoid broad frequently-changing values, and memoize provider values when stable identity matters for consumers.
- For dialogs/modals/tooltips/accordions, prefer accessible unstyled primitives when appropriate. Focus trapping, focus restoration, Escape close, scroll lock, and screen-reader behavior are hard.

## Next.js / full-stack guidance

- Distinguish client rendering, SSR, hydration, React Server Components, streaming, and lazy loading.
- In Next App Router, `page.js` defines routes and `layout.js` defines shared shells. Components are Server Components by default.
- Add `'use client'` only for interactive, stateful, or browser-dependent islands; keep Client Components as small as practical.
- Client Components still render on the server during SSR, so do not read `window`, `document`, `localStorage`, viewport, time/randomness, or browser-only values during render.
- Avoid hydration lies. The first client render should match server output, or use server-readable persistence like cookies for SSR-critical UI such as theme/cart.
- Match rendering strategy to freshness/performance needs: static generation, ISR, per-request dynamic rendering, streaming, and cache/dedupe behavior have different tradeoffs.
- Use Suspense boundaries to group slow async UI and control loading/streaming UX; choose fallbacks/skeletons that avoid layout shift and jarring staggered reveals.
- Lazy loading is for JS bundle timing; streaming/Suspense is for HTML/data readiness. Use `React.lazy`, `next/dynamic`, and `ssr: false` deliberately for heavy or browser-only client code.
- Use framework routing, metadata, caching, and lazy-loading features instead of hand-rolled versions when appropriate.
- For MDX blogs, map MDX components intentionally, keep interactive islands isolated, and consider `next-mdx-remote` tradeoffs from the course notes.
- Production builds can differ from dev. Validate important Next work with a production build/start.

## Motion guidance

- Current projects should import from `motion/react` (`import { motion, MotionConfig } from 'motion/react'`) unless maintaining older Framer Motion code.
- Use `MotionConfig` with reduced-motion handling, and respect OS/browser “Reduce Motion”.
- Prefer layout animations (`layout`, `layout="position"`, or `layout="size"`) for position/size transitions; let CSS define the final layout and Motion animate bounding boxes with transforms.
- Text can distort during layout animation; isolate text in a non-layout child or shrink-wrap around content.
- Shared layout animations require stable `layoutId`s and correct grouping; avoid accidental layoutId collisions across repeated component instances.
- Use motion to clarify cause/effect, not as decoration that slows interaction. UI must remain usable with animations disabled.

## Project patterns

- Toast project: use provider/shelf/toast architecture, variants, dismissals, and portals when useful. Toasts are non-blocking status; dialogs are for blocking urgent UI.
- Toast APIs should support add/remove, visual variants, dismissal, placement, non-blocking interaction, timed/persistent behavior, and accessible status semantics without focus-trapping.
- Word game project: keep answer, guesses, current guess, and status as the source of truth; derive cell statuses and win/loss display.
- Blog project: MDX can power interactive content in Next; avoid unnecessary Suspense for fast server work, map custom MDX components deliberately, and disable navigation prefetch when fresh data is critical.
