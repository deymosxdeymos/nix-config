# Joy of React - Module 7: Framer Motion

---

## Intro to Motion • Josh W Comeau's Course Platform

Source: /joy-of-react/07-framer-motion/01-framer-motion

Bonus Module
Layout Animations with Motion

A while back, I published a blog post, An Interactive Guide to Flexbox
. It includes these interactive demo units:

Show Primary Axis
Hello
to
the
World
Primary Axis
Primary Axis
flex-direction
row
column
row
justify-content
flex-start
center
flex-end
space-between
space-around
space-evenly
flex-start
align-items
stretch
flex-start
center
flex-end
stretch

Try fiddling with some of the controls along the bottom. The 4 child boxes rearrange themselves, growing and sliding as-needed to match the selected parameters.

It might not seem like much, but this sort of animation has historically been incredibly difficult to implement.

You might think you could solve this with a CSS transition, but sadly, it doesn't work:

.wrapper {
  display: flex;
  justify-content: center;
  /* 🚫 Won't do anything: */
  transition: justify-content 500ms;
}

CSS transitions allow us to smoothly interpolate between discrete numerical values. We can transition opacity from 0.5 to 1, or we can transition width from 200px to 1000px. But we can't transition layout properties like justify-content. It also can't animate DOM tree changes, like an element getting moved from one parent to another, or being reordered in the DOM.

In 2016, I decided I wanted to contribute a solution in this space. I built an animation library called react-flip-move
, which tackles a very specific problem: list re-ordering.

It can handle situations like this:

I put a lot of work into my library, dozens and dozens of hours. It gave me an appreciation for how dastardly these problems are. It's incredibly complex.

A few years ago, I heard about a new animation library, Motion
. And honestly, it totally blew my mind.

It's so much more powerful than my little animation library. It can tackle stuff that seemed absolutely impossible to me. It's incredible.

In the years since, I've used Motion for all kinds of stuff. It's become an indispensable part of my toolbox. It powers the Flexbox demo you saw above, along with many other interactive demos I've created. I use it in my Gradient Generator
, as well as in my JavaScript Operator Lookup
 tool:

Now, I should warn you: Motion has a pretty steep learning curve. It takes a lot of practice to truly become comfortable with how it works.

In this module, I don't want to stick to beginner-friendly examples. I want to show you the really cool stuff, the sorts of things I actually do in my work. As a result, the exercises in this module will likely be quite challenging.

I'll help you build a foundation with Motion, and hopefully give you a sense of what's possible with this tool. But to really become a Motion expert, you'll need to keep practicing.

I'm pumped to show you what we can do with Motion. Let's do this!

Renamed to “Motion”!
(warning)

In late 2024, Framer Motion was renamed to Motion
. Its creator, Matt Perry, acquired the rights to this tool from his former employer, Framer.

This is a wonderful thing, in my opinion! The name “Framer Motion” confused lots of developers, because Framer is thought of as a prototyping tool, and this gave the impression that Framer Motion wasn’t a production-ready tool.

At the same time, Motion has grown a bit beyond React. There are now Vue bindings available, and even some vanilla JS stuff (though the main feature we’ll talk about in this module, layout animation, isn’t available in the vanilla JS version).

The videos in this module were filmed before this change, so you’ll see me refer to it as “Framer Motion” from time to time. Fortunately, the API itself hasn’t changed, so all of the stuff we cover is still relevant and up-to-date.

As far as I know, the only thing you’ll have to change is the NPM imports. Everything else should stay the same:

// Change this...
import { motion } from 'framer-motion';

// ...to this:
import { motion } from 'motion/react';

---

## Getting Started

Source: /joy-of-react/07-framer-motion/02-framer-motion-basics

Getting Started

Before we get to the dazzling layout animation stuff, I think it'll help if we start with a “Hello World” example. Let's talk about how to slide a DOM node around.

Video Summary

You can start building an intuition for how spring physics work with my blog post, A Friendly Introduction to Spring Physics
. You can also learn more about the motion component in the Motion docs
.

Here's the final code from the video above:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';
import { motion } from 'motion/react';

function App() {
  const [isEnabled, setIsEnabled] = React.useState(true);

  return (
    <>
      <motion.div
        initial={false}
        className="yellow ball"
        transition={{
          type: 'spring',
          stiffness: 200,
          damping: 25,
        }}
        animate={{
          y: isEnabled ? 60 : 0,
        }}
      />
      <button onClick={() => setIsEnabled(!isEnabled)}>
        Toggle
      </button>
    </>
  );
}

