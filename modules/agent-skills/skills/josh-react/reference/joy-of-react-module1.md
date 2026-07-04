# Joy of React - Module 1: React Fundamentals

## The Magic of React

In the early 2010s, Facebook had a problem. Thousands of people were complaining about "phantom messages".

Users would see a little 1 notification badge by the "messages" icon, suggesting they had new messages. But when they'd click it, there wouldn't be anything new, just the same old messages.

At the time, the UI had 3 separate locations where message state was presented:

Users were getting phantom messages because these 3 parts of the UI were powered by separate views, and those views were getting out of sync.

This might seem like a trivial problem to solve, but Facebook is a tremendously complex app, with hundreds of developers across dozens of teams all collaborating, adding new features, moving fast and breaking things. Every week, some new edge-case would crop up, leading to phantom messages. It was like playing whack-a-mole; every time they fixed a bug, a new one would pop up.

The team eventually solved this problem by migrating to an experimental new internal tool: React. This problem, along with so many others, disappeared.

If you're interested in hearing a more-detailed version, this story is told by Jing Chen in a talk, Rethinking Web App Development at Facebook 
*
.

The truly magical thing about React is that we don't have to worry about keeping our state (held in JavaScript) and our UI (in the DOM?) in sync.

With React, we're describing what we want the UI to be, based on the current application state. React takes those descriptions and makes it real.

I started building with React in 2015. I've had the privilege of working on a number of large React codebases, including Khan Academy, which was one of the first large applications outside of Facebook to migrate to it, and Unsplash, the internet's 250th most popular website
*
.

I can honestly say that I never want to build dynamic web applications any other way. Once you get comfortable with React, it becomes such a powerful tool.

I'm so excited to share the joy of React with you. Let's get started!


About React 19

---

## About React 19

About React 19
(Optional lesson)

In December 2024, the long-awaited React 19 update became stable. 🎉

Lots of students have reached out to ask if this course has been updated for React 19 / Next.js 15. I’m pleased to share that this course has mostly been updated!

In this brief lesson, I’ll share exactly what I mean by “mostly”, but first, let me reassure you: this course is still 100% relevant for software developers using React today. I genuinely do not believe you need to be concerned about this.

To quickly summarize what has changed in React 19, I think there are 3 main buckets:

Minor improvements and tweaks
The stabilization of Server Components
The introduction of “Actions”

(There were also a bunch of under-the-hood changes, but those only really affect framework/library maintainers, so I’ve excluded them from this list.)

Let’s look at each bucket in turn.

1. Minor improvements and tweaks

React 19 introduces a handful of “quality of life” changes, tweaking things to be slightly more ergonomic.

The Joy of React has been updated to include these changes. I’ve added notes throughout the course to highlight and explain changes in React 19. I’ve also updated the playgrounds and projects to use React 19 as well, so you can experiment with these changes on this platform.

These changes are all pretty minor, but I’ve made sure that you won’t miss any of them as you go through the course!

2. Stabilization of Server Components

Server Components is one of the two headline features for React 19. And good news: we already cover them in The Joy of React!

How is that possible? Well, Server Components were released in “beta” in React 18. They’ve been marked as stable in React 19, but their public API hasn’t changed at all.

So when it comes to this particular bleeding-edge feature, this course is already 100% up to date. 😄

3. The introduction of “Actions”

The new Actions API is the other headline feature for React 19. They offer an alternative way to work with forms and perform mutations.

This is the biggest thing missing from The Joy of React right now: we don’t really cover Actions at all. It’s very possible that I’ll add some content in the future to fill this gap, but at least for now, I’m in “wait and see” mode. I want to see if the community adopts them or not.

I’ve done some experimenting with Actions, and truthfully, it isn’t clear to me that it’s really an improvement over the existing alternatives. I’ll be watching to see whether companies start using them, whether it becomes a thing you need to know as a React developer.

Actions are supplemental
(warning)

In this course, we learn how to work with forms in the “traditional” way, using controlled inputs. You might be wondering: isn’t this a waste of time, if Actions are the future?

Here’s the thing: Actions don’t really replace controlled inputs, they supplement them. You still need to understand controlled inputs.

I’ll explain this in more depth when we get to that point in the course, but I want to reassure you that you won’t spend a bunch of time learning something that’ll soon be made redundant by new React features. 😄

Next 15

In Module 6 of this course, we cover full-stack React principles in the context of Next.js’ new App Router.

Next.js recently released a new major version, 15. This release was largely about bumping React from 18 to 19, though there were also some breaking changes.

I’m pleased to share that this course has been fully updated for Next 15. In Module 6, all of the code has been updated, and notes have been added that highlight recent changes.

Keep calm and carry on

Over the summer, I built a brand-new version of my blog, joshwcomeau.com 
. I used React 19 (while it was still in beta), because I wanted to learn all the new stuff.

And honestly, React 19 feels exactly like React 18 most of the time. I was able to benefit from some of the quality-of-life improvements, and I had fun experimenting with Actions, but the overwhelming majority of things were completely identical.

As I mentioned above, the course now highlights the things that have changed in React 19 / Next 15, so you won’t miss out on any new goodies. But for the most part, React is still React, and the stuff you learn in this course will serve you in your career for years to come. 💖


Hello React

---

## Hello React

Hello React

Let's start with a “hello world” React application:

Code Playground
(Restored)

Reset Code
Hide line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.js
index.html
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
// 1. Import dependencies
import React from 'react';
import { createRoot } from 'react-dom/client';

// 2. Create a React element
const element = React.createElement(
  'p',
  { id: 'hello' },
  'Hello World!'
);

// 3. Render the application
const container = document.querySelector('#root');
const root = createRoot(container);
root.render(element);
Result
Console
Refresh results pane

We start with two files: an index.html file that includes a barebones HTML document, and an index.js file with a minimal React application.

When we run this code, we're left with a paragraph that displays the text “Hello World!”.

There's a lot to unpack here. We'll go through it one section at a time. If you're up for it, though, I'd encourage you to spend a couple minutes poking and prodding at this example. See what you can figure out with a bit of sleuthing?!

1. Import dependencies
import React from 'react';
import { createRoot } from 'react-dom/client';

At the very top of the file, we have two import statements, using the native JavaScript module system. We're importing the core React library from the react dependency, as well as a createRoot function from react-dom.

If you're wondering why there are two separate packages, this is because React itself is “platform agnostic”. We have the core react package, and then there are different platform-specific renderers:

react-dom for the web
react-native for mobile (iOS / Android) or desktop (Windows / macOS) applications
react-three-fiber for 3D scenes using WebGL and Three.js

Every platform has its own “primitives”, the set of built-in elements we use to create our UI. On the web, the primitives are HTML elements like <div> and <p> and <button>. By contrast, React Native doesn't have divs, it has Text and View and Pressable. And things get even more wild with react-three-fiber, where the primitives are things like lights, geometries, materials, and cameras.

All of these platforms will use the same core React framework, which comes from the react package. But when it comes to actually turning all of the business logic into a user interface, we need the correct bindings for our platform.

This is actually a terrific thing, because it means that the skills you build learning React can also be used to build mobile applications or 3D interfaces, if that's where your interests or your career takes you!

What the heck is the “DOM”, anyway?
(info)

The DOM is the living, breathing structure that makes up a live website / web application. When we visit a website, the browser turns the static HTML into the DOM.

To use an analogy: HTML is the blueprint for a specific car, and the DOM is the car itself, zipping around the city.

Here's another way to look at it:

When you right-click and “View source”, you view the HTML, a static document that describes what will be constructed.
When you right-click and “Inspect element”, to open the Elements pane, you're interacting with the DOM. You can change attributes and watch the UI update in response.

When we use a tool like React, it works by interacting with the DOM via JavaScript. It'll create, update, and delete DOM elements as required.

In case you're curious, DOM stands for Document Object Model.

2. Create a React element

Next up in our mini-application, we have the following code:

const element = React.createElement(
  'p',
  { id: 'hello' },
  'Hello World!'
);

React.createElement is a function that accepts 3 or more arguments:

The type of the element to create.
The properties we want this element to have.
The element's contents. We can omit this if the element should be empty.

This function returns a “React element”. React elements are plain old JavaScript objects. If we inspect it with console.log(element), we'll see something like this:

{
  type: "p",
  key: null,
  ref: null,
  props: {
    id: 'hello',
    children: 'Hello World!',
  },
  _owner: null,
  _store: { validated: false }
}

This JavaScript object is a description of a hypothetical paragraph tag, with an ID of hello, containing the text "Hello World!". This information will be used to construct the actual paragraph we can see in-browser.

Later in this course, we'll learn about key and ref. The final two properties, _owner and _store, are meant to be used internally by React, and can be safely ignored by us. 
*

DOM hierarchy
(info)

The DOM is organized as a tree. Much like a family tree, individual elements can have parents and grand-parents, siblings, and children.

For example, consider this document:

<html>
  <body>
    <main>
      <p>
        <strong>Warning:</strong>
        objects in mirror are closer than they appear.
      </p>
    </main>
    <footer>
      © 2022 Acme Inc.
    </footer>
  </body>
</html>

The <main> element:

Has <body> as its parent.
Has a single child, the <p> element.
Has a single sibling, <footer>.

This hierarchy is a big part of the web. We reference it in CSS, when writing selectors like this:

p:first-child {
  /*
    Apply styles to the paragraph if it's the
    first child within its parent container.
  */
}

React embraces this model as well. As we've seen, React elements can specify “children”. We use the same language, because React elements form a hierarchy just like DOM elements do.

3. Render the application

We've made it to the last few lines of code:

const container = document.querySelector('#root');
const root = createRoot(container);
root.render(element);

document.querySelector is a helpful function that lets us capture a reference to a pre-existing DOM element. It's the modern version of document.getElementById, if you're more familiar with that function.

It works in this case because our index.html file includes the following element:

<div id="root"></div>

This element will be our application's container. When we render our React application, it will create and append new DOM element(s) to this container.

With react-dom's createRoot function, we specify that this element should be the root of our application. And, finally, we render the application with root.render(element).

You can think of the render function as a machine that converts React elements into DOM nodes. In this case, our React element describes a paragraph tag, with an ID, and some text inside. render will turn that description into the following DOM structure:

<p id="hello">
  Hello World!
</p>

With that DOM element created, it then adds it to the page at the specified root. In essence, this code takes a JavaScript-based description of some HTML, and uses it to produce real-world DOM nodes.

This probably seems like a very complicated way to create a paragraph! But, as we'll learn throughout this course, the real magic happens when things change. ✨

This changed recently!
(warning)

If you've read other React tutorials, you might've seen something that looks like this:

import ReactDOM from 'react-dom';

ReactDOM.render(
  element,
  container
);

This is how React applications were rendered in version 17 and earlier. Starting in version 18 (released in March 2022), the API was changed to the createRoot and render combo shown above.

In some of the videos in this course, you'll catch glimpses of this API, which were recorded before I had upgraded React to the latest version on this course platform.

Build systems

Video Summary

We'll learn more about build systems in the “Tools of the Trade” reference module.

About video summaries
(info)

Many of the videos in this course have text summaries available. You can show this summary by clicking the “Video Summary” button underneath the video.

Please note, however: Reading the summaries isn't really an adequate replacement for watching the videos. They're primarily intended to help with review, to remind yourself of what was covered in a video you watched earlier.

If you have prior React experience, and you think you might already know everything in a video, you can use the summaries as a way to quickly gauge if that's true. But in general, I'd suggest watching the videos. You can always increase the playback speed to go through them more quickly!


Build Your Own React

---

## Build Your Own React

Build Your Own React

One of the best ways to learn how something works is to build our own simplified version of it.

In this exercise, you'll create a render function that takes React elements and produces the equivalent DOM structure!

To keep things as simple as possible, we won't bother with the createRoot API discussed in the previous lesson. Instead, we'll write a render function that takes two parameters:

The React element, describing the UI we want.
A target DOM node that will house our application.

This is meant to be a challenging exercise. It's 100% OK if you can't solve it. Spend 5-10 minutes on it, and then watch the video below.

Acceptance criteria?:

The “Result” pane should show the UI described by the React element. It should contain an anchor tag, which links to Wikipedia, and contains the text “Read more on Wikipedia”.
It should work with any element type (eg. anchors, paragraphs, buttons…)
It should handle all HTML attributes (eg. href, id, disabled…)
The element should contain the text specified under children. children will always be a string.

Interacting with the DOM
(warning)

In order to solve this challenge, you'll need to know how to interact with the DOM, to do things like create DOM elements and append them to the page.

We cover all of the methods you'll need in the “Interacting with the DOM” reference lesson 👀.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.js
index.html
function render(reactElement, containerDOMElement) {
  const domElement = document.createElement(
    reactElement.type
  );
  domElement.textContent = reactElement.children;
  for(const key in reactElement.props) {
    const value = reactElement.props[key];
    domElement.setAttribute(key, value);
  }
  containerDOMElement.appendChild(domElement);
}

