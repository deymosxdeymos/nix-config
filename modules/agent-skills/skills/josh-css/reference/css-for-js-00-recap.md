# CSS for JS - Module 0: Fundamentals Recap

---

## Introduction • Josh W Comeau's Course Platform

Source: /css-for-js/00-recap/01-introduction

Fundamentals Recap

This course is designed to help you deepen your understanding of CSS; it isn't meant to be an absolute beginner's guide.

That said, everybody has gaps in their knowledge, and this is especially true for folks who are self-taught. I've been writing CSS for over a decade, and I still learned quite a lot of fundamental stuff while preparing this course!

The goal of this pre-module is to fill in those gaps, and ensure that all students are starting with the same rock-solid foundation.

Even if you have a solid amount of CSS experience, I bet you'll learn something in this module!


Anatomy of a Style Rule

---

## Anatomy of a Style Rule

Source: /css-for-js/00-recap/02-anatomy

Anatomy of a Style Rule

Here's a sort of "Hello World" CSS snippet:

.error-text {
  color: red;
}

(If you're not sure what this snippet does, check out this introductory article
 on MDN. It'll get you up to speed!)

You may be comfortable with this code, but how comfortable are you with the terminology? Can you identify, for example, the “declaration” in this snippet?

Terminology isn't the most interesting thing in the world, but it's important; you'll see the terminology again and again in this course, and I'd hate for it to be confusing!

Rather than present you with a bunch of dull definitions, let's play a game! In just a few minutes, you should be good to go.

Selector Selection

Media Queries

---

## Media Queries

Source: /css-for-js/00-recap/03-media-queries

Media Queries

The web is an incredibly broad platform: the same HTML and CSS might be tasked with running on a 5" phone screen and a 72" TV!

In order to accommodate screens of different shapes and sizes, CSS features media queries, which allow us to apply different CSS in different scenarios.

Responsive design is a huge part of modern front-end development, and it's a topic we'll dive deep into, later on in the course. For now, let's focus on the fundamental concepts.

Media queries use the @media syntax. You can kinda think of it as an if statement in JavaScript:

// JavaScript
if (condition) {
  // Some JS that will run if the condition is met.
}
/* CSS */
@media (condition) {
  /* Some CSS that'll run if the condition is met. */
}

Let's look at an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  @media (max-width: 300px) {
    .thing {
      font-weight: bold;
      text-align: center;
      background: peachpuff;
    }
  }
</style>

<p class="thing">
  Hello there!
</p>
Result
Refresh results pane

In this case, the condition is max-width: 300px. If the window is between 0px and 300px wide, the CSS within will be applied.

By default, you should see some plain black text, since the window will naturally be larger than 300px wide. You can resize the “Result” area to see the styles get applied:

(Sorry, mobile users — unfortunately, this demo only works on desktop computers!)

About these playgrounds
(info)

Normally, in order to test a media query, you need to resize the entire window. Why is it that we can trigger a media query by resizing the white box inside the playground?

The playground uses iframes. An iframe is an embedded HTML document within the main HTML document. It's a page within a page.

When you resize the partition between code and preview, you're resizing the embedded document. The media query runs in the context of that inner page.

Hiding content

It's common to use media queries to have alternative interfaces depending on the screen size.

In this demo, we will only ever see one of these HTML elements at a time:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

display: none is a declaration that removes an element from the rendering process; it's as if it doesn't exist. By default, we'll hide any elements with the large-screens class.

If our window is at least 300px wide, however, we apply special overrides. This includes showing large-screens elements, and hiding small-screens elements.

This is useful for UI that is only intended to be shown for specific device sizes. For example, a site might have a row of navigation links on desktop and a hamburger icon on mobile.

Valid conditions

Inside the parentheses, we typically use either max-width to add styles on small screens, or min-width to add styles on larger ones.

The syntax looks quite a lot like the declaration syntax, especially since max-width: 1023px is a valid CSS declaration! Unfortunately, this is misleading; In the context of a media query, max-width is a “media feature”, not a CSS property. They just happen to share the same name.