export default App;
Result
Console
Refresh results pane

Breaking the big component rule?
(info)

Way back in Module 1, we learned about the “big component rule”: components have to start with a capital letter.

For example, this doesn't work:

function greeting() {
  return <p>Hi there!</p>;
}

root.render(<greeting />);

When this JSX gets compiled into JavaScript, it thinks <greeting> is a native HTML tag. As a result, it'll use a string, not a reference to our component:

root.render(React.createElement('greeting'));

To fix this, our component has to start with a capital letter:

function Greeting() { ... }

root.render(<Greeting />);
// Compiles to:
// React.createElement(Greeting);

There we go. Now, Greeting is a reference to our function.

But, hmm… The motion helper component doesn't have any capital letters! And somehow, it still compiles correctly:

root.render(<motion.div />);
// Compiles to:
// React.createElement(motion.div);

The reason the “big component rule” exists is so that the compiler can tell whether we want to render a built-in tag like <button>, or a custom component like Button. But this rule doesn't apply when our components are properties on an object.

In HTML, tags aren't allowed to have periods in them. <motion.div> is not valid HTML syntax. And so the compiler doesn't need to rely on the capitalization; it knows right away that this has to be a component.

Motion + styled-components
(success)

If you've used styled-components before, this API should look pretty familiar. We use helpers like styled.div or styled.h1 to create mini React components with baked-in styles.

You might be wondering, how do we use these two tools together?

We can solve this problem using composition:

const RedButton = styled(motion.button)`
  color: red;
`;

RedButton will still render a motion.button, along with any styles declared.

In some cases, you may want to render a Motion component selectively, based on some prop. We can do that using the as prop:

function Button({ isAnimated, ...delegated }) {
  return (
    <RedButton
      {...delegated}
      as={isAnimated ? motion.button : 'button'}
    >
    </RedButton>
  )
}

const RedButton = styled.button`
  color: red;
`;

If the isAnimated prop is truthy, RedButton will use a motion.button as the component to style. Otherwise, it’ll produce a plain <button>.


---

## Exercises

Source: /joy-of-react/07-framer-motion/02.01-basics-exercises

Exercises
Toggle Component

Let's migrate a cute on/off <Toggle> component to use Motion!

Below, you'll find a fully-functional Toggle component, but it uses CSS transitions. Your mission is to convert it to use Motion.

Acceptance Criteria:

The animation should use Motion rather than a CSS transition.
The animation should not happen on mount. It should only animate when the value changes.
A spring transition should be used. In terms of the specific transition settings, feel free to tinker with stiffness and damping until you're happy with the results!
You can use this handy parameter chooser
 to quickly test lots of different stiffness/damping combos.

How do I do this again?
(info)

If you can't remember the exact parameters and things, you can reference the playground in the previous lesson 👀. You can also check out the Motion docs; the Animation Overview
 and Transitions
 pages in particular should come in handy.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Toggle.js
Toggle.module.css
import React from 'react';
import { motion } from 'motion/react';

import styles from './Toggle.module.css';

function Toggle({
  value,
  onChange,
  ...delegated
}) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={value}
      className={styles.wrapper}
      onClick={() => onChange(!value)}
      {...delegated}
    >
      <span
        className={styles.ball}
        style={{
          transition: 'transform 300ms',
          transform: `translateX(${
            value ? '100%' : '0%'
          })`,
        }}
      />
    </button>
  );
}

export default Toggle;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
Springy Toasty

Back in Module 3, we created a Mortal-Kombat-inspired “Toasty!” animation:

We used a fairly-typical CSS transition, and the effect is alright, but I think we can do better.

Using Motion, let's update this animation to use a really smooth spring:

Acceptance Criteria:

The Toasty component should be updated to use Motion.
A custom transition should be set, manually specifying stiffness and damping. If you'd like, you can try to match the animation in the above GIF, but you can also experiment and come up with something different!
Here's that spring parameter chooser
 tool again!
Stretch goal: Tweak the values for stiffness/damping depending on whether the character is entering or exiting. The exit animation should be much quicker:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Toasty.js
Toasty.module.css
Result
Console
Refresh results pane

Solution:

Note: This is one of those solution videos where we learn some new stuff. Specifically, we dig deeper into how spring animations really work, and learn about the restDelta property.

Also, this video doesn't include the “stretch goal”, because I only thought of it after I had finished recording 😅. You can see my approach in the solution code below:

Solution code
(success)

 Show more

---

## Layout Animations

Source: /joy-of-react/07-framer-motion/03-layout-animations

