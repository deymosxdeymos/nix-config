# CSS for JS - Module 3: Modern Component Architecture

---

## Problems and Solutions • Josh W Comeau's Course Platform

Source: /css-for-js/03-components/01-intro

Modern Component Architecture

There are a few “Hard Problems” when it comes to CSS. One of the very hardest has to do with CSS' global nature: how do we structure large applications to avoid specificity wars and naming collisions? How do we identify which styles affect a given element?

As it turns out, this doesn't have to be a major pain point! With the right combination of tooling and methodology, these are solved problems.

Let's dig into this a bit:

CSS Nesting
(info)

In the video above, I mention that preprocessors like Sass allow us to nest styles like this:

.form {
  border: 1px solid;

  p {
    color: red;
  }
}

Since filming this video, browsers have been adding support for native CSS nesting. This means that this code is now valid CSS, without any preprocessing!

As I write this update in December 2025, native CSS nesting is sitting around 85% browser support
 according to caniuse
*
. It’s been supported in all major browsers since late 2023, but there’s still a significant population using an older or more-niche browser. So, I’d say it’s still generally a good idea to use a tool that will convert nested styles into flat styles. Most of the libraries/frameworks/tools we explore in the next lesson will do this for us.

Can you look at a piece of markup and know what it'll look like, when it's rendered? Historically, this hasn't been possible. And similarly, when faced with a chunk of CSS, it was impossible to say which element(s) would be affected if we changed or removed it.

Let's talk about how we can answer these questions:

In this module and throughout the course, we'll use styled-components alongside React to cover CSS fundamentals in a modern context. I can't stress enough that these tools are just vehicles for the underlying knowledge: It's OK if you never plan on using styled-components or React, you'll still get a ton out of this module!

Maintenance mode
(warning)

In March 2025, styled-components maintainer Evan Jacobs announced that styled-components was entering “maintenance mode”
.

Initially, I assumed that the library would not receive any significant updates beyond bug fixes. In the year since, I’ve been pleasantly surprised; several improvements have been added to the library, including support for React Server Components
!

So, I would say even in 2026, styled-components is a viable choice. It continues to be popular, with over 8 million downloads per week
 on NPM.

I should also note: we use styled-components in this course, but the course isn’t really about styled-components. That’s just the vehicle we use to cover CSS concepts.

Even if you never plan on using a tool like styled-components, most of the lessons in this module are still relevant for you, since they cover core underlying concepts. And the lessons that are strictly about styled-components (eg. the installation instructions) have been marked as Optional, so feel free to skip them.

Global and inherited styles
(info)

In the video above, we talked about how it's good to have a strict boundary around our component, that all applied styles should be internal, and not the result of a style “leaking out” of another component.

There are a couple exceptions, when styles won't be colocated within a component. Fortunately, this doesn't tend to cause major issues, but I'd be neglectful if I didn't mention them.

 Show more

---

## Ecosystem World Tour

Source: /css-for-js/03-components/02-ecosystem-world-tour

Ecosystem World Tour
(Optional lesson)

When it comes to writing CSS in a modern JS application, there are a lot of options! In my time as a developer, I’ve seen countless CSS libraries and preprocessors come and go. It feels like there’s a new tool every week!

In this optional lesson, we'll take an overview of the various popular styling solutions out there, and talk about their pros and cons.

An important bit of context: these are my opinions. I've worked with each of the tools mentioned in this list and my opinions are based on that first-hand experience, but they also aren't objective or universal. Lots of very smart and experienced developers will likely disagree with me, that's just the way it goes.

Vanilla CSS

Pros:

No tooling means less complexity, no runtime performance costs.
Modern CSS features make certain library/preprocessor features redundant. For example, CSS Custom Properties? are like super-powered versions of Sass variables.

Cons:

Global and unscoped. The CSS you write in one place will be applied everywhere. Using a naming convention like BEM can help, but it's high-friction and prone to failure at scale: naming collisions are still possible, and it requires enormous dedication and willpower to stay 100% consistent with it.
Requires that you remember to add vendor prefixes for many CSS properties, to ensure optimal browser support.
Can't easily share data between CSS and JS.
When it comes to modern JS application development, it feels a bit like a square peg being squeezed into a round hole. CSS is built for documents, not apps.
Sass / Less

As we saw in this module's introduction, Sass
 is a preprocessor that compiles to vanilla CSS. It extends CSS with features like nesting, variables, and iteration.

It's similar in operation to TypeScript: all valid CSS is also valid Sass, and Sass compiles to CSS at build-time, just like TypeScript compiles to JavaScript.

$font-stack: Helvetica, sans-serif;
$primary-color: #333;

.wrapper {
  font-family: $font-stack;

  h1 {
    font-size: 2rem;
    color: $primary-color;
  }
}

I grouped Less
 into this category because it's quite similar. I've worked with both extensively, and the main difference I remember is that they use different syntax for variables: @var: 10 vs $var: 10.

Pros:

Includes powerful tools like for-loops, mixins, and nesting.
Has really high developer satisfaction compared with vanilla CSS.

Cons:

Requires a build step (and it's pretty slow in development compared with hot-reloading).
Because it compiles to CSS, it remains global by nature, and isn't scoped to specific components. It inherits a lot of "cons" from vanilla CSS, such as not automatically vendor-prefixing.
Everything happens at build time, so it can't react to things in real-time. As we'll learn later on, Sass variables are nowhere near as powerful as CSS variables for this reason.
Requires native dependencies that can fail or get out-of-date. I can't access my old Sass projects without spending hours dealing with native dependency issues. I can't just npm install — it's a real pain.
CSS has added a bunch of new features over the years, and there have been naming clashes. CSS has a native min function now, and it's way better than Sass' min function, but the keyword is already reserved. There are workarounds, but it's added friction.
It's becoming less and less popular in the JS scene. While popularity isn't everything, a fading solution will have less community resources, less support, and more potential for trouble.
CSS Modules

CSS Modules
 is a tool that allows you to write vanilla CSS, and import it into a JS file.

“CSS Modules” is a name for a very specific third-party project, not a built-in CSS feature for modules.

/* App.module.css */
.wrapper {
  background-color: gray;
  min-height: 200px;
}

@media (min-width: 1025px) {
  .wrapper {
    font-size: 1.25rem;
  }
}
// App.js
import styles from './App.module.css';

function App() {
  return (
    <div className={styles.wrapper}>
      Hello World!
    </div>
  );
}

Pros:

Solves scoping and specificity! The .wrapper class you write will be globally-unique, even if a different CSS file has a .wrapper as well. If you were to console.log in the JS file, you'd see something like .wrapper-abc123.
Feels like writing straight-up CSS, which can be nice and familiar.
Offers a composes feature, to extend existing CSS classes.

Cons:

Doesn't really offer any modern convenience features, like autoprefixing.
Hard to share data between CSS and JS.

CSS Modules are often mixed with PostCSS
, a plugin ecosystem for extending CSS in beneficial ways (autoprefixing, transpiling, etc). This can smooth out the experience a bit, but in my opinion, it still doesn't feel near as nice in a modern JS context as some of the other options.

Single-file components

Both Vue and Svelte offer a way to create scoped CSS in the same file as your component definition.

// Hello.vue
<template>
  <p>Hello World</p>
</template>

<style scoped>
  p {
    background-color: gray;
    min-height: 200px;
  }

  @media (min-width: 1025px) {
    p {
      font-size: 1.25rem;
    }
  }
</style>

This solution reminds me a lot of CSS Modules, and the pros and cons are essentially the same: we can scope our CSS to our component and not have to worry about fallible naming methodologies, but it doesn't help us share data or state between JS and CSS. It feels a lot like writing vanilla CSS, for better or worse.

(Vue added support for state-driven dynamic CSS
, which uses CSS variables to pass data from JS to CSS, but I haven't personally tried it, so I can't vouch for its effectiveness.)

In my opinion, the biggest benefit compared to similar options is that your styles and markup are written in the same file. This is awesome, and requires way less jumping-around between files. And if your JS framework has a “first-party” way of writing CSS, it’s a good bet that it’s pretty reliable!

styled-components

As we've already discussed, styled-components
 is a “CSS-in-JS” solution with a radical idea: every style is also a React component.

import styled from 'styled-components';

function App() {
  return (
    <Wrapper>
      Hello World!
    </Wrapper>
  );
}

const Wrapper = styled.div`
  background-color: gray;
  min-height: 200px;

  @media (min-width: 1025px) {
    font-size: 1.25rem;
  }
`;

Pros:

Solves scoping and specificity in a magnificent way. This solution is tailor-made for component-driven architectures, and it fits like a glove.
Feels like writing CSS (since you are just writing css!), with some of the quality-of-life improvements from Sass/Less rolled in.
Offers good solutions for animations and global styles — you can write 100% of your CSS with this tool.
High developer satisfaction.
Solid performance.
In January 2026, it was updated to be compatible with React Server Components
!

Cons:

While overall usage is still growing
, there isn’t as much community momentum behind this project, and it’s currently being maintained by a smaller team with less resources.
Requires a runtime, which adds about 11kb gzip to your bundles, and can potentially slow down initial renders (though in my tests, this effect is negligible in most realistic cases).
It's primarily a React tool. You can use styled-components with Vue
 and possibly other frameworks, but those communities will be much smaller.
Obfuscates the underlying markup tags, which can make it harder to get a sense of the HTML semantics at a glance.

CSS-in-JS and haters
(info)

styled-components is a “CSS-in-JS” tool. This means that the CSS is being created using JavaScript, either in the browser or during compile.

The name “CSS-in-JS” has always bothered me—it's a misnomer! It makes it sound like we've come up with some pure-JavaScript way of doing styling. Nothing could be further from the truth: we're still writing 100% legitimate full-fat CSS. JS is the delivery mechanism for our CSS, that's all.

Emotion

Emotion
 emerged shortly after styled-components, featuring a very similar API, but with improved performance characteristics.

Over time, the performance difference has disappeared (both libraries are extremely fast), and Emotion has grown to be a bit broader in scope.

Pros:

Shares all of styled-components’ pros.
Can be used without React (albeit with a different syntax).
Slightly smaller bundle size compared with styled-components: 8.5kb gzip instead of 11kb gzip.

Cons:

Shares all of styled-components’ cons.
Not as popular or battle-tested as styled-components — according to Github in December 2024, ~320k projects depend on Emotion, while ~2.6m projects use styled-components. So there are almost 10x as many styled-components projects out there.

Ultimately, Emotion is so similar to styled-components that, in my opinion, they’re interchangeable. You can pick either one. I think styled-components makes slightly more sense because of its community size, but it’s not likely to make a big difference.

Tailwind

Tailwind
 is a utility-first CSS framework.

"Utilities" in this context are short CSS classes that map to specific styles. Here's an example:

<div class="relative z-10 max-w-screen-lg xl:max-w-screen-xl mx-auto">
  Hello World
</div>

These classes apply the following CSS to the div:

z-index: 10;
position: relative;
max-width: 1024px;
margin-left: auto;
margin-right: auto;

Pros:

Tailwind has exploded in popularity over the past few years. It’s become the most popular option on this list.
Solves scoping and specificity.
Encourages good habits when it comes to following a design system — instead of specifying sizes in pixels, for example, they're specified in terms of size (lg, xl).
Includes built-in design tokens (colors, sizes…), which can make it easier to come up with a nice design.
Can be faster to write, once you get the hang of it.
Not React-specific.

Cons:

Relatively steep learning curve, compared to other tools.
Produces a single CSS file for the entire project, which can be hundreds of kilobytes on very large projects. It doesn’t scale as well as other choices on this list.
Not all CSS can be expressed concisely as utility classes. The Tailwind API has become much more flexible in recent years and most things can be expressed, but it can feel messy.
Adds a lot of "bulk" to your markup. In real-world scenarios, many many classes are required, and this can make it harder to read. For example:
<div
  class="relative col-start-1 col-end-2 sm:col-start-2
  sm:col-end-3 lg:col-start-1 lg:col-span-full
  xl:col-start-2 xl:col-end-3 row-start-2 row-end-3
  xl:row-start-3 xl:row-end-4 self-center pr-8 sm:px-6
  md:px-8 pb-6 md:pb-8 lg:px-0 lg:pb-0 -mt-6 sm:-mt-10
  md:-mt-16 lg:-mt-32 xl:mt-0"
></div>

Tailwind tends to be very polarizing: developers love it or hate it.

Linaria

The most popular CSS-in-JS tools, styled-components and Emotion, both require a runtime. Unfortunately, this strategy doesn’t work as well in modern React with the introduction of React Server Components in 2024. This is kind of a big tangent; if you’re curious, you can read more about it in my blog post, CSS in React Server Components
.

I recently rebuilt my blog, and I wanted to find a CSS tool that offered the same “styled” API, but without sacrificing any compatibility with React Server Components. I landed on Linaria
, a wonderful tool that offers the same great styling API, but instead of working its magic at runtime, it runs during the build step, and compiles to CSS Modules.

Pros:

Offers the same great styling API as styled-components, but without a runtime. This means it adds 0kb to our JavaScript bundle, is just as performant as vanilla CSS in-browser, and is fully compatible with React Server Components.
Compiles to CSS Modules, one of the most battle-tested and reliable tools out there.

Cons:

Very niche. Despite being one of the oldest CSS-in-JS tools, it never attracted a large user base. The community is tiny.
React-specific.
It’s tricky to get it to work with Next.js.
Because there’s no runtime, certain patterns with styled-components won’t work with Linaria.
Next-gen CSS-in-JS

Several libraries have popped up, offering a similar API to styled-components, but with a focus on full compatibility with modern React.

Here’s a quick list of options, with my thoughts about them:

Panda CSS
 — This library is probably the most popular of the collection. Under the hood, it compiles to Tailwind-style utility classes. Unfortunately, this is a dealbreaker for me, since it removes the ability to cross-reference classes (something we’ll learn about later in this module).
Pigment CSS
 — This library was built by the Material UI team to serve as a drop-in replacement for styled-components. It uses Linaria’s core tech under the hood. I was very excited about this project, but progress appears to have stalled, and it remains unclear if this will see a large-scale public release.
Next Yak
 — this library is also intended to be a drop-in replacement for styled-components, created by a large European e-commerce platform. It looks pretty great, but it’s exclusive to Next.js, and it hasn’t found a large user base.

Truthfully, none of these options really work for me, but I’m very picky with my CSS libraries. Panda CSS in particular seems to be fairly battle-tested, and may be a great option for you!

Conclusion

This list can feel a bit overwhelming; it can be hard to decide what to pick!

This is also a bit of a tricky time specifically for React developers. It feels like we’re in limbo, where tools like styled-components have lost some of their allure, but nothing else has stepped in to fill that gap. I’m hoping that Pigment becomes the primary CSS-in-JS tool for this new era, but it’s too soon to say.

Tailwind is the obvious choice, if judging by popularity and compatibility, but it’s very polarizing. I’ve spent a few weeks trying to like it, and it just doesn’t work for me.

All of this said, though, it doesn’t really matter as much as you’d think. This course uses styled-components, but 90%+ of this course is focused on CSS principles that work the same way no matter which CSS tool or library you choose to use. In a few years, we'll probably all be using some fancy CSS tool that doesn't even exist yet, and I feel confident the skills you learn in this course will still help you every day.

If I had to make one recommendation, it's that you pick an option that is scoped by default — using Vanilla CSS or Sass is still a viable path, but it adds a lot of mental overhead and unnecessary challenge. It takes all the fun out of writing CSS. Beyond that, though, they're all good choices. The tool matters less than how you use it.

As I mentioned in the last video, though, it's worth getting comfortable with the basics of styled-components even if you have no intention of switching to it as your primary tool. It'll help you in this course, and give you ideas you can take back to your tool of choice.


---

## styled-components 101

Source: /css-for-js/03-components/03-styled-components-101

styled-components 101

Shortly, we'll run through some exercises to help us get comfortable writing CSS in this way. First, though, I wanted to dig into some of the ideas we covered in the introduction, and explore a couple more concepts.

Here's a “Hello World” example:

const Button = styled.button`
  font-size: 2rem;
`;

This library uses an obscure JavaScript feature called tagged template literals
. styled.button is a function, and it gets passed a template string as an argument. This is syntactic sugar?, and we'll see in a bit why it's so useful.

styled-components also uses a Sass-like preprocessor behind the scenes called stylis
. It automatically adds vendor prefixes for maximum browser compatibility. It also allows us to use the ampersand character (&) to reference the soon-to-be-created class, like so:

const Button = styled.button`
  display: flex;

  &:hover {
    color: red;
  }
`;

Here's the CSS that will be produced:

.abc123 {
  display: flex;
}

/* Plucks out the `hover` pseudo-class:  */
.abc123:hover {
  color: red;
}

Note that component names don't have to be globally unique — pretty much every React component I write has a Wrapper styled component in it. When styled-components generates the class, it picks a unique hash every time, even for components with the same name.

The & character can be thought of as a placeholder: it will be replaced by a class name, once that class is generated. This allows us to use additional selectors, like &:hover or &:first-of-type. It allows us to use the full power of CSS even though we aren't typically specifying a selector.

Coming to vanilla CSS!
(info)

This handy operator has been available in CSS preprocessors for years, but it's finally been included in the CSS specification under CSS Nesting
.

As of December 2024, browser support is starting to get there. It’s currently around 91%, according to caniuse
. Most CSS tools have built-in support for this operator, so this doesn’t really change anything for us unless we’re using vanilla CSS.

One last thing: the styled object has methods for every HTML tag. Examples will frequently use styled.div, but it's important to point out that there is also styled.a, styled.cite, styled.canvas, styled.marquee, and so on. Semantic HTML is really important, and we need to be especially mindful of it when using styled-components!

A worked example

Let's build a component from scratch using styled-components!

In the video, I mention a CSS Tricks article
 about semantic structure for quotes. It's worth a read if you're interested in refining your semantic-HTML chops!

Here's the source code we wind up with in this video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Differences from the video
(warning)

The videos in this module were filmed using an older version of the playground. In the older version, dependencies like the styled helper were automatically injected, and a magical render() function was used to render our components.

The modern version of the playground doesn't do anything magical. Instead, the code is structured in a more real-world way. We import the dependencies we use, and wrap up our JSX in an App component.

I also haven't yet found a way to support syntax highlighting for CSS written using styled-components. For now, your CSS will be all yellow. Sorry about that! The good news is that this limitation is specific to the course platform; your local code editor should have full syntax highlighting support for styled-components.

If you'd like to see how the full application is structured, you can hit the  button to view all of the code in CodeSandbox.

One or two colons?
(info)

In the video, I mention that I use a single colon with pseudo-elements, like &:before, even though the “proper” syntax is to use two (&::before).

It honestly doesn't make a big difference either way, but I have started using two colons for all pseudo-elements. The code above has been updated to reflect this.

 Show more
CSS prop

styled-components comes with an alternative writing method: the css prop:

const Title = ({ id, children }) => {
  return (
    <h1
      id={id}
      css={`
        font-size: 2rem;
        font-weight: bold;
    `}
    >
      {children}
    </h1>
  )
};

This method is similar in appearance to inline styles, but it's full-fat CSS — the same bag of tricks is available, including using pseudoclasses and media queries, things that aren't possible with inline styles. It's a bit closer to utility-first frameworks like Tailwind.

I personally don't love this style of writing CSS — it bloats the JSX and feels messy to me. But ultimately, it's a subjective, aesthetic choice. We still reap all the same benefits around specificity and scoping. So if you prefer this style, go for it!

Read more about the css prop
 on the styled-components docs.

Note that the css prop requires a Babel plugin, and as such, it won't work in the playgrounds on this course platform.

Continue learning

If you're interested in learning more about how styled-components works, I wrote a blog post called “Demystifying styled-components”
.

If you've been using styled-components for a while and still feel like you don't quite understand what it's doing, this post will help you understand the magic, to increase your confidence with the tool.


---

## Installation and Setup

Source: /css-for-js/03-components/04-setup

Installation and Setup
(Optional lesson)

styled-components is a specialized tool, and there are some things we can do to improve our experience writing it. This article covers how to get it installed and running, and how to optimize the developer experience!

To be clear, the stuff covered in this lesson is useful if you want to use styled-components in your own projects. This information isn't necessary for completing the exercises and workshops in this course.

Installation

styled-components is an NPM package
. You can install it by running:

npm install styled-components

If you're not familiar with NPM, you can read this short guide about getting set up with Node and React

Babel plugin

When you write a styled component, the runtime will transform that component into a CSS class with a randomly generated name, like .a5gsgpzvq. As you might imagine, this can be a little frustrating when you're poking around in the elements pane and trying to match an HTML element with its source component.

To make life easier, the styled-components team also released a Babel plugin which picks semantically-meaningful class names in development (the behaviour doesn't change in production, for performance reasons).

Class names will be structured in the following format: Filename_componentName-hash. So if the HTML is <header class="ShoeIndex__Header-sc-123">, you can look for the const Header inside ShoeIndex.js.

If you have access to your project's build tool (eg. Webpack), the plugin can be installed alongside other Babel plugins.

If you use Create React App
, the build configuration is hidden unless you eject. The styled-components team has you covered, though: you can use the Babel plugin without ejecting with this one weird trick.

First, install the plugin as a dev dependency:

npm install --save-dev babel-plugin-styled-components

In your React application, change all imports to match the following:

// From this:
import styled from 'styled-components';

// ...to this:
import styled from 'styled-components/macro';

By importing from the macro, you get the benefits of the Babel plugin without needing to eject, or fuss with the build configuration.

This works because Create React App supports Babel macros
. Other boilerplates/starters might not support it, so this trick may not work by default.

Editor integrations

styled-components works by using tagged template literals. By default, this means that your styles will be treated like any other string: a solid, lifeless color:

Fortunately, editor integrations exist! This means that you can have proper CSS syntax highlighting even when using styled-components:

It isn't just syntax-highlighting, either: you also get proper auto-complete, and all the other niceties of working in a modern editor:

I personally use VS Code (and can wholeheartedly recommend the official vscode-styled-components plugin
!), but integrations exist for most popular IDEs. For the most up-to-date list, check out the official list of resources
.

Server-side Rendering

I use styled-components on my blog, joshwcomeau.com
.

Here's something kinda cool: check out what happens when I disable JavaScript, and try to visit it:

Even though I've disabled JS, most of the site still works
*
. All of the styles still appear!

How is this possible? We learned that styled-components runs in-browser, and generates the classes on-the-fly.

styled-components has server-side rendering support, which means the initial HTML/CSS is generated beforehand. My blog uses Next.js, which means I can go 1 step further, and do all this work when I build the site.

In a way, this makes it like Sass — I can pre-compile all of the HTML and CSS before I even deploy the site! It's even more powerful, though, because it also runs in the browser. I can do dynamic stuff that wouldn't otherwise be possible.

Learning how to integrate styled-components into your SSR process is beyond the scope of this course, and will depend on the meta-framework you’re using.

styled-components and React Server Components
(warning)

You may have heard that styled-components is incompatible with React 19 or Next.js. This isn’t entirely true, but there is a bit of an issue using styled-components with Next.js.

I describe the issue in this blog post:

CSS in React Server Components

---

## Performance

Source: /css-for-js/03-components/05-tooling-performance

Performance
(Optional lesson)

When it comes to CSS-in-JS tools like styled-components, a lot of focus has been placed on the performance of these tools, and whether they can be detrimental to the user experience.

This article looks at the current-day performance of styled-components, compared to other solutions. This is an optional lesson. Feel free to skip this one if you aren't inherently interested in performance — it's an academic lesson for folks who like this stuff.

When we speak about performance, there are two main things we're talking about

There is the bundle bloat — the amount of KBs the library adds to your JS bundle.
There is the "mount and update speed" — this refers to how long it takes to transform the styled.whatever elements into CSS classes, and mount them into the stylesheet. Either on initial mount, or when a dynamic style changes.

Let's look at them in turn.

Bundle size

styled-components is a pretty tiny module; it weighs 8.4KB gzipped
, as of version 6.3.11 in early 2026. Happily, the bundle size has been getting smaller, not bigger, as the tool has evolved!

In my opinion, 8KB is a very reasonable price to pay for a library as fully-featured as styled-components.

For context: a large hero image on a news site might be 200KB, or larger. The comparison isn't apples-to-apples, since the browser has to do more work with JS than with binary data like images, but when it comes down to it, I don't think we need to sweat a bundle bump of under 20KB for a core component of our application (after all, React on its own is over 40KB, and Angular 2 weighs in at over 100KB!).

Mount and update speed

Consider the following code:

const Button = styled.button`
  color: red;
`;

ReactDOM.render(
  <Button>Hello World</Button>,
  document.querySelector('#root')
);

When this code runs, React will render that styled.button, and the styled-components library will have to do a few things:

Generate a class name, .button-abc123, that holds the associated CSS declarations (in this case, color: red;).
Insert that class into the <head> of the document, in a <style> tag
Render a button element with the associated class, <button className="button-abc123">

It repeats this process for every styled component in your application 😱

It sounds like it might take a while, but styled-components has gotten ridiculously optimized over the last couple years.

A couple of years ago, I used a benchmarking tool to compare the performance of different CSS solutions. In the main test, “Mount deep tree”, it mounts a tree with over 600 styled components, in a deeply-nested structure:

On my desktop computer, here are the results:

styled-components: 16.5ms
Emotion: 17.5ms
Straight-up inline styles: 28.3ms

Keep in mind, this benchmark renders 600 styled-components on the page at once. That’s a lot! I use styled-components on this course platform, and the page you’re looking at right now only has ~200 styled-component instances. But even with a relatively large number of elements, this work would be done in 16.5ms (roughly 1/20th the time it takes to blink).

The benchmark tool also shows the speed to update dynamic styles, and this speed tends to be even quicker (which makes sense, since updating is usually less work than mounting).

Granted, these numbers will look worse on lower-end hardware and mobile devices. But even if we assume it takes 10 times longer, 165ms. This is still an imperceptibly small amount of time.

Running your own benchmarks
(info)

Unfortunately, the benchmarking tool I used appears to no longer be online, as of September 2025. If you’re reading it in the future, it’s possible that the bug has been fixed.

Try the benchmark
View the benchmark on Github
Server-side rendering

There's one other huge thing we have to talk about: server-side rendering (SSR).

If you use a meta-framework like Next.js, Gatsby, Nuxt, or SvelteKit, you're good to go: these tools are server-side-rendered. 👍

In a standard non-SSR app, the user receives a mostly-empty index.html file. They'll stare at a blank white screen until the JS bundle has been downloaded, parsed, and executed.

With SSR, all of that work is done ahead of time, either when the user requests the page, or well ahead of time, when the app is compiled. The HTML file they received is fully-formed and styled.

This means that users will see all of the styles immediately. Before the JS bundle is downloaded. Before the styled-components runtime is executed. Before all of the mount/update work happens.

Now, there is a downside I should acknowledge. The initial HTML document the user receives, with all of the markup and styles, won't be interactive. This means that any custom JS (eg. an onClick handler) won't be available until the JS bundle has been parsed and executed.

By using styled-components, we're adding more weight to our bundle, and creating more work to do on mount. At least in theory, styled-components can increase the “time to interactive”, the amount of time the user is looking at a fully-formed HTML document that isn't actually ready-to-go.

But how much time are we actually talking about? Well, on a typical 3G connection, we can download 8KB in about 30 milliseconds
. There will be some additional time spent parsing the JavaScript, and then around 16ms to create and apply all of the styles.

Let's be very conservative and say that it takes 100ms to do all this work, delaying the “Time to Interactive” by a tenth of a second. Is this noticeable by the user? Will they try to interact with something that requires JS within this 100ms window?

Here's something else to consider: if we follow semantic HTML best practices, most things on the page should work even without JS. We should be able to click links to visit a new page, or submit a form to search or log in. On this course platform, you can disable JS altogether and things still work! Only the videos, code playgrounds, and interactive widgets require JS.

In conclusion

When we talk about performance, we should always focus on the actual user experience. Specifically, what is the real-world impact when using a tool?

When it comes to CSS-in-JS libraries like styled-components, I've become increasingly convinced that they don't have a noticeable impact on the user experience, especially in a server-side-rendering context (and if you care about performance, you should absolutely be using SSR).

And yet, so many folks in our community are convinced that tools like styled-components have a large negative impact on performance. How come?

I think there are two reasons:

When styled-components first launched, many years ago, it was far less optimized than it is today. It's possible that folks are relying on stale news for their information.
It really seems like styled-components should be slow, since it has to do all this extra work on mount.

It's an unfortunate truth that most of our opinions around performance come from assumptions or synthetic benchmarks, not real-world experiences. Certain "performance tips" get passed around and applied without ever running tests to see if they help or not.

Fortunately, the smart folks working on these libraries have done all the optimizations for us, so we can use these tools without guilt!


---

## Exercises

Source: /css-for-js/03-components/06-exercises

Exercises

Alright, let's get some hands-on practice!

The exercises below include some components styled using vanilla CSS. Your job is to convert the styles to use styled-components.

By the time you're done, the /styles.css file should be empty.

Frequently Asked Question

I've built so many little FAQ components over the years. Let's convert this one!

Your mission is to use styled-components to style the FrequentlyAskedQuestion component. You'll need to migrate all of the styles currently written in /styles.css.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
import styled from 'styled-components';

function FrequentlyAskedQuestion({
  question,
  answer,
}) {
  return (
    <details className="faq">
      <summary>{question}</summary>
      <div className="answer">
        {answer}
      </div>
    </details>
  );
}

const App = () => (
  <FrequentlyAskedQuestion
    question="What does “CSS” stand for?"
    answer="Cool Styling Strategy"
  />
);

export default App;
Result
Console
Refresh results pane

Solution:

Login Form

The login form below is styled using vanilla CSS. Let's migrate it to use styled-components:

Code Playground

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

Solution:

Contact card

Next up, a contact card!

Same deal as last time, with one exception: you aren't expected to convert any “global” styles, like the background color on body. We'll cover that in the next lesson.

Code Playground

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

Solution:


---

## Global Styles

Source: /css-for-js/03-components/07-global-styles

Global Styles

With styled-components, the styles we write are indelibly bound to the elements created. In a component-driven framework like React, this is exactly what you want, most of the time.

But what about global styles? Things like CSS resets, and some baseline styles for native HTML elements?

styled-components has a specific API for creating global styles:

// GlobalStyles.js
import { createGlobalStyle } from 'styled-components';

const GlobalStyles = createGlobalStyle`
  *, *::before, *::after {
    box-sizing: border-box;
  }

  html {
    font-size: 1.125rem;
  }

  body {
    background-color: hsl(0deg 0% 95%);
  }
`;

export default GlobalStyles;

This API is remarkably similar to the styled helpers we've seen so far: it's called using a tagged template literal, and it returns a component we can render in our app:

// App.js
import GlobalStyles from '../GlobalStyles';

function App() {
  return (
    <Wrapper>
      <Router>
        {/* An entire app here! */}
      </Router>

      <GlobalStyles />
    </Wrapper>
  )
}

export default App;

When the GlobalStyles component is rendered, it will inject all of its CSS into the <head> of the document, applying those styles.

It doesn't really matter where you render this component; there is no significant advantage to putting it above or below the rest of your app's content. I normally include it in my top-level App component, so that I know it's always being rendered, and I put it below the rest of the JSX in that component so that it's out of the way.

Global style patterns

Let's talk about when and how to take advantage of global styles!

Updated: my global styles
(success)

You can see the baseline set of global styles I personally use in new projects over on my blog:

A Modern CSS Reset

---

## Dynamic Styles

Source: /css-for-js/03-components/08-dynamic-styles

Dynamic Styles

One of the great things about using a tool like styled-components is that it allows us to dynamically alter our styles based on our application state. In this lesson, we'll look at some options for how to manage dynamic styles with styled-components.

Correction: In the video, I use the term “back ticks” when I meant “dashes”, to describe the characters at the start of CSS variables (--hover-color). Sorry for the confusion!

In this video, we saw 3 different approaches for managing dynamic styles. They're summarized below:

Inline styles
const Button = ({ color, onClick, children }) => {
  return (
    <Wrapper onClick={onClick} style={{ color }}>
      {children}
    </Wrapper>
  );
}

const Wrapper = styled.button`
  color: black;
  padding: 16px 24px;
`;

Inline styles are quick and easy to add, but they carry two significant disadvantages:

They make it harder to understand what's going on by "splitting up" where the CSS definitions live
They aren't compatible with media queries, pseudo-classes, and any CSS that isn't straight-up property/value.
Camel-case properties

When setting properties in JavaScript, we use “camelCase” versions of property names:

<a
  style={{
    // Instead of `border-radius`:
    borderRadius: '8px',
    // Instead of `text-decoration`:
    textDecoration: 'none',
    // Instead of '-webkit-font-smoothing':
    WebkitFontSmoothing: 'antialiased',
  }}
>
  Hello
</a>

This isn't React-specific! This is how styles are written and read in vanilla JavaScript as well:

const anchor = document.querySelector('a');

console.log(anchor.style.borderRadius); // 8px;

anchor.style.borderRadius = '16px';
console.log(anchor.style.borderRadius); // 16px;
Interpolation functions

The official styled-components way of managing dynamic styles is to use interpolation functions
:

const Button = ({ color, onClick, children }) => {
  return (
    <Wrapper onClick={onClick} color={color}>
      {children}
    </Wrapper>
  );
}

const Wrapper = styled.button`
  color: ${props => props.color};
  padding: 16px 24px;
`;

This API leverages tagged template literals. If you're curious about how this all works, MDN has some great documentation
 on the subject.

CSS Variables

Finally, we can solve this problem using CSS Variables (AKA CSS Custom Properties):

const Button = ({ color, onClick, children }) => {
  return (
    <Wrapper onClick={onClick} style={{ '--color': color }}>
      {children}
    </Wrapper>
  );
}

const Wrapper = styled.button`
  color: var(--color);
  padding: 16px 24px;
`;

CSS Variables are really pretty neat, and we'll learn more about them later on in the course.

This method offers a great developer experience — it's quick and easy to add new styles, it feels lower-friction than using styled-components interpolations.

That said, they're a bit less flexible; they can only be used to provide property values, which can be limiting when it comes to media queries.

One important note I neglected to mention in the video: CSS Variables aren't supported in Internet Explorer
. If you need to support IE, you should use styled-components interpolations instead.

Media queries

We haven't touched on media queries in styled-components yet! We'll learn much more about them in future modules, but here's a quick example for those curious:

const Wrapper = styled.button`
  color: black;

  @media (min-width: 1200px) {
    color: red;
  }
`

Note that you don't need to nest the selector within the @media tag, the way you do with vanilla CSS. This is done to make life easier for us.


---

## Exercises (pt. 2)

Source: /css-for-js/03-components/09-exercises-pt2

Exercises (pt. 2)

Now that we've covered global styles and interpolations, let's get some more practice!

These exercises take the same form as the last set: convert some vanilla-CSS snippets to use styled-components exclusively.

Framed art

Note: You'll need to use createGlobalStyle
 in this exercise. This method has been imported for you, at the top of the /App.js file.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
import styled, { createGlobalStyle } from 'styled-components';

function WallArt({ src, alt, caption, width }) {
  const aspectRatio = 3 / 2;
  const height = width * aspectRatio;

  return (
    <div className="wall-art-wrapper">
      <img
        src={src}
        alt={alt}
        style={{
          width,
          height,
        }}
      />
      <p className="caption">{caption}</p>
    </div>
  );
}

function App() {
  return (
    <WallArt
      src="https://courses.joshwcomeau.com/cfj-mats/wall-art.jpg"
      alt="A hallway with rainbow-colored lights"
      caption="Photo by Efe Kurnaz"
      width={250}
    />
  )
}

export default App;
Result
Console
Refresh results pane

Solution:

Fragments?
(warning)

In this solution video, I use a “fragment” to return multiple top-level elements from my App component. I've heard from some bewildered students who have pointed out that I haven't introduced or explained fragments at all! 😅

If you're not familiar with fragments, and you'd like to learn a bit of React, you can read on:

 Show more
Icon Buttons

In this exercise, your task is once again to convert vanilla CSS to use styled-components.

Code Playground

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

Solution:


---

## Vendor Prefixes

Source: /css-for-js/03-components/09.01-vendor-prefixes

Vendor Prefixes

Back in the day, it was common for bleeding-edge CSS properties/values to be released with a vendor prefix. For example, in the early days of Flexbox, we had to write:

.flex-wrapper {
  /* Supported in Safari and other webkit browsers: */
  display: -webkit-flex;
  /* Supported in Internet Explorer: */
  display: -ms-flexbox;
  /* Supported in all other browsers: */
  display: flex;
}

This was a major pain in the butt, and so we built tools that would solve this problem for us. CSS preprocessors like Sass would add these duplicate declarations automatically for us. We’d write display: flex, and the tool would generate the rest.

styled-components uses a preprocessor called Stylis under the hood, and stylis also generates these vendor prefixes for us. So, this isn’t something we’ve historically had to deal with.

However, starting in styled-components v6, vendor prefixes are disabled by default.

I can understand their reasoning. These days, vendor prefixes are much less common; it’s been many years since a new CSS feature was released with any sort of vendor prefix. This is a thing of the past. And we can trim our bundles down a bit by excluding these mostly-unnecessary prefixes.

Unfortunately, there are still some properties that require vendor prefixes to work correctly. For example, the backdrop-filter property (Discussed in Module 9) drops from 97% support all the way down to 85% support when we exclude the vendor prefix.

Ideally, we’d be able to select which vendor prefixes to opt into, but Stylis doesn’t offer any sort of granularity, it’s an all-or-nothing kind of thing. Personally, I think it’s still worth including vendor prefixes.

Here’s how we can opt into vendor prefixes:

import { StyleSheetManager } from 'styled-components';

function App() {
  return (
    <StyleSheetManager enableVendorPrefixes>
      {/* Entire application here */}
    </StyleSheetManager>
  );
}

This tag should wrap around our entire application, like other context providers.

This change has been made for all playgrounds on this course platform, so you don’t have to worry about vendor prefixes here.


---

## Component Libraries

Source: /css-for-js/03-components/10-component-libraries

Component Libraries

Over the past few years, it's become increasingly common for larger organizations to build a component library.

A component library is a collection of generic, reusable components that can be dropped in to multiple applications. It's a way to ensure consistency between products, and it can help boost new development speed, since you have a suite of drop-in primitives and don't have to build everything from scratch.

There are many open-source component libraries out there. For example, the Material component library
 for Angular:

In this module, we're going to explore this concept in depth, and learn how to build our own mini component library!

This module is for you!
(success)

Some of you might be thinking: “I'm not looking to build a massive open-source component library! I just want to improve my CSS to build small web apps. Will this module help me with that goal?”

The answer is a resounding yes! The methodology used by large corporations to structure their component libraries can benefit every single React/Angular/Vue/Svelte app out there. By thinking of the components we write in these terms, we produce better applications.

This doesn't mean that you need to spin up an entirely separate project, or open-source anything. The lessons in this module are applicable even if your “component library” is a half-dozen components sitting inside your side-project application.

Design systems and design tokens

Over the past few years, component-driven frameworks like React have grown to be massively popular within the front-end web scene. A similar transformation has been happening in the design world.

A design system is essentially the "designer version" of a component library. Instead of a suite of React components, though, a design system is made up of a suite of vector graphics produced in tools like Figma or Sketch or Adobe Illustrator.

In many organizations, the two are linked; the design team has a design system with components like Button and Modal and Combobox, and the development team has a component library with those same elements. Designers combine their design components into mockups, and we can map those components neatly to our component library.
*

Design systems also consist of design tokens. A lot of systems will specify scales for sizes or colors, and a design token is a value in that scale.

We saw this in an earlier workshop. Rather than allow all possible font sizes under the sun, we might limit it to a smaller subset:

0.75rem
0.875rem
1rem
1.25rem
1.5rem
2.5rem
CSS as a specialty

Some have said that as more and more organizations adopt the "component library" strategy, fewer and fewer developers will need to know CSS to do front-end dev work.

Let's talk about it.

Using a pre-existing component library

Should you use a third-party component library, like Google's Material Design library?

Update: Reach UI, the library we saw in this video, is no longer being actively maintained. Fortunately, there are plenty of other options for us to choose from!

Here are my current recommendations:

Radix Primitives
Headless UI
Ariakit
React Aria

I share more information about these tools in the Treasure Trove.


---

## Breadcrumbs

Source: /css-for-js/03-components/11-breadcrumbs

Breadcrumbs

Alright, enough theory: let's build some components!

We'll start with a Breadcrumbs component. Breadcrumbs are the helpful navigation links you often find near the top of e-commerce listing pages. They show the hierarchy of the content's structure, and let you quickly hop up to the parent or grandparent category page.

In this lesson, we’ll build a component that can render breadcrumbs. Here’s the UI we’ll be creating:

For this lesson, you have a choice:

You can treat this as an exercise, and attempt to implement the UI shown in that clip.
Or, you can treat this like a typical video lesson, and see how I would implement this UI.

Here's the blank canvas we’ll start with:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Here's the video, where I walk through how to build this component:

Check out the WAI-ARIA guidelines for Breadcrumbs
, along with a specific implementation
.

In the video above, I neglected to add aria-current="page", to indicate that the final breadcrumb is a reference to the current page. I've added it in the code below:

import styled from 'styled-components';

const Breadcrumbs = ({ children }) => {
  return (
    <nav aria-label="Breadcrumb">
      <BreadcrumbList>{children}</BreadcrumbList>
    </nav>
  );
};

const Crumb = ({ href, isCurrentPage, children }) => {
  return (
    <CrumbWrapper>
      <CrumbLink
        href={href}
        aria-current={isCurrentPage ? 'page' : undefined}
      >
        {children}
      </CrumbLink>
    </CrumbWrapper>
  );
};

const App = () => (
  <Breadcrumbs>
    <Crumb href="/">Home</Crumb>
    <Crumb href="/living">Living Room</Crumb>
    <Crumb href="/living/couch">Couches</Crumb>
    <Crumb href="/living/couch/sectional">
      Sectionals
    </Crumb>
  </Breadcrumbs>
);

const BreadcrumbList = styled.ol`
  padding: 0;
  margin: 0;
  list-style-type: none;
`;

const CrumbWrapper = styled.li`
  display: inline;
  --spacing: 12px;

  &:not(:first-of-type) {
    margin-left: var(--spacing);

    &::before {
      content: '/';
      opacity: 0.25;
      margin-right: var(--spacing);

      /*
        Note: The ideal version of this solution
        would instead use a transformed border,
        to avoid using a real character which
        could be announced by screen readers.

        For example, something like this:

          content: '';
          display: inline-block;
          transform: rotate(15deg);
          border-right: 1px solid;
          margin-right: var(--spacing);
          height: 0.8em;
       */
    }
  }
`;

const CrumbLink = styled.a`
  color: inherit;
  text-decoration: none;

  &:hover {
    text-decoration: revert;
  }
`;

export default App;

---

## Button

Source: /css-for-js/03-components/12-button

Button

Our Breadcrumbs component has some tricky elements, but ultimately it isn't a very dynamic component. Let's look at something a bit more interactive: a button component.

Composition

Before we start working on our Button component, we should talk about one more trick in the styled-components bag: composition.

If we need multiple variants of a component, we can choose one component to serve as the base for another. For example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import styled from 'styled-components';

export default function App() {
  return (
    <PrimaryButton>Button</PrimaryButton>
  );
}

const Base = styled.button`
  font-size: 1.5rem;
`;

const PrimaryButton = styled(Base)`
  background: blue;
  color: white;
`;
Result
Console
Refresh results pane

If you inspect that element in the devtools, you'll notice that it's applying both styles:

<button class="iaGSPX coOzpk">Button</button>

<style>
  /* Base */
  .iaGSPX {
    font-size: 1.5rem;
  }

  /* PrimaryButton: */
  .coOzpk {
    background: #00f;
    color: #fff;
  }
</style>

(In the devtools, you should also see some additional classes that start with sc-. We can ignore those. They're added as labels, designed to be transformed by the babel plugin for improved debugging.)

This kind of composition is common in the CSS world, but styled-components handles a lot of the messier details for us, like ordering our class names so that conflicts are solved correctly.

Mission brief
Exercise

Here are the resources you'll need for this exercise:

The starter files on CodeSandbox
The design file on Figma
My bonus lesson covering Figma

This component uses the “Roboto” font. This font is already included (you can find the Google Fonts snippet in public/index.html
), so you can use it like so:

font-family: 'Roboto', sans-serif;

A note on outlines and Firefox
(info)

The Figma design includes custom “focus” styles, including a color-matched outline. Unfortunately, Firefox doesn't support tweaking the color of focus outlines.

In my opinion, custom focus styles are a “nice-to-have”, and so it's not a big deal if they aren't available for everyone. The fallback experience of Firefox's default focus styles is perfectly sufficient.

(If you're wondering why this doesn't work, given that the outline-color property is supported in Firefox
, it's because interactive elements like buttons have special non-default outlines; we'll explore this distinction in Module 9.)

Solution

You can access my final code on CodeSandbox
.

Correction: I made a few small mistakes in this video, with incorrect vertical padding and a couple of forgotten properties 😅. I have updated my solution to include these fixes.


---

## Dynamic tags

Source: /css-for-js/03-components/13-link-button

Dynamic tags

In this lesson, we'll see how to use the polymorphic as prop to dynamically change the tag that styled-components renders.

Here's our solution, from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import styled from 'styled-components';

function Button({ href, children }) {
  return (
    <Wrapper href={href} as={href ? 'a' : 'button'}>
      {children}
    </Wrapper>
  );
}

const Wrapper = styled.button`
  background: blue;
  color: white;
  border: none;
  padding: 16px 24px;
  border-radius: 4px;
`;

const App = () => (
  <Button href="/">Hello</Button>
);

export default App;
Result
Console
Refresh results pane

Here's another quick example, this time using React Router's Link instead of a plain anchor:

import { Link } from 'react-router-dom';

function Button({ href, children }) {
  return (
    <Wrapper to={href} as={href ? Link : 'button'}>
      {children}
    </Wrapper>
  );
}

const Wrapper = styled.button`
  /* styles */
`;

render(<Button href="/">Hello</Button>);

Learn more by reading the styled-components documentation
.


---

## Escape Hatches

Source: /css-for-js/03-components/14-escape-hatches

Escape Hatches

So far, we've been operating under the assumption that our components are 100% well-suited for every situation that requires them. Unfortunately, things aren't usually so neat and tidy.

No matter how much preparation we do, we will always discover additional needs once we start using the component in our application. Sometimes, it's a matter of updating the standard to include an additional tweakable parameter. Other times, a special situation will call for special one-off handling.

In this lesson, we'll look at a few common scenarios to see which approach makes the most sense. We'll also learn how to build escape hatches into our components, to allow for specialized tweaks.

A new variant

Let's imagine that we're working on a brand new feature: users can delete their accounts from our app.

We add a confirmation prompt, and realize that our button is missing something:

We really want this button to be red, to emphasize the gravity of this action… but our component only comes in a standard blue color.

There are many ways we could handle this situation, and to determine which path makes the most sense, I like to ask a question: is this tweak something we'll plausibly need to do again?

We can't predict the future, but we can make educated guesses. In this case, I imagine that we may want to add additional destructive actions to our application!

In fact, it's quite common for component libraries to include color variants for different statuses:

“info” is usually a calm blue
”success” is usually green
“alert” is usually orange or yellow
“danger” is usually red

Adding all 4 at this point would be overkill, but I would update our component to take a new mood prop:

<Button
  mood="danger" // 'default' or 'danger'
/>

We've codified this behaviour so that it's there when we need it next time. It's important that we're always refining our components, to make sure they match the needs of our team!

That said, each added prop carries a significant and exponential cost in terms of complexity. We don't want to add new props whenever a new customization is needed! Let's look at some other options.

Color-blindness
(info)

Approximately 5-10% of people around the world aren't able to see the full spectrum of color.

Most commonly, folks aren't able to distinguish between red and green
*
.

It's important to keep in mind whenever we work with color. We should never rely exclusively on color to communicate an idea, it should always be used to emphasize.

In this example, we're alright, since the primary signal is the text “DELETE”, and the red color is used for emphasis.

We'll learn more about this in Module 9.

Composition

Let's imagine another scenario: the marketing team is building a "spooky" landing page for Halloween, and they want to be able to create an orange button with a different font:

How might you allow for this new styling?

One approach could be to add a new mood, spooky. I don't love this idea, though, for a few reasons:

It adds significant complexity to our code: this new mood would tweak background color, text color, and font family.
This Halloween landing page sounds like a one-off, and not something we'll need to use again and again.
It doesn't really scale. What happens when the marketing team decides they want a “Christmas” mood, with animated candy canes? Our poor button is going to get more and more overloaded.

Instead, I prefer to use composition. Here's how I'd do it:

/* components/SpookyButton.js */
import Button from './Button';

const SpookyButton = styled(Button)`
  font-family: 'Spooky Halloween Font';
  background-color: orange;
  color: black;
`;

export default SpookyButton

We build a one-off component that composes our base Button component.

But hold on—The Button component we're importing isn't a styled-component, it's a custom component we created ourselves! Can we compose custom components too?

We can, though it does require a change:

const Button = ({ variant, size, children, className }) => {
  const styles = SIZES[size];

  let Component;
  if (variant === "fill") {
    Component = FillButton;
  } else if (variant === "outline") {
    Component = OutlineButton;
  } else if (variant === "ghost") {
    Component = GhostButton;
  } else {
    throw new Error(`Unrecognized Button variant: ${variant}`);
  }

  return (
    <Component style={styles} className={className}>
      {children}
    </Component>
  );
};

The difference: we added a className prop to our component, and passed it along to the rendered <Component>.

To understand why this works, let's consider what happens when we try to use our new SpookyButton component:

function HalloweenPage() {
  return (
    <SpookyButton variant="fill">
      Sign up… if you dare!
    </SpookyButton>
  );
}

SpookyButton is a styled-component, so it will extract the declarations into a class, append that class to the <head>, and apply that class to the element.

<Button> will be given the class name that styled-components generates, and it will be added to the rendered <Component>. Our final markup will look like this:

<button class="base-abc123 fill-def456 spooky-ghi789">
  Sign up… if you dare!
</button>

styled-components will apply the classes in order, so that the “spooky” styles will overwrite the “fill” button styles, which in turn overwrite the “base” styles.

This is a really powerful idea, but like everything, there are tradeoffs. The downside is that it does spread our styles around a bit.

The good news is that there are no mysteries. When we look at SpookyButton's definition, we see that it builds upon the Button styles, so we have a trail of breadcrumbs we can follow to see all of the styles. But it's additional friction.

That said, it's way better than the alternative in this case: We could keep them all in 1 place, but then that place would be really cluttered. A typical large app will have too many one-off button styles to fit comfortably in 1 place; it's better to spread it out a little bit, so that one-off buttons can be viewed in isolation (and a developer trying to understand the common case isn't burdened with all the exceptions!)

Escape hatches

Essentially what we've done, by forwarding className, is we've given ourselves an escape hatch.

Escape hatches are tools that allow us to break free of the constraints that normally serve us well. For example, React will automatically sanitize all children, but if you want to apply direct HTML, you can do so with this escape hatch:

<div
  dangerouslySetInnerHTML={{
    __html: 'First &middot; Second'
  }}
/>;

You might look at that and say "huh, that seems unnecessarily complicated".

The same result could be accomplished with a lower-friction API:

<div rawHtml="First &middot; Second" />

The React team intentionally adds friction because they want it to be clear that this is an escape hatch to be used in exceptional circumstances, not something you should reach for every day.

I like to follow a similar motto when it comes to building reusable components: it should be easy to follow the convention, and hard (but possible!) to break free of it.

Earlier, when we added a mood prop, we decided that it should be a part of the API, and we made it very easy to change the background color:

<Button mood="danger">Confirm</Button>

For one-off components, though, the developer will need to go through a higher-friction process:

import Button from './Button';

const SpookyButton = styled(Button)`
  font-family: 'Spooky Halloween Font';
  background-color: orange;
  color: black;
`;

export default SpookyButton

This will encourage us to use conventions when possible, but it gives us an escape hatch we can use to create special variants. In my opinion, it's the perfect level of flexibility.

Some folks disagree. They say that the point of a component library is to enforce a consistent style, and by incorporating an escape hatch, it becomes possible to change any CSS. It's too much power.

My rebuttal is that the world is messy, and we will need to break with convention sometimes. Designs call for exceptions. If the component can't flex, we'll need to build a new one from scratch. And the end result will be an even-less-consistent user interface.

This framework — easy to follow the convention, possible to break free of it — has served me really well over the years.


---

## Single Source of Styles

Source: /css-for-js/03-components/15-single-source

Single Source of Styles

In this video, we look at a challenging problem involving “contextual styles”. How do we allow components to take on different styles in different contexts without "reaching in" and styling other elements?

Our goal is to update the code below so that TextLink has black, underlined text when it's inside the Quote component. When it's rendered outside the Quote component, it should be blue, and not have an underline.

It's important to stress: we haven't learned how to do this yet. I want to give you the chance to think about this problem, to see why it's tricky. I don't expect you to be able to solve it yet, however.

Here's the playground. Spend a few minutes working on this problem, then watch the video to see how to solve it.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import styled from 'styled-components';

const Quote = ({ by, source, children }) => {
  return (
    <figure>
      <QuoteContent>{children}</QuoteContent>
      <figcaption>
        <Author>
          <SourceLink href={source}>{by}</SourceLink>
        </Author>
      </figcaption>
    </figure>
  );
};

/*
  We want this TextLink to be black
  and underlined when it's inside
  a Quote component.
*/
const TextLink = styled.a`
  color: blue;
  text-decoration: none;
`;

const QuoteContent = styled.blockquote`
  margin: 0;
  background: hsl(0deg 0% 90%);
  padding: 16px 20px;
  border-radius: 8px;
  font-style: italic;

  &::before {
    content: '“';
  }
  &::after {
Result
Console
Refresh results pane

As a hint: “Referring to other components”
 in the docs will help!

Working through the problem

Our solution applies TextLink styles when TextLink is found within QuoteContent:

const TextLink = styled.a`
  /* Standard styles: */
  color: blue;
  text-decoration: none;

  /* Styles when rendered inside a quote: */
  ${QuoteContent} & {
    color: black;
    text-decoration: revert;
  }
`;

I call this approach “Inversion of control nesting”. It's the opposite from how many developers think about nesting, where we always start from the parent:

// Standard nesting.
// **DON'T do this**
const Aside = styled.aside`
  /* Standard styles */

  ${TextLink} {
    color: black;
    text-decoration: revert;
  }
`;

With this approach, we avoid "reaching in" and setting TextLink styles from within another component. As a bonus, it colocates all relevant TextLink styles in the same place.

Another huge bonus: we aren't relying on our own memory.

Imagine if we had solved this using a variant prop instead:

<Quote by="unknown">
  Using a
  <TextLink variant="quote" href="">variant</TextLink>
  is one possible way to do this.
</Quote>

This approach works alright, but it requires that we remember to use variant="quote" whenever we add a new quote. I know myself well enough to know that I will not remember to do this 100% of the time, leading to a very inconsistent UI.

(Additionally, sometimes it isn't possible to add specific props like this, if the quote and link are sourced in a CMS or written in Markdown!)

There is a downside to this approach, however: we need to import the parent component, so that we can reference it in our styles. This can bloat our bundles, and hurt performance.

How do we avoid this downside? We should only use this approach for "common" situations, not one-offs.

We'll discuss this approach more in the next lesson, as we review the different tools we have for managing styles.


---

## In Summary

Source: /css-for-js/03-components/16-summary

In Summary

One of the hardest parts of working with styles in modern component-based applications is dealing with all the variations. Unfortunately, a single Button component might have lots of different presentations depending on the context.

In this module, we've seen a lot of ways to add or tweak styles, and it may not be clear which to use when. Let's review the methods we've seen, and consider when they come in handy.

Core options through props

When we created our Button component, we added props for variant and size. For example:

<Button
  variant="ghost"
  size="small"
>
  Click me
</Button>

Most of the reusable components we create will take a small number of props for their "core" options. These options will map to specific styles that get applied within the component.

Composition with styled()

It's important not to add too many core options. It would be hard to use (not to mention maintain!) a component that worked like this:

<Button
  fontFamily="Spooky"
  buttonSize="small"
  textSize="small"
  backgroundColor="orange"
  color="black"
  cornerRadius="small"
  hoverEffect="grow"
  focusStyles="default"
  disappearOnClick={true}
  isPartOfAGroup={false}
>
  Click me
</Button>

As our application grows, we'll wind up with lots of "one-off" requirements, like our SpookyButton from earlier. We can solve for these problems using composition:

/* components/SpookyButton.js */
import Button from './Button';

const SpookyButton = styled(Button)`
  font-family: 'Spooky Halloween Font';
  background-color: orange;
  color: black;
`;

export default SpookyButton

How do we decide whether a property is a "core option" or a "one-off variant"? Admittedly, sometimes the line can be a little blurry. Use your best judgment, and remember that you can always change your mind later! If the Button component starts to feel too overwhelming, with too many options, consider extracting a couple composed variants to lighten the mental load.

The goal should be to have props for every-day common use cases, and one-offs for niche, specialized situations.

Contextual styles

Sometimes, we want to apply a style only when it's within another component, or in a specific situation.

In these cases, it's less about picking the right prop for a job, and more about changing the defaults.

We saw this in the last lesson. It's a technique I call "Inversion of control nesting":

const ButtonBase = styled.button`
  /* Standard styles omitted */

  ${ButtonGroup} & {
    border-radius: 0px;
  }
`;

This technique is useful when we want a change to be "implicit". It saves the developer (us) from having to remember to use a specific variant prop in a specific situation.

There is a bit of a blurry line here, though. Could we not say that SpookyButton is a contextual style, to be used whenever Button is inside HalloweenPage?

// Button.js
import { Wrapper as HalloweenWrapper } from '../HalloweenPage';

const ButtonBase = styled.button`
  /* Standard styles omitted */

${HalloweenWrapper} & {
    font-family: 'Spooky Halloween Font';
    background-color: orange;
    color: black;
  }
`;

This accomplishes the exact same goal, but the tradeoffs are different:

Pro: I can see these styles in the same spot as my other Button styles, letting me know that this variant exists.
Pro: Makes the contextual styles "automatic". Developers don't need to remember to use SpookyButton, it happens automatically.
Con: Bloats our JavaScript bundle. Because we need to import HalloweenPage, it means that any page that uses a Button also has to download all of the markup and code for the halloween page, even if it's the middle of February!
Con: Having access to all possible contextual styles in 1 place can be overwhelming. Adds a lot of noise.

For super-niche styles like HalloweenPage, I think the cons outweigh the pros. We don't want to bloat our bundle or our style definition by adding all possible one-off variants.

By reserving this trick for common, every-day situations, we increase its power, since we're more likely to pay attention to them. If there are 30 contextual styles defined in 1 place, we'll probably just ignore them, since it's too much mental overhead to go through each of them.

Removing the JS bloat
(info)

The "inversion of control nesting" idea requires that we import the parent component. I know this makes a lot of JavaScript developers nervous, since it seems like it could inflate our JS bundle sizes!

In my experience, it hasn't really been a problem. I reserve this trick for "low-level" components like TextLink and Quote. These components tend to be small, and really widely-used. This means that we aren't pulling in that many unnecessary components, and when we do, they tend to be quite tiny.

That said, there is an alternative approach that avoids the import. I don't recommend it for most use cases, since it has its own tradeoffs, but it can be a worthwhile trick on very large or performance-sensitive applications, for advanced users.

 Show more
The right tool for the job

styled-components provides many different tools, and developing an intuition for which to use when is the work of many years. Hopefully this summary has helped set you on the right track, but ultimately this is the kind of thing that comes with practice. Don't worry if you don't feel like you have a handle on it yet!

For those who aren't using styled-components outside of this course, spend a few moments considering how these alternatives relate to your tool of choice. How might you simulate each of these alternatives in your current stack, to achieve similar tradeoffs?

Taking it back to where we started, our goal is to understand which styles affect which elements, and ultimately, the ideas in this module are all in service of that goal.


---

## Workshop: Mini Component Library

Source: /css-for-js/03-components/17-workshop

Workshop: Mini Component Library

In this workshop, we build our own component library!

Your mission

Our component library consists of 3 components:

A progress bar:

A select input:

And a text input with icon:

These components might seem simple, but building robust, accessible versions of these components isn't so simple.

Access starter files

You can access the Figma design here:

“Mini Component Library” on Figma

And here's the starter code:

github.com/css-for-js/mini-component-library
codesandbox.io/p/sandbox/mini-component-library-l79u06
 (Experimental)

The CodeSandbox URL is “experimental” because this workshop uses Storybook, a tool for component testing that typically needs to run on a local machine. CodeSandbox has recently begun to support these types of applications, and it seems to work great (just give it a few minutes to boot up)!

If you run into any issues, you can always get the files from Github.

If you're not familiar with Git, never fear! You can download a .zip from Github:

For submitting the workshop, you can package up your work into a .zip file, upload it somewhere (Dropbox, Google Drive, etc), and paste the link below.

Check out the README for instructions for running Storybook.

A polarizing workshop

I've heard feedback from some students that this workshop is particularly stressful / frustrating. In particular, the second exercise (<Select>) requires some out-of-the-box thinking, and possibly some googling / experimentation. It feels unfair.

At the same time, other students have reached out to tell me that they loved this workshop, precisely because it challenged them, and helped them build their problem-solving skills.

CSS is a huge language, and there's no way that I can possibly cover every challenge, property, or UI component in this course. Instead, I want to help you build the skills needed to be able to solve challenging problems on your own!

All of that said, I don't want you to feel frustrated. If you reach the point where you're not having fun with this one, I've added a hint to the solution page that should offer just enough guidance to get you unstuck.

You can also take a “hybrid approach”. Spend a few minutes hacking on the problem, then watch a few minutes of the solution videos. Bounce between working and watching until you finish the workshop.

As always, this is your course. You can choose your own adventure. The most important thing is that you get value from this course. If you're not having fun, you're not likely to finish the course, and that's the worst outcome of all.

Submit Workshop

I review a small percentage of submitted workshops, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## ProgressBar

Source: /css-for-js/03-components/18-workshop-progress

ProgressBar

Let's build a ProgressBar!

View the solution code on Github

Native vs. custom

HTML comes with a <progress> element. In some cases, you may wish to use that element rather than build something custom from scratch.

Progress elements can be styled
, but only on Chrome and Safari. Even then, support for animations is limited, and there are likely many designs that will not be possible using native <progress>.

If we choose to build our own element, as we do in this workshop, we need to make sure our alternative is just as usable and accessible as the native element. This MDN doc
 explains how to use this role correctly.

Trimmed corners

We can use wrapping elements to trim corners of all children with overflow: hidden.

const Trimmer = styled.div`
  border-radius: 16px;
  overflow: hidden;
`;

This is useful in our ProgressBar because it allows us to round the edges of the <Bar /> element in exactly the right way, as it approaches 100%.

Concentric circles

When we nest elements that use border-radius, we need to tweak the outer element to be more curved than the inner one.

We discuss this strategy in depth in Module 9.

Alternative approaches

Several students have suggested using a linear-gradient to create the progress-bar aesthetic. This removes the need for BarWrapper, since we don't have to trim the corners of a child element.

There are two reasons I've opted not to use that approach here:

If we wanted to animate this progress bar, the transform-based solution will be more fluid and performant.
Creating a sharp edge with a gradient is a bit tricky, and it's beyond what we've seen in the course so far. We'll learn more about this approach in Module 9.

Those caveats aside, it's totally valid to use gradients to create a progress bar! If you've gone with this approach, you don't have to change anything. 💯


---

## Select

Source: /css-for-js/03-components/19-workshop-select

Select

Next up in the roster, a Select component.

A helpful hint
(success)

The most challenging part of this exercise is that <select> tags have a built-in chevron. In order to use the <Icon> that has been provided, we need to somehow hide this default character!

Read on for a hint:

 Show more

View the solution code on Github

An important correction
(warning)

In the video, I left out a pretty important declaration:

const NativeSelect = styled.select`
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  appearance: none;
`;

In Safari, <select> tags have a default height, one which can't be overridden with the height property. The appearance property removes this restriction.

If not using a CSS preprocessor, you may wish to use -webkit-appearance instead of appearance. The appearance property is supported in Safari 15.4+
, but there's still lots of folks on older versions of Safari.

Some important highlights from this video:

The sweet spot

Generally, developers pick one of two strategies when it comes to styling the <select> element / creating a single-select input:

Take the native <select> element and style it, acknowledging that certain things (eg. the icon) can't be customized and will vary by platform
Build it entirely from scratch, a daunting challenge when considering mobile devices and accessibility

For inputs like <select> and <input type="file">, a third option exists: we can keep the native input, but set it to be invisible. We can create whatever presentation we want, and when the user clicks the form control, the real input will become activated, preserving the great cross-platform, accessible UX that these elements bring.

The adjacent sibling combinator

CSS offers a method to style elements based on their siblings: the adjacent sibling combinator
.

This allows us to style our presentational element when the real element is focused:

const NativeSelect = styled.select`
  /* styles */
`;

const PresentationalBit = styled.div`
  ${NativeSelect}:focus + & {
    outline: 1px dotted #212121;
    outline: 5px auto -webkit-focus-ring-color;
  }

  ${NativeSelect}:hover + & {
    color: ${COLORS.black};
  }
`;

Note that we still follow the same best practices when it comes to keeping a single source of styles; all of the styles that affect PresentationalBit are still stored within the relevant styled element.

There is also the general sibling combinator (~)
, which works much the same way but doesn't require elements be directly adjacent.

(Lastly, the order matters: div ~ p will only affect p tags coming after div tags.)

Restyling the native select
(info)

Several students have written in, saying they found a way to achieve the design without hiding the native <select>.

By applying appearance: none, the default chevron is stripped away. We can then include our own <Icon> component, and make it absolutely-positioned to sit in front of the <select>.

This approach works, but there are some gotchas to be aware of:

Because the <Icon> is sitting in front of the <select>, it has the potential to block clicks, if the user happens to click right where the icon is. We can fix this by applying pointer-events: none. We'll learn more about this property in Module 9.
Because the <select> is being used for layout calculations, it will stretch based on the length of the longest option (rather than dynamically resizing based on the currently-selected option). This isn't necessarily a problem, but it's something to be aware of.
appearance has pretty good browser support, though it's missing Internet Explorer. If you're not using a preprocessor, you'll want to include the -webkit-appearance property as well, to pull the browser support from ~88% to ~98%
.

But yeah, this is an absolutely valid solution to the problem!


---

## IconInput

Source: /css-for-js/03-components/20-workshop-IconInput

IconInput

Finally, IconInput!

One small correction: In the end, we use straight-up pixels for the font size and height, and this is a mistake! We should have kept using rems. This is corrected in the solution:

View the solution code on Github

Styling placeholder text

We can use the placeholder pseudo-element to tweak the styles of our placeholder text:

const TextInput = styled.input`
  /* other styles omitted */

  &::placeholder {
    font-weight: 400;
    color: ${COLORS.gray500};
  }
`;
Alternative: Using composition

Something we didn't look at in the video is an alternative solution which uses composition instead. Here's what that alternative would look like, omitting the parts that don't need to change:

const IconInput = ({
  label,
  icon,
  width = 250,
  size,
  ...delegated
}) => {
  const iconSize = size === 'small' ? 16 : 24;
  const Input = size === 'small'
    ? SmallInput
    : LargeInput;

  return (
    <Wrapper>
      <IconWrapper style={{ '--size': iconSize + 'px' }}>
        <Icon id={icon} size={iconSize} />
      </IconWrapper>
      <Input
        {...delegated}
        style={{
          '--width': width + 'px',
        }}
      />
    </Wrapper>
  );
};

const TextInput = styled.input`
  width: var(--width);
  border: none;
  color: inherit;
  font-weight: 700;
  outline-offset: 2px;

  &::placeholder {
    font-weight: 400;
    color: ${COLORS.gray500};
  }
`;

const SmallInput = styled(TextInput)`
  height: 24px;
  font-size: ${14 / 16}rem;
  border-bottom: 1px solid ${COLORS.black};
  padding-left: 24px;
`;

const LargeInput = styled(TextInput)`
  height: 36px;
  font-size: ${18 / 16}rem;
  border-bottom: 2px solid ${COLORS.black};
  padding-left: 36px;
`;

In general, composition approaches like this work best when there are many variants and many differences between each variant; it can be hard to follow the logic otherwise. In this case, however, I think both approaches are equally valid.