Not all CSS properties have corresponding media features. For example, this snippet is not valid:

/* 🚫 Not valid, since `font-size` can't be queried */
@media (font-size: 32px) {

}
Nested media queries

In the old days, the typical way of working with media queries was to have separate chunks of CSS for each breakpoint. It was common to structure our stylesheet like this:

/* Default (desktop) styles */
.wrapper {
  /* ... */
}
.title {
  /* ... */
}
.hero-image {
  /* ... */
}

/* Tablet styles */
@media (max-width: 768px) {
  .wrapper {
    /* ... */
  }
  .title {
    /* ... */
  }
  .hero-image {
    /* ... */
  }
}

/* Mobile styles */
@media (max-width: 440px) {
  .wrapper {
    /* ... */
  }
  .title {
    /* ... */
  }
  .hero-image {
    /* ... */
  }
}

This organizational structure always felt a bit off to me. Rather than group our styles by device type, I would rather keep all of the styles for a given element in 1 spot. This is especially worthwhile when working with component-based frameworks like React, as we’ll see later in this course.

Wouldn’t it be nice if we could do something like this instead?

.wrapper {
  /* Default (desktop) styles here */

  @media (max-width: 768px) {
    /* Tablet styles */
  }

  @media (max-width: 440px) {
    /* Mobile styles */
  }
}

Rather than have three separate .wrapper rules spread across three separate chunks of CSS, I’m instead nesting the media queries within a single .wrapper rule. Way nicer!

When I first released this course, this wasn’t considered valid CSS. We needed to use CSS preprocessors like Sass/Less to transform this code into the browser-friendly top-level structure shown above.

Fortunately, CSS now officially supports nesting! As I write this update in December 2025, nesting is available across all major browsers, though it’s still a bit below 90% total support
.

Here’s a full example, showing how we can nest media queries:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

I like this a lot more!

Most of this course was created before CSS nesting was widely-available, and even today (in December 2025), I think it’s a good idea to use a preprocessor or some other tool to “flatten” nested styles, to make sure our work displays correctly for the largest percentage of people. We’ll learn all about preprocessors later in the course.

Tip of the iceberg

In Module 5, we'll go way deep into media queries and responsive development. Building adaptive, responsive interfaces is a huge part of mastering CSS, and it will not be neglected in this course!

---

## Selectors

Source: /css-for-js/00-recap/04-selectors

Selectors

CSS comes with an incredibly rich set of selectors, and those selectors can be mixed and matched in interesting ways.

The most straightforward selectors target a specific tag or class:

/* Turn all links red! */
a {
  color: red;
}

/*
  Remove the underline from all elements that
  have been given a class of `navigation-link`
*/
.navigation-link {
  text-decoration: none;
}