Layout Animations

Video Summary

A small clarification
(info)

Clarification: In the video, I mentioned that Motion works using the “FLIP” technique. I recently learned that this isn't quite right; FLIP only deals with position, not size. Instead, it uses something called “layout projection”, which is a spiritual successor to FLIP. It's a very similar idea, but even more sophisticated.

I have resources for all this stuff below, if you'd like to learn more!

Phew! We covered a lot of ground in that video 😅. Here are some of the key takeaways:

We use the layout prop to enable layout animations for motion components.
layout can be set to "position", "size", or true (for both position and size).
Layout animations use CSS transforms, which essentially treat the element as if it was an image. This can cause distortions, if the element contains text or other elements. We fix this by nesting motion components, to “cancel out” those transformations.
Motion uses the bounding box for all elements. It doesn't know where the individual characters are within a paragraph. To avoid issues, we should “shrinkwrap” elements around their characters.
Transition settings aren't inherited; be sure to copy the transition prop from the parent to the child, so that they both use the same spring parameters.

Here's the playground from the video. I strongly recommend spending a few minutes tinkering with it. See if you can start building an intuition for how it works:

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
Result
Console
Refresh results pane

Preview keeps refreshing!
(warning)

The playgrounds that use layout animations have had the “hot reloader” disabled. As a result, every change you make will cause a full page reload.

I recognize that this is pretty annoying, but unfortunately, it's necessary. Layout animations often break when swapping out code, and it can lead to super confusing situations where the code is correct but the animation doesn't seem to work.

Additional resources
(success)

If you'd like to learn more about how on earth Motion works its magic, I have several resources you can check out:

Inside Motion's Layout Animations
, a talk by Matt Perry (creator of Motion).
FLIP Your Animations
, the original blog post on these techniques by its creator, Paul Lewis.
“Saving the Web, 16 Milliseconds at a Time”
, a talk I gave a couple of years ago on animation performance. It should help you understand why Motion uses transforms rather than more-sensible properties like width/height.

To be clear, you don't need to understand this stuff in order to use Motion effectively! These resources are provided as an optional deep dive, for those curious about how this stuff works.

View Transition API?
(info)

Recently, a team of wonderful people at Google has been working on something called the View Transition API.

This API allows us to implement native-style transitions between routes, and also potentially between states. In theory, it can do many of the same things that Motion can do!

This is a very exciting API, but I don’t really consider it a replacement for Motion. View Transitions don’t support interrupts; if the layout changes as the element is transitioning, it instantly teleports to the final position and animates from there, which is super jarring. Motion handles that same situation much more gracefully.

It’s also worth considering browser support. As I write this in mid-2025, View Transitions are sitting at 87% support
. They recently landed in Safari, but they’re still missing from Firefox.

So, I’d consider View Transitions a complementary tool, not a replacement!


---

## Layout Exercises

Source: /joy-of-react/07-framer-motion/03.01-layout-exercises

Layout Exercises
Toggle, Revisited

Earlier, we saw how to build a <Toggle /> component using Motion:

We solved it in that example using the animate property, but now that we know about layout animations, there might be a better way!

Your mission is to update the code below so that it uses layout animations.

Acceptance Criteria:

The Toggle component should not use the animate property. Instead, the ball's position should be controlled with CSS, and it should be animated using a layout animation.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Toggle.js
Toggle.module.css
import React from 'react';
import { motion } from 'motion/react';

import styles from './Toggle.module.css';

function Toggle({ value, onChange, ...delegated }) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={value}
      className={styles.wrapper}
      onClick={() => onChange(!value)}
      {...delegated}
    >
      <motion.span
        className={styles.ball}
        initial={false}
        transition={{
          type: 'spring',
          stiffness: 500,
          damping: 40,
        }}
        animate={{
          x: value ? '100%' : '0%',
        }}
      />
    </button>
  );
}

export default Toggle;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
Flex Demo

Let's recreate the “FlexDemo” component from my blog post, An Interactive Guide to Flexbox
!

Most of the code has already been provided. Your mission is to apply the Flexbox settings according to the state variables, and to animate it using Motion.

Acceptance Criteria:

The flexDirection, justifyContent, and alignItems state variables should be applied as an inline style to the demoArea element.
Layout animations should be used to animate changing the various parameters.
The text should not be distorted when switching between parameters (for example, alignItems should be able to switch between stretch and center without any text warping).

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
FlexDemo.js
FlexDemo.module.css
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

---

## Shared Layout

Source: /joy-of-react/07-framer-motion/04-layout-id