const reactElement = {
  type: 'a',
  props: {
    href: 'https://wikipedia.org/',
  },
  children: 'Read more on Wikipedia',
};

const containerDOMElement = document.querySelector('#root');

render(reactElement, containerDOMElement);
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
Productive failure

So, you've just attempted the first exercise of the course! How did it go?

I suspect it was pretty tricky, unless you were already familiar with DOM interaction methods. You may not have successfully completed it. You might be feeling a bit discouraged or frustrated.

If so, I have some good news for you: you probably learned a lot more than you think from this exercise!

Most online courses give you everything you need right at the start. You can code along with the instructor without breaking a sweat, and glide through the exercise effortlessly. And, a month later, you won't remember any of it.

It turns out that struggling and failing is one of the most effective ways to learn a new skill quickly!

In academic circles, this is known as productive failure. Here's a quote from a 2019 scientific article 
:

In Productive Failure, the conventional instruction process is reversed so that learners attempt to solve challenging problems ahead of receiving explicit instruction. While students often fail to produce satisfactory solutions (hence “Failure”), these attempts help learners encode key features and learn better from subsequent instruction (hence “Productive”).

In other words: if you struggle with a problem, give up, and then watch the solution video, you're much more likely to fully understand and remember things. This is how we build lasting, generalized skills!

Of course, it can be demoralizing to struggle. It can trigger our impostor syndrome, make us doubt ourselves. But this is the wrong interpretation! All it means is that you're being challenged, that you're attempting problems that are beyond your current reach. And that's the most effective way to learn! Struggling doesn't mean that you're incapable, it means that you're growing!

When I worked at Khan Academy, we spoke a lot about having a “growth mindset”. A growth mindset is the belief that our brains are elastic, that we become smarter through practice, and that failure is the fastest way to learn. This mindset is a superpower for developers. Personally, it's had a huge impact in my own development, my own career.

So, this course is designed to be challenging, especially for beginners. It won't be all struggle — I want us to have fun, after all! But occasionally, the exercises and projects will push you to go beyond what we've learned in the lessons.

You can learn more about cultivating a growth mindset in this talk from Carol Dweck, presented at Google: “Mindset: The New Psychology of Success” 
.

This course is for you
(success)

I remember taking exams in high school. Teachers would circulate between the desks, looming above us, making sure we weren't trying to cheat.

This course is not like that. I'm not an authoritarian taskmaster. This is your course, and you should use it however you like.

If you'd prefer, you can watch the solution videos first, and then try to reconstruct the solution. Or, you can code alongside the video. There is no wrong approach.

It might not be as effective as the “productive failure” stuff I talked about, but it's a heck of a lot more effective than saying screw this and giving up!


Understanding JSX

---

## Understanding JSX

Understanding JSX

In the last lesson, we saw how to create a React element using plain, everyday JavaScript.

In reality, very few developers create elements this way. It's much more common to use a specialized syntax called JSX.

Here's that same example, but using JSX instead of JavaScript:

Code Playground
(Restored)

Reset Code
Hide line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.js
index.html
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
import React from 'react';
import { createRoot } from 'react-dom/client';

//// Old way:
// const element = React.createElement(
//   'p',
//   {
//     id: 'hello',
//   },
//   'Hello World!'
// );

// New way:
const element = (
  <p id="hello">
    Hello World!
  </p>
jjj);

const container = document.querySelector('#root');
const root = createRoot(container);
root.render(element);
Result
Console
Refresh results pane

Instead of writing React.createElement, we use an HTML-like syntax to create React elements.

Why do we use JSX? It might not be obvious from this tiny example, but as our chunk of markup grows, it becomes increasingly clear that JSX is just easier to read.

Remember how I mentioned that React elements can form a tree structure, just like HTML elements? This happens when we set the “children” parameter of a React element to another React element.

In practice, we often wind up with pretty significant tree structures in our React code. Here's an example, using plain JavaScript:

const element = React.createElement(
  "nav",
  { id: "main-nav" },
  React.createElement(
    "ul",
    null,
    React.createElement(
      "li",
      null,
      React.createElement(
        "a",
        { href: "/" },
        "Home"
      )
    ),
    React.createElement(
      "li",
      null,
      React.createElement(
        "a",
        { href: "/archives" },
        "Archives"
      )
    )
  )
);

Pretty hard to read, right? Here's that same example in JSX:

// In JSX:
const element = (
  <nav id="main-nav">
    <ul>
      <li>
        <a href="/">
          Home
        </a>
      </li>
      <li>
        <a href="/archives">
          Archives
        </a>
      </li>
    </ul>
  </nav>
);

For whatever reason, HTML-like syntax is easier for our brains to process. It's nicer to read, and it's nicer to write.

Why the parentheses?
(info)

In the example above, we wrap the JSX in parentheses, like this:

const element = (
  <nav id="main-nav">
    <ul>
      (List items removed, for brevity)
    </ul>
  </nav>
);

This is done purely for formatting purposes. It allows us to push the JSX onto the next line.

 Show more
Compiling JSX into JavaScript

If we try to run this JSX code in the browser, we'll get an error. JavaScript engines don't understand JSX, they only understand JavaScript. And so we need to "compile" our code into plain JS.

This is most commonly done as part of a build step, using a tool like Babel; we'll talk much more about this later in the course.

Here's the important thing to understand for now: The JSX we write gets converted into React.createElement. By the time our code is running in the user's browser, all of the JSX has been zapped out, and we're left with a JS file full of nested React.createElement calls.

“transpiled” vs. “compiled”
(info)

The process of converting JSX into browser-friendly JS is sometimes referred to as “transpiling” instead of “compiling”. Are these terms synonyms, or is there a difference?

There is a difference, but in my opinion, that difference doesn't really matter. You can treat them as synonyms. In this course, I'll be using "compiling" exclusively.

If you're curious, you can read more about the distinction here:

 Show more

File extensions and JSX
(warning)

In the playground above, the file is named index.js. Several students have asked: shouldn't the file be named index.jsx, since it's not a “pure” JS file?

To provide a bit of context: in the early days of React, any file that included JSX had to use the .jsx file extension. This was how we told the compiler: “Hey! This file has some JSX in it, and needs to be compiled to JS.”

This turned out to be a bit annoying. It was one more thing to think about, one more bit of friction in the development process. Having to rename a file whenever we add/remove JSX is a bit of a pain!

And so, the rules were loosened. These days, we can include JSX in a .js file, and everything will work perfectly
*
. Compilers assume that any .js file can contain JSX.

Now, some developers prefer to continue using the .jsx extension, to make it clear which files actually contain JSX. And you're absolutely welcome to do this, if you'd like! Either approach is just fine. 👍

Skipping the React import?

Let's look again at this code snippet:

import React from 'react';
import { createRoot } from 'react-dom/client';

const element = (
  <p id="hello">
    Hello World!
  </p>
);

const container = document.querySelector('#root');
const root = createRoot(container);
root.render(element);

On the very first line, we're importing React, but we aren't actually using it anywhere… Are we? Can we omit it?

In fact, we are using the React import! Let's unpack what's going on here.

After we compile away the JSX, we're left with the following code:

import React from 'react';
import { createRoot } from 'react-dom/client';

const element = React.createElement(
  'p',
  { id: 'hello' },
  'Hello World!'
);

const container = document.querySelector('#root');
const root = createRoot(container);
root.render(element);

When the JSX is compiled into plain JS, the dependency makes itself clear. That <p> tag becomes a React.createElement call! It's obfuscated? by the JSX.

In earlier versions of React, you'd get an error if you forgot to include the React import:

Error: React is not defined

This error message produced a lot of confusion for beginners. Most tutorials gloss over how JSX actually works. And so, if you don't understand that <p> becomes React.createElement('p'), you won't have any idea what this error message is about, or how to fix it. 😬

This was such a common stumbling block for beginners that the React team decided to spend some time seeing how they could improve things. And they came up with a pretty clever solution!

With React 17, the React team introduced a new “JSX transformer”, used by Babel and other compilers. Essentially, it automatically injects the import during the build process.

For example, let's suppose we had this code:

const element = (
  <p id="hello">
    Hello World!
  </p>
);

Using the modern JSX transformer, it will get compiled to:

import { jsx as _jsx } from 'react/jsx-runtime';

const element = _jsx(
  'p',
  { id: 'hello' },
  'Hello World!'
);

Note that our original code didn't include that import statement. It was included automatically by the compiler.

_jsx is a fancy optimized version of React.createElement. It includes some shortcuts when we use certain React features like Fragments or Portals. Otherwise, it does the exact same thing as React.createElement: it creates a React element.

And so, these days, we don't have to import React. The JSX compiler will solve this problem for us.

Personally, though, I continue to import React whenever I work with JSX. It's partially that old habits are hard to break, and partially that we still do need to import React in order to use many React features, like hooks (covered in depth in Module 2 and Module 3). By always importing React, I know that it'll be there whenever I need it.


Expression Slots

---

## Expression Slots

Expression Slots

Video Summary

For more information about the difference between statements and expressions, check out the “Statements Vs. Expressions” lesson 👀 from the JavaScript Primer module.

Here's the sandbox from the video above:

Code Playground

Reset Code
Hide line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
import React from 'react';
import { createRoot } from 'react-dom/client';

const shoppingList = ['apple', 'banana', 'carrot'];

// This code...
const element = (
  <div>
    Items left to purchase: {shoppingList.length}
  </div>
);

// ...is equivalent to this code:
const compiledElement = React.createElement(
  'div',
  {},
  'Items left to purchase: ',
  shoppingList.length
);

const container = document.querySelector('#root');
const root = createRoot(container);
root.render(element);
Result
Console
Refresh results pane
Comments in JSX

To add a comment in JSX, we use an expression slot:

const element = (
  <div>
    {/* Some comment! */}
  </div>
);