Within the modern JS ecosystem, however, we often rely on tooling to generate these selectors for us (we'll cover this in more depth in Module 3). For this reason, we won't focus too much on them in this course.

There are, however, many nifty selectors that come in handy even with modern tooling. In the lessons that follow, we'll cover a few common ones.


Pseudo-classes

---

## Pseudo-classes

Source: /css-for-js/00-recap/04.01-pseudo-classes

Pseudo-classes

Let's say we have a button, and we want to change its text color when we hover over it.

We can do this with the :hover pseudo-class:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  button:hover {
    color: red;
  }
</style>

<button>Hover over me!</button>
Result
Refresh results pane

Pseudo-classes let us apply a chunk of CSS based on an element's current state. In this case, we're adding a blue text color when the element is hovered.

This is similar to onMouseEnter / onMouseLeave events in JavaScript, but with built-in state management. If we were to do this in JS, we'd need to register event listeners, but we'd also need to manage the state somehow, to know if the element is currently being hovered.

As a result, CSS makes this kind of thing much simpler!

There are lots and lots of pseudo-classes
, and we'll learn about many of them throughout this course. For now, though, let's pick a couple more.

focus

HTML comes with interactive elements like buttons, links, and form inputs. When we interact with one of these elements (either by clicking on it or tabbing to it), it becomes focused. It'll capture keyboard input, so we can type into a form field or press "Enter" to follow a link.

The :focus pseudo-class allows us to apply styles exclusively when an interactive element has focus:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Try focusing the buttons one by one to activate the :focus styles.

How to navigate by keyboard
(info)

For most users, a button can be focused by clicking on it. Focus can then be moved between buttons by pressing “Tab” (to go forward) or “Shift” + “Tab” (to go backwards).

On macOS, things work a bit differently, depending on the browser:

On Safari, clicking a button won't focus it. This is a known bug.
On certain versions of Firefox on macOS, “Tab” skips links, and only navigates between buttons and form fields.
On Safari, “Tab” skips buttons and links. You'll need to use “Option” + “Tab” (and “Option” + “Shift” + “Tab”) to tab between buttons

Read more about button focusing on MDN
. Alternatively, you can configure Firefox and Safari to use common tab behaviour
.

Why do focus styles matter?
(warning)

You may wonder why focus styles are necessary. Why is it helpful to know which element is focused?

Focus styles are primarily useful for folks who don't use a "pointer-style" input device (like a mouse, a trackpad, or a finger on a touchscreen). For example, I built the foundations of this course platform without the use of a keyboard/mouse, due to a repetitive stress injury; initially, I did all of my navigation by voice, speaking "tab" into a microphone to move between focused elements. The focus styles show you where you are on the page, which element is selected.

Fortunately, browsers do come with default focus styles. It varies by browser, but it's typically either a blue or dotted outline. We'll talk about focus outlines later in the course.

Please don't add outline: none to get rid of the focus outlines (unless you're replacing it with an even-more-prominent set of styles).

We'll touch on accessibility concerns throughout this course. If you're looking to dive deeper into accessibility, I recommend a11y.coffee
.

checked

The :checked pseudo-class only applies to checkboxes and radio buttons that are "filled in". You can apply additional styles to indicate that the input is activated:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Browsers don't offer too much flexibility when it comes to checkboxes and radio buttons, but this neat trick lets you apply certain CSS properties depending on its status.

first/last child

Pseudo-classes aren't just for states like hover/focus/checked! They can also help us apply conditional logic.

For example, let's suppose we have a set of paragraphs within a <section>:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

There's quite a lot of space under that final paragraph... Why isn't it symmetrical??

The problem here is this rule:

p {
  margin-bottom: 1em;
}

This rule is meant to add space between each paragraph, but it also applies to the final paragraph. We can see this in the devtools:

As we'll learn in the next module, that orange rectangle represents margin. And we don't want that bottom margin to apply to that final paragraph!

Here's how we can fix it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Here's how this works: The :last-child pseudo-class will only select <p> tags which are the final element within its container. It needs to be the last child within its parent.

Similarly, the :first-child pseudo-class will match the first child within a parent container. For example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

What about :first-of-type and :last-of-type?
(info)

In addition to :first-child and :last-child, we also have :first-of-type and :last-of-type. They're almost identical, but they have one critical difference.

:first-of-type depends on the type of the HTML tag.

For example, let's suppose we have the following setup:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The first child within the parent <section> tag is an <h1>. Our p:first-child is looking for situations where a paragraph is the first child within a parent container. It doesn't work in this case.

But, if we switch the selector to p:first-of-type, it does work:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The :first-of-type pseudo-class ignores any siblings that aren't of the same type. In this case, p:first-of-type is going to select the first paragraph within a container, regardless of whether or not it's the first child.


Pseudo-elements

---

## Pseudo-elements

Source: /css-for-js/00-recap/04.02-pseudo-elements

Pseudo-elements

Pseudo-elements are like pseudo-classes, but they don't target a specific state. Instead, they target "sub-elements" within an element.

For example, we can style the placeholder text in a form input with ::placeholder:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  input {
    font-size: 1rem;
  }
  input::placeholder {
    color: goldenrod;
  }
</style>

<label>
  Postal Code:
  <input
    type="text"
    placeholder="A1A 1A1"
  />
</label>
Result
Refresh results pane