Shared Layout

The Vercel dashboard has this rather fun nav animation:

As I hover over different nav links, a grey box slides behind them, following the cursor.

I've built this sort of effect from scratch before, and I can tell you that it's a ton of trouble. Fortunately, it's much easier with Motion 😄. In this lesson, we'll see how to recreate this effect.

Let's do things a bit differently for this lesson. We'll start with a functional (but not quite complete) implementation. I'll walk you through how it works later, but first, I want you to do some experimentation on your own.

Here's the code. Spend 5ish minutes poking at it, seeing if you can figure out how it works. Hover over each navigation item.

Your mission is to see if you can make sense of the code, and figure out how that translates into the actual DOM. Use the “Elements” pane of the devtools to help you dig into what's going on.

Also: there's a subtle visual issue with this approach. Can you spot it?

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
Navigation.js
import React from 'react';
import { motion } from 'motion/react';

function Navigation() {
  const [hoveredNavItem, setHoveredNavItem] =
    React.useState(null);

  return (
    <nav
      onMouseLeave={() => setHoveredNavItem(null)}
    >
      <ul>
        {LINKS.map(({ slug, label, href }) => (
          <li key={slug}>
            {hoveredNavItem === slug && (
              <motion.div
                layoutId="hovered-backdrop"
                className="hovered-backdrop"
              />
            )}

            <a
              href={href}
              onMouseEnter={() =>
                setHoveredNavItem(slug)
              }
              onClick={(ev) => {
                // The links aren’t real
                ev.preventDefault();
              }}
            >
              {label}
            </a>
          </li>
        ))}
      </ul>
Result
Console
Refresh results pane

Alright, so now that you've taken a few minutes to explore this implementation, let's talk about it.

Video Summary

This technique is known as “shared layout animations”, and you can learn more in the Motion docs:

Shared Layout Animations

Also, if you're not sure why that z-index solution worked towards the end of the video, you might want to check out my blog post, “What the Heck, z-index??”
.

Here's the final playground from the video:

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
Navigation.js
Result
Console
Refresh results pane

---

## Working With Groups

Source: /joy-of-react/07-framer-motion/04.01-layout-groups

Working With Groups

Video Summary

In this video, we make good use out of our range utility function. As a reminder, you can learn more about it in the “Range Utility” lesson from earlier in the course.

Here's the sandbox that holds the initial, un-animated version:

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
WidgetProcessor.js
import React from 'react';
import { motion } from 'motion/react';
import { ChevronDown, ChevronUp } from 'react-feather';
import range from 'lodash.range';

import VisuallyHidden from './VisuallyHidden';

function WidgetProcessor({ total }) {
  const [numOfProcessedWidgets, setNumOfProcessedWidgets] = React.useState(0);

  const numOfUnprocessedWidgets = total - numOfProcessedWidgets;

  function handleProcessWidget() {
    if (numOfProcessedWidgets < total) {
      setNumOfProcessedWidgets(numOfProcessedWidgets + 1);
    }
  }

  function handleRevertWidget() {
    if (numOfProcessedWidgets > 0) {
      setNumOfProcessedWidgets(numOfProcessedWidgets - 1);
    }
  }

  return (
    <div className="wrapper">
      <div className="inbox">
        {range(numOfUnprocessedWidgets).map((itemNum) => {
          return (
            <div
              key={itemNum}
              className="widget"
            />
          );
        })}
      </div>
Result
Console
Refresh results pane

And here's a sandbox with the final fully-animated version:

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
WidgetProcessor.js
Result
Console
Refresh results pane

Funky interrupts
(info)

One thing you might notice is that things look a bit strange if we spam the button:

This happens because the layout changes while the widgets are mid-transition. We're pulling the rug out from under them!

Unfortunately, I don't really know how to make the animation smooth in situations like this. My suggestion would be to use a faster spring transition, or to temporarily disable the button after each click for a fraction of a second, to prevent the user from clicking so quickly.

Two different approaches: fungible and non-fungible

Video Summary

Here's the sandbox from the video above. Feel free to tinker with it, to get a sense of the new implementation.

NOTE: The up/down arrows haven't been implemented; this is something you'll tackle in an exercise shortly!

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
WidgetProcessor.js
Result
Console
Refresh results pane

---

## Shared Layout Exercises

Source: /joy-of-react/07-framer-motion/04.02-shared-layout-exercises

Shared Layout Exercises
Finishing our non-fungible WidgetProcessor

In the previous lesson, we saw how to use a “non-fungible” approach, so that each widget has a unique identity. This allows us to process individual widgets:

The solution I came up with isn't fully complete. Your mission in this exercise is to finish this implementation!

This (short!) video explains what you need to do:

Video Summary

Acceptance Criteria:

Clicking the "Down" button should mark a single widget as processed. It should select the final unprocessed widget in the inbox.
Clicking the "Up" button should mark the very first processed widget as unprocessed.
If there are no widgets in the relevant box when the Up/Down buttons are clicked, it should have no effect. No error should be thrown.
When widgets are processed, they should stack at the start of the .outbox.
When widgets are reverted, they should stack at the end of the .inbox.
This start/end stack logic should apply both when clicking individual widgets, and when using the "Up"/"Down" buttons.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
WidgetProcessor.js
Result
Console
Refresh results pane

Solution:

In this video, I briefly mention the “Principle of Least Privilege”. You can hop over to that lesson if you'd like a quick refresher.

Solution code
(success)

 Show more

Making it reusable
(info)

Community member Siddharth noticed that the solution we wind up with breaks if we try and render multiple WidgetProcessor instances:

If you'd like, spend a moment or two seeing if you can make sense of why this is happening, and come up with a possible solution. We'll discuss below.

 Show more
Coin Sorter

Here's what we'll build in this exercise:

We have a grid with 4 compartments. The coins appear to glide from compartment to compartment when each is selected.

The implementation below includes all of the raw logic, but none of the Motion stuff. Your mission is to update the code so that the coins glide smoothly from box to box.

Your solution should be perfectly smooth; the coins shouldn't be “bunched up” at the start of the transition. This clip shows an exaggerated version of the issue you might run into:

Also, this exercise has a stretch goal. We want to apply a subtle stagger to the coins, so that the coins move with increasing lethargy. Here's another clip that shows an exaggerated version of the effect:

Surprisingly, this stagger can be accomplished using the parts of the Motion API we've already learned. You don't need to learn anything new to apply this effect.

Acceptance Criteria:

Selecting a new compartment should cause the coins to glide smoothly from their current compartment.
The coins should not get bunched up at the start of the transition:
Stretch goal: The coins should not be perfectly uniform in terms of their animation settings. Instead, the 6 coins should be on a spectrum from quick to slow.

Troubleshooting
(info)

In addition to reviewing the content in the previous lessons, I've created a Motion Troubleshooting guide. If you're seeing weird or glitchy behavior, you can check it out to see if it offers any clues!

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
CoinSorter.js
CoinSorter.module.css
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

---

## One Last Exercise

Source: /joy-of-react/07-framer-motion/04.03-reading-list

One Last Exercise

Alright, let's take what we've learned so far and use it to build a more real-world UI:

As with previous exercises, we'll start with an implementation that includes all of the standard React logic, but no animation. Your job is to set up the layout animation.

Like with all layout animations, the devil is in the details here. There are a couple of things to pay attention to.

When a book is moving from the grid to the reading list, it should have a slower transition. Notice in the GIF above that the selected book is still moving after the grid has settled.

Also, the “Close” buttons in the reading list shouldn't jump up or down awkwardly:

And finally, like we dealt with in the WidgetProcessor exercise, we want to be intentional about the order of the books. You'll find the exact specification in the Acceptance Criteria:

Acceptance Criteria:

Layout animations should be used for all book movement, including transitioning to/from the Reading List.
A smoother, more lethargic transition should be used for books moving to the reading list. You can use the default transition for when books shift around in the grid.
When books are removed from the reading list, the “X” buttons should smoothly slide as well, they shouldn't snap to their new position.
When adding a new book to the reading list, it should always be added to the end of the stack.
When dismissing a book from the reading list, it should always return to the end of the grid.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
BookPage.js
BookGrid.js
ReadingList.js
BookPage.module.css
BookGrid.module.css
ReadingList.module.css
data.js
Result
Console
Refresh results pane

Solution:

Unique layout IDs?
(info)

In the earlier examples, we've guaranteed that each layoutId was unique to each component instance with the useId hook. You might be wondering why I didn't do something like that here!

In this particular case, we need to share the layout ID across multiple components, BookGrid and ReadingList. And so, I don't want them to be fully unique!

I suppose the “proper” thing to do would be to lift useId() into the parent BookPage component. I could then pass that unique ID down to both children, to integrate it into both layout IDs.

But honestly, that seems like more trouble than it's worth. It protects us against the hypothetical scenario of rendering multiple <BookPage> elements, but I can't imagine a case where I'd want to do that.

This is why it's good to understand the reasoning behind “best practices”. We can keep our code a bit simpler by bending the rules, because we know that the drawbacks don't really apply in this situation.

Solution code
(success)

 Show more
Stretch goal: Reading list optimizations

As it stands, each item in the “Reading List” has a fixed height of 50px. This means we can only fit a handful of books before we run out of space!

What if we did something more dynamic?

In this stretch goal, you'll add two enhancements to the Reading List. First, you'll update the height of each list item, so that books are given less space the further back they are from the front of the stack:

Notice how the books further up in the stack get compressed, as each new book is added?

This makes it possible for us to fit more books, but it also makes it harder to see what the books actually are. Let's add the ability to expand the books, on hover/focus:

Your mission in this stretch goal is to add these two enhancements. This is not an easy challenge. Unless you've done stuff like this in the past, you probably won't be able to come up with a solution on your own. Don't let that discourage you from trying, though! You'll learn a ton either way. 😄

Acceptance Criteria:

Instead of each list item having a fixed height of 50px, the height should be dynamically calculated based on its distance from the top of the stack.
Specifically, the range should be from 50px to 10px, in 5px increments.
Hovering over a particular item should increase its height to 100px.
Focusing a particular book's “X” button should also increase that book's height to 100px, as a fallback for folks who don't use a pointer device.

To complete: Either keep working on your solution in the playground above, or build on my original solution in the playground below. Whichever you prefer!

This is a particularly tricky challenge, so I've provided some hints:

Hint

By default, each list item has a height of 50px, defined in the CSS. To solve this problem, we'll want to apply a custom height as an inline style, on the <li>.

You'll need to derive the heights using the bookIndex. You should come up with some sort of formula that produces the following results:

Final book: 50px
2nd to last book: 45px
3rd to last book: 40px
4th to last book: 35px
5th to last book: 30px
6th to last book: 25px
7th to last book: 20px
8th to last book: 15px
9th to last book: 10px
10th to last book: 10px
11th to last book: 10px
…and so on
Hint

For the hover effect, you'll want to track which book is highlighted using a new state variable. Specifically, you'll want to listen for the mouseEnter event on the list item (as well as focus on the close button, for keyboard users).

You could solve it by applying a transform: translate to all books after the highlighted book, but I believe the simplest option is to increase the height of the highlighted list item.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
BookPage.js
BookGrid.js
ReadingList.js
BookPage.module.css
BookGrid.module.css
ReadingList.module.css
data.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

---

## Motion Accessibility

Source: /joy-of-react/07-framer-motion/05-accessibility

Motion Accessibility

In general, I believe that motion is an important part of any web application. It can provide a sense of continuity, making the UI feel more tangible. It also provides an opportunity for us to surprise users with an unexpected bit of whimsy. ✨

But not everyone experiences motion the same way. For some, motion can trigger physical symptoms like vertigo, nausea, and malaise.

Operating systems provide a setting users can toggle, in order to disable potentially-upsetting animations:

On macOS, you can find this setting under Accessibility » Display. On Windows, it's under Accessibility » Visual Effects. You can also emulate this setting in-browser; more about this shortly.

There's a bit of a good-news-bad-news situation with this setting:

The bad news is that this setting has no effect on web animations. It only disables motion within the operating system itself (eg. minimizing windows).
The good news is that we have access to this setting on the web, in the form of a media query!

When working in CSS, we can apply transitions / keyframe animations only for users who haven't opted out:

@media (prefers-reduced-motion: no-preference) {
  .some-elem {
    animation: swoop 700ms;
  }

  .some-other-elem {
    transition: transform 300ms;
  }
}

When it comes to Motion, we can tell it to respect user preferences with a special component, MotionConfig. Here's how it works:

import React from 'react';
import { MotionConfig } from 'motion/react';

function App() {
  return (
    <MotionConfig reducedMotion="user">
      {/* The entire application here */}
    </MotionConfig>
  );
}

export default App;

By setting reducedMotion to "user", we're telling Motion to obey the prefers-reduced-motion media query. If the user toggles the “Reduce motion” setting, all animations will be disabled, and elements will instantly teleport to their new positions instead of smoothly gliding.

I wish Motion defaulted to this setting. It makes a lot more sense to me. But, since it doesn't, we need to set it ourselves.

I recommend wrapping this component around our entire application. In the next lesson, we'll cover how to set this up in Next.js applications.

Emulating prefers-reduced-motion

Every now and then, it's worth testing our applications with the “Reduce motion” setting enabled. It's important to make sure our application is still clear and easy-to-use even with animations disabled.

Rather than fussing with the “System Preferences” in your OS, we can emulate this setting within the browser.

In Chrome, you can toggle this setting by enabling the devtools, opening the Command Palette (Ctrl + Shift + P), and typing “reduce”:

For other browsers, you can google “emulate prefers-reduced-motion” to find specific instructions.

Let's give it a shot. Below, you'll find our Toggle component from earlier, using the MotionConfig component to respect the user's preference. Your mission is to emulate “Reduce motion” in the browser devtools, to see what the experience is like for folks who disable motion.

Note: You'll need to refresh the iframe using the  button after enabling the emulation.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Toggle.js
Toggle.module.css
Result
Console
Refresh results pane

By emulating the prefers-reduced-motion media query, the toggle should jump immediately from one side to another:

We'll see MotionConfig again in the final project, but if you'd like to have a bit more practice, I'd suggest going through the previous exercises and adding support for reduced motion.

Going deeper

If you'd like to learn more about this stuff, I have a blog post, “Accessible Animations in React”
. We go a bit deeper into why it's so important to be mindful of our animations.

There's also a hook that comes with Motion, useReducedMotion. It can be useful if you'd like to have finer-grained control; instead of disabling animations outright, we can supply alternative animations (eg. using opacity instead of motion). You can learn more in the “useReducedMotion” documentation
.

That said, I don't think we need to overcomplicate this. As long as you use the MotionConfig component as described in this lesson, as well as the prefers-reduced-motion media query for any CSS-based motion, you should be good to go. 👍


---

## Disabling Motion in Next

Source: /joy-of-react/07-framer-motion/05.01-disabling-in-next-js

Disabling Motion in Next

In the previous lesson, I mentioned that it's a good idea to wrap the <MotionConfig> element around the entirety of our React application, to ensure that all motion elements respect the “Reduce motion” preference:

import React from 'react';
import { MotionConfig } from 'motion/react';

function App() {
  return (
    <MotionConfig reducedMotion="user">
      {/* The entire application here */}
    </MotionConfig>
  );
}

export default App;

This works for a client-side build tool like Parcel, but how does it work in the context of Next.js? We don't have an App.js in Next.

The closest thing we have to an App component is the root layout, in /src/app/layout.js. Here's my initial attempt at a solution:

// /src/app/layout.js
import React from 'react';
import { MotionConfig } from 'motion/react';

function RootLayout({ children }) {
  return (
    <MotionConfig reducedMotion="user">
      <html lang="en">
        <body>
          {children}
        </body>
      </html>
    </MotionConfig>
  );
}

export default RootLayout;

If we do this, though, we'll get an error:

You're importing a component that needs useEffect. It only works in a Client Component but none of its parents are marked with "use client", so they're Server Components by default.

We're not using useEffect anywhere, but MotionConfig does. And, unfortunately, the maintainers of Motion haven't added "use client" directives.

This is quite common; there are lots of third-party libraries that have not yet been updated to work with React Server Components.

2026 Update
(warning)

Since I first created this lesson, Motion has added the "use client" directive! Unfortunately, this hasn’t solved our issue. We run into a new related issue now:

Error: It's currently unsupported to use "export *" in a client boundary. Please use named exports instead.

This issue shares the same root cause, as well as the same solution, described below.

So, how should we fix this? Spend a few moments and consider the problem. We'll dig into the possible solutions below.

The easiest thing would be to add the "use client" directive to our layout.js file:

// /src/app/layout.js
"use client";

import React from 'react';
import { MotionConfig } from 'motion/react';

function RootLayout({ children }) {
  return (
    <MotionConfig reducedMotion="user">
      <html lang="en">
        <body>
          {children}
        </body>
      </html>
    </MotionConfig>
  );
}

export default RootLayout;

This works because marking a component as a Client Component affects all components imported by that file. It has the effect of treating MotionConfig as a Client Component, regardless of whether it includes the "use client" directive or not.

But this isn’t a great solution. In a real app, our root layout probably has a bunch of stuff that we don’t need to include in our JS bundles! Plus, we typically want to use the Metadata API in this file to set up meta tags, and we can’t use the Metadata API in Client Components.

Instead, what if we create a client wrapper component? For example:

// src/components/RespectMotionPreferences.js
'use client';

import React from 'react';
import { MotionConfig } from 'motion/react';

function RespectMotionPreferences({ children }) {
  return (
    <MotionConfig reducedMotion="user">
      {children}
    </MotionConfig>
  );
}

export default RespectMotionPreferences;

I've created a small component with 1 job: to “wrap around” the MotionConfig component, locking in the reducedMotion prop and setting the "use client" directive.

We then use this component instead of MotionConfig:

// /src/app/layout.js
import React from 'react';

import RespectMotionPreferences from '@/components/RespectMotionPreferences';

function RootLayout({ children }) {
  return (
    <RespectMotionPreferences>
      <html lang="en">
        <body>
          {children}
        </body>
      </html>
    </RespectMotionPreferences>
  );
}

export default RootLayout;

With this approach, layout.js remains a Server Component. We import RespectMotionPreferences, a Client Component, and pass through all of the UI through the children prop.

Essentially, we're doing the same thing we did in the “Server Components and styled-components” exercise. We create a new Client Component that wraps around the chunk of code that requires client-side React. That way, we reduce the amount of stuff that has to run on the client.

As I mentioned in Module 6, it takes a while to get used to the “React Server Components” paradigm, so please don't feel bad if it doesn't make much sense to you yet! Intuition will come with practice. ❤️


---

## Troubleshooting

Source: /joy-of-react/07-framer-motion/06-troubleshooting

Troubleshooting

When working with layout animations, there are tons of little gotchas and common issues. This lesson is essentially a big list of things you can try, if your layout animation isn't doing what you expect.

Stretched/warped text

To prevent text from stretching or warping, wrap nested elements in their own Motion component, setting layout to "position":

<motion.div layout={true}>
  <motion.p layout="position">
    Hello world!
  </motion.p>
</motion.div>
Text snapping on start

If the text “snaps” to a new position at the start of the transition, it's likely because the characters themselves are shifting around in their DOM rectangle. Use CSS to shrinkwrap the DOM node around the characters:

<div
  style={{
    display: 'flex',
    justifyContent: 'center',
  }}
>
  <motion.p>
    Centered text
  </motion.p>
</div>

(I'm using an inline style here so that it all fits in the same snippet. You can apply these styles however you typically write CSS!)

Jiggling elements

If elements appear to dance or jiggle, make sure that any nested motion components use the same transition settings:

<motion.div
  transition={CUSTOM_SPRING}
>
  <motion.p
    transition={CUSTOM_SPRING}
  >
    Centered text
  </motion.p>
</motion.div>

const CUSTOM_SPRING = {
  type: 'spring',
  stiffness: 300,
  damping: 45,
}
Twitchy corners

If the corners appear to twitch during an animation, make sure you're specifying the borderRadius explicitly, using initial:

<motion.div
  initial={{
    borderRadius: 32,
  }}
/>

You can also do the same thing with boxShadow, though it only works with a single shadow.

Teleporting elements

For shared layout animations that seem to teleport around, try wrapping all related elements in a LayoutGroup element:

<LayoutGroup>
  <div>
    {someCondition && <motion.div layoutId="some-val" />}
  </div>
  {!someCondition && <motion.div layoutId="some-val" />}
</LayoutGroup>
Disappearing elements

If elements appear to blink out of existence during a shared layout animation, make sure you're using the same value for layoutId and key:

<motion.div
  layoutId={layoutId}
  key={layoutId} // Not `index` or something else!
/>
Invalid layout IDs

When setting the layoutId prop, make sure it's a truthy value (and not 0 or ''):

<motion.div
  layoutId={`${uniqueId}-${index}`}
/>
Other issues

In addition to these gotchas that we've covered, here are some more you might wish to research further, in your own endeavours with Motion:

If the element doesn't seem to be animating at all, make sure the element isn't set to display: inline. If you're animating a <span>, <a>, or other inline element, you'll need to set display: block so that it can be transformed.
If a layout animation is happening when it shouldn't be (eg. when a different part of the DOM changes), you can use layoutRoot
 to ignore certain changes.

Check out the full Troubleshooting Guide
 in the Motion docs.

Onwards!

And so, this marks the end of the bonus module on Motion. I hope you've found it helpful. 😄

In these lessons, I chose to go deep into layout animations, since I think it's the killer feature with Motion. It's worth pointing out, though, that Motion has a bunch of other features as well, including support for lots of different gestures, exit animations, and more.

Even within the narrow slice of layout animations, I've shown you the most critical parts of the API, but there's so much more we can do with them! I hope that I've given you a sense of what's possible with this tool, and that you'll continue to experiment and explore. ✨

There’s a wealth of information in the official docs
. Start experimenting, and use the docs to help you answer any questions you run into. You’ll get comfortable with the library in no time. ❤️