We specifically need to use the multi-line comment syntax (/* */) instead of the single-line syntax (//). This is because the single-line syntax comments everything out, including the closing } for the expression slot!

Attribute expression slots

We can use the same trick for dynamic attribute values!

Here's an example:

const uniqueId = 'content-wrapper';

const element = (
  <main id={uniqueId}>
    Hello World
  </main>
);

As we saw above, the squiggly brackets ({}) allow us to create an expression slot. This time, we're creating a slot for the value of the id attribute.

Here's how it compiles:

const element = React.createElement(
  'main',
  {
    id: uniqueId,
  },
  'Hello World'
);

For comparison, here's what it looks like without an expression slot, when the value for id is fixed:

const element = (
  <main id="content-wrapper">
    Hello World
  </main>
);

const compiledElement = React.createElement(
  'main',
  {
    id: "content-wrapper",
  },
  'Hello World'
);

We can use attribute expression slots whenever we need the values to be dynamic. We can put any valid JavaScript expression in here, not just variables:

const userEmail = 'sumeet@thegreat.com';

const element = (
  <main id={userEmail.replace('@', '-')}>
    Hello World
  </main>
);

// Will get compiled as:
const compiledElement = React.createElement(
  'main',
  {
    id: userEmail.replace('@', '-'),
  },
  'Hello World'
);

Note that when we compile the code, it doesn't actually get evaluated. We've written some logic which will turn that userEmail string into "sumeet-thegreat.com", replacing the @ character with a -, but that only happens when we run the code.

When JSX gets compiled to JS, we copy over everything between the { and }. We don't call any functions or run any of the logic. That happens later, when the processed JavaScript runs in the browser.

This is the distinction between compile-time (the code processing that happens before the code runs in the browser) and run-time (the code execution that happens in the browser).

Type coercion

At run-time, React will automatically convert types as needed when supplying attributes in expression slots.

For example, these two elements are identical:

// This works:
<input required="true" />

// And so does this!
<input required={true} />

In the first example, we're setting the required attribute equal to the string "true". In the second example, it's equal to the boolean attribute true. In HTML, values must be strings, and so the boolean true is converted to the string "true".

Similarly, we can pass either numbers or strings for numeric attributes:

// ✅ Valid
<input type="range" min="1" max="20" />
// ✅ Valid
<input type="range" min={1} max={20} />

Boolean attributes
(info)

In HTML, it's possible to set attributes to true by specifying only the key, like this:

<input required>

This same pattern has been implemented in JSX; these two elements are equivalent:

<input required />
<input required={true} />

Honestly, though, I don't recommend doing this. I prefer to spell it out, and write required={true}.

 Show more

Differences from HTML

---

## Differences from HTML

Differences from HTML

JSX looks like HTML, but there are some fundamental differences. In this lesson, we'll dig into those differences.

Note: Please don't feel like you have to memorize all these rules right now! Fortunately, React is pretty good about guiding us in the right direction when we make these mistakes. If you keep an eye on the developer console, you don't need to memorize these rules.

Test your knowledge!
(info)

Think you've already got a pretty good understanding on the differences between HTML and JSX?

You can jump to the next lesson, which is a mini-game that tests your knowledge on this subject. If you ace the game, you can skip this lesson!

Fix the Converter
Reserved words

JavaScript has a couple dozen 
 "reserved words". Reserved words are keywords with built-in functionality. Because they do something already, we can't use them in our JSX.

For example:

const while = 10;

If we run this code, we'll get a syntax error, because while is a reserved word. It's used for “while loops” like this:

let count = 5;

while (count > 0) {
  console.log('Countdown:', count);
  count -= 1;
}

Because JSX gets transformed into JS, we can't use any reserved words in our JSX. And this is a problem, because HTML attributes sometimes overlap with JavaScript reserved words.

Consider this JSX:

const element = (
  <div>
    <label for="name">
      Name:
    </label>
    <input
      id="name"
      class="fun-input"
    />
  </div>
);

If we compile this into JavaScript, we'll discover that we're using two reserved words:

for
class

To work around this conflict, React uses slight variations on these two terms:

const element = (
  <div>
    <label htmlFor="name">
      Name:
    </label>
    <input
      id="name"
      className="fun-input"
    />
  </div>
);

Specifically:

for is changed to htmlFor
class is changed to className

It's a bummer that we need to do this mental conversion, but it doesn't take too long to adjust!

It seems to work, though…
(info)

If you actually try and use for and class in your JSX, you'll get a friendly warning from the React framework, but you won't get any errors. In fact, everything seems to work just fine!

The truth is that in this specific situation, there isn't any conflict with reserved words. But in other situations, you can run into big problems. To stay safe, you should never use for or class in your JSX.

 Show more
Self-closing tags

HTML is a pretty loosey-goosey language. For example, this is perfectly valid HTML:

<div>
  <p>This paragraph is opened… but never closed.
  <p>We're omitting the closing tags!
</div>

Paragraph tags can't be nested. The browser is smart enough to figure out that the first paragraph must end before the second paragraph starts, and it will automatically insert the </p> for you, similar to how the JavaScript engine can insert missing semi-colons for you.

JSX is a bit of a wet blanket. We absolutely need to close every tag we open:

const element = (
  <div>
    <p>These paragraphs are valid.</p>
    <p>They include the closing tags.</p>
  </div>
);

In HTML5, certain elements don't have closing tags. For example, the img tag can't have children, and so it doesn't need to be closed:

<img
  alt="A friendly kitten"
  src="/images/kitten.jpg"
>

Our JSX compiler won't like this one bit. We need to explicitly close this tag. We can do this with a "self-closing" tag:

const element = (
  <img
    alt="A friendly kitten"
    src="/images/kitten.jpg"
  />
);

(This self-closing syntax, <img />, comes from earlier versions of HTML. It isn't necessary in modern HTML, but it's still valid, and many developers continue to use it out of habit.)

Case-sensitive tags

HTML is a case-insensitive language. In fact, it was common many years ago for HTML to be written in all-uppercase:

<MAIN>
  <HEADER>
    <H1>Hello World!</H1>
  </HEADER>
  <P>
    This HTML is so loud!
  </P>
</MAIN>

JSX, by contrast, is case-sensitive. Our tags must all be lowercase:

const element = (
  <main>
    <header>
      <h1>Hello World!</h1>
    </header>
    <p>
      This HTML is so loud!
    </p>
  </main>
);

This restriction might seem arbitrary, but there's a very good reason for it: the JSX compiler uses the tag's case to tell whether it's a "primitive" (part of the DOM) or a custom component. We'll learn more about this when we learn about components.

Case-sensitive attributes

In JSX, our attributes need to be “camelCase”?.

For example, this is valid HTML:

<video
  src="/videos/cat-skateboarding.mp4"
  autoplay="true"
>

In JSX, we need to capitalize the “p” in “autoplay”, since “auto” and “play” are distinct words:

const element = (
  <video
    src="/videos/cat-skateboarding.mp4"
    autoPlay={true}
    //  ^ Capital “P”
  />
);

(I've also switched to use an expression slot, {true}, instead of keeping it as a string. This is slightly more idiomatic in React, although both options will work.)

It can be hard to tell whether an attribute contains multiple words or not, especially if English isn't your first language! Fortunately, you'll get a helpful warning in the developer tools if you make a mistake.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Preview
Refresh results pane
Console
Clear Console

Other properties that need to be "camelCased" include:

onclick → onClick
tabindex → tabIndex
stroke-dasharray → strokeDasharray (this one is specific for SVGs)

Data and ARIA attributes keep their dashes
(warning)

There are two exceptions to the "camelCasing" of attributes: data attributes and ARIA attributes.

For example, this is valid JSX:

const element = (
  <button
    data-test-id="close-dialog-button"
    aria-label="Close dialog"
  >
    <img alt="" src="/icons/x.svg" />
  </button>
);

Data attributes aren't used that often in React, but they can be helpful for labelling elements for automated testing. ARIA attributes are used by assistive technologies like screen readers to improve the accessibility of our applications.

Inline styles

In HTML, the style attribute allows us to apply some styles inline, to a specified element:

<h1 style="font-size: 2rem;">
  Hello World!
</h1>

In JSX, style instead takes an object:

const element = (
  <h1 style={{ fontSize: '2rem' }}>
    Hello World!
  </h1>
);

Double squiggly brackets??
(info)

It might seem weird that we need two sets of squiggly brackets. Why can't we write it like this?

const element = (
  <h1 style={ fontSize: '2rem' }>
    Hello World!
  </h1>
);
 Show more

All CSS properties are written in “camelCase”. Every dash is replaced by capitalizing the subsequent word:

background-position becomes backgroundPosition
border-bottom-color becomes borderBottomColor

For vendor prefixes like -webkit-font-smoothing, we capitalize the first letter as well: WebkitFontSmoothing.

Also, React will automatically apply the px suffix for certain CSS properties. For example:

<div
  style={{
    width: 200, // Equivalent to `width: 200px`
    paddingTop: 8, // Equivalent to `padding-top: 8px`
  }}
>

Watch out for properties that take a unitless value by default, like flex or lineHeight.

For example, this code will produce lines that are twenty times taller than default, not lines that are 20px tall:

<p
  style={{
    lineHeight: 20, // Equivalent to `line-height: 20`
  }}
>

While it's a common convention in React to use unitless values where possible, you can absolutely use full units if you prefer!

<p
  style={{
    width: '200px',
    paddingTop: '8px',
  }}
>

Are inline styles bad?
(info)

You might have heard that inline styles shouldn't be used. They're an escape hatch, like !important, and should only be used as a last resort in specialized circumstances.

Personally, I agree that we shouldn't use inline styles as our primary method of styling, but I think there are lots of cases where inline styles are the way to go. This is especially true with modern CSS and CSS variables.

While it's not really a focus of this course, we'll see some examples that showcase how CSS variables can be used with React, to tremendous effect.


Fix The Converter

---

## Fix The Converter

Fix the Converter

MINIGAME


Control Scheme

Click and Hunt. Poke around with your mouse, trackpad, or finger. Recommended for most people.
Multiple Choice. Select from a set of possible listed issues. Recommended for people who navigate by keyboard.
Start Game

The Whitespace Gotcha

---

## The Whitespace Gotcha

The Whitespace Gotcha

Let's talk about one of the most common "gotchas" with JSX.

Here's a quick example:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import { createRoot } from 'react-dom/client';

const daysUntilSantaReturns = 123;

const element = (
  <div>
    <strong>
      Days until Santa returns:
    </strong>
    {' '}
    {daysUntilSantaReturns}
  </div>
);

const container = document.querySelector('#root');
const root = createRoot(container);
root.render(element);
Result
Console
Refresh results pane

Notice how there's no space between the bold text and the number? Instead of returns: 123, it's showing as: returns:123.

To understand why this happens, let's consider how this JSX compiles to JavaScript:

const element = React.createElement(
  'div',
  {},
  React.createElement(
    'strong',
    {},
    'Days until Santa returns:'
  ),
  daysUntilSantaReturns
);

Our <div> has two children, the <strong> tag and the daysUntilSantaReturns variable.

Remember, JSX doesn't compile to HTML, it compiles to JavaScript. And when that JavaScript is executed, it's only going to create and append two HTML nodes:

A <strong> tag with some text.
A text node, for the number 123.

So how do we fix it? The most common solution is to add a single whitespace character, in curly braces:

<div>
  <strong>Days until Santa returns:</strong>
  {' '}
  {daysUntilSantaReturns}
</div>

Here's how this compiles:

const element = React.createElement(
  'div',
  {},
  React.createElement(
    'strong',
    {},
    'Days until Santa returns:'
  ),
  ' ',
  daysUntilSantaReturns
);

I'll admit, when I first learned this trick, I thought it was really hacky. I wished that the React team would fix this bug, and make it handle whitespace the same way that HTML does.

I've come to realize, though, that this behavior is actually more of a feature than a bug.

Let's talk about it.

Video Summary

Here's the 3-images playground from the video:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Letting Prettier format
(info)

Over the past few years, a formatting tool called Prettier has taken the JavaScript community by storm.

Prettier is a tool that will automatically format our code for us. It's opinionated, and follows conventions used by the majority of JavaScript developers.

Here's the good news: Prettier knows about this whitespace gotcha, and will automatically add the {' '} whitespace character for us when it's necessary.

On this course platform, I've integrated Prettier into the code playgrounds. You can trigger it by clicking the 
Format code using Prettier
 icon, or by using the “Save” keyboard shortcut.

Later in this course, we'll learn how to use Prettier in our own projects. You can check it out now 👀 if you're curious!


Exercises

---

## JSX Exercises

Exercises
Search Form

In this exercise, we'll build an inline search form:

Below, you'll find the raw HTML code that produces the UI we want. Your job is to convert it to JSX, so that it can be used in React.

Acceptance Criteria:

The UI should match the screenshot above.
No errors should be shown in the Result pane.
No warnings should be logged in the Console pane.
Note: the console isn't cleared automatically when the warnings are fixed. You can refresh the Preview pane with the  icon.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.js
index.html
import React from 'react';
import { createRoot } from 'react-dom/client';

const element = (
  <form>
    <label htmlFor="searchInput">Search:</label>
    <input id="searchInput" />
    <button aria-label="Submit" className="submit-btn">
      <img
        alt=""
        src="https://sandpack-bundler.vercel.app/img/arrow-right.svg"
      />
    </button>
  </form>
);

/*
Here's the raw HTML:

<form>
  <label for="search-input">Search:</label>
  <input id="search-input">
  <button aria-label="Submit" class="submit-btn">
    <img
      alt=""
      src="https://sandpack-bundler.vercel.app/img/arrow-right.svg"
    >
  </button>
</form>
*/

const container = document.querySelector('#root');
const root = createRoot(container);
root.render(element);
Preview
Refresh results pane
Console
Clear Console

Solution:

Solution code
(success)

 Show more
Critter

Let's build a Twitter/Animal-Crossing hybrid! A social network for animals called Critter.

Specifically, we'll be implementing the following UI:

To help, you've been given two things:

A message object, containing all the data you'll need to populate the UI
A chunk of HTML, which needs to be converted to JSX, so it can be rendered by React.

Acceptance Criteria:

The UI should match the mockup, using the data from the message object
The data should be referenced using expression slots. Instead of copy/pasting the data into the JSX, we should access it from the message object, like message.content.
The user's name should be a link, and it should link to /users/[handle]. With this particular data, it should be /users/benjaminthorn.
There is no actual "profile page", and so the link won't resolve to anything. That's alright.
The avatar image should use the author's avatarDescription for the alt text.
For the timestamp in the footer, use the provided formatDate function. Pass in the message.published to get a nicely-formatted timestamp.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.js
date-helpers.js
Preview
Refresh results pane
Console
Clear Console

Solution:

This solution uses string interpolation with template strings. Check out the JS Primer lesson on string interpolation 👀 if you're not familiar with this syntax.

Solution code
(success)

 Show more

JSX vs. Templates

---

## JSX vs. Templates

JSX vs. Templates
(Optional lesson)

JSX is sometimes compared to template languages, like Handlebars or EJS or Pug. There's an important distinction between these two concepts, though. In this lesson, we're going to see how JSX is a bit of a different beast.

Optional lesson?
(warning)

Some lessons in this course will be marked as “optional”. These lessons are intended to offer a bit more depth for people especially curious, or to provide context to a specific subset of students.

In this case, this lesson is intended for developers who have worked with a template language, like Handlebars or Pug (formerly Jade). If you have experience with these sorts of languages, this lesson might help you contextualize what JSX is and how it's different.

Comparing JSX to template languages

For comparison, let's imagine we have a Handlebars template like this:

<div>
  {{#if user}}
    <h1>{{user.name}}</h1>
  {{/if}}
</div>

The Handlebars library includes a JavaScript function that takes a Handlebars template and some data, and produces an HTML string. For example, if there's a user by the name of Sujata, we'll wind up with the following string: "<div><h1>Sujata</h1></div>".

Template languages also generally have a custom DSL?, with special syntax and keywords. In the example above, #if is a built-in helper that will conditionally render some children. Another helper, #each, will iterate through an array.

Here's the important distinction: all of that dynamic / custom stuff happens when we compile the template.

With React, we're compiling JSX to JS. We aren't resolving any of the dynamic stuff yet.

We'll learn more about conditional rendering soon, but as a quick preview, here’s how we'd do the same thing in JSX:

<div>
  {user && <h1>{user.name}</h1>}
</div>

And here's what it compiles to:

React.createElement(
  'div',
  {},
  user && React.createElement(
    'h1',
    {},
    user.name
  )
);

Notice that our condition hasn't been resolved yet. We don't know if we have a user yet or not.

Template languages are their own special thing. They invent custom syntax like {{#if}}. In essence, you have to learn an entirely separate language, learn its subtle differences from JavaScript.

JSX is actually a very thin layer of abstraction. It isn't an entirely separate language. We use plain ol’ JavaScript to manage conditionals and iteration. And this means you only need to understand one language, JavaScript, to use it effectively.

It took me a while to wrap my head around this distinction. Here's another way to put it:

Template languages turn the markup you write into HTML. This means they need to invent a custom mini-language to do dynamic things, since HTML doesn't have these things built-in.
JSX turns the markup you write into JavaScript. It "forwards along" any logic you include, without resolving it.

Personally, I prefer the JSX approach. I like only having to understand 1 language.

Another benefit: we have the full power of JavaScript available as we write our markup! Template languages tend to be pretty narrow in their scope, and so they won't let you do things like filter an array to only select certain items. Instead of being limited to a small number of helpers like {{#each}}, we have all of the JS methods available to us, like .filter, .slice, and .reduce.


Components

---

## Components

Components

Components are a huge part of React. If you only know one thing about React, you probably know that it is a component-based framework.

What is a component, exactly? Here's how I like to define them: a component is a bundle of markup, styles, and logic that controls everything about a specific part of the user interface.

It's a different mental model when it comes to code organization. Instead of separating our application into markup (written in HTML), styles (written in CSS), and logic (written in JS), we organize our application into components.

There's a lovely graphic that I think illustrates this really well:

Credit for this wonderful image goes to Cristiano Rastelli 
.

Mechanisms of reuse

Traditional HTML doesn't really have a way to reuse chunks of markup. Many languages will use partials to achieve this. A partial is a chunk of HTML that can be inserted into another HTML document.

In CSS, the main mechanism we have for reuse is the class. For example, we might create a standard “button” style, under the btn class:

.btn {
  padding: 8px 32px;
  background: blue;
  border: none;
  font-size: 1rem;
}

Whenever we want to apply this set of styles to an HTML element, we can pop the btn class onto it.

And for JavaScript, the mechanism of reuse is the function. Maybe we have a function to process data in some way:

function shout(sentence) {
  return sentence.toUpperCase() + '!!';
}

shout("we're off to see the wizard")
// -> "WE'RE OFF TO SEE THE WIZARD!!"

With React, components are the main mechanism of reuse. Instead of partials for HTML, classes for CSS, and functions for JavaScript, we create a component that bundles up all 3, and allows us to create a library of high-level reusable UI elements.

This idea is really very powerful. It takes a while to get accustomed to thinking in components, but once you do, you'll never want to work on a project without them.

(Modern React also features hooks, which offers a way to reuse React logic! We'll learn all about them in the modules ahead.)


Thinking in Components

---

## Thinking in Components

Thinking in Components

ACTIVITY

Before we get to the nitty-gritty technical stuff, let's get some practice thinking in terms of components!

In this activity, you'll be shown a screenshot of a design, and asked to draw boxes around the elements that you think should be a component.

After each exercise, I'll share my own approach, but this shouldn't be treated as a solution! There's no right/wrong answers with this stuff. Our goal today is to start asking the right questions. We'll learn how to answer those questions throughout the course.

Have fun!

Start Drawing!

Basic Syntax

---

## Basic Syntax

Basic Syntax

Alright, enough high-level ideas. Let's look at some code!

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';
import { createRoot } from 'react-dom/client';

function FriendlyGreeting(dick) {
  return (
    <p
      style={{
        fontSiLze: '1.25rem',
        textAlign: 'center',
        color: 'sienna',
      }}
    >
      Greetings, {dick.name}!
    </p>
  );
}

const container = document.querySelector('#root');
const root = createRoot(container);
root.render(<FriendlyGreeting name="galin"/>);
Result
Console
Refresh results pane

In React, components are defined as JavaScript functions. They can also be defined using the class keyword, though this is considered a legacy alternative that isn't recommended in modern React applications.

Typically, React components return one or more React elements.

This component, FriendlyGreeting, creates a React element that describes a paragraph, with some built-in styles. For simplicity, we're using inline styles here; we'll talk more about React's rich styling ecosystem in an upcoming lesson.

We render a component the same way we render an HTML tag. Instead of rendering a <div> or an <h1>, we render a <FriendlyGreeting>.

Arrow functions vs traditional functions
(info)

Modern JavaScript supports two different syntaxes for writing functions. In addition to the traditional way, using the function keyword, you can also use “arrow functions”. If you're not familiar with arrow functions, check out the JavaScript primer lesson “Arrow Functions” 👀.

Which sort of function should we use when defining React components? The short answer: it doesn't matter. They both work exactly the same way.

 Show more
The big component rule

There aren't a ton of rules when it comes to creating components, but there's an iron-clad one: React components need to start with a Capital Letter. This is how the JSX compiler can tell whether we're trying to render a built-in HTML tag, or a custom React component.

For example, here are two JSX elements:

const heading = <h1>Hello!</h1>
const greeting = <FriendlyGreeting />

…And here are those same elements, compiled into JavaScript:

const heading = React.createElement('h1', null, 'Hello!');
const greeting = React.createElement(FriendlyGreeting, null);

A React element is a description of a thing we want to create. In some cases, we want to create a DOM node, like an <h1> or a <p>. In other cases, we want to create a component instance.

The first argument that we pass to React.createElement is the “type” of the thing we want to create. For the first element, it's a string ("h1"). For the second element, it's a function! It's FriendlyGreeting, and not "FriendlyGreeting".

The convention is to use PascalCase? for all React component names, though technically it's only the first letter that truly matters. We could name it Friendlygreeting, but it's much more conventional to go with FriendlyGreeting.

Why is it based on the character casing?
(info)

At first glance, this whole rule feels a bit unnecessary. Surely, React can tell whether we're trying to render an HTML tag or a component?? There are only so many built-in HTML tags, right?

Sadly, things aren't quite as straightforward as they seem…

 Show more

Props

---

## Props

Props

So far, our FriendlyGreeting component is kinda cool, but it isn't terribly useful. Every time we render <FriendlyGreeting />, we get the exact same result. It isn't flexible at all!

Thankfully, components have a thing called props. Props are like arguments to a function: they allow us to pass data to our components, so that the components can include customizations based on the data.

When I taught React at a local coding bootcamp, props were a common stumbling block. It can take a while for the concept to “click”. If you feel discouraged for not getting it right away, please know that it's normal to feel that way, and you can always ask questions in our community Discord!

Alright, so let's suppose we want to tweak our greeting to take a person's name, so that we can greet them!

Video Summary

In the video, we use destructuring assignment to extract props from the function parameter. If you haven't seen this syntax before, it looks pretty wild. You can learn more about it in the Object Destructuring 👀 lesson from the JavaScript Primer reference module.

Here's the sandbox from the video:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane
Default values

Let's suppose we're working on our FriendlyGreeting component. We want to greet the user, but there's a problem: We don't know everyone's name.

I ran into this exact problem when I was building a tool to generate newsletter issues. I didn't know the name of every subscriber. If I didn't know their name, I wanted to render a “fallback” value:

// If I know their name:
Hey Josh!

// If not:
Hey there!

We could do this in React with the || operator, like this:

function FriendlyGreeting({ name }) {
  return (
    <p>
      Hey {name || 'there'}!
    </p>
  );
}

If name is provided, it'll be used. Otherwise, we'll fall back and use “there”.

This method works, but there's an even better way to do this in React. We can specify default values for each prop:

function FriendlyGreeting({ name = 'there' }) {
  return (
    <p>
      Hey {name}
    </p>
  );
}

There are a couple of benefits to this approach:

If we have multiple props with default values, we can see all of the defaults in the same place, rather than having them sprinkled around the component
The default value is “locked in”. We don't have to remember to add the fallback check everywhere we reference the name prop.
The || operator will occasionally surprise us by using the default value even when we've supplied a value! This can happen when the supplied value is falsy 👀.

As a result, it's become a well-established convention to specify default values within the prop object.

Here's another example. We have a decorative “HorizontalRule” component, essentially a way to draw a line between sections. It has a default width of 100px, but we can override that value:

function HorizontalRule({ size = '100px' }) {
  return (
    <div style={{ width: size }}>
      {/* Line-drawing stuff here */}
    </div>
  );
}

<HorizontalRule size="250px" /> // Will be "250px"
<HorizontalRule />              // Will be "100px"

Nullish Coalescing operator
(info)

Another option for setting fallback values is with the Nullish Coalescing operator 
:

function FriendlyGreeting({ name }) {
  return (
    <p>
      Hey {name ?? 'there'}!
    </p>
  );
}

If you haven't seen this curious fella, it's very similar to ||, but it only guards against nullish values (null and undefined). It means we don't have to worry about “surprising” falsy values like 0.

Ultimately, though, I prefer to use the “default values” approach when it comes to React props. I like being able to see the fallback values all in 1 place, and to make sure that the same fallback value is being used consistently, whenever the prop is referenced.

You can learn more about this operator on my JavaScript Operator Lookup tool 
.

“defaultProps” property
(warning)

In older versions of React, we had an explicit defaultProps property we could apply to components. Frustratingly, if you google “React default props”, you'll discover outdated resources teaching this antiquated method.

Rest assured, you don't need to use defaultProps anymore! The recommended approach is to use the destructuring assignment shown in this lesson.


The Children Prop

---

## The Children Prop

The Children Prop

Let's suppose that we're building a custom button component. It should look and act just like a regular HTML button, but it should have a red background and white text.

We could write it like this:

function RedButton({ contents }) {
  return (
    <button
      style={{
        color: 'white',
        backgroundColor: 'red',
      }}
    >
      {contents}
    </button>
  );
}

…And then we'd use it like this:

root.render(
  <RedButton contents="Don't click me" />
);

This works… but it feels a bit funny, doesn't it? It's quite different from how we use a typical HTML button, where the content goes in-between the open and close tags:

<button>
  Don't click me
</button>

As a nice bit of syntactic sugar?, React lets us do the same thing with our custom components:

root.render(
  <RedButton>
    Don't click me
  </RedButton>
);

When we do this, we can access the children through the children prop:

function RedButton({ children }) {
  return (
    <button
      style={{
        color: 'white',
        backgroundColor: 'red',
      }}
    >
      {children}
    </button>
  );
}

This is a quality-of-life thing that React does for us. When we pass something between the open and close tags, React will automatically supply that value to us under children.

We can see this when we examine the React element produced:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Console
Clear Console
Refresh results pane

children is a special value, a “reserved word” when it comes to props.

But it's not that special. I think a lot of newcomers to React think that children is somehow distinct or different from other props. In fact, it's exactly the same.

If we wanted to, we could pass children in the "traditional" way. It's clunky, but the outcome is the same:

// This element:
<div children="Hello world!" />

// …is equivalent to this one:
<div>
  Hello world!
</div>

And so, we're given a special bit of syntax, to make JSX feel more like HTML, but fundamentally, the children prop is the same as any other prop. There's nothing special or magical about it.

What if both?
(info)

What happens if we pass both forms of the children prop?

Well, let's give it a shot:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

It appears that React chooses to prioritize the children passed in-between the open/close tags. This seems like the right call to me, since that's the more-conventional way to set an element's children.

To understand what’s going on here, let’s consider what the compiled JavaScript code would look like in this case:

const element = React.createElement(
  'div',
  {
    children: 'As an attribute',
  },
  'Between the brackets',
);

The createElement function receives both sets of children, and React decides to prioritize the between-the-brackets one. Discord user Theo found the specific point 
 in React’s source code where this decision is made.


Exercises

---

## Component Exercises

Exercises
Extract components

Let's practice creating components! In the exercises below, you'll be given a chunk of JSX, and your mission is to refactor the code so that it uses a component.

Building a CRM

Let's suppose we're building CRM? software.

We've written the markup to display the contact information for 3 contacts, but there's an awful lot of repetition involved. Let's create a new component, ContactCard, and use that component for each of the 3 contacts.

Acceptance Criteria:

A brand-new ContactCard component should be created and used for each of the 3 contact cards
Props should be created for any bits of information that vary from card to card.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.js
App.js
import React from 'react';

function ContactCard({
  children,
  job = 'Jobless',
  email = 'No email',
}) {
  return (
    <li className="contact-card">
      <h2>{children}</h2>
      <dl>
        <dt>Job</dt>
        <dd>{job}</dd>
        <dt>Email</dt>
        <dd>{email}</dd>
      </dl>
    </li>
  );
}

function App() {
  return (
    <ul>
      <ContactCard
        job="Electric Engineer"
        email="josh@acme.co"
      >
        {' '}
        Josh{' '}
      </ContactCard>
      <ContactCard job="Bakery Shop" email="josh@acme.co">
        {' '}
        Brolin{' '}
      </ContactCard>
      <ContactCard
        job="Software Engineer"
Result
Console
Refresh results pane

What the dl?
(info)

The <dl> HTML tag is fairly obscure, but a super worthwhile tag!

It stands for “Description List”, and it's intended to be used to display key/value pairs. For example, many e-commerce platforms will display product details in this format:

Learn more about this tag on MDN 

Solution:

In this video, we mention that there are ways to dynamically change the rendered tag. This is known as “polymorphism”, and we learn all about it in Module 4.

Solution code
(success)

 Show more
Creating a “Button” component

Below, we have two <button> elements. Create a Button component, and use it to render both buttons.

Acceptance Criteria:

A brand-new Button component should be created and used for both buttons
Each Button instance should be able to set its own text content, as well as choose a text/border color. It's up to you to decide how you want to structure this!

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Solution:

Different colors?
(warning)

The original version of this exercise featured a green “Confirm” button. Regrettably, this meant that most color-blind folks couldn't perceive the difference in color between these two buttons. And so, I changed the “Confirm” button, making it black.

The solution video below was filmed using the original version of this exercise, with a green “Confirm” button. Sorry for any confusion!

Solution code
(success)

 Show more

Weird syntax?
(info)

In the first version of this solution, we wind up with this code:

<button
  style={{
    border: '2px solid',
    color,
    borderColor,
  }}
>
  {children}
</button>

JS objects are typically given key/value pairs with a colon, like border: "2px solid". What the heck is going on with color and borderColor, though? Is this some weird JSX thing??

Actually, this is a bit of modern JS known as the “property value shorthand”. It's equivalent to this:

<button
  style={{
    border: '2px solid',
    color: color,
    borderColor: borderColor,
  }}
>
  {children}
</button>

To learn more, check out the “Property Value Shorthand” lesson 👀 in the JavaScript primer.


Application Structure

---

## Application Structure

Application Structure

No matter how big or small, most React applications will share a common structure.

Here's an example of this structure. Take a few moments to poke around and see how everything works:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.js
App.js
Header.js
import React from 'react';
import { createRoot } from 'react-dom/client';

import App from './components/App';

const root = createRoot(
  document.querySelector('#root')
);

root.render(<App />);
Result
Console
Refresh results pane

Let's break down these files.

Index

The root index.js file is typically the first bit of code which will be executed. It's responsible for rendering our React application, turning the React elements we write into live DOM nodes.

In general, there will only be 1 spot in the entire codebase that calls the createRoot and render methods from react-dom. While it's possible to have multiple application roots, this is generally only done when progressively migrating to React, from another framework or technology stack.

It's common to do "setup" tasks in this file as well. For example, this file is a good place to import global CSS files, or set up any error-logging services.

Because index.js is more of a setup file than an active part of the application, we don't typically want to render a bunch of JSX here. It would be weird to include headers and buttons and footers here; that stuff happens in the app, and we're still setting up the app here.

Aside from some provider components (discussed later in the course), this file generally only renders a single element: <App />.

App

It's common for our projects to have a component called App, short for “Application”.

This is the “home base” React component in our project, the component that is an ancestor to every other component. Pick a random component in a React app, and you should be able to trace its lineage to App.

This component will sometimes manage "core" layout stuff, like headers and footers. In smaller applications, like the "hello world" one shown here, we're rendering additional UI in this component, though we tend not to see as much of that as the application grows in size.

If you're using a routing solution like React Router, our top-level routes are often included in this file.

Every project is different, and there are no hard rules for how to structure this component. The important thing is that App should show developers how the application is structured. It's a home base for developers to check, to get acquainted with how things work.

Modules

We generally use the ES module system to split our application into multiple files.

If you're not familiar with this import/export syntax, you can learn more about it in the “JavaScript Modules” lesson 👀 from the JavaScript Primer reference module.

Going forward

I wanted to share this quick lesson on application structure because we'll be using it in many of the sandboxes in this course, going forward!

For example, you might see something like this:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
FancyButton.js
Result
Console
Refresh results pane

To keep things focused and minimal, we aren't showing the index.js, with the createRoot and render() calls. Whenever it's not shown, you can assume it's rendering the App component.

There will also be some minimal styles included "covertly" in some of the sandboxes. If you're curious about how certain styles work, you can always inspect them in the browser developer tools!


Fragments

---

## Fragments

Fragments

Let's suppose we want to wind up with the following HTML:

<h1>Welcome to my homepage!</h1>
<p>Don't forget to sign the guestbook!</p>

We copy/paste this HTML into our React application, turning it into JSX. We wind up getting an error though:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function App() {
  return (
    <>
      <h1>Welcome to my homepage!</h1>
      <p>Don't forget to sign the guestbook!</p>
    </>
  );
}
export default App;
Result
Console
Refresh results pane

The error message is telling us to use a “JSX fragment”, and we'll learn all about that shortly. But first, let's take a moment and think about it. Why does this produce an error?

Spend a couple minutes tinkering with the problem. Can you figure out why this is invalid?

Hint

JSX can obscure what's really going on here. Try converting the JSX to React.createElement function calls! It might help illustrate the problem.

After poking at the problem for a couple of minutes, watch this video for an explanation:

Video Summary

So, that's why this code is invalid. How can we fix it?

One option is to wrap both React elements in a div:

return (
  <div>
    <h1>Welcome to my homepage!</h1>
    <p>Don't forget to sign the guestbook!</p>
  </div>
);

If we examine the raw JS, we see that we're no longer returning multiple expressions:

return (
  React.createElement(
    'div',
    {},
    React.createElement('h1', {}, 'Welcome…'),
    React.createElement('p', {}, "Don't forget…"),
  );
);

So, this fixes the syntax error, but it's not really ideal. It pollutes the DOM with unnecessary elements. And it can even lead to accessibility and layout issues, like this:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

In this example, the list items are meant to be displayed in a single row, but the <div> breaks the Flexbox algorithm. It also produces invalid markup, which means that it might cause problems for folks who rely on assistive technologies like screen readers.

Fortunately, there's a better way. We can use fragments.

A fragment is a special React component that does not produce a DOM node. It looks like this:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

If we inspect the output in our developer tools, we see that our two HTML elements, <h1> and <p>, sit directly inside the container element (<div id="root">):

Fragments allow us to respect the rules of JavaScript without polluting the HTML. They're a great option!

Shorthand

React fragments can also be created using the following syntax:

return (
  <>
    <h1>Welcome to my homepage!</h1>
    <p>Don't forget to sign the guestbook!</p>
  </>
);

This shorthand syntax might seem a bit more magical / strange, but I kinda like it. It shows that it's an "empty" HTML tag.

Either way, the JSX will compile to the exact same JavaScript:

React.createElement(
  React.Fragment,
  {},
  /* Children here */
);

The React team included this special component specifically to allow us to return multiple elements from a component without polluting the DOM. It's a great tool!


Iteration

---

## Iteration

Iteration

In a recent exercise, “Building a CRM”, we extracted a ContactCard component and used it for our 3 contacts:

<ul>
  <ContactCard
    name="Sunita Kumar"
    job="Electrical Engineer"
    email="sunita.kumar@acme.co"
  />
  <ContactCard
    name="Henderson G. Sterling II"
    job="Receptionist"
    email="henderson-the-second@acme.co"
  />
  <ContactCard
    name="Aoi Kobayashi"
    job="President"
    email="kobayashi.aoi@acme.co"
  />
</ul>

This solution works, but there's a potential issue with it: we won't always have the data when we write the code.

If we're building CRM software, this data will be dynamic. Every user will have a separate set of contacts, and those contacts will change all the time. We can't hardcode 3 random contacts like this!

In React, we typically solve this problem by using iteration. We dynamically create these React elements by using raw, unadulterated JavaScript.

Let's see how.


Mapping Over Data

---

## Mapping Over Data

Mapping Over Data

Alright, so let's suppose that the data for our CRM is held in an array, like this:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
ContactCard.js
import ContactCard from './ContactCard';

const data = [
  {
    id: 'sunita-abc123',
    name: 'Sunita Kumar',
    job: 'Electrical Engineer',
    email: 'sunita.kumar@acme.co',
  },
  {
    id: 'henderson-def456',
    name: 'Henderson G. Sterling II',
    job: 'Receptionist',
    email: 'henderson-the-second@acme.co',
  },
  {
    id: 'aio-ghi789',
    name: 'Aoi Kobayashi',
    job: 'President',
    email: 'kobayashi.aoi@acme.co',
  },
];

function App() {
  return (
    <ul>
      {data.map((employee) => (
        <ContactCard
          key={employee.id}
          name={employee.name}
          job={employee.job}
          email={employee.email}
        />
      ))}
    </ul>
  );
Result
Console
Refresh results pane

We want to create a <ContactCard> element for each of the contacts in the data array, passing in their name/job/email.

In other frameworks like Vue and Angular, special syntax is provided for doing iteration. In React, however, we rely purely on JavaScript. There is no “React syntax” for doing this sort of iteration.

If you're feeling adventurous, spend a few minutes and see if you can figure out how to solve this problem! It's OK if you're not sure. Experiment, and see what happens! This is the best way to start building an intuition.

I'll share my approach below.

Hint

You can render an array inside the JSX, React will unpack it for you.

You can learn about some handy array methods in the “Array Iteration Methods” 👀 bonus lessons!

My approach

Video Summary

The JavaScript Primer bonus module has some relevant lessons for this approach:

Arrow Functions 👀
Array Iteration Methods 👀 (specifically the map method)

Solution code
(success)

 Show more

Parentheses vs. squigglies?
(warning)

There's a pretty common syntactical gotcha here. Consider the following code:

return (
  <ul>
    {data.map((contact) => {
      <ContactCard
        name={contact.name}
        job={contact.job}
        email={contact.email}
      />
    })}
  </ul>
);

Instead of using parentheses, ( and ), we're using squiggly brackets, { and }. It seems like a pretty innocuous change, but it causes big problems here: none of the contact cards will show up!

Here's what's going on: in order for the <ContactCard> elements to be rendered, they need to be returned from the .map() callback.

We can fix this by adding the return keyword:

return (
  <ul>
    {data.map((contact) => {
      return <ContactCard
        name={contact.name}
        job={contact.job}
        email={contact.email}
      />
    })}
  </ul>
);

This is the “long-form” way of writing arrow functions. The squiggly brackets give us the space to add 1 or more JavaScript statements. We need to use the return keyword, to control what gets returned.

There's also a “short-form” syntax for arrow functions. In this alternative format, we omit the squiggly brackets. We can only pass a single expression, and it gets returned automatically. The parentheses are added for formatting purposes.

We dig deeper into this in the “Arrow Functions” 👀 lesson in the JavaScript Primer.

JSX inside JS inside JSX

When iterating in React, it's not uncommon to wind up with structures like this:

<ul>
  {items.map(item => (
    <li>{item}</li>
  ))}
</ul>

On the second line, we use curly brackets to add some "vanilla JS" to our JSX. But then we're using JSX inside those curly brackets! Some developers are caught off guard by the fact that this is "legal".

The JSX compiler is able to resolve "nested" JSX calls without issue. The end result is something like this:

React.createElement(
  'ul',
  {},
  items.map(item => (
    React.createElement(
      'li',
      {},
      item
    )
  ))
);

Keys

---

## Keys

Keys

You may have noticed, in the previous lesson, that we get a console warning:

Warning: Each child in a list should have a unique "key" prop.

When we give React an array of elements, we also need to help React out by uniquely identifying each element.

Here's how we can fix this issue in our CRM application:

const data = [
  {
    id: 'sunita-abc123',
    name: 'Sunita Kumar',
    job: 'Electrical Engineer',
    email: 'sunita.kumar@acme.co',
  },
  // ✂️ Other contacts trimmed
];
function App() {
  return (
    <ul>
      {data.map(contact => (
        <ContactCard
          key={contact.id}
          name={contact.name}
          job={contact.job}
          email={contact.email}
        />
      ))}
    </ul>
  );
}

Conveniently, the contacts in our data array have a unique identifier, id. We set that string as the key, and the React warning goes away.

Here's the live sandbox, if you want to play with it for yourself:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
ContactCard.js
import ContactCard from './ContactCard';

const data = [
  {
    id: 'sunita-abc123',
    name: 'Sunita Kumar',
    job: 'Electrical Engineer',
    email: 'sunita.kumar@acme.co',
  },
  // ✂️ Other contacts trimmed
];

function App() {
  return (
    <ul>
      {data.map(contact => (
      	<ContactCard
          key={contact.id}
          name={contact.name}
          job={contact.job}
          email={contact.email}
        />
      ))}
    </ul>
  );
}

export default App;
Result
Console
Refresh results pane

The purpose of a key is to uniquely identify each React element.

Why are keys necessary?

One of my personal pet peeves when I'm learning something is when the instructor tells me what to do, but not why it's necessary or how it works.

It does seem kind of odd, right? Why does React need us to annotate each element with a unique key? Can't it figure this out on its own??

Let's talk about it.

Video Summary

Where does it go?

So, the previous video talked about keys at a very high level, in terms of their purpose and why they're necessary.

There's another little mystery with keys. This one is much lower-level.

Take a look at the following JSX:

const element = (
  <ContactCard
    key="sunita-abc123"
    name="Sunita Kumar"
    job="Electrical Engineer"
    email="sunita.kumar@acme.co"
  />
);

At first glance, it seems like we've given this component 4 props: key, name, job, and email.

But, if we add a console.log to this ContactCard component, we'll notice that something's missing:

function ContactCard({ key, name, job, email }) {
  console.log(key); // undefined
  console.log(name); // 'Sunita Kumar'
  console.log(job); // 'Electrical Engineer'
  console.log(email); // 'sunita.kumar@acme.co'

  return (
    <li className="contact-card">
      {/* ✂️ Removed for brevity */}
    </li>
  );
}

We've specified 4 props, but only 3 have come through! key has not been provided.

Here's the deal: there are a small number of “reserved words” in React. key is one of these special terms. When we apply a key to a React element, we're not actually setting it as a prop.

Let's dig into this. First, let's take a look at this in plain JavaScript, no JSX:

const element = React.createElement(
  ContactCard,
  {
    key: 'sunita-abc123',
    name: 'Sunita Kumar',
    job: 'Electrical Engineer',
    email: 'sunita.kumar@acme.co',
  }
);

Hmmm… So far, key still looks like a prop. Let's keep going.

This code shows that we're calling the React.createElement function. As the name implies, this function creates a React element. If we were to execute this code, we'd be left with something like this:

const element = {
  type: ContactCard,
  key: 'sunita-abc123',
  props: {
    name: 'Sunita Kumar',
    job: 'Electrical Engineer',
    email: 'sunita.kumar@acme.co',
  }
}

Ah-ha! The React.createElement() function has taken our data and used it to produce a React element, and that element has key as a top-level property!

As we saw in the “Build Your Own React” lesson, React elements are JavaScript objects that describe a thing that React needs to create. In this case, the element describes a ContactCard component that needs to be rendered.

Keys identify a particular React element. It's a property of the element itself, not something that needs to be passed along to the component!

We're getting into some pretty advanced territory here. The relationship between elements and components is something we'll be revisiting throughout the course, and I don't want to get too far ahead of myself.

For now, the important thing to understand is this: key looks like a prop, but it's a special thing that React uses to identify React elements.

Key rules

Let's look at some of the rules that govern how keys should be used.

Top-level element

In order to satisfy this requirement, the key needs to be applied to the very top-level element within the .map() call.

For example, this is incorrect:

function NavigationLinks({ links }) {
  return (
    <ul>
      {links.map(item => (
        <li>
          <a
            key={item.id}
            href={item.href}
          >
            {item.text}
          </a>
        </li>
      ))}
    </ul>
  );
}

From React's perspective, it has a group of <li> React elements, and it doesn't see any unique identifiers on them. It doesn't "dig in" and look for keys on children elements.

Here's how to fix it:

function NavigationLinks({ links }) {
  return (
    <ul>
      {links.map(item => (
        <li key={item.id}>
          <a href={item.href}>
            {item.text}
          </a>
        </li>
      ))}
    </ul>
  );
}

When using fragments, it's sometimes required to switch to the long-form React.Fragment, so that we can apply the key:

// 🚫 Missing key:
function Thing({ data }) {
  return (
    data.map(item => (
      <>
        <p>{item.content}</p>
        <button>Cancel</button>
      </>
    ))
  );
}

// ✅ Fixed!
function Thing({ data }) {
  return (
    data.map(item => (
      <React.Fragment key={item.id}>
        <p>{item.content}</p>
        <button>Cancel</button>
      </React.Fragment>
    ))
  );
}
Not global

Many developers believe that keys have to be globally unique, across the entire application, but this is a misconception. Keys only have to be unique within their array.

For example, this is totally valid:

function App() {
  return (
    <ul>
      {data.map(contact => (
        <ContactCard
          key={contact.id}
          name={contact.name}
          job={contact.job}
          email={contact.email}
        />
      ))}
      {data.map(contact => (
        <ContactCard
          key={contact.id}
          name={contact.name}
          job={contact.job}
          email={contact.email}
        />
      ))}
    </ul>
  );
}

Each .map() call produces a separate array, and so there's no problem. 👍


Exercises

---

## Iteration Exercises

Exercises

Alright, let's get some practice!

Avatar selection

Below, we have an application which displays multiple avatars the user can select from.

The Avatar component is already wired up, but it's being rendered manually, copy/pasted with different data. Let's update it to use the tricks we've learned in these lessons!

Acceptance Criteria:

You should create an array that holds the data needed for all avatars.
That array should be iterated over, creating an <Avatar /> element for each item in the array.
There should be no key warnings in the console.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Avatar.js
import Avatar from './Avatar';

const data = [
  {
    id: '001',
    alt: 'person with curly hair and a black T-shirt',
  },
  {
    id: '002',
    alt: 'person wearing a hijab and glasses',
  },
  {
    id: '003',
    alt: 'person with short hair wearing a blue hoodie',
  },
  {
    id: '004',
    alt: 'person with a pink mohawk and a raised eyebrow',
  },
];

function App() {
  return (
    <div className="avatar-set">
      {data.map(({ alt, id }) => (
        <Avatar
          key={id}
          src={`https://sandpack-bundler.vercel.app/img/avatars/${id}.png`}
          alt={alt}
        />
      ))}
    </div>
  );
}

export default App;
Result
Console
Refresh results pane

Solution:

This solution uses string interpolation with template strings. Check out the JS Primer lesson on string interpolation 👀 if you're not familiar with this syntax.

Solution code
(success)

 Show more

Using the array index as the key
(warning)

You might be wondering if it's possible to do something like this:

<div className="avatar-set">
  {data.map((
    { id, alt },
    index
  ) => (
    <Avatar
      key={index}
      src={`https://sandpack-bundler.vercel.app/img/avatars/${id}.png`}
      alt={alt}
    />
  ))}
</div>

When we call .map(), the callback function receives the item itself as the first parameter, but also the current index as the second parameter.

These numbers are indeed unique within the context of the array, but there's an issue: they don't really uniquely identify the item itself, they only identify the item's position in the array. This can lead to performance problems, as well as strange quirks.

In order to understand these issues, we'll first need to become comfortable with how state works in React, and we're not there yet. So, let's put this on the back burner? for now; I promise we'll explore this stuff in depth in the next module!

Shopping cart

Let's imagine we're building a shopping cart UI. We receive an array of items being held in the cart from the server.

Sometimes, an item in the user's shopping cart will be out of stock. If the item is out of stock, they can't purchase it. And so it should be displayed separately.

Here's a mockup for what we're trying to build:

We've started working on it, but two problems remain:

We need to show all of the items in the user's shopping cart, not just the first one.
We need to show two separate tables. One for the in-stock items, one for the sold-out items.

Acceptance Criteria:

Update the CartTable component (in the second file) to use iteration.
Make sure that there are no key warnings in the console.
In App, we should be rendering two CartTable elements:
One for the “in stock” elements, in the current spot
One for the “out of stock” elements, below the “Sold Out” heading.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
CartTable.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Conditional Rendering

---

## Conditional Rendering

Conditional Rendering

Often in React, we'll want to render a chunk of markup based on some condition. For example, maybe we want to include a little green dot next to the names of our friends who are currently online:

Let's look at some techniques we can use to solve this problem.


With an If Statement

---

## With an If Statement

With an If Statement

With the curly brackets, we can add JavaScript expressions within our JSX. Unfortunately, though, we can't add JavaScript statements.

As a result, this sort of thing is illegal:

function Friend({ name, isOnline }) {
  return (
    <li className="friend">
      {if (isOnline) {
        <div className="green-dot" />
      }}

      {name}
    </li>
  );
}

Why doesn't this work? Well, let's consider how this would compile down to JavaScript:

function Friend({ name, isOnline }) {
  return React.createElement(
    'li',
    { className: 'friend' },
    if (isOnline) {
      React.createElement('div', { className: 'green-dot' });
    },
    name
  );
}

The problem is that we can't put an if statement in the middle of a function call like this — to look at a simpler example, it would be equivalent to trying to do this:

console.log(
  if (isLoggedIn) {
    "Logged in!"
  } else {
    "Not logged in"
  }
)

(For a refresher on the difference between expressions and statements in JavaScript, check out the primer lesson on “Statements vs. Expressions” 👀.)

Here's the good news, though: we can still use an if statement! But we have to pull it up so that it's not in the middle of a React.createElement call:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Friend.js
Result
Console
Refresh results pane

There's no rule that says that our JSX has to be part of the return statement. We can absolutely assign chunks of JSX to a variable, anywhere within our component definition!

The JSX compiles to this:

function Friend({ name, isOnline }) {
  let prefix;

  if (isOnline) {
    prefix = React.createElement(
      'div',
      { className: 'green-dot' }
    );
  }

  return React.createElement(
    'li',
    { className: 'friend' },
    prefix,
    name
  );
}

In the code above, prefix will either be assigned to a React element, or it won't be defined at all. This works because React ignores undefined values.

Undefined attributes
(info)

Consider the following code:

function Greeting() {
  let someClass;

  return (
    <div className={someClass}>
      Hello World
    </div>
  );
}

What do you expect the markup to look like?

Make a guess, and then expand this section to see the answer:

 Show more

With &&

---

## With &&

With &&

The downside with using an if statement is that we need to pull the logic up, away from the rest of the markup. While this is perfectly valid, it can make it harder to understand how a component is structured, especially in larger and more-complex components. We'd have to hop all over the place to understand what gets returned!

Fortunately, there's a way for us to embed if logic right in our JSX: using the && operator.

Here's how we'd do it:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
function Friend({ name, isOnline }) {
  return (
    <li className="friend">
      {isOnline && <div className="green-dot" />}
    </li>
  );
}

function App() {
  return (
    <ul className="friend-list">
      <Friend name="Andrew" isOnline={false} />
      <Friend name="Beatrice" isOnline={true} />
      <Friend name="Chen" isOnline={true} />
    </ul>
  );
}

export default App;
Result
Console
Refresh results pane

In JavaScript, && is a control flow operator. It works quite a bit like if/else, except it's an expression instead of a statement.

To help us understand what's actually happening here, let's take a look at the exact same logic, but expressed using if/else:

function Friend({ name, isOnline }) {
  let prefix;
  if (isOnline) {
    prefix = <div className="green-dot" />;
  } else {
    prefix = isOnline;
  }

  return (
    <li className="friend">
      {prefix}
      {name}
    </li>
  );
}

The && operator is said to be a “control flow” operator because, like if/else, it will always result in one of two paths being taken.

If the left-hand value (isOnline) is falsy, the expression short-circuits, and evaluates to isOnline, which resolves to false. If that value is truthy, however, it evaluates to whatever's on the right-hand side of the operator (<div className="green-dot" />).

You can think of the && operator a bit like a nightclub bouncer. If you try to get in with a fake ID
*
, the bouncer won't let you access the React element on the other side. If the value is truthy, though, the bouncer unhooks the velvet rope, and we're allowed to access the React element.

This concept is explained in greater depth in the JavaScript primer lesson “Logical Operators” 👀.

Common gotcha: the number zero

Consider this situation:

function App() {
  const shoppingList = ['avocado', 'banana', 'cinnamon'];
  const numOfItems = shoppingList.length;

  return (
    <div>
      {numOfItems && (
        <ShoppingList items={shoppingList} />
      )}
    </div>
  );
}

We have a component, ShoppingList, and it only really makes sense to render that component if we have at least 1 item in our shopping list.

If you've been using JavaScript for a while, you might know that every number in JS is truthy except 0. 0 is the only falsy number, just like how '' is the only falsy string.

Therefore, it seems to make sense to do things this way. If numOfItems has at least 1 item in it, it will be truthy, and we'll render the <ShoppingList> element. If we have 0 items, we should skip it.

But check out what happens when we actually run this setup:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
ShoppingList.js
Result
Console
Refresh results pane

We wind up with 0 being rendered!

Why is this happening? We need to keep two things in mind:

The && operator doesn't return true or false. It returns either the left-hand side or the right-hand side. So, when our list is empty, this expression evaluates to 0.
React will render any number you give it, even zero!

React will ignore most falsy values like false or null, but it won't ignore the number zero.

In fact, let's see how React handles all of the different falsy values:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

React will actually render the number 0. And when we think about it, this makes sense. There are lots of situations where we'd want to render this number:

function Banner({ ticketsRemaining }) {
  return (
    <h2>
      Number of JIRA tickets left: {ticketsRemaining}.
    </h2>
  );
}

If ticketsRemaining is equal to 0, we want to show the number 0, not an empty space!

Solution: Always use boolean values with &&

To avoid having random 0 characters sprinkled around your application, I suggest following a “golden rule”: make sure that the left-hand side of && always evaluates to a boolean value, either true or false.

For example, we can check if the number is greater than zero:

function App() {
  const shoppingList = ['avocado', 'banana', 'cinnamon'];
  const numOfItems = shoppingList.length;

  return (
    <div>
      {numOfItems > 0 && (
        <ShoppingList items={shoppingList} />
      )}
    </div>
  );
}

I really like this approach. We're being really specific with what the condition is: if we have 1 or more items in the shopping list, we should render the <ShoppingList> element. The “greater than” operator (>) will always produce a boolean value, either true or false.

We can also convert any non-boolean value to a boolean value with !!:

function App() {
  const shoppingList = ['avocado', 'banana', 'cinnamon'];
  const numOfItems = shoppingList.length;

  return (
    <div>
      {!!numOfItems && (
        <ShoppingList items={shoppingList} />
      )}
    </div>
  );
}

If you're not sure what's going on here with !!, check out the JavaScript Primer lesson on Truthy and Falsy 👀.

ESLint rule
(info)

There is a handy ESLint rule that will warn you when your expressions could potentially result in an unexpected 0 or NaN showing up in the UI: jsx-no-leaked-render 
. I haven’t personally used it, since I only learned of it recently, but it seems helpful, especially while you’re still learning about JSX and its quirks!

You can learn more about ESLint in the Tools of the Trade 👀 reference module.


With Ternary

---

## With Ternary

With Ternary

The && operator allows us to conditionally render something if a condition is met. But what if we want to render something else if the condition isn't met?

For example, suppose we're building an admin dashboard. If the user is logged in, we want to render the charts and tables and everything. If they're not logged in, we want to render a short message asking them to log in.

We could use two && operators, like this:

function App({ user }) {
  const isLoggedIn = !!user;

  return (
    <>
      {isLoggedIn && <AdminDashboard />}
      {!isLoggedIn && <p>Please login first</p>}
    </>
  );
}

This works, but it's a bit clunky. Fortunately, we can use the ternary operator to help us out.

Here's what it looks like:

function App({ user }) {
  const isLoggedIn = !!user;

  return (
    <>
      {isLoggedIn
        ? <AdminDashboard />
        : <p>Please login first</p>}
    </>
  );
}

The ternary operator isn't new; it's been a part of the JavaScript language since Internet Explorer 3 launched in 1996! But for a long time, it was a pretty obscure language feature.

It's particularly useful in a React context because it allows us to embed if/else logic within our JSX. Because the ternary operator is an operator instead of a statement, it can be used inside JavaScript expressions.

A ternary operator consists of three parts:

condition ? firstExpression : secondExpression

If condition is truthy, the first expression will be the one that gets evaluated. If it's falsy, the second expression will be evaluated instead.

Short circuiting
(info)

Quick question: what do you think will happen when the following code runs?

console.log('condition')
  ? console.log('first condition')
  : console.log('second condition');

Which log(s) will fire? And in what order?

Give it some thought, and then expand this section to show the answer:

 Show more

Showing and Hiding

---

## Showing and Hiding

Showing and Hiding

In the examples we've seen so far, our strategy has been to selectively add or remove a chunk of markup to the page.

There is another way to solve this problem, however. Depending on your background, you might be much more familiar/comfortable with this method.

Instead of adding and removing whole HTML elements, we can toggle their visibility using CSS.

Here's what this looks like in React:

function Friend({ name, isOnline }) {
  const style = isOnline
    ? undefined
    : { display: 'none' };

  return (
    <li>
      <div
        className="green-dot"
        style={style}
      />
      {name}
    </li>
  );
}

If the friend is online, style will be undefined, and will have no effect. The green dot will be shown.

If the friend is offline, the green dot will have display: none applied, effectively removing it from the UI.

Inline styles?
(info)

I'm using an inline style here to set display: none because it's the most straightforward way to demonstrate the concept.

There are lots of different ways to apply this CSS declaration, including using a CSS class or using a CSS-in-JS solution. Ultimately, all of these options are just different roads to the same place, and can be used interchangeably in this situation.

We'll talk more about CSS soon!

Comparing approaches

Alright, so we can either conditionally render the element, using the JS operators we've seen, or we can apply some CSS to show/hide the element. Which approach is best?

Well, from a usability perspective, it doesn't make any difference. Elements hidden with display: none are functionally removed from the page. This is true visually, and it's also true in terms of keyboard navigation and screen-reader support.

There are some interesting performance differences, though.

DOM nodes consume memory just by existing, and that memory will be consumed whether or not they're visible to the user. In a large application with lots of DOM nodes, it can be beneficial to use conditional rendering, to reduce the number of DOM nodes at any given time, and lower the amount of memory consumed.

On the other hand, adding a brand-new DOM node to the page is a much slower task than toggling a CSS property. If the user is toggling the content on and off (eg. expanding an accordion menu), it could be faster to use the display property.

That said, in most cases, the differences are so small that it doesn't really matter.

Here's what I suggest: use conditional rendering by default. Test your applications on low-end devices. If you notice that a particular transition feels laggy, experiment with alternative approaches to see if you can improve the experience.

This is one of those situations where it's very easy to fall into the “premature optimization” trap. Watch out for it!


Exercises

---

## Conditional Exercises

Exercises
Supporting screen readers

We've used JavaScript operators to conditionally render a green circle next to online users' names, but there's a problem: what happens when someone visits our application using a screen reader?

What's a screen reader?
(info)

A screen reader is a piece of software that parses the DOM and reads its contents aloud, using a synthetic voice. It's a vital tool used by folks who have poor or no vision (although screen readers are more broadly used by all sorts of people, including those who have dyslexia or other reading disorders).

Let's consider the following DOM structure:

<ul class="friends-list">
  <li class="friend">
    Andrew
  </li>
  <li class="friend">
    <div class="green-dot"></div>
    Beatrice
  </li>
  <li class="friend">
    <div class="green-dot"></div>
    Chen
  </li>
</ul>

The trouble is that the <div class="green-dot"> is semantically meaningless, and so screen readers will ignore it. If someone can't see the screen, they'll have no idea that this random div is meant to signify that someone is online!

How can we make this information available to folks who use a screen reader? Well, there are a number of valid approaches, but my personal favourite is to use some CSS to visually hide a chunk of text.

Here's what this looks like, using a custom VisuallyHidden component:

<p>
  This text is shown normally.
  <VisuallyHidden>
    This text isn't on the screen, but is announced by screen readers.
  </VisuallyHidden>
</p>

Your task is to use this component to add the suffix “(Online)” after the names of online users.

Acceptance Criteria:

Users who are online should have the text “(Online)” added after their names.
The VisuallyHidden component should be used to make sure that this text isn't shown visually.
Users who are offline should not be affected.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
VisuallyHidden.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

If you'd like to learn more about this component, and see a “souped up” version with the ability to toggle visibility in development mode, check out the VisuallyHidden snippet 
 on my blog.

VisuallyHidden vs. aria-label
(info)

You might be wondering: could we solve this problem using the aria-label attribute instead?

function Friend({ name, isOnline }) {
  return (
    <li className="friend">
      {isOnline && (
        <div
          className="green-dot"
          aria-label="(Online)"
        />
      )}
      {name}
    </li>
  );
}

The aria-label attribute is a way to add additional semantic data to our markup. It doesn't affect the visual presentation at all, but assistive tools like screen readers will read it aloud.

In this particular case, however, we can't use aria-label. This is because aria-label only works on interactive elements like buttons.

As a general rule, I prefer to use this VisuallyHidden component over aria-label, because it includes all of the same accessibility benefits, but without the pitfalls.

It also works better with auto-translation tools 
, with browsers translating visually-hidden content but not aria-label values. Thanks to Brian Hinton for the heads-up about this!

User Profile with Badges

Certain community sites, like LinkedIn or StackOverflow, have "badges", small awards for people who achieve certain goals or who fit certain requirements.

In this exercise, we're going to update a set of user profiles to conditionally render some badges.

Here's what this should look like, for folks who have at least 1 badge:

For users who have no badges, though, this whole section should be omitted. Things should stay as they are:

The markup for badges looks like this:

<ul class="badge-list">
  <li>Badge 1</li>
  <li>Badge 2</li>
  <li>Badge 3</li>
</ul>

Acceptance Criteria:

If the user has at least 1 badge, an unordered list with the class badge-list should be rendered, using the data from profile.badges.
Each badge should be its own list item, with badge.label being rendered within.
There should be no “key” warnings in the browser console. You can trust that the badge slugs are unique.

Stretch goal:

If the user has 3 or more badges, a golden color should be applied:

This can be done by adding the golden class to the <ul>:

<ul class="golden badge-list">
  <li>Badge 1</li>
  <li>Badge 2</li>
  <li>Badge 3</li>
</ul>

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
ProfileCard.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Range Utility

---

## Range Utility

Range Utility

As we saw a couple of lessons ago, we can use .map to iterate over an array of data, to render 1 React element per item.

But what if we don't have an array?

For example, it's common for ratings to use a 5-star system. Let's suppose we want to render 0 to 5 little star icons, depending on the rating.

Spend a few minutes poking at the problem here. Your goal is to render n stars inside the StarRating component, where n is the value of rating:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
StarRating.js
function StarRating({ rating }) {
  const range = (start, end, step = 1) => {
    let output = [];

    if (typeof end === 'undefined') {
      end = start;
      start = 0;
    }

    for (let i = start; i < end; i += step) {
      output.push(i);
    }

    return output;
  };

  return (
    <div className="star-wrapper">
      {range(rating).map((num) => (
        <img
          key={num}
          alt=""
          className="gold-star"
          src="https://sandpack-bundler.vercel.app/img/gold-star.svg"
        />
      ))}
    </div>
  );
}

export default StarRating;
Result
Console
Refresh results pane

This is a tricky problem!

Our default tool in JavaScript to do this sort of thing would be a for loop. As we've learned, though, for is a statement, and we can't use statements within our JSX.

Here's one solution: we can use a for loop above the JSX, to create our array of elements:

function StarRating({ rating }) {
  let stars = [];

  for (let i = 0; i < rating; i++) {
    stars.push(
      <img
        key={i}
        alt=""
        className="gold-star"
        src="https://sandpack-bundler.vercel.app/img/gold-star.svg"
      />
    );
  }

  return (
    <div className="star-wrapper">
      {stars}
    </div>
  );
}

We create an array of image elements with a for loop, and then we render that array inside our JSX. As we saw with .map, React can “unpack” arrays for us, and render each of the elements inside, so long as we provide a unique key for each element.

A functional alternative

There's nothing wrong with this approach, but I have a preferred alternative: using a range function.

range is a utility function. It's not part of the JavaScript language (unfortunately), but it is a staple of utility libraries like lodash.

This is one of my favourite utilities. I use it in every project I work on (in fact, I've used it over 20 times in the codebase for this course platform!). I love it.

To understand how it works, let's look at some examples:

// Create an array from 0 (inclusive) to 2 (exclusive):
range(2);
// Produces: [0, 1]

// Create an array from 0 (inclusive) to 5 (exclusive):
range(5);
// Produces: [0, 1, 2, 3, 4]

// Create an array from 2 (inclusive) to 6 (exclusive):
range(2, 6);
// Produces: [2, 3, 4, 5]

// Create an array from 2 to 10, picking every 2nd number
range(2, 10, 2);
// Produces: [2, 4, 6, 8]

Essentially, it's the expression version of a “for” loop statement, like how && can be an expression version of an “if” statement. This means we can use it in our JSX.

Here's how we'd use it:

function StarRating({ rating }) {
  return (
    <div className="star-wrapper">
      {range(rating).map((num) => (
        <img
          key={num}
          alt=""
          className="gold-star"
          src="https://sandpack-bundler.vercel.app/img/gold-star.svg"
        />
      ))}
    </div>
  );
}

range(rating) will produce an array from 0 up to (but not including) n, where n is the supplied rating. Then, we use the .map trick we learned about to iterate over that array, creating a copy of our star image for each one.

For the key, we use the number generated within the array, since we know these numbers will be unique.

Range function code

Here's how the range function is defined:

const range = (start, end, step = 1) => {
  let output = [];

  if (typeof end === 'undefined') {
    end = start;
    start = 0;
  }

  for (let i = start; i < end; i += step) {
    output.push(i);
  }

  return output;
};

Here's a complete solution demonstrating this function:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
StarRating.js
Result
Console
Refresh results pane

When relevant, this range function will be provided to you on this course platform.

In terms of using this in the real world, I like to create a utils.js file that collects this and other handy JS functions. You can also use the lodash “range” function 
 from NPM.

A simpler alternative?
(info)

Lots of students have pointed out that we can solve this problem using modern built-in array methods.

There are a few ways to do this, but here's the most straightforward option I've seen:

function StarRating({ rating }) {
  return (
    <div className="star-wrapper">
      {Array(rating).fill().map((_, index) => (
        <img
          key={index}
          alt=""
          className="gold-star"
          src="https://sandpack-bundler.vercel.app/img/gold-star.svg"
        />
      ))}
    </div>
  );
}

This does indeed work, and there’s nothing wrong with this approach, but I suppose I wonder why you’d want to do it this way when you can instead use a lovely flexible range function!

Personally, I prefer to rely on a set of core utilities whenever I run into situations like this. I’ve used this range function for many years now, hundreds of times, and it’s served me very well. Whenever I need an array of numbers, I don’t even have to think about it. That’s the beauty of a solid convention. 😄

This is also a relatively simple case; we don’t actually care about the specific numbers being generated. In other cases, like the one we’ll encounter in the next exercise, we need to generate specific arrays of numbers, and our range utility function can handle that without breaking a sweat.

But surely there’s a better way to implement our range function, using modern JS? Many students have also reached out to share alternative implementations, like this one:

const range = (start, stop, step = 1) => Array.from(
  { length: (stop - start) / step + 1 },
  (_, i) => start + i * step
);

What do you think about this alternative? Is it better or worse?

Earlier in my career, I would have told you it was better. It's nice and concise, which means there's less opportunities for typos and other bugs. And it uses functional programming principles: it doesn't mutate any variables, for example.

And, if I was feeling particularly honest that day, I'd have admitted that the real reason I liked this alternative code is that it felt sophisticated. It was a step above the basic stuff I wrote as a junior developer. It made me feel smart.

My thinking has changed quite a bit since then. These days, I want my code to be as basic as possible. When I come back to this code in 6 months, I want to be able to make sense of it as quickly and easily as possible. I also want to make sure that the code I write can be easily understood by the most junior members of my team.

It’s harder to spot bugs in code like this. For example, did you notice that it won’t work if you only specify a start value?

range(0, 5);
// ✅ Works correctly.
// Produces [0, 1, 2, 3, 4]

range(5);
// ❌ Doesn’t work.
// Produces []

My vintage range definition is verbose and basic, but it works flawlessly and I can make sense of it without burning any calories. That’s the most important thing for me.

I dig into this idea in a blog post I wrote, “Clever Code Considered Harmful” 
.


Exercises

---

## Range Exercises

Exercises
Graph Ticks

Later in this course, we'll dig into different server-based rendering strategies. To help explain how everything works, those lessons have embedded dynamic graphs like this one:

Default (no lazy loading)

Default
Lazy Load
0
10
20
30
40
Server
Client
Page
Interactive
Content
Painted
First
Paint
Render
App
Hydrate
Download JS

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

"Render App" on server. Duration: 6 units of time.
Response from server. Duration: 4 units of time.
"Download JS" on client. Duration: 12 units of time.
"Hydrate" on client. Duration: 8 units of time.

When I build stuff like this, I generally don't use data-visualization libraries. Instead, I construct them myself, using friendly every-day DOM nodes!

In this exercise, we'll reconstruct the bottom edge of this graph:

0
10
20
30
40

Below, you'll find a Graph component that has some example markup. All of the styles have been provided. Your mission is to update the code so that it renders the correct number of pegs, based on the props that the component receives.

Acceptance Criteria:

The Graph component should use the provided range function to generate the correct pegs for the given from and to props.
The pegs should always increase by 10, and be inclusive of both the from and to values.
You can assume that from and to will always be multiples of 10.
There shouldn't be any key-related warnings in the console.

To clarify some of these acceptance criteria, here are some examples, showing the UI we expect to produce based on different from/to values:

<Graph from={0} to={40} />
0
10
20
30
40
<Graph from={20} to={70} />
20
30
40
50
60
70
<Graph from={-20} to={20} />
-20
-10
0
10
20

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
utils.js
Graph.js
Preview
Refresh results pane
Console
Clear Console

Solution:

Solution code
(success)

 Show more
Rendering a grid

Suppose we're building a Scrabble-like word game, and we want to render a grid of HTML elements like this:

Here's what the DOM structure looks like, for a 2×4 grid:

<div class="grid">
  <div class="row">
    <div class="cell"></div>
    <div class="cell"></div>
    <div class="cell"></div>
    <div class="cell"></div>
  </div>
  <div class="row">
    <div class="cell"></div>
    <div class="cell"></div>
    <div class="cell"></div>
    <div class="cell"></div>
  </div>
</div>

Your mission is to replicate this structure, but for a variable number of rows and columns.

Acceptance Criteria:

You've been given the template for a Grid component, which will be provided with a numRows prop for the number of rows, and a numCols prop for the number of columns.
There should be X divs with a class of row, where X is equal to the numRows prop.
Inside each row, there should be Y divs with a class of cell, where Y is equal to the numCols prop.
You should use the provided range function to solve this problem.
There shouldn't be any key-related warnings in the console.
Note: the console isn't cleared automatically when the warnings are fixed. You can refresh the Preview pane with the  icon.

This is a challenging exercise, and will require a bit of creative problem solving. It's 100% alright if you can't solve it! Spend 15 minutes giving it a shot, and then check out the solution video below.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
utils.js
Grid.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Styling In React

---

## Styling In React

Styling In React

React is unopinionated when it comes to styling. As a result, there are dozens of options out there when it comes to pairing CSS with React.

Technically, there's nothing stopping you from doing things the “traditional” way. You could keep a bunch of CSS files, and include them with <link> tags in your index.html.

But honestly, if you want to have the best experience building with React, there are better approaches.

Remember when we first talked about components, and we saw this graphic?

The core idea with components is that each component is a bundle of markup (in JSX), logic (in JS), and styles (in CSS). Our Button component should “own” all the styles related to that component!

When we structure our code this way, something magical happens. Working with CSS becomes so much simpler.

Let's talk about it.

Video Summary


CSS Modules

---

## CSS Modules

CSS Modules

On this course platform, I have a “Sidenote” component, used to add tangential information. You've probably noticed them already, they look like this:

I'm a sidenote!
(info)

I contain some text!

Let's build a simplified version of this component!

Here's a rough sketch, in terms of the props and the markup:

function Sidenote({ title, children }) {
  return (
    <aside>
      <h3>{title}</h3>
      <p>{children}</p>
    </aside>
  );
}

And here's how we style it with CSS Modules:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Sidenote.js
Sidenote.module.css
import styles from './Sidenote.module.css';
console.log(styles)
function Sidenote({ title, children }) {
  return (
    <aside className={styles.wrapper}>
      <h3 className={styles.title}>{title}</h3>
      <p>{children}</p>
    </aside>
    
  );
}

export default Sidenote;
Result
Console
Refresh results pane

There's a lot of weird stuff going on here. I'll explain exactly how this all works, but first, I'd suggest spending a few moments poking at this for yourself!

For example, what do you suppose that styles import is? Make a guess, and then see if you're right by logging it, with console.log(styles).

After you've poked at this example a bit, watch this video for an in-depth explanation:

Video Summary

You can learn more about Webpack in the Webpack “Tools of the Trade” bonus lesson 👀.

Naming the “styles” import
(info)

In some tutorials for CSS Modules, the import is named “classes” instead of “styles”:

import classes from './Sidenote.module.css';

Ultimately, this is the same thing. Webpack treats the CSS module as a “default export”, and so we can name it whatever we like.

For more information, check out the “JavaScript Modules” lesson 👀 in the JS primer.


Exercises

---

## Styling Exercises

Exercises
Sidenote types

On this course platform, I have 4 different “types” of Sidenote components, depending on the status of the thing happening:

This is type=“notice”
(info)

It's blue!

This is type=“warning”
(warning)

It's yellow!

This is type=“error”
(error)

It's red!

This is type=“success”
(success)

It's green!

In this exercise, we'll update our simplified Sidenote component to support a new type prop. This prop will be used to apply a dynamic CSS class.

Here's the markup we want to wind up with:

<aside class="wrapper notice">
  <h3>This is an informational sidenote.</h3>
</aside>

<aside class="wrapper success">
  <h3>This is a success sidenote!</h3>
</aside>

The wrapper class contains "shared" styles, things like the amount of padding, or the thickness of the border. The type classes like notice and success contain the category-specific styles (eg. background color).

In this exercise, you'll implement this pattern using CSS Modules. All of the styles have been provided. Your task is to apply the correct class name based on the type prop.

Acceptance Criteria:

All sidenotes should have the wrapper class applied.
The type property of the Sidenote should apply an additional class, which changes the color of the background and border.

Never rely on color alone
(warning)

In this exercise, we're using color to distinguish between the different types. This is insufficient, because folks who are colorblind can't always differentiate between the colors. In a real application, we'd want a secondary indicator.

On my course platform, I use different icons, like the ⚠ icon in this warning. We're skipping it in this exercise to keep things focused on the lesson at hand.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Sidenote.js
Sidenote.module.css
Result
Console
Refresh results pane

Solution:

Video Summary

Solution code
(success)

 Show more

When to use square brackets?
(info)

In the video above, I mention that we need to make sure to write styles[type] and not styles.type. But what exactly is the difference? When do we use the dot, and when do we use square brackets?

 Show more
Movie ratings animation

Let's suppose we're building a site that'll help people find new movies to watch.

We're displaying some basic information about each movie, including a rating (sourced from Rotten Tomatoes).

Let's do something fun. For movies that have a rating of at least 9.0, we want to add an animation to the rating number:

The idea is to highlight movies with great ("glowing") reviews, to make them stand out.

A CSS class has been provided, glowingReview. You'll need to apply this to all ratings that are 9 or above. Don't be afraid to make changes to the markup for this!

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Movie.js
Movie.module.css
Result
Console
Refresh results pane

Not seeing the animation?
(warning)

If the glowing reviews aren't growing and shrinking even after applying the class, it's likely that you've ticked the “reduce motion” checkbox in your operating system's accessibility settings.

Feel free to leave motion disabled. As long as you see the colors changing, you're good to go!

We'll learn more about motion accessibility towards the end of the course 
.

Solution:

Small tweak to the solution
(warning)

Discord user xavortm noticed that the solution I provide in this video produces a warning:

Warning: Received false for a non-boolean attribute className.

The culprit is this line:

<span
  className={movie.rating >= 9 && styles.glowingReview}
>
  {movie.rating}
</span>

If movie.rating is less than 9, the whole expression will produce false. Somewhat surprisingly, this is not a valid value for the className prop.

We can fix it by using a ternary expression instead:

<span
  className={movie.rating >= 9 ? styles.glowingReview : undefined}
>
  {movie.rating}
</span>

This fix has been applied to the solution below:

Solution code
(success)

 Show more

Class utilities
(info)

The className prop expects a string. This string can include multiple classes, separated by spaces.

We can dynamically create this string using string interpolation 👀, like this:

<button
  className={`
    ${styles.btn}
    ${type === 'primary' ? styles.primary : ''}
    ${user ? styles.loggedIn : styles.notLoggedIn}
`}
>

This works, but it can be tricky to make sure the string we're constructing is perfectly valid. In cases like this, it's easier to use a class utility.

For example, here's how we could apply this logic using the clsx package 
:

import clsx from 'clsx';

<button
  className={clsx(
    styles.btn,
    type === 'primary' && styles.primary,
    user ? styles.loggedIn : styles.notLoggedIn
  )}
>

The clsx function will take each of these arguments and produce a unified string that satisfies the className prop requirements. It'll automatically remove falsy values like false or null.

Ultimately, it's not a game-changer, but it can be a handy little utility! It shaves off some of the rough edges of trying to construct the string ourselves.


Working With State

---