In terms of syntax, pseudo-elements use two colons instead of one (::), though some pseudo-elements also support single-colon syntax.

If we stop and think about it, something pretty interesting is happening here. We haven't explicitly created a <placeholder> element, but by adding the placeholder attribute to the <input> tag, a pseudo-element is created.

This is why they're called pseudo-elements — these selectors target elements in the DOM that we haven't explicitly created with HTML tags.

Placeholders and accessibility
(warning)

You may have heard that placeholders are bad for accessibility and shouldn't be used.

My personal opinion is that they're alright to use when they're used properly. The trouble is that many developers use them improperly.

 Show more
before and after

Two of the most common pseudo-elements are ::before and ::after.

Here's an example:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

These pseudo-elements are added inside the element, right before and after the element's content. We could rewrite the above example like so:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

There is no significant difference in terms of performance between these two examples. ::before and ::after are really just secret spans, nothing more. It's syntactic sugar.

In general, we probably shouldn't use these two pseudo-elements. In a vanilla HTML/CSS world, it can be helpful to "bundle" content in with a CSS selector. In the era of components, however, we have better ways of bundling content.

There are also some accessibility concerns with ::before and ::after. Some screen readers? will try to vocalize the content. Others will ignore them entirely. This inconsistency is problematic.

That said, if the effect is entirely decorative (eg. colorful shapes), I believe it's fine to create them with an empty content string:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Combinators

---

## Combinators

Source: /css-for-js/00-recap/04.03-combinators

Combinators

When you think about it, the humble <a> tag has a lot of different hats to wear. The same element needs to handle navigation links in a header, as well as inline links in an article.

What if we wanted to only style navigation links? Well, we could do that using a combinator:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  nav {
    color: red;
    font-weight: bold;
  }
</style>

<nav>
  <a href="">Home</a>
  -
  <a href="">Shop</a>
</nav>

<p>
  Hello world! You might be interested in reading <a href="">an article</a>!
</p>
Result
Refresh results pane

By putting a space between nav and a, we're combining two selectors in a very specific way: we're saying that the styles should only apply to a tags that are nested within nav tags. The first two links in the snippet qualify, but the last one doesn't.

The term “combinator” refers to a character that combines multiple selectors. In this case, the space character combines nav and a to create a descendant selector.

The descendant selector will apply to all descendants, no matter how deeply nested they are. For example, the anchor tags will still work even if they're inside a list:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  nav a {
    color: red;
    font-weight: bold;
  }
</style>

<nav>
  <ul>
    <li>
      <a href="">Home</a>
    </li>
    <li>
      <a href="">Shop</a>
    </li>
  </ul>
</nav>
Result
Refresh results pane

In CSS, we can differentiate between children and descendants. Think of a family tree: a child is only one level down from the parent. A descendant might be 1 level down (child), 2 levels down (grandchild), 3 levels down…

What if we only want to target children, and not deeper descendants?

Here's an example using another combinator. Take a minute and poke at it. I'll explain what's going on in the video below.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Note: This video was recorded using an earlier version of the code playground. The code is the same, but there are some aesthetic differences.


Exercises

---

## Exercises

Source: /css-for-js/00-recap/04.04-exercises

Exercises
Recipe app

In this exercise, we'll update a recipe app to have styled links:

Here's our criteria:

Main article links should have a color of deeppink, with no underline. Hovering will show an underline
Links in the aside should be black, with an underline. Hovering will hide the underline.
We should solve this problem by writing new CSS selectors, not by adding new classes to the <a> tags. We shouldn't have to modify the <a> tags at all.

Don't forget the semicolons!
(warning)

CSS isn't as forgiving as JavaScript. If you don't include a semicolon (;) at the end of every CSS declaration, it will invalidate the next declaration, leading to very confusing bugs!

Unfortunately, the playground on this platform doesn't do a great job of highlighting this issue when it occurs. So, please stay vigilant!

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  article > p > a {
    color: deeppink;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }

  aside a {
    color: black;
    text-decoration: underline;
    &:hover {
      text-decoration: none;
    }
  }
</style>

<article class="recipe">
  <h2>Chicken Vindaloo</h2>
  <p>
    “Vindaloo” is a popular Indian
    <a href="">curry dish</a> that calls for meat to be
    marinated in a highly flavorful spicy mixture with
    vinegar, then quickly cooked up when you’re ready to
    eat.
  </p>
  <p>
    While this dish has a long list of spices, most are
    quite common in the average spice rack. If you find
    you're missing one, it's not a deal breaker. You will
    still have a lovely, fragrant curry.
  </p>
  <aside>
    <p>
Result
Refresh results pane

Solution:

This video walks through how I would solve this problem:


Color

---

## Color

Source: /css-for-js/00-recap/05-color

Color

Color in CSS is a huge topic, and one that we'll revisit throughout this course. We'll learn how to do lots of phenomenal things with color. But for now, we'll focus on the basics.

We can adjust the text color of a specified element using the color property:

strong {
  color: red;
}
Color formats

CSS includes many different ways to represent color.

A lot of developers use hex codes (#FF0000), but I believe there are better options!

Let's see what those options are.

Prefer a text format?
(info)

The video below explores how 4 different color formats work. If you'd prefer to read an interactive article on the same subject, check out my blog post, Color Formats in CSS
.

Modern color formats
(info)

Towards the end of this video, I mention that there are newer, perceptually-uniform color formats like LAB and LCH, but that they aren’t widely supported yet. Since recording this video, support has gotten much better; as of November 2025, support is sitting around 92%
.

The best color format we have today, in my opinion, is oklch(). It’s perceptually uniform and it supports a broader range of colors on wide-gamut displays. That said, I still find myself using hsl() most of the time. It uses percentages for lightness and saturation, which is a lot more intuitive than the “unbounded” values used in LCH. And while 92% is pretty darn good for browser support, I don’t really want 1 in 12 users to be deprived of colors!

We can supply fallback values in HSL, but honestly, unless the design uses really vibrant colors, it feels like too much of a hassle to be worthwhile. Here’s how we can do this using feature queries:

.vibrant-element {
  /* Fallback color using HSL: */
  background: hsl(340deg 100% 50%);

  /* Vibrant color using oklch: */
  background: oklch(0.65 0.25 3);
}

As mentioned, my favourite color format is HSL (Hue/Saturation/Lightness). You can play with the color picker from the video below, to build an intuition for it!

How to use: Click/tap and drag on the two handles to tweak the color. If you're not using a pointer device, you can focus the handle and use the arrow keys instead.

SATURATION
LIGHTNESS
HUE
0 degrees
.box {
  background-color: hsl(0deg 100% 50%)
}

You can use HSL colors anywhere you'd normally put a hex code:

.colorful-thing {
  color: hsl(200deg 100% 50%);
  border-bottom: 3px solid hsl(100deg 75% 50%);
}

The first number has the deg suffix since it's in degrees (from 0° to 360°), and the next two numbers are percentages (from 0% to 100%).

Transparency

Certain color formats allow us to supply an additional value for the alpha channel.

This is a measure of opacity. At 1 (default), the color is fully opaque and solid. At 0, the color is invisible. We can specify decimal values to create a semi-transparent color.

Here's how we represent this in HSL:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

What's the deal with the slash?
(info)

Many students have asked about this funky syntax; why is there a slash in the hsl function??

The / character is becoming a more common pattern in modern CSS. It isn't about division, it's about separation. The slash allows us to create groups of values. The first group is about the color. The second group is about its opacity.

Later, we'll see how the same syntax can be used with border-radius to separate horizontal and vertical radius values. It's also used in CSS Grid, when an element spans multiple rows or columns.

Browser support
(warning)

This "version" of HSL color is part of a 2016 revision to how colors work in CSS. It enjoys wide browser support, but will not work in Internet Explorer.

If your project supports IE, you'll need to use a slightly different syntax:

 Show more
Background colors

The color property only affects the color of the text. If we want to set a color to the element's background, we can use the background-color property.

Here's how we can create a "highlighter" effect:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Later, we'll see how we can pass images and gradients to be used instead of solid colors, and all of the cool things we can do with them!


Units

---

## Units

Source: /css-for-js/00-recap/06-units

Units

The most popular unit for anything size-related is the pixel:

.box {
  width: 1000px;
  margin-top: 32px;
  padding: 8px;
}

Pixels are nice because they correspond more-or-less with what you see on the screen
*
. It's a unit that many developers get comfortable with.

Ems

The em unit is an interesting fellow. It's a relative unit, equal to the font size of the current element.

If a heading has a font-size of 24px, and we give it a bottom padding of 2em, we can expect that the element will have 48px of cushion underneath it (2 × 24px).

Here's a quick playground. Try tinkering with the font size to get a sense of how it works:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  p {
    /* Change me! */
    font-size: 15px;

    padding-bottom: 2em;
    border: 1px solid;
  }
</style>

<p>
  This paragraph has a relative amount of bottom padding!
</p>
Result
Refresh results pane

Here's another example: try changing the font size to see how that affects the child spans:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

How often should you use ems? I don't often reach for them. It can be very surprising when a tweak to font-size affects the spacing of descendant elements.

This is especially true when it comes to modern component architectures. Using em means that a component's UI will change depending on the font size of the container it's placed within. This can be useful, but more often than not, it's a nuisance.

The rem unit is much more useful in most circumstances.

Rems

The rem unit is quite a lot like the em unit, with one crucial difference: it's always relative to the root element, the <html> tag.

All of the rems across your app will be taking their cues from that root HTML tag. By default, the HTML tag has a font size of 16px, so 1rem will be equal to 16px.

Check out the following playground, and then change the html element's font size:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Notice how all the text scales accordingly, when you change the root font size? That's why people like the rem unit. No matter where an element is in the DOM tree, the rem is consistent.

It behaves consistently and predictably, like pixels, but it respects user preferences when it comes to increasing/decreasing default font sizes.

Please note, you shouldn't actually set a px font size on the html tag. This will override a user's chosen default font size. The only reason we're doing it here is to demonstrate how the rem unit works, and to simulate a user changing their default font size.

If you really want to change the baseline font size for rem units, you can do that using percentages:

html {
  /* 20% bigger `rem` values, app-wide! */
  font-size: 120%;
}
Percentages

The percentage unit is often used with width/height, as a way to consume a portion of the available space.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In this example, we've created a box with a fixed size (250px by 250px), and then added a child with a relative size. When the size of the .box element changes, the child will scale accordingly.

There are some interesting quirks when it comes to percentage-based values. We'll see them throughout the course, like when we talk about Height algorithms and aspect ratios.

When should I use which unit?

I recently published a blog post, “The Surprising Truth about Pixels and Accessibility”
. This blog post aims to answer the “pixels vs. rems” thing once and for all.

In the future, I plan on integrating this blog post into this course. For now, I strongly recommend that you check the blog post out. Consider it a bonus lesson from this course!

You can read it here:
https://www.joshwcomeau.com/css/surprising-truth-about-pixels-and-accessibility/

---

## Typography

Source: /css-for-js/00-recap/07-typography

Typography

When web designers are learning how to design for the web, they're taught that text is the most important aspect. Remove the text from the page, and it becomes totally unusable. The same might not be true for images or colors or styles.

CSS gives us many levers we can pull to tweak the text on our page, and we'll go deep into them later on. For now, let's cover the fundamentals of styling text.

Just the beginning!
(info)

Hey there! Just a friendly reminder, this module is meant as a quick recap. We'll go much deeper into many of these ideas later in the course!

For example, Module 6
 is all about typography and images, and we'll learn way more about how to style text on the web.

Font families

We can change which font is used with the font-family property:

font-family: Arial;

It's called a “family” because each font consists of multiple character sets: for example, “Roboto” includes 12 individual sets: 6 font weights, with 2 variants (normal and italic):

There are a handful of “web safe fonts”. These are fonts that come pre-installed on all major operating systems, like Arial, Times New Roman, Tahoma.

Font families come in different styles. The two most popular:

Serif
Sans-serif

A “serif” is a little adornment at the edge of strokes. Serif fonts are very common in print media, but less so on the web (they tend to create a more sophisticated, aged look).

On the left, a sans-serif font with straight edges. On the right, a serif font with curled tips.

If we want, we can tell the operating system to use its default font for a specific category, like so:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

By passing a category instead of a specific font, the operating system will use its default system font from this category. For example, when specifying sans-serif, Windows 11 will use “Segoe UI”, while macOS Ventura uses SF Pro
.

This can be useful if you want your site/app to feel “native” to its platform, but in general, we want to have our own branding! We can do this with a web font.

Web fonts

A web font is a custom font that we load in our CSS, allowing us to use any font we like. For example, Airbnb developed its own font in-house called “Cereal”. They use it across their web and native applications.

We'll explore this concept in depth later in the course. For now, here's what we need to know: we can drop a snippet into our HTML which will download this custom font onto the user's device, when they visit our site/app.

For example, this is the snippet that Google Fonts provides, if we want to use Roboto
, one of their hosted web fonts:

<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">

This HTML snippet will make the web font available for us to use in our CSS. Here's how we'd use it:

font-family: 'Roboto', Arial, sans-serif;

When using a web font, it's customary to surround its name in quotation marks, like 'Roboto'. This is technically only required if the font name has multiple words, but it's a worthwhile convention, to make clear that it refers to a custom web font.

I'm also specifying multiple comma-separated fonts here. This is known as a font stack. The idea is that the browser will use the first available font from the list. If Roboto isn't available (eg. because the download failed, or it's simply taking too long), we'll use Arial instead. And if the user's device doesn't have Arial, it'll fall back to the system-default sans-serif font.

Note that in production settings, you will likely wish to self-host your web fonts, for optimal performance and GDPR compliance. We'll look at how to do this later in the course.

Typical text formatting

Word processing software like Microsoft Word or Google Docs provide many ways to format text, and CSS has inherited some of these conventions.

We'll focus on the 3 most common formatting options:

Bold
Italic
Underline

This section looks at how to accomplish those goals on the web.

Bold text

We can create bold text with the font-weight property:

font-weight: bold;

There's also a numbering system, from 1 to 1000, which lets us control the font weight more precisely:

/* Light, thin text*/
font-weight: 300;

/* Normal text */
font-weight: 400;

/* Heavy, bold text */
font-weight: 700;

The default value for font weight is 400, and the bold keyword maps to 700.

If we only supply a single font weight, the browser will do its best to represent bold text by thickening the characters. It generally doesn't do a great job at this. We'll learn more in Module 6.

Italic text

When we communicate in person, there are all sorts of non-verbal cues that signal what we mean. Emphasis is an important tool in this toolbox.

On the web, emphasis is generally represented by slanting the text at an angle. Angled text suggests that the words are being "leaned into".

We can apply italic text with this declaration:

font-style: italic;

Similar to bold text, the browser can simulate italic text by rendering the characters at an angle. For best results, though, we should supply an italic character set.

Underlined text

On the web, underlines carry a very specific meaning: they tend to be links.

We shouldn't, therefore, use underlines for visual effect, or to signify that something is important. It'll confuse users.

That said, not all links will need underlines. For example, navigation links in a site's header are rarely underlined, but it's clear from their presentation that they serve as links.

We can toggle an element's underline with the text-decoration property:

/* remove underlines from navigation links: */
nav a {
  text-decoration: none;
}
Styles and semantics

CSS allows us to change the cosmetic presentation of text, but it doesn't affect the semantic meaning of the markup. For that, we need to use specialized HTML tags.

The <strong> HTML tag is meant to convey that an element is critically important or urgent, like “Warning: Product may explode if shaken”.

The <em> HTML tag is used for emphasis, the way one might emphasize a particular word in a sentence, like “these pretzels are making me thirsty.”

Semantics are important because not everyone can see the cosmetic styles. For a variety of reasons, some people use assistive technologies like screen readers (software that reads the text using a synthesized voice) to help them navigate the web. When we use the <em> tag, for example, the synthesized voice will stress the syllable much like a human would!

That said, this applies specifically to “copy”, the text content on our websites. We don't need to follow the same rules when it comes to UI elements. For example, we might want to make an input's <label> bold, and we can do this purely in CSS, without using a <strong> tag.

<b> and <i>?
(info)

Before we had <strong> and <em>, we had <b> (for bold) and <i> (for italic). When HTML5 came around and introduced semantic markup, these two tags were deprecated.

In the years since, however, these tags have been un-deprecated, and given new semantic meaning:

<b> is used to draw attention to text without implying that it's urgent or important.
<i> is used to highlight “out of place” content, like a foreign word, or the internal thoughts that a character is having in fiction.

Now, I'll be honest: I rarely use <b> and <i> myself. I don't know why you'd want to draw attention to something that isn't important. And it isn't clear to me what the semantic benefits are of the <i> tag.

It is important to use semantic HTML, and we'll see plenty of examples throughout this course. My personal opinion is that I'd rather focus on higher-impact things.

Alignment

Another word-processing concern: how do we tweak text alignment?

We can shift characters horizontally using the text-align property:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

text-align is also capable of aligning other elements, like images. In general, though, we'll use other tools for those kinds of jobs. We should reserve text-align for text.

Language directions
(info)

This example assumes that we're rendering a left-to-right language like English. We should exercise caution when applying alignment in international products that support right-to-left languages like Arabic or Hebrew.

We'll learn more about this in the next module.

Text transforms

We can tweak the formatting of our text using the text-transform property:

/* RENDER WITH ALL CAPS */
text-transform: uppercase;

/* Capitalize The First Letter Of Every Word */
text-transform: capitalize;

Why use text-transform when we can edit the HTML? It's advisable to use this CSS so that the “original” casing can be preserved.

In the future, we may wish to undo the ALL-CAPS treatment. If we had edited the HTML, we'd have to track down and change every single instance. But if we do it in CSS, we only have to remove a single declaration!

Spacing

We can tweak the spacing of our characters in two ways.

We can tweak the horizontal gap between characters using the letter-spacing property.
We can tweak the vertical distance between lines using the line-height property.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

line-height is a bit of an odd duck because it takes a unitless number. This number is multiplied by the element's font-size to calculate the actual line height.

As an example, suppose we have the following CSS:

p {
  font-size: 2rem;
  line-height: 1.5;
}

We can calculate the actual height of each line by multiplying the font size (2rem) by the line-height (1.5), for a derived value of 3rem.

By default, browsers come with a surprisingly small amount of line height. In Chrome, the default value is 1.15. In Firefox, it's 1.2.

These default values produce densely-packed lines of text which can be hard to read for people who are dyslexic or have poor vision. To comply with accessibility guidelines, our body text should have a minimum line-height of 1.5. This is according to WCAG 1.4.12, Text Spacing guidelines
.

p {
  line-height: 1.5;
}

It's possible to pass other unit types (eg. pixels, rems), but I recommend always using this unitless number, so that the line-height always scales with the element's font-size.

Careful with JSX!
(info)

If you use JSX and React, there's a bit of a gotcha here.

 Show more

---

## Debugging in the Browser

Source: /css-for-js/00-recap/09-debugging

Debugging in the Browser

Learning to effectively use the developer tools to debug CSS is a critical part of becoming proficient with CSS. We'll learn as we go, but here's a quick intro with some of my favourite tips.

Something I neglect to mention in the video: You can pop open the devtools by right-clicking and selecting “Inspect element”, or by using the keyboard shortcut:

On Mac, it's Command + Option + I
On Windows/Linux, it's Control + Shift + I

Hints in Chrome!
(info)

In the video, I mention that Firefox will warn us about “inactive” CSS declarations, where there's an unmet dependency.

Chrome recently added support for the exact same feature, starting in v108. So, if you happen to use Chrome as your default browser, you can now enjoy this wonderful feature as well!

Thanks to Aravind for letting me know.


Rendering Logic I

