# Joy of React - Module 6: Full Stack React

---

## Introduction • Josh W Comeau's Course Platform

Source: /joy-of-react/06-full-stack-react/00-introduction

Full Stack React

So far in this course, we've been dealing with React exclusively on the client. In this module, we're going to look at building full-stack web apps with React.

This is a particularly exciting time to be learning about this stuff. The React team has been quietly working for years on a number of advanced full-stack features (eg. Suspense, React Server Components), and they're finally ready to use.

As I write this in the summer of 2023, there's only one way to take advantage of all the new stuff, and that's to use Next.js.

Next.js
 (or simply Next, as it's often called) is a full-stack React meta-framework created and maintained by Vercel
. It was originally released in 2016, and pioneered a lot of things that have since become common in meta-frameworks, like file-based routing.

Over the past couple of years, as the React team has been reimagining how React could work in a full-stack context, Vercel has decided to become an active participant in the process. They essentially rebuilt Next from the ground up, to be based around the next-gen React features. They've even hired several React core team members, like Andrew Clark
 and Sebastian Markbåge
.

As a result, Next.js is currently the most modern React meta-framework. Using Next is like getting a glimpse into the future of React. And I have to say, it's pretty amazing. 😮

All of that said, this isn't a Next.js course. For the most part, we're going to focus on the core React features, and use Next as the “setting”, the environment in which we access those features. Ultimately, you'll still learn how to build a full-stack application using Next, but we won't cover everything that Next has to offer.

Right now, Next.js is the only game in town that supports modern React features, but it won't stay that way forever. Other meta-frameworks will catch up, and brand-new ones (like Waku
) will pop up. I want the skills you learn in this module to be transferrable!

I'm exceptionally excited to show you this stuff. So many new doors open when we can introduce a server into the mix. And you'll be learning the most bleeding-edge version of all this stuff; very few React developers understand what you'll understand by the end of this module. 😄

What if I don't use a full-stack meta-framework?
(info)

There are many production React applications in the world that don't use Next.js, or any other full-stack meta-frameworks. Maybe you work at a company that maintains a client-side React application. You might be wondering: Will anything in this module be relevant for me?

I think you'll still get a lot out of this module!

The most direct benefit is that you'll learn more about how React works. This module continues the work we've been doing throughout this course to understand React at a deeper level. Many of the bleeding-edge features we'll be discussing can still be used in a client-side rendering context. Suspense, for example, started off as a client-side feature.

Now, to be clear, this module will be most beneficial for folks who work with Next.js, or another full-stack meta-framework. But I still think there's a lot of benefit for those who maintain client-side React apps.

And honestly, once you see all of the benefits we get from all the new stuff, you might be tempted to migrate!

Next 15
(warning)

Since releasing this course, Next has gone from version 14 to 15. This release is mostly about matching React 19, but there are a couple of breaking changes that we’ll bump into in this module.

I’ve updated all of the associated projects to use Next 15 / React 19 and tweaked all of the solutions, but I haven’t re-filmed any of the videos. When something in a video is outdated, I’ve put a note below that contains the correction.


---

## Client vs. Server Rendering

Source: /joy-of-react/06-full-stack-react/01-server-vs-client-rendering

Client vs. Server Rendering

Video Summary

Correction: In this video, I mention that the Toast Playground was created using Create React App. Since filming this video, that project has been migrated to use Parcel. Fortunately, both Create React App and Parcel use client-side routing, and so the result is the same.

Command palette?
(info)

In the video above, I disable JavaScript using the command palette:

This handy panel can be opened in Chrome by pressing Ctrl + Shift + P. Note that the devtools must be open for this to work.

There are palette shortcuts for tons of stuff — it's a great alternative to digging through sub-menus looking for the right controls!

Graphing it out

Throughout this module, we'll be looking at lots of different rendering strategies, and I find it's useful to plot these strategies out on a graph, to understand the timeline of what happens when, and what the potential performance implications are.

For example, here's a graph that shows the Server Side Rendering flow we've been talking about:

0
10
20
30
Server
Client
Page
Interactive
Content
Painted
Load JavaScript
Render
application

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

"Render application" on server. Duration: 8 units of time.
Request to server. Duration: 3 units of time.
"Load JavaScript" on client. Duration: 16 units of time.

First, the server does the initial React render. Then, the HTML file is sent to the client (that's what the swoopy arrow indicates). Finally, the JavaScript bundle is downloaded and executed, adding interactivity to our application.

I've also added a couple of flags, to indicate what the user experiences during this timeline:

Content Paint — This is the moment that the user sees the main content on the page. For example, on my course platform, this is the moment they're able to start reading the lesson text. This is often referred to as Largest Contentful Paint
 (LCP).
Page Interactive — This is when the page becomes fully dynamic; on my course platform, this is the moment when users can interact with code sandboxes, toggle the dark/light color theme, etc. This is often referred to as Time To Interactive
 (TTI)

Here's another graph, showing the traditional “client-side rendering” we've been working with so far in this course:

0
10
20
30
Server
Client
Page
Interactive
Content
Painted
Render application
Load JavaScript

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

Request to server. Duration: 3 units of time.
"Load JavaScript" on client. Duration: 12 units of time.
"Render application" on client. Duration: 12 units of time.

The swoopy arrow at the start represents the server sending along an empty HTML file. Once that file has been received by the client, it can start downloading the JS bundle. Once the JS bundle is ready, the React application can finally be rendered.

Please note: these graphs are abstract approximations. They're meant to help you understand the sequence of events, not to be a 100% accurate reflection of reality. In practice, each of these steps will take a wildly different amount of time depending on unique circumstances (the amount of content, the speed of the server, the strength of the network, etc).

They're also oversimplified at the moment; In the next lesson, we'll learn about hydration, a puzzle piece currently missing from these graphs.

---

## Hydration

Source: /joy-of-react/06-full-stack-react/01.01-hydration

Hydration

When we use server-side rendering, the browser receives a fully-formed page. Ideally, all of the necessary HTML and CSS should be included.

But a huge component of React applications is interactivity. React is all about building dynamic, stateful applications. Most of our time in this course has been spent learning about how to make our applications interactive, with state and effects.

The process of turning the initial static HTML file into an interactive web application is called hydration.

I really like the way React core team member Dan Abramov explains it:

Hydration is like watering the “dry” HTML with the “water” of interactivity and event handlers.

At a high level, the process of hydration goes something like this:

Perform a “speed render”, to figure out the shape of our component tree, and to initialize our component instances.
Wire up all of the interactivity (add event listeners, attach refs, etc).

In a client-side rendering environment, the initial render is responsible for creating all of the DOM nodes. With server-side rendering, however, all of those DOM nodes already exist. Instead, React has to “adopt” the DOM.

Here's how I picture this working:

Static
Interactive
Start Hydration

The grey boxes represent static DOM nodes, embedded in the server-generated HTML. On the client, React quickly constructs the component tree and matches it to the DOM, so that it can wire up event listeners and make the application interactive.

Fancy optimizations
(success)

As we'll learn later in this module, modern React has a bunch of tricks up its sleeves to improve the hydration performance. This visualization shows the simplest, least-optimized version of this process.

Updating our graphs

Here's what our updated “SSR” graph looks like, now that we know about hydration:

0
10
20
30
Server
Client
Page
Interactive
Content
Painted
Hydrate
Download JavaScript
Render
application

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

"Render application" on server. Duration: 8 units of time.
Request to server. Duration: 3 units of time.
"Download JavaScript" on client. Duration: 12 units of time.
"Hydrate" on client. Duration: 4 units of time.

Our “Load JavaScript” step has been broken into two phases: Downloading the JS bundle, and hydrating the React application.

Hydration in code

This requires a slightly different approach. Here's how we'd change the index.js file at the root of our React application:

import React from 'react';
-import { createRoot } from 'react-dom/client';
+import { hydrateRoot } from 'react-dom/client';

function App() {
  return (
    <h1>Hello world!</h1>
  );
}

-const root = createRoot(document.querySelector('#root'));
-root.render(<App />);
+hydrateRoot(document.querySelector('#root'), <App />);

The hydrateRoot method is how we adopt an existing DOM structure.

Now, to be clear, we don't generally write this code ourselves. Often, server-side rendering is a feature of React meta-frameworks like Next.js, and they handle this stuff internally.

I think it's important to understand how this stuff works conceptually though. There are a couple of “gotchas” with hydration, and server-side rendering in general. We'll explore them a little later in this module.


---

## SSR Flavors

Source: /joy-of-react/06-full-stack-react/01.02-taste-the-rainbow

SSR Flavors

Using my course platform as an example, we saw an example of how Server Side Rendering can be implemented:

User visits a lesson page.
The server receives the request, and does the first React render, generating the initial HTML.
User receives a fully-formed HTML document, so they can start learning even while the JavaScript bundles are downloading.

This is known as on demand server side rendering. The HTML is generated “just-in-time”, when the server receives the request.

It's not the only strategy we can use, though! SSR comes in many different flavors. Another popular implementation is called Static Site Generation, SSG.

This is the strategy I use on my blog, joshwcomeau.com
.

The big innovation with SSG is that the HTML is generated ahead of time. Instead of rendering our React application on demand (when a request is received), we do the render at compile-time.

We've talked a little bit about how React apps need to be compiled. This process does a bunch of stuff:

Turns JSX into browser-friendly JavaScript.
Runs any checks, like ESLint.
Bundles all of our individual JavaScript files into a handful of scripts.

With SSG, we add one more step to this pipeline: Generate the initial HTML for each page by doing the first React render.

We then upload all of the HTML files to our server, and those files are served “as-is” when the user requests them.

Think about what this means from a performance perspective. When a user visits joshwcomeau.com/animation/css-transitions/, the server immediately sends along the fully-formed HTML document. The server doesn't have to do any processing at all, because that work was already done during the compile step!

0
10
20
30
Server
Client
Page
Interactive
Content
Painted
Hydrate
Download JavaScript

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

Request to server. Duration: 3 units of time.
"Download JavaScript" on client. Duration: 12 units of time.
"Hydrate" on client. Duration: 4 units of time.

A helpful analogy
(info)

If you're having trouble understanding the difference between “on-demand” SSR and SSG, I have an analogy that may help! Content Warning: This is a food-related analogy.

“On-demand” SSR is like ordering a pizza. You call your local pizzeria and they start making your pizza from scratch, made to order. Starting from a lump of dough, they transform it into a pizza, and slide it into the oven. The pizza shows up at your house 30 minutes later.

Static Site Generation, on the other hand, is like heating up a frozen pizza.

Frozen pizzas are produced weeks/months in advance. They're generic; it's impossible to make customizations when you buy a frozen pizza at the grocery store.

Either way, you wind up with a pizza, but it's produced at totally different times.

A note on terminology

Let's clear up something that often gets confused in online discussions about this stuff.

The term “Server Side Rendering” refers very specifically to one thing: Using the react-dom/server APIs to generate the HTML in Node.js:

import { renderToString } from 'react-dom/server';

import App from './components/App';

const html = renderToString(<App />);

No matter whether we run this code on-demand, like we saw with my course platform, or at compile-time, like I do with my blog, they both fit under the “Server Side Rendering” umbrella, because they both use the same APIs. The only difference between them is the timing!

With SSG, we call the renderToString method when we compile our site, and save the HTML files to disk, to be served to users when they visit the page. With “on-demand” SSR, we call renderToString in response to a user request, to generate the HTML right as it's needed. Ultimately, these are two different “flavors” of SSR.

A third flavor, created by Next.js, is called Incremental Static Regeneration (ISR)
*
.

The ISR flow is a bit hard to explain in words, so here's an interaction that should (hopefully) make it clear. Try clicking "Request page" for a couple of the people here:

deymos

Request page

Noora

Request page

Anthony

Request page
Server
Discard Generated File

The first time a user requests a particular page, the server will generate the HTML and send it to the user, the same as “on-demand” server-side rendering. The difference is that it hangs onto that generated HTML. The next time someone requests that same page, Next will automatically serve up that pre-generated HTML, same as SSG.

In order to prevent the generated file from growing too stale, we can configure Next to regenerate the HTML file after a certain amount of time has passed. This is known as revalidation.

For example, suppose we set a revalidation time of 60 minutes. When someone visits this page after 61 minutes, the Next server will serve that user the stale HTML file, but will start a brand new Server Side Render in the background. The next user will get the fresh, newly-generated file.

You can learn all about Incremental Static Regeneration in the Next docs
, though honestly I don't think it's something you need to dig into right now.

Here's the important takeaway: “Server Side Rendering” is an umbrella term that can refer to many different potential strategies! They each have their own pros and cons, but fundamentally, they all serve the same purpose: to improve performance.

Mini Quiz

So, here's a question: why doesn't my course platform use Static Site Generation?

With on-demand SSR, the server has to spend some time generating the HTML, whereas with SSG, the HTML file already exists. And so, wouldn't it be better to use SSG on my course platform?

Put another way: Can you think of any drawbacks to SSG?

Spend a few moments thinking about it, and see if you can come up with 2 or 3 possible reasons. You can use this text box as a notepad, to store your thoughts:

Once you've thought about it for a little while, expand to see my answer:

REVEAL

---

## React Server Components

Source: /joy-of-react/06-full-stack-react/02-server-components

React Server Components

Video Summary

Two corrections for the above video:

I mention in the video that the "use server" directive could theoretically be used to declare a Server Component, but that’s not true; "use server" is used for a completely separate purpose, part of the new Actions API. We don’t yet cover this API in the course, but you can read about it in the React docs
.
I show some functions for connecting to a MySQL database, mysqliConnect and mysqliQuery. These functions aren't real; they're placeholders meant to make it easier to compare the PHP and JS versions.
If you're interested in working with an SQL database in JavaScript, I'd use PostgreSQL instead of MySQL. The NPM package pg
 appears to be the most popular option for working with PostgreSQL in JS.

use strict?
(info)

If you're curious about that 'use strict'; directive I mention in the video, you can learn more about it on MDN
.

This directive is added automatically by bundlers like Webpack. You don't need to add it yourself.

RSC without SSR?
(info)

One of the things I was very confused about, when I was first trying to figure this stuff out, was how it would be possible to use React Server Components without Server-Side Rendering.

To be clear, this is not an expected use case. The ideal strategy is to use both together. But, if you're wondering about this as well, I'll explain here.

 Show more
The benefits of React Server Components

As we saw above, React Server Components are a significant paradigm shift, an entirely new way to think about components!

Why go through all the trouble? What are the benefits?

The most obvious benefit to me is performance. If half of the components in your application are Server Components, it means that your JS bundle will be significantly smaller, since all of that code can be omitted.

We're already seeing some innovation happening here: Bright
 is a syntax-highlighting library specifically designed to be used with React Server Components.

If we were to try to use this library in a typical React app, it would add a whopping 250kb gzip to our JavaScript bundle. Syntax-highlighting libraries tend to be quite large, since they have to include complex tokenization logic for potentially dozens of languages. Generally, these libraries have to make lots of trade-offs, in order to shrink them to an acceptable size.

But, Bright doesn't get added to your JS bundle! It runs on the server, generating all of the HTML needed to display syntax-highlighted code. Server components don't hydrate or re-render on the client, and so we don't need this code to be shipped to the browser.

This, to me, is the most obvious benefit to React Server Components. When I've spoken to members of the React core team, however, they've said that it isn't yet clear what the biggest benefits will be. It's a whole new paradigm, and it remains to be seen what benefits are made possible by it.

Understanding with graphs

Let's see how each of these approaches affect the graphs we've been looking at. Toggle between the different choices to see how things change:

Server Side Rendering

CSR
SSR
SSR + RSC
0
10
20
30
Server
Client
Page
Interactive
Content
Painted
First
Paint
Render App
Render App
Hydrate
Download JS
Query Data

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

"Query Data" on server. Duration: 4 units of time.
"Render App" on server. Duration: 4 units of time.
"Render App" on server. Duration: 4 units of time.
Response from server. Duration: 4 units of time.
"Download JS" on client. Duration: 10 units of time.
"Hydrate" on client. Duration: 4 units of time.

---

## Intro to Next.js

Source: /joy-of-react/06-full-stack-react/03-nextjs

Intro to Next.js

As I mentioned at the top of the module, Next.js (commonly shortened to just Next) is a popular full-stack React meta-framework. As I write this in mid-2023, it's the only framework to fully take advantage of React's new full-stack model, including React Server Components.

In this chunk of lessons, we'll learn about the fundamental structure of Next applications. You'll learn how to create pages and layouts, how to structure server vs. client components, and learn how to avoid some of the gotchas with server-side rendering.

Two different Nexts
(warning)

An important thing to know about Next is that it changed dramatically in 2023.

On May 4th 2023, Next released v13.4, which marked the official stable release of the “App Router”. This is essentially a total rewrite of Next.js, done to integrate all of the new React features like React Server Components.

In this course, we're going to focus exclusively on the new App Router. This is the future of Next.js, and honestly, I think it's a big improvement.

I want to teach you the latest and greatest stuff, so that the skills you learn in this course last as long as possible. The trade-off here is that you'll be ahead of many educational resources out there. It can be harder to troubleshoot issues with Next 13.4+, because there just aren't that many tutorials / StackOverflow answers / etc.

The “original” version of Next is called the Pages Router. It hasn't officially been deprecated yet, but I imagine that it's only a matter of time.

How can you tell if an online resource is out of date? Here are some things to watch out for:

A directory structure that involves the /pages directory.
Methods named getServerSideProps and getStaticProps.
Files named _app.js and _document.js.
“API Routes”.

If you see these things in an online tutorial, it means they're using the classic Pages Router; anything related to routing will be out-of-date.

These days, the current major version of Next is 15, released in October 2024. Fortunately, things have been relatively static since the App Router’s introduction, so you don’t have to worry as much about discrepancies in online resources.


---

## Hello Next!

Source: /joy-of-react/06-full-stack-react/03.01-hello-next

Hello Next!

Video Summary

Note: In this video, I briefly show a project setup using Create React App, because this was the build tool originally used for the first two projects. I've since migrated these projects to use Parcel. Fortunately, Parcel and Create React App are structured the same way, and so the comparison is still relevant.

If you'd like to play around with this minimal starter, you can access it here:

View on Github
View on CodeSandbox

Minimum Node version
(warning)

Next.js requires at least Node 18.18 to work correctly. If you try to run these projects with a lower version of Node, you'll likely run into cryptic / hard-to-decipher error messagers.

You can check your current version of Node using the terminal command node -v. If the value is less than 18.18, you'll want to upgrade Node to the current LTS (Long Term Support) version
.

I recommend using a version manager like nvm
 so that you can install multiple versions of Node and hop between them easily. If you're a Windows user, you may need to use WSL, discussed in the “Tools of the Trade” reference module 👀.


---

## Exercises

Source: /joy-of-react/06-full-stack-react/03.02-initial-exercises

Exercises

Alright, let's get some hands-on practice!

The exercises in this module work a bit differently. We can't use the typical embedded playground because Next.js is a full-stack framework, and we need a server!

Instead, you'll be given two options for most of the exercises in this module:

Local development, on your machine
Online, using CodeSandbox
Local Development

Option 1 is to download the code onto your computer and run a local development server.

Fortunately, this process is quite similar to the one we followed when running a local dev server in the Wordle and Toast Component projects.

Here's the flow:

Download the code from Github, either by forking the repository, or downloading a .zip file. A link will be provided for each of the exercises below.
cd into the newly-created folder that contains all of the files.
run npm install to install all of the dependencies.
run npm run dev to start a local development server.

For a more detailed runthrough of these steps, it might be helpful to refer to the “Local Development” instructions 👀 from the Wordle project. That project uses Parcel, not Next.js, but the local development instructions are the same.

Minimum Node version
(warning)

Next.js requires at least Node 18.18 to work correctly. If you try to run these projects with a lower version of Node, you'll likely run into cryptic / hard-to-decipher error messagers.

You can check your current version of Node using the terminal command node -v. If the value is less than 18.18, you'll want to upgrade Node to the current LTS (Long Term Support) version
.

Running on CodeSandbox

For Option 2, you'll need to sign up for a free account
 with CodeSandbox in order to make any edits.

I should also warn you, you might run into some issues with CodeSandbox. It uses a VM to run Node.js in the browser, which is an incredible accomplishment, but may still have some kinks.

If you run into any issues with CodeSandbox, you can always run the code locally instead.

Viewing your edits on CodeSandbox
(info)

In order for your edits to become viewable in the preview window, you need to either:

Save the file using the “Save” shortcut (Ctrl + S)
Click outside the code editor, so that it loses focus.

Performing one of these actions should should re-compile the application and update the preview.

Server Timestamp

Back in the early days of the web, it was common for websites to add a timestamp to the bottom of the page, to show exactly when the HTML page was generated.

For example, Codeforces
 has been doing this since 2010!

Let's add a timestamp to a basic Next.js starter app!

Acceptance Criteria:

Add a <footer> tag that shows a timestamp.
The time should reflect when the page was generated. Refreshing the page should re-generate the page, and update the timestamp.
The JavaScript code should only run on the server, not the client.
To format the time, you can use the toLocaleString() method on a date object:
const timestamp = new Date().toLocaleString();

Getting Started:

As I mentioned above, you have two options to work on this exercise:

Download from Github
Work on CodeSandbox

CodeSandbox gotchas
(warning)

Before trying to work on the exercise on CodeSandbox, you need to register for a free account
. Be sure to complete the onboarding flow.

If you try to edit the changes before registering an account, you'll be prompted to log in, but the login will silently fail, because you don't yet have an account.

Also, you might see some weird logs instead of a live preview:

This new version of CodeSandbox includes multiple output tabs. You need to click the dev:3000 tab to view the live preview.

Solution:

Note: Even if you solved this problem without issue, you might want to watch the solution video anyway: we dig into the HTML sent by Next, and some of the nice things it does. ✨

Server logs
(info)

In the video above, I add a console.log('layout rendered') to the layout, to check whether this component is being rendered on the client, the server, or both. Because the log didn't show on the client, I knew it was only rendering on the server.

Since filming this video, Next.js added a neat quality-of-life feature. In the current version, Next will “proxy” all server logs to the client. This means you’ll see something like this in the browser console:

The “Server” prefix tells us that this message was actually logged on the server, not the client. In development mode, Next.js forwards all logs to the client, for our convenience. But make no mistake, the component itself didn't actually render on the client.

Solution code
(success)

 Show more

Dynamic vs. static routes
(warning)

If you try to deploy this code as-is, you'll notice that the server timestamp doesn't seem to be updating.

This is because Next.js automatically optimizes our Server Components in production so that they only run during the build, like a static site generator. We need to opt into “on-demand” server-side rendering.

We'll look at how to do this later in the module.

Hit Counter

Let's create a hit counter using Next.js!

In a production app, we'd store the # of hits in a database. To keep things simple for us, we'll read and write from a locally-stored JSON file:

// /src/database.json
{
  "hits": 0
}

If you've never tried to read or write files inside Node.js before, don't worry! I've provided a couple of handy helper methods inside /src/helpers/file-helpers.js. You'll find a small example of how to use these methods in the project's page.js file.

Acceptance Criteria:

The current number of hits should be shown. The current number should be read from the database.json file.
Visiting the site should increment the number by 1. This new number should be saved by overwriting the database.json file.
Note that you'll need to convert between strings and objects with JSON.parse and JSON.stringify.

Link to exercise code:

Download from Github
Work on CodeSandbox

Solution:

Solution code
(success)

 Show more

Production woes
(warning)

So, if you try to deploy this solution to production, you'll discover it doesn't really work.

In most production settings, the deployed files are read-only. When we try to update the # of hits in our database.json file, an error would be thrown, since Node isn't allowed to write to any files.

Ultimately, in a real setting, we'd want to use a database to store this information. I'm using a database.json file here because it's the simplest way for us to learn about Next.js, but it's not a practical option in production.


---

## Client Components

Source: /joy-of-react/06-full-stack-react/03.03-client-components

Client Components

Let's suppose we want to add a new feature to our “Hit Counter” example: the ability to obscure and reveal it.

Before I show you how to do this, I'd encourage you to spend 5-10 minutes hacking on it. You can use the same “hit-counter” project
 we used in the previous exercise.

The project already has all the CSS you need. Your goal is to wind up with the following markup:

<!-- Censored -->
<button class="censored">
  123
</button>

<!-- Not censored -->
<button>
  123
</button>

The current number of hits should be wrapped in a <button>, and the "censored" class should be toggled on and off when the button is clicked, using a React state variable like isCensored.

This is a surprisingly tricky challenge. I don't expect you to be able to solve it. But I do think there's tremendous value in tinkering with this, to get a feel for the problem.

Once you've done some experimentation, watch this video to explore a couple of different solutions:

Video Summary

This lesson builds on the “Parents vs. Owners” distinction we learned about in the last module. I suggest reviewing this lesson if you're feeling a little lost. ❤️

You can view my final solution on Github:

Toggleable Hit Counter solution

Small correction
(info)

In the video above, I forgot to remove the isCensored/setIsCensored props from the HitCounter component. These props aren't used, since we're dealing with this stuff in the Censored component.

Here's the correct final code:

function HitCounter() {
  let { hits } = JSON.parse(
    readFile(DATABASE_PATH)
  );

  hits += 1;

  writeFile(
    DATABASE_PATH,
    JSON.stringify({ hits })
  );

  return hits;
}

This correction has been applied to the Github solution
.


---

## Exercises

Source: /joy-of-react/06-full-stack-react/03.04-client-components-exercises

Exercises
Server Components and styled-components

Let's get some practice with Server and Client Components!

This exercise requires a bit of context. Please watch this short video before continuing:

Video Summary

Acceptance Criteria:

The Home component in page.js should be a Server Component (no "use client" directive).
The MainWrapper styled component should be a Client Component.
As little code as possible should be included in Client Components.

I recognize that it might not be obvious whether or not a component is being used as a Client Component or not; please don't fret! Give it your best shot, and then watch the solution video.

Also: if you'd like to create any new components, you can do that with the new-component package:

$ npx new-component YourComponentName

You can do this in CodeSandbox by clicking the + icon in the right-hand column and selecting “New terminal”. This will allow you to execute this terminal command.

Link to exercise code:

Download from Github
Work on CodeSandbox

Solution:

Video Summary

NOTE: Even if you solved the problem successfully, this is one of those solution videos I recommend watching regardless; the second half of the video digs into the metrics, to see what the actual tangible benefits are.

Solution code
(success)

 Show more
Revealable Code Snippets with Bright

Earlier, I mentioned Bright
, a syntax-highlighting package designed to be used within React Server Components.

In this exercise, you'll create “revealable” code snippets, as part of a hypothetical Python tutorial:

Acceptance Criteria:

Clicking "Reveal Content" should show the relevant code snippet.
No compile or runtime errors should be present.
Please feel free to refactor / improve the code however you see fit!

Starting with an error
(info)

When you first run this project, you'll get an error about useState only working in Client Components. This is expected. Your mission is to fix the error.

Link to exercise code:

Download from Github
Work on CodeSandbox

Solution:

Solution code
(success)

 Show more
Drum Machine

In this exercise, we're going to finish wiring up a drum machine. 4 different buttons can be clicked to play a different sample. We can also mute the machine using a separate button:

(🥁 This video requires sound!)

The drum machine itself has already been implemented, using my use-sound NPM package
. Your mission is to wire up the mute button.

Acceptance Criteria:

Clicking the  icon should toggle a soundEnabled state variable
This state variable should control whether or not the 4 drum machine buttons make noise.
You're not allowed to move the existing components (eg. you can't move the <Header> element to page.js).

There's quite a bit of “stuff” in this project (I may have gotten a bit carried away with the 90’s design 😅). It might help to spend a few minutes going through the files and learn how everything is connected.

More than meets the eye
(warning)

This exercise is not as straightforward as it might seem. Due to the way Next is structured, you'll likely hit a wall, and it won't be clear how to proceed.

This is one of those exercises where the goal is to experiment. I don't expect you to be able to solve it. Failure on this one is still incredibly productive.

After you've hit the wall, I have a hint that might help get you unstuck:

 Show more

Link to exercise code:

Download from Github
Work on CodeSandbox

Solution:

If you're feeling a bit rusty when it comes to context, it might be helpful to review the “Provider Components” lesson.

Solution code
(success)

You can view my solution on Github
.

(This links to the “diff” view on Github, so you can see exactly what changes I made to the original code. You can also explore the “solution” branch
 to see all of the code.)


---

## SSR Gotchas

Source: /joy-of-react/06-full-stack-react/03.05-ssr-gotchas

SSR Gotchas

Alright, let's talk about one of the biggest gotchas with server-side rendering.

Earlier in the course, we saw how we can persist state in localStorage. For example:

'use client';

function Counter() {
  const [count, setCount] = React.useState(() => {
    return Number(
      window.localStorage.getItem('saved-count') ||
      0
    );
  });

  React.useEffect(() => {
    window.localStorage.setItem('saved-count', count);
  }, [count]);

  return (
    <button onClick={() => setCount(count + 1)}>
      Count: {count}
    </button>
  );
}

This works fine in a client-side-rendered app (eg. with Parcel), but it blows up when we do this sort of thing in a Client Component in Next, or any other SSR framework.

Do you see the problem? If not, spend a moment or two thinking about it. Why might this break if we try to run this code on the server?

A hint?
(info)

If you're not sure what the problem is, I'll give you a hint, by showing you what the error message would be.

Here it is:

 Show more

In order to initialize the count state variable during the first render, we run the following code:

window.localStorage.getItem('saved-count');

Here's the problem: There is no window object on the server.

It's a bit weird to think about, but when we server-side-render a React component, that first render happens in a “headless” environment. In Node.js, there is no browser window. There is no DOM.

And even if Node.js did have a fake window object, window.localStorage is designed to read/write data on the user's device. Our Node.js server can't possibly know which value is saved locally on the user's phone or computer!

As a result, Node.js won't be able to complete the server-side render, and it'll serve up a blank HTML file. We've lost all the benefits of SSR!

This is one of two very common footguns? with Server Side Rendering:

Trying to access “browser stuff” on the server.
Hydration mismatches.

Let's get some hands-on practice with this stuff. I've created a Next project with this problematic code:

Download from Github
Work on CodeSandbox

When you try to run a development server, you should see an error in the terminal:

Spend a few moments seeing if you can fix this problem. You may run into additional confusing errors. That's OK! I'll explain everything in the video below, but my explanation will be clearer and more memorable if you take 5-10 minutes to experiment first.

After you've taken a few moments to experiment, check out this video, where we'll explore the issue in depth:

Video Summary

Here's the new “Hydration visualization” showing what happens when there's a mismatch:

Static
Interactive
Start Hydration

(This visualization shows the best-case scenario, where React is able to bend the DOM into the right shape; this isn't always the case, however!)

We're not done yet!
(warning)

In this video, we solve the most-immediate problem, but our solution isn't yet ready for prime-time!

Be sure to continue on with this lesson, where we explore a “two-pass” approach that is much more robust and production-ready.

Two-pass rendering

In the video above, we solve our problem by setting a default value of “0”. This creates a flicker, since the count flips to the saved value after hydration:

I see this sort of thing all the time on the web. Most commonly, websites will show the “logged out” state for the first second or two, before flipping to the correct logged-in state.

For example, The Guardian:

Or Airbnb:

The fundamental challenge here is the same: When we do the first render, we don't have all of the information we need. And so, we pick some sort of “default” state. Airbnb and The Guardian, for example, decide to assume the user is not logged in.

I think there's a better approach though. Let's take a lesson from cereal manufacturers.

I noticed something while I was at the grocery store. The expiration dates are printed separately, after the fact:

Cereal boxes are produced in bulk, potentially months in advance, possibly contracted out to a different company. When the boxes are first printed, we have no idea when the cereal in that particular box will expire. The cereal probably doesn't even exist yet!

And so, we leave a blank blue rectangle which will eventually show an expiration date.

Then, when the cereal has been produced and has been packed into the box, we can stamp on the particular expiration date for each box.

I call this a two-pass strategy. First we print the generic parts, the cultural-appropriation leprechauns and the talking bees. Then, when we have the specific information for each box, we do a second pass and fill in those details.

This is my preferred stategy for these types of situations. Rather than render something which is potentially wrong (like the number 0 in our Counter button), what if we render a placeholder?

For example, why not render a loading spinner inside our button, for that first render?

Here's what this looks like in code:

'use client';
import React from 'react';

import Spinner from '../Spinner';

function Counter() {
  const [count, setCount] = React.useState(null);

  React.useEffect(() => {
    const savedValue = window.localStorage.getItem('saved-count');

    setCount(savedValue ? Number(savedValue) : 0)
  }, []);

  React.useEffect(() => {
    if (typeof count === 'number') {
      window.localStorage.setItem('saved-count', count);
    }
  }, [count]);

  return (
    <button
      className="count-btn"
      onClick={() => setCount(count + 1)}
    >
      Count:{' '}
      {typeof count === 'number' ? count : <Spinner />}
    </button>
  );
}

export default Counter;

We initialize the count variable to null. In that first pass, we don't yet know if the user has a saved value or not, and so we aren't ready to show any number.

Inside the <button>, we render count if it's a number. Otherwise, we show a loading spinner.

After hydration, the effect runs. We check if we have a saved value. If so, that becomes the new value for count. Otherwise, we set it to 0. Either way, count becomes a number, and the loading indicator is swapped out for the correct value.

This feels a lot more honest to me. Instead of picking the most likely value and showing it to everyone (even when it's not the correct value), we're letting folks know to hang on a sec while we update the UI.

Give it a shot!
(info)

This Spinner component has been provided in the repository you downloaded! I'd encourage you to apply this change to your local copy, to see this new flow for yourself. 😄

But it's a Client Component!
(warning)

Given that Counter is a Client Component, shouldn't we be able to access the window object right inside the render? Since this component only renders on the client?

This is one of the most common gotchas with React Server Components. Despite their name, Client Components do run on the server, during Server Side Rendering.

For more information, check out the “React Server Components” lesson.


---

## SSR Exercises

Source: /joy-of-react/06-full-stack-react/03.06-ssr-exercises

SSR Exercises

Alright, let's get some practice!

Check out the following Git repository, which includes three SSR-related exercises:

Download from Github
Work on CodeSandbox
Clock

Earlier in this course, we built a clock! In this exercise, we'll adapt that code so that it works in a server-side rendering context.

Acceptance Criteria:

There should be no errors.

Getting started:

You'll find the files for this exercise in /src/app/exercises/01-clock.

Once you've started a dev server with npm run dev, you can visit localhost:3000/exercises/01-clock to view the app in-browser. If you're using CodeSandbox, you can append /exercises/01-clock to the URL shown in the dev:3000 pane.

Solution:

Solution code
(success)

 Show more

More information about suppressHydrationWarning
(info)

If you'd like to learn more about this escape hatch, you can read a bit more about it in the React documentation
.

Neighborhood Shop

This next exercise features a checkout flow for an e-commerce shop:

Your mission is to persist the user's cart in Local Storage, so that their cart isn't lost when refreshing the page. Your approach should be SSR-compatible, using the techniques we learned in the previous lesson.

You'll find the files for this exercise in /src/app/exercises/02-checkout.

Acceptance Criteria:

A user's cart should not be lost when refreshing the page.
The user should never be lied to about their cart. If they have saved items, they shouldn't see "Your cart is empty", not even for a second.
Instead, you can show a loading indicator. You'll find a suitable component in /src/components/Spinner.
There should be no hydration-related errors, and no errors inside the server terminal.
You'll need to tweak code in multiple files. Don't be afraid to restructure the provided code!

localStorage gotchas
(warning)

This is another one of those exercises that relies on the Local Storage API. As a result, you might run into some baffling issues.

Please refer to the Local Storage Troubleshooting Guide
 if you run into any trouble, including cryptic error messages like "undefined" is not valid JSON.

Solution:

Solution code
(success)

 Show more
Artist Interview

Finally, we'll tackle a responsive interview layout.

This page has an “About the Artist” sidebar. This sidebar is intended to be hidden on smaller devices. The current implementation, however, is not SSR friendly. Your job is to fix it.

You'll find the files for this exercise in /src/app/exercises/03-interview.

Acceptance Criteria:

The initial code has a hydration mismatch on desktop/tablet window sizes (>500px). Your main task is to remove the mismatch.
No other errors should be thrown, on the server or the client.
The sidebar should not be visible when the window is less than 500px wide.

No package necessary
(info)

This exercise uses a dependency we haven't seen before, react-responsive. A reasonable instinct might be to dig through this package's documentation, to see if it's misconfigured.

I'll save you some time: The ideal solution doesn't use this package, or any other NPM package. This exercise can be solved using the fundamentals: HTML, CSS, and JS.

Solution:

Solution code
(success)

 Show more

---

## Routing

Source: /joy-of-react/06-full-stack-react/04-routing

Routing

In the late 1980s, a computer scientist working at CERN?, Tim Berners-Lee, had a novel idea: Hypertext, but on the internet.

“Hypertext” is a document format that includes “hyperlinks”, shortcuts that you can use to jump from one document to another. There have been many implementations and variations, but the core idea is that each individual document can contain links to other documents, allowing users to jump around as they wish.

Hypertext has been around for a long time. It goes back to an academic paper published in the 1940s, and would become a core part of Doug Engelbart's 1968 talk, commonly known as the “Mother of All Demos”
!

When the internet came along in the early 80s, it wasn't immediately obvious that Hypertext was the ideal interface for sharing information online. Instead, people communicated using:

FTP (File Transfer Protocol), to upload/download files from a particular machine.
SMTP (Simple Mail Transfer Protocol), to send/receive email.
NNTP (News Network Transfer Protocol), for newsgroups and online discussion.

Tim Berners-Lee was the first to realize the potential of using Hypertext on the internet. Instead of linking dozens of documents on our local machines, we could link billions of documents across the world. He came up with a new protocol, HTTP (HyperText Transfer Protocol), and the rest is history.

All of this to say, links are the “killer feature” of the web. If you're building any sort of significant project, you need to be able to construct multiple pages and link between them.

In these lessons, we're going to dig deeper into how routing works in Next. We'll learn about the clever tricks that Next does to improve performance, see how to move people programmatically from one page to another, and even see how to dynamically generate pages based on the URL.

The history of Hypertext and the web
(info)

I know all of this stuff because I've been reading Tim's book, Weaving the Web
. It's a fascinating look at how the World Wide Web was created.

I'd also recommend checking out Jakob Nielsen's “The History of Hypertext”
.


---

## Page Transitions

Source: /joy-of-react/06-full-stack-react/04.01-page-transitions

Page Transitions

So, we've seen how to create multiple routes in Next, by creating page.js components and placing them in subdirectories.

We haven't yet seen how to connect these routes with links!

This is one of those topics that seems simple on the surface, but there's actually an incredible amount of sophisticated engineering involved. In this lesson, we're going to go deeper into how routing in Next works.

Video Summary

You can poke around with the code from this video on Github:

github.com/joy-of-react/next-routing-demo

There's some other stuff in there, which'll be covered in the lessons ahead. 😄

Credit where credit is due
(info)

When I worked at Gatsby (a React-based static site generator), I was privy to some of the work my co-workers were doing, making our client-side router accessible to folks who use screen-readers.

They did a ton of research and user testing to make sure we were building a fully accessible router. I strongly suspect that their work influenced the direction that Next took with <next-route-announcer>.

Huge props to Marcy Sutton, Madalyn Parker, and everyone else who did this research/testing. You can read more about their work on the Gatsby blog
.

Outdated resources!
(warning)

In earlier versions of Next, the <Link> component was designed to wrap around the anchor tag:

<Link href="/about">
  <a>About page</a>
</Link>

Starting in Next 13, this API has been deprecated; <Link> is now a drop-in replacement for <a>. If you see any tutorials/guides that nest the anchor inside <Link>, it means it's outdated.


---

## Programmatic Routing

Source: /joy-of-react/06-full-stack-react/04.02-programmatic-routing

Programmatic Routing

In most cases, the <Link> component is the best way to get folks from one page to another. Users are familiar with hyperlinks, after all!

Occasionally, however, we might wish to bring the user to a new page programmatically. For example, maybe they submit a contact form, and we want to take them back to the homepage:

For programmatic navigation, we can use the useRouter custom hook:

'use client';
import React from 'react';
import { useRouter } from 'next/navigation';

function ContactPage() {
  const router = useRouter();

  function handleSubmit(event) {
    event.preventDefault();

    // ✂️ Send data to server

    router.push('/');
  }

  return (
    <form onSubmit={handleSubmit}>
      {/* ✂️ Form stuff here */}
    </form>
  );
}

We call router.push with a new URL — in this case, we're taking them back to the homepage. This is equivalent to them clicking a <Link> tag — it uses the same optimized transition, no need to download a new HTML file.

It's called “push” because it pushes the new URL onto the history stack; after the transition, the user can use the browser's “back” button to go back to the contact page.

For more information on all the cool programmatic-routing stuff we can do in Next, check out the official docs
.

Not that router, that router!
(warning)

Confusingly, there are two separate routers included in Next:

// 🛑 Incorrect:
import { useRouter } from 'next/router';
// ✅ Correct:
import { useRouter } from 'next/navigation';

next/router is used in the "pages" directory, the original Next router. Everything we're learning about in this module uses the newer “App Router”, located in next/navigation.

As I write this, most of the tutorials and guides out there are still based on the older “pages” router. If you see any references to next/router, it means you're reading an outdated resource!


---

## Dynamic Segments

Source: /joy-of-react/06-full-stack-react/04.03-dynamic-segments

Dynamic Segments

Video Summary

Add Note

The code from this video can be found on Github:

github.com/joy-of-react/next-routing-demo

You can also learn more about Dynamic Segments in the Next.js documentation
.

Update in Next 15
(info)

As of Next 15, params and searchParams need to be await-ed:

async function ProfilePage({
  params,
  searchParams,
}) {
  const { profileId } = await params;
  const { campaign } = await searchParams;

  const profile = await getProfileInfo(profileId);
}

This change has been made to the next-routing-demo repo
.

If you have older projects that don’t use the await keyword, you can use the official codemod
 to automatically update your code. I used it on my blog, and it works surprisingly well!


---

## Exercises

Source: /joy-of-react/06-full-stack-react/04.04-routing-exercises

Exercises

Both of the exercises on this page use the same project:

Download from Github
Work on CodeSandbox
Screensaver

Remember in the 90s, it was common for TVs to have "bouncy logo" screensavers?

In this exercise, we're going to revive it!

Inside /src/app/exercises/01-screensaver, you'll find a <ScreenSaver> component. The bouncing-around logic has already been implemented. Your mission is to allow the user to change the color using routing:

Acceptance Criteria:

When the user visits a route like /exercises/01-screensaver/hotpink, a <ScreenSaver> component should be rendered using the color specified (hotpink).
The /exercises/01-screensaver route should be updated so that it includes a list of links, so that users can choose a color. Feel free to pick your favourite named HTML colors
!
All 147 named colors should be supported (not only the 3-4 colors that are explicitly linked to).

Solution:

Next 15 update
(warning)

The solution video above was filmed using an earlier version of Next. With Next 15, params need to be await-ed:

async function ScreenSaverExercise({ params }) {
  const { color } = await params;

  return (
    <main className="screen-saver-wrapper">
      <ScreenSaver color={color} />
    </main>
  );
}

This fix has been added to the solution on Github
.

What’s the deal with (home)?
(info)

In this exercise, the homepage route is nested within a directory named (home).

This is known as a Route Group
 in Next.js. By wrapping the directory name in parentheses, we omit it from the URL, so it's the same thing as having the page.js right inside /src/app. I'm doing this purely for organizational purposes, to label this route as the homepage.

In hindsight, I probably shouldn't have used this feature here, since we don't cover it in the course. Sorry for any confusion!

Solution code
(success)

View the solution on Github
.

Flash messages

Earlier, we saw how to programmatically redirect the user on form submission:

There's an important UX feature missing from this, however: there's no confirmation message! We aren't confirming for the user that their message was received.

A common pattern in full-stack applications is to use flash messages. A flash message is a notification that shows up on navigation, usually to provide additional context about the route change that just happened.

For example, we can use a flash message here to confirm that the message was sent:

In this exercise, you'll use the Toast component we built in the second project. By strategically creating a new toast as the user is redirected, it effectively becomes a flash message!

The relevant pages are /exercises/02-flash-messages and /exercises/02-flash-messages/contact.

This is a tricky one!
(warning)

This is one of those exercises designed to stretch a bit beyond what might be comfortable. We haven't really seen how to do this sort of thing yet!

Please don't feel discouraged if you can't solve this problem.

Acceptance Criteria:

Submitting the contact form should redirect the user to the exercise homepage (/exercises/02-flash-messages).
Upon redirection, a confirmation message should be shown, using the Toast component. You should also make use of the ToastShelf and ToastProvider components from the previous project.
You don't have to use localStorage or cookies or anything like that. React context alone should be sufficient.

Solution:

Solution code
(success)

View the solution on Github
.

Server Actions and Route Handlers
(info)

In this exercise, we didn't solve the core problem of actually sending the user's message to our back-end.

There are a couple of ways we could do this in Next. They're both beyond the scope of the course, but I wanted to mention them in case you wanted to do your own research.

The first would be to set up an API endpoint using Next, and to send the data to that endpoint using the Fetch API. You can use Route Handlers
 to set up those API endpoints.

Another option is to use the brand-new Server Actions
 feature. It's very early days; as I write this, the feature is still in Alpha. I haven't actually used it myself yet. But I suspect once this becomes a stable part of Next, it'll be a delightful way to solve this problem!

---

## Next's Metadata API

Source: /joy-of-react/06-full-stack-react/05-metadata

Next's Metadata API

Video Summary

Next 15 update
(warning)

In Next 15, params need to be await-ed. This is true within the generateMetadata function as well:

export async function generateMetadata({ params }) {
  const { userId } = await params;

  const user = await db.getUser(params.userId);

  return {
    title: `${user.name}’s profile`,
  };
}

You can learn much more about the Metadata API in the Next docs
.

Duplicated work?
(info)

With the solution we've wound up with, you might've noticed that we're doing the same chunk of work twice:

export async function generateMetadata({ params }) {
  const { profileId } = await params;

  const profile = await getProfileInfo(profileId);

  return {
    title: `${profile.name}’s profile`,
  };
}

async function ProfilePage({ params, searchParams }) {
  const { profileId } = await params;

  const profile = await getProfileInfo(profileId);

  // ✂️ Content removed for brevity
}

Whenever someone visits this page, we wind up fetching their data two separate times!

To improve performance, we can take advantage of the React Cache API. We'll learn more about this later in this module.


---

## Creating, Building, Deploying

Source: /joy-of-react/06-full-stack-react/06-creating-building-deploying

Creating, Building, Deploying

In this section, we'll cover everything you need to know to start a new project, everything from generating the initial files to publishing your app on the internet.

Specifically, we'll look at:

Bootstrapping new projects with create-next-app.
Using import aliases to get rid of all those ../'s.
Generating a production build, and how to run it locally.
Analyzing our bundles, to understand what they consist of.
Deploying our application, to our own custom domain.
Automatically generating preview builds for work-in-progress branches.

Let's get into it!


---

## Starting a New Project

Source: /joy-of-react/06-full-stack-react/06.01-creating

Starting a New Project

Video Summary

You can learn more about create-next-app on NPM
.

Pre-requisites
(info)

This video assumes that you already have Node/NPM installed, and that you're comfortable using the command line. If you're feeling confused by this video, check out these resources from the “Tools of the Trade” reference module:

The Terminal
Node.js and NPM

---

## Import Aliases

Source: /joy-of-react/06-full-stack-react/06.02-import-aliases

Import Aliases

One of the downsides to file-based routing is that we tend to wind up with sprawling directory structures. It's not uncommon to see stuff like this:

// /src/app/profiles/[:profileId]/page.js
import React from 'react';

import { getProfileInfo } from '../../../helpers';

async function ProfilePage({ params }) {
  // Stuff here
}

export default ProfilePage;

As you might've already discovered, having to count the number of ../ gets pretty annoying 😬. It also makes it hard to restructure things and move files around.
*

Fortunately, there's a solution: import aliases.

This comes built into Next, when you use create-next-app. It looks like this:

import { getProfileInfo } from '@/helpers';

@ is an alias for our root directory, src. This makes the import paths absolute instead of relative; we can move this file anywhere in the codebase, and the import will still resolve correctly.

We can also customize the symbol we want to use as the import alias. That's what this question is about, during the initial project creation flow:

? Would you like to customize the default import alias? › No / Yes

If you select “Yes”, you'll be prompted to select a new character. In practice, most devs stick with the default. The only other semi-popular option I've seen is the dollar sign ($). I've also heard from some folks who use the tilde (~).

Configuring the alias
(info)

When you bootstrap a new project using create-next-app, you'll be given the choice of customizing the alias. But what does this actually do? And how might we edit our alias later?

This setting lives in a file called jsconfig.json:

{
  "compilerOptions": {
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}

This file, jsconfig.json, is used by IDEs like VS Code to enable things like auto-completion. Rather than have a duplicate setting inside next.config.js, the Next team smartly decided to use an existing industry standard.

If you want to pick a different alias for your Next project, you can edit it here. For example, if I wanted to use $ for the alias, I would make the following tweak:

{
  "compilerOptions": {
    "paths": {
      "$/*": ["./src/*"]
    }
  }
}
Downsides?

Import aliases offer a pretty big quality-of-life improvement, especially when working with Next. That said, that benefit isn't free. There's one significant trade-off that may be worth considering.

Import aliases aren't actually a thing in JavaScript. This is custom syntax, implemented at the bundler level; tools like Webpack will essentially do a find-and-replace for us during the build, filling in the real paths.

This can cause problems if we have other tools that need to work with these files. For example, if you have a unit testing library and you try to import some of these files, that tool will throw an exception, since it won't know how to resolve the file path.

A few years ago, this was a really common issue. Fortunately, nowadays, most tools support import aliases. Usually, it's a quick matter of checking the docs for the project in question, and figuring out how to configure it to use the same alias as the Next app.

And so, I think import aliases are safe to use for most developers, but if you happen to use niche or obscure JS tooling, it may be worth checking for compatibility first.


---

## Building for Production

Source: /joy-of-react/06-full-stack-react/06.03-building

Building for Production

Throughout this course, we've been talking about the difference between “development mode” and “production mode”.

In “development mode”, React and Next are both optimized for the developer experience. We get things like:

Better error messages.
Improved integration with the React developer tools
React Strict Mode, helping us catch edge-case issues by doing things like running our effects twice.

By contrast, “production mode” is optimized for the user experience. Essentially, it's a slimmed-down mode focused on performance. The JS bundles become way smaller, and React's render performance becomes much better.

Occasionally, it's worth checking to see how our application performs in “production mode”. This will give you a much more accurate picture of what it's like to use your application.

In this lesson, we're going to talk about how to build our applications for production, and how to run the production build locally.

Video Summary

To summarize the most important bits:

You can generate a production build by running npm run build.
You can run a local production server by running npm run start.
Take care to stop your dev server before running either of these commands.
Port conflicts

Both the development server and the production server default to running on port 3000.

The development server is flexible. If port 3000 is taken, it'll try 3001. Then 3002. It keeps going until it finds an available one:

The production server, annoyingly, is not as flexible. It'll complain if something is already running on the default port:

If something else is already running on port 3000, the process throws an error, rather than trying the next available port.

As mentioned, you want to stop the dev server before starting a production server, and so this won't be an issue if you're only working on a single project. But if you work on multiple projects at the same time, you'll run into this issue.

For example, when I'm working on this course platform, I run the dev server on port 3000. Then, I start my blog, which runs on port 3001. If I want to check how my blog runs in production, I'll kill the blog's dev server, but the course platform is still running on 3000.

Fortunately, there's a workaround:

// package.json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "start:local": "next start -p 4004",
    "lint": "next lint"
  },
}

I've created a new NPM script, start:local. It does the same thing as the standard start script, but it specifies a custom port using the -p flag. In this case, I've chosen port 4004, but in practice, I pick a different number for each project, to avoid conflicts.

Why not edit the existing start script? As we'll cover in the next lesson, the start script will also be used when we deploy the site, on the server. If we edit this script, we might break our deployments. So it's better to create a separate script we can use exclusively on our local machines.

Analyzing our bundles

Video Summary

You can learn more about this tool by visiting the NPM package page:

@next/bundle-analyzer

Honestly, I don't use this tool super often, but whenever I do use it, I find it incredibly useful. I think it's a good idea to check it every few months, to look for any low-hanging fruit.

Important note for Windows users
(warning)

The process for setting environment variables like ANALYZE is a bit different on Windows.

First, you'll need to install the cross-env NPM package:

npm install cross-env

Then, you'll update the package.json script to use it:

{
  "name": "sample-next-app",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "analyze": "cross-env ANALYZE=true npm run build",
    "lint": "next lint"
  }
}

Everything else should be the same. Sorry for any confusion!

Assessing NPM packages

Let's suppose we're building an app that requires a rich-text editor. We go looking on NPM, and come up with several options: draft-js
, react-rich-text-editor
, react-quill
, etc.

One of the important questions to answer as part of this process is: how big is the library? How many kilobytes will it add to our bundles?

My tool of choice for this is Bundle Phobia
. Plug in the name of the package, and it'll show you how many kB's it would add to your bundle.

Now, it's not 100% accurate. It's impossible for any tool to know exactly what sort of impact a dependency will have in your specific application. There are a few reasons for this:

You might already be using some of the sub-dependencies needed by the package. If react-quill depends on left-pad but you're already using left-pad in your app, that dependency will be reused.
On the other hand, some packages require peer dependencies that are not counted by Bundle Phobia.
Some modules support “tree-shaking”, which means that you only pay for the specific parts of the library you use. For example, react-feather is 26kb if you use every single icon, but on my blog, it only adds 1kb-6kb, depending on the route.

And so, if you really want to know how a given package will impact your bundle size, you'll need to do the bundle-analyzer process described above, running a build with/without the dependency to see the difference. But I've found that Bundle Phobia
 is a great way to get a rough answer with a lot less effort.

---

## Deploying

Source: /joy-of-react/06-full-stack-react/06.04-deploying

Deploying

Alright, so you've created a local project, and you want to show it to the world! Let's learn how to ship it.

Working with full-stack frameworks like Next can be a bit tricky. We can't really use “off the shelf” hosting companies like GoDaddy; these services only work if you have a bunch of static HTML/CSS/JS files, but with Next, we need a live-running Node.js server, so we can do our on-demand server side rendering.

A few years ago, this was a really daunting challenge. Essentially, we'd need to provision a Linux server, set up SSH, get an SSL certificate, learn how to configure nginx, figure out a deployment strategy, the list goes on.

Fortunately, it's way way easier nowadays. Several companies have made it their mission to make this stuff as simple as possible.

Here are some examples of these sorts of companies:

Netlify
Vercel
Render
Heroku

In this lesson, we’ll explore how to deploy your Next.js process on Netlify, which is my current top choice. The instructions should be quite similar on other providers.

An earlier version of this lesson used Vercel instead of Netlify. If you’d prefer to deploy on Vercel, you can check out the old version of this lesson.

Git deploy triggers
(warning)

Modern providers like Netlify use a Git-based workflow; when you push your project to the origin (eg. Github, Gitlab), your project will automatically be deployed in the background.

If you’re not familiar with Git, you can learn the basics here:

Introduction to Git and Github

Certain providers like Netlify also provide the option to upload your site by dragging and dropping
, but unfortunately, this is meant purely for pure HTML/CSS/JS sites. It doesn’t seem to work for Next.js applications.

Managed vs. self hosting

Before we go through the step-by-step process of deploying with Netlify, I want to quickly answer the question: Should we use a managed hosting provider, or do it ourselves?

Netlify, Vercel, Render, and Heroku are all examples of “managed” hosting providers. These services offer a layer of abstraction that sits above the actual hardware.

We don't have to use one of these services, we could manage the hosting ourselves. The classic way to do this is to rent a VPS? and set everything up from scratch. A more modern alternative is to use a cloud infrastructure provider like AWS Lambda.

But these options are hard. It's an entire engineering discipline ("DevOps"). Speaking as someone who has gone the “classic” route before, there are so many things we have to consider. Things like ongoing maintenance (updating software to patch security vulnerabilities) and scaling (provisioning additional servers and a load balancer).

If we use Amazon Web Services or Google Cloud, we can avoid some of this pain, but these services are notoriously difficult to learn. There are “AWS Certification” programs that take months to complete.

Modern managed providers like Netlify are built on top of cloud infrastructure providers like AWS and Google Cloud. They wrap over these complex services and provide a super-user-friendly way to use them. That's their main value proposition.

They do charge for this service, of course. At scale, services like Netlify or Vercel charge more than the underlying cloud infrastructure providers like AWS. And, in general, AWS / Google Cloud are more expensive than managing your own provisioned server.

That said, almost every provider has a free “hobby” tier, and these tiers are usually generous enough for most non-professional use cases. And even for commercial projects, the costs can be surprisingly low. My blog, for example, gets a couple million pageviews a year and can be hosted for about $20/month.

Watch out for that curve!
(info)

As generous as this pricing structure is for small-to-medium projects, I should warn you that pricing scales up dramatically after the 1TB mark.

For example, here’s what pricing looks like based on bandwidth usage for Vercel’s “Pro” plan:

Netlify's pricing model is nearly identical: $20 for the first 1TB, and then $55/100GB beyond that.

Both Vercel and Netlify have “Enterprise” plans as well, but my understanding is that you need to be spending thousands per month before qualifying for these plans.

These are all pretty big numbers, and likely not anything you'd need to worry about for a while when starting a new project. But I wanted to point it out, because it can become significant in certain cases.

Learn more about pricing:

Vercel pricing
Netlify pricing
Our first deploy

Alright, enough jibber-jabber! Let's get to work.

First, we need a project we want to deploy. I'm going to use the “hello-next” project
 we saw earlier in the course.

You'll need your own copy of this project on Github. The easiest way to accomplish this is to “fork” it. Click this little button:

You should wind up with your own personal copy of the project:

This is the project I'll use in this lesson, but you should feel free to use any React project you want! It really doesn't matter, the process is the same regardless.

Now that we have our project, we're ready to get started.

Netlify Onboarding

Visit the signup page
, and go through the onboarding flow.

After answering some basic questions, you’ll be directed to this page:

Not quite what you see?
(info)

Companies like Netlify are constantly iterating on their product. As you follow along with this lesson, you might notice that there are some discrepancies between what you're seeing and what's shown in these screenshots.

If you’re not sure how to proceed, feel free to ask on Discord!

We first need to connect our Github account to our new Netlify account, so that we can select our project and have it automatically deploy when that project is updated.

Click "GitHub" (or whichever Git provider you use), and follow the instructions in the popup window to complete the authorization.

Once connected, you should see a list of your Github projects in the Netlify application. You can filter to find the project you’d like to deploy:

Click on the project. Netlify will examine it, and determine that it’s a Next.js project. We shouldn’t need to adjust the build settings at all. Click the big green “deploy” button:

This creates a new Netlify project, and brings us to the main Netlify dashboard, showing a deploy in progress:

With super-small projects like this, it should only take a minute or two to deploy. You should see a success message pretty quickly!

Build errors
(info)

If your build doesn’t succeed, it’s likely because Next.js was unable to successfully complete a production build.

To troubleshoot this, run a local production build. Once you get it working locally, it should also work on Netlify.

Netlify generates a unique ID for all projects. In my case, that ID is super-tartufo-2c6d8c. This ID is used to construct a production URL for our project. If we visit that URL, we see that our project has indeed been successfully deployed! 🌈

Updating the project

Let's talk about how we deploy changes to our project.

Because we've synced our Netlify project with our Github repository, our application will automatically be updated whenever we push changes to Github.

As a silly example, suppose I make the following change:

function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        {children}
        <footer>Copyright Josh Inc.</footer>
      </body>
    </html>
  );
}

I create a new Git commit with this change in the main branch and push it to Github. Netlify detects this change and immediately starts a new deploy. We can see this on the “Deploys” tab:

Sure enough, after another minute or two, our new footer can be seen in the live version of our app!

If you're already using Git to manage your project, it's zero extra steps to deploy your changes. Whenever you push your code to Github, Netlify will rebuild your application, and the new version will be up within a minute or two.

Branch deploys

Let's talk about one of the coolest features that Netlify offers: branch deploys.

When we added this project, Netlify inferred that the “production” branch is main. When we commit to the main branch, Netlify will re-deploy our project, launching a new version of the site.

But what if we want to deploy a different branch? We don’t want this change to go live for our users, but it would be super helpful if Netlify could create an additional deployment, so that we can test our changes in a production environment, share our work with the design team, stuff like that.

This feature has to be enabled explicitly. Go into the project settings, and find the Branches and deploy contexts section:

Click “Configure”, and then change “Branch deploys” to “all”, and save:

Now, when you push a change to Github under a different branch, Netlify will automatically start a new deploy:

Click on that deploy, and scroll down to find the “Preview” button:

This will open our new deployment, revealing the randomly-generated URL:

This feature is sometimes called “deploy previews” on other hosting providers. It’s a wonderful feature, allowing us to spin up disposable versions of our site to test things in a duplicated production environment.

Build minutes
(warning)

One thing I should point out: Netlify plans come with a finite number of “build minutes”. This is the amount of time each month that Netlify will spend building and shipping our production deployments. Like those old cell phone plans that limited how much time you could spend in calls.

On the Free plan, we get 300 build minutes a month. This should be more than enough for most hobby use cases: it only takes about 1m30s to build our site, so we can do this ~200 times per month. But branch deploys do count towards this total.

So, if you’re the type of person who pushes your project to Github several times per day, you may wish to leave the “branch deploys” feature disabled. Otherwise, you may find that your build minutes run out pretty quickly!

The “Pro” plan, which is $19/month, bumps this limit up to 25,000 build minutes per month, which is quite a bit (to put this in context, there are only roughly 43,200 minutes per month in total!).

Custom domains

As we've seen, Netlify generates custom domains we can use, for both branch deploys as well as our main production deploy. This is convenient for hobby projects, but we probably don't want to launch a serious project with a .netlify.app domain!

Suppose you own a domain you want to use, hello-next-josh.com. Let's look at how to wire it up so that this domain points to our new project.

In the sidebar, select “Domain management”, and click “Add domain”:

You’ll be prompted to enter the domain you wish to use.

If the domain hasn’t been registered, you’ll be able to register it through Netlify. Otherwise, you’ll need to edit the DNS settings to point your domain to Netlify.

Every registrar has its own process for editing DNS, but you should be able to find instructions online. You can find the specific DNS values by clicking the “Awaiting External DNS” link in the Domain Management panel:

It can take a few hours for DNS servers all over the world get word of your update. Soon enough, however, your domain will be pointing to your Netlify deployment!

Netlify will automatically generate and apply an SSL certificate. Your site will use HTTPS without you needing to do anything at all. ✨

Buying domains through Netlify
(info)

If you don't already own the domain you wish to use, and it's not registered by someone else, you can choose to purchase this domain directly through Netlify.

I haven't personally done this, because I like having some separation between my hosting provider and my domain registrar. If anything happens with Netlify (significant outage, bankruptcy, hacking attack, whatever), I can deploy my project somewhere else, and point the domain to this new location. If Netlify also owns the domain and all of their services are down, we lose this option.

So, while it might be a bit paranoid, my recommendation is to register your domain somewhere else. That way, you can point the domain to a new host if necessary.

---

## Rendering Strategies

Source: /joy-of-react/06-full-stack-react/07-rendering-strategies

Rendering Strategies

One of the very first things we did with Next was to build a “server timestamp”. We did this by rendering a date in the footer of our layout.js component, which is a Server Component:

If you try and deploy this project, however, something funky happens:

Notice that the timestamp isn't changing, even when I refresh the page?

Here's the deal: When we're in “development mode”, Next always uses a “dynamic” SSR strategy. Each route is rendered on-demand, in response to the request.

In “production mode”, however, things work differently.

Earlier, we talked about several different flavors of SSR. We saw three different strategies:

“On-demand” SSR, where the HTML is generated per-request.
“Static Site Generation”, where the HTML is generated for every route when the app is built.
“Incremental Static Regeneration”, where each route is rendered on-demand for the first request, but the HTML is saved for future requests.

In the past, frameworks had to pick one strategy and use it for every route in the entire app. With Next, however, it uses different strategies depending on the route.

And so, for our “server timestamp” example, everything works fine in development, because it's doing the SSR dynamically, on-demand. But when we deploy the app, it uses the production build. And, for this particular route, Next opts for a “static” rendering strategy. The HTML is generated during the build, and the footer's timestamp is frozen in place.

When we build our app, Next tries to figure out the most optimal strategy for each route. The default behaviour is to use a “static” strategy, since it's more performant. It flips to a “dynamic” strategy if we're doing something that can't be calculated during the build (eg. trying to read the cookies for the request, accessing request headers, etc).

To summarize:

In development, Next always uses a “dynamic” on-demand SSR strategy
In production, Next will try to pick the optimal strategy on a route-by-route basis.
The default strategy is “static”, pre-generating all of the HTML during the build process.
Using certain Next APIs will cause Next to switch to a “dynamic” strategy for a particular route. For example, if we try to access the cookies, Next knows it needs to do the SSR dynamically, for every request.
Because our “Server timestamp” example doesn't use any of these APIs, Next can't tell that we want it to be done dynamically.

The good news is that we don't have to rely on Next to correctly infer our intention. We can explicitly tell it which strategy to use!

Switching rendering strategies

We can instruct Next to use “on-demand” SSR for this route by exporting a special variable:

// src/app/layout.js
export const dynamic = 'force-dynamic';

function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        {children}
        <footer>
          Page rendered on{' '}
          {new Date().toLocaleString()}
        </footer>
      </body>
    </html>
  );
}

We can export this dynamic variable in any page.js or layout.js file. There are several valid values:

auto (default) — Next will try and select the most optimal rendering strategy based on the code.
force-dynamic — Next will use “on-demand” server-side rendering.
force-static — Next will do the server-side rendering during the build, like a static site generator.
error — Similar to force-static, but will throw an error if the code tries to do dynamic things (eg. tries to access cookies).

Note that you won't always need to set this value. In many cases, Next will correctly select the best approach. This configuration option is provided as an escape hatch, in situations like this where Next can't infer that it needs to switch to a dynamic rendering strategy.

You can learn much more about this stuff in the Next docs
.

Dynamic Segments

Earlier, we saw how to use dynamic segments to create “catch-all” routes that will match a wide variety of URLs, capturing the value as a variable and making it available to our components.

The example we used was a social network, where the URL took the format /profile/[profileId].

When we use dynamic segments, Next will automatically switch to an “on-demand” rendering strategy.

This makes sense, when we think about it. With the “pre-compiled” SSG? strategy, we need to create HTML files for every possible URL, and we can't do that if part of the URL is dynamic and could be anything!

That said, there are other situations in which the universe of possibilities isn't enormous.

For example, our Screen Saver exercise. We're using a dynamic segment there, but there are only 140 named HTML colors. In theory, we could pre-render all of those HTML files at build-time, for optimal performance!

We can do this with the help of the generateStaticParams function:

import React from 'react';

import ScreenSaver from '../../components/ScreenSaver';

async function ScreenSaverExercise({ params }) {
  const { color } = await params;

  return (
    <main className="screen-saver-wrapper">
      <ScreenSaver color={color} />
    </main>
  );
}

const COLORS = [
  "AliceBlue",
  "AntiqueWhite",
  "Aqua",
  // ...
  "WhiteSmoke",
  "Yellow",
  "YellowGreen",
];

export function generateStaticParams() {
  return COLORS.map((color) => ({
    color,
  }));
}

export default ScreenSaverExercise;

Next expects generateStaticParams to return an array containing data about all valid dynamic segments. In this case, the produced array would look like this:

[
  { "color": "AliceBlue" },
  { "color": "AntiqueWhite" },
  { "color": "Aqua" },
  { "color": "Aquamarine" },
  // ...and so on, for all 140 options
]

During the build, Next will generate 140 HTML files, each one rendering the ScreenSaverExercise component with a different value for the color param, as specified by this array.

We don't have to set the dynamic constant in this case. By specifying generateStaticParams, we've given Next enough of a hint for it to use static generation.

I took the liberty of creating and deploying this project. You can check it out for yourself here:

Source code on Github
Deployed version on Vercel

You can learn much more about this function in the Next docs
.

Did it work?
(info)

You can tell if you've configured things correctly by inspecting the build output.

For example, when I deployed this screensaver app, it logged the following table:

I see individual pages generated for each named HTML color, and the filled-in circle tells me that it's using SSG. Looks great! 💯


---

## Exercises

Source: /joy-of-react/06-full-stack-react/07.01-rendering-strategies-exercises

Exercises
Fixing our Hit Counter

Earlier, we built a hit counter:

Unfortunately, this hit counter has the same problem that our “Server Timestamp” has—it works fine in development, but gets frozen in time in production.

Your mission is to update the code so that it works in production.

Link to exercise code:

Download from Github

No CodeSandbox link this time, sorry! You'll need to do this one locally, so that you can run a local build and serve in production.

Acceptance Criteria:

When running the production build (npm run build and then npm run start), the hit counter should continue to function correctly, increasing by 1 for every page visit.

Solution:

Note: We cover some new ground in this video, digging deeper into the .next directory and inspecting the build output. I suggest giving this one a watch even if you solved the exercise!

Solution code
(success)

 Show more

Failed Vercel deploys
(warning)

If you try to deploy this solution on Vercel, you'll wind up getting an error:

Error: ENOENT: no such file or directory, open '/var/task/src/database.json'

The error message tells us that the src/database.json file can't be opened because it doesn't exist. But hm, where did it go? Why doesn't it exist??

Here's the problem: To save time, Vercel doesn't automatically upload all of the files in our repository to the live server environment. It only uploads the files that it can tell are being used. It does this through a process known as file tracing.

In this situation, Vercel isn't smart enough to realize that the /src/database.json file is actually being used in production. And so, it doesn't get uploaded. When a user visits the page, the app tries to open a file that doesn't exist.

To solve this problem, we need to explicitly tell Next to include this database.json file with the deploy. We can do this by creating (or modifying) a next.config.js file, and adding the following configuration:

module.exports = {
  outputFileTracingIncludes: {
    '/*': ['./src/database.json'],
  },
};

outputFileTracingIncludes allows us to specify which files should be included on a route-by-route basis. Here, we're saying that the '/src/database.json' file should be made available for all routes (represented by the wildcard /*).

Essentially, we're telling Next: Hey, this application requires this random JSON file, please upload it along with the compiled application during deployment.

You can learn more about this configuration option in the Next.js docs
.

Note that, as mentioned earlier, this hit counter won't actually work in production, because all uploaded files are read-only; we can't edit the database.json file. You'd need to store the # of hits in a real database.

---

## React Cache

Source: /joy-of-react/06-full-stack-react/08-react-cache

React Cache

Video Summary

You can learn more about the React.cache API in the React docs
.


---

## Suspense

Source: /joy-of-react/06-full-stack-react/09-suspense

Suspense

Alright, so it's time to talk about one of the most advanced and bewildering APIs in React.

I'll be honest, for a long time, I didn't really know what Suspense was. And that's OK. The React team has long said that Suspense is a low-level feature, something built into libraries and meta-frameworks. Open-source maintainers need to learn the hard stuff, but not app developers like us.

And in fact, that's sorta how it's worked out. The new version of Next uses Suspense under-the-hood, to glorious effect. You don't need to understand Suspense at all to take advantage of it in Next!

All of that said, I like to understand how my tools work, at least at a conceptual level. And if we learn how Suspense works, it opens up some new doors for us. We can go beyond the built-in basic stuff, and do some more advanced things.

So, here's the plan:

First, I'll show you the practical benefits of Suspense. We'll see how to use it in combination with Streaming SSR to achieve truly spectacular performance.
Then, we'll see exactly how this performance is achieved, looking at the order of operations, the sequence of events.
Finally, we'll learn exactly what Suspense is and how it works.

Stormy waters ahead
(info)

There's a reason that the React team has said that developers like us don't need to understand Suspense; it's friggin’ complicated. This is arguably the trickiest stuff we cover in the entire course.

I'm going to do my best to simplify and explain it, but please don't feel bad if you find it hard to follow along.

The good news is that this is all “nice-to-have” knowledge. You don't need to understand Suspense in order to use it. And, honestly, you don't even need to use it. Many (probably most!) popular React apps don't leverage Suspense at all, and they work just fine.

---

## An Exciting New World

Source: /joy-of-react/06-full-stack-react/09.01-exciting-new-world

An Exciting New World

Video Summary

Phew, we covered a lot of ground in that one! As I mentioned in the video, don't worry if you're feeling overwhelmed: we'll learn more about how all this stuff works in the lessons ahead.

(I also recognize that I have yet to actually define “Suspense” for you; I thought it would be helpful to start with the practical implications, but rest assured, we'll get to the theory shortly!)

You can see all of the code for this project on Github
. I've committed the final solution, using Suspense via loading.js, but you can see the alternative implementations in the /alternatives directory
.

We touch on a few different Next concepts in this project. You can learn more in the Next docs:

Nested layouts
Route handlers
 (for API routes)
Using loading.js

Is SWR still useful?
(warning)

In the lesson above, we see that modern React, with Server Components and Suspense and Streaming SSR, offers exciting new ways to fetch data. You might be wondering: is there still a place for libraries like SWR / React Query in this strange new world?

Honestly, I think the jury's still out.

The stuff we saw in this video is super new. SWR is a battle-tested library that can handle a wide set of different scenarios, and it remains to be seen if all this new stuff is as flexible.

In the meantime, I definitely think it's worth understanding how to use libraries like SWR. If you're looking to get a job as a React developer, the odds are very very good that you'll be working with a client-side data-fetching library like SWR.


---

## Graphing It Out

Source: /joy-of-react/06-full-stack-react/09.02-graphing-it-out

Graphing It Out

In the previous lesson, we explored the performance implications of various data-fetching strategies using the “Performance” tab of the Chrome developer tools.

This view is powerful indeed, but it can definitely feel overwhelming. It also doesn't tell the full story, since it doesn't know what's happening on the server.

I took the liberty of creating an interactive graph that shows the flow of events across 3 different strategies:

Traditional server-side rendering.
Doing a light server-side render, and then fetching the data on the client with SWR.
The fancy new solution using Suspense and Streaming SSR.

Spend a few moments exploring these strategies in the graph. Afterwards, I'll walk you through it, and (hopefully) answer any questions you have about it!

Classic Server Side Rendering

SSR
SWR
Streaming SSR
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
Database Query

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

"Database Query" on server. Duration: 12 units of time.
"Render App" on server. Duration: 4 units of time.
Response from server. Duration: 4 units of time.
"Download JS" on client. Duration: 6 units of time.
"Hydrate" on client. Duration: 4 units of time.
Graph walkthrough

Video Summary

---

## Understanding Suspense

Source: /joy-of-react/06-full-stack-react/09.03-understanding-suspense

Understanding Suspense

In the previous two lessons, we saw how Suspense can offer dramatically-improved loading experiences. But what exactly is Suspense? What does it do? How does it work?

In order to properly answer these questions, we need to go on a bit of a journey. The annoying truth is that Suspense has been evolving within React for years and years. Suspense is actually older than hooks! In order to understand the amazing results we saw in the last lesson, we need to rewind by a few years.

I'll warn you now, this lesson won't feel super related to what we just saw, with the sneaker store. I promise it all ties in though!

Our journey starts in 2018. Andrew Clark, a member of the React core team at Facebook, shared the following tweet:

Andrew Clark
@acdlite

Here's a fun game: I call it "Count the Placeholders." Load a web page and observe how many times something pops onto the screen before the load is complete.

I'll go first. This is my favoritest example, from Facebook's Ads Manager.

10:24 PM · May 1, 2018

That's a lot of spinners!

You've probably used products like this. As each section loads, it shoves everything else out of the way, leading to a jarring and unpleasant user experience.

Unfortunately, component-driven frameworks like React tend to lead us in this direction. The whole idea with components is that we're packaging up all of the stuff for a particular part of the UI. If each component fetches its own data, we wind up in Spinner Hell.

Let's look at a quick code example, to see how this problem occurs:

function TrafficCard() {
  const { data, isLoading } = useSWR('/api/traffic', fetcher);

  if (isLoading) {
    return <Spinner />;
  }

  return <Card>{/* Stuff using `data` */}</Card>;
}

function OfferCard() {
  const { data, isLoading } = useSWR('/api/offer', fetcher);

  if (isLoading) {
    return <Spinner />;
  }

  return <Card>{/* Stuff using `data` */}</Card>;
}

function Dashboard() {
  return (
    <>
      <TrafficCard />
      <OfferCard />
    </>
  );
}

When we render the <Dashboard /> component, we start off with two loading spinners. Both TrafficCard and OfferCard make network requests to fetch their data. When that data comes through, the component re-renders with the real UI.

Here's what will happen in practice. Click the green “play” button:

Traffic
Offer

The trouble is that each component is operating independently. They both make a request for data, and when it's received, they re-render immediately.

The more data-fetching elements we have, the more potential for chaos there is. The Facebook Ads Manager app has at least 6 individual data-fetching components, and the result is something like this:

Traffic
Offer
Placements
Audience
Budget
Insights

There's a technical term for when things move around like this: layout shift. Over the past few years, we've become increasingly aware of the problems associated with excessive layout shifts.

Here's one of the most relatable videos I've ever seen, from web.dev
:

In 2020, Google created a new metric to help us measure the amount of layout shift. It's called Cumulative Layout Shift
 (CLS). If large chunks of your UI move around during the loading experience, you'll wind up with a poor CLS score.

CLS has become one of Google's “Core Web Vitals”
, the most important metrics they use when evaluating a page. It's just as important as the other metrics we've been talking about, like “Content Painted” (LCP
) and “Page Interactive” (TTI
).

Alright, so how do we fix it?

Well, we could solve this by lifting the data-fetching requests up to the parent component, so that we can “group” their loading states. Maybe something like this?

function Dashboard() {
  const {
    data: trafficData,
    isLoading: trafficIsLoading,
  } = useSWR('/api/traffic', fetcher);
  const {
    data: offerData,
    isLoading: offerIsLoading,
  } = useSWR('/api/offer', fetcher);

  // If *either* request is still pending, we'll show a spinner:
  if (trafficIsLoading || offerIsLoading) {
    return <Spinner />
  }

  return (
    <>
      <TrafficCard data={trafficData} />
      <OfferCard data={offerData} />
    </>
  )
}

In this new version, we show a spinner until both network requests have resolved. Here's the result:

Traffic
Offer
Grouped

I think this is a better user experience. By waiting until both components are ready, we avoid the jarring experience of elements jumping around.

But it does feel like a step backwards in terms of developer experience. At least to me, it feels like components should own their data requests, the same way they own their styles, markup, and business logic.

Imagine if we had 6+ different network requests, like that Facebook Ads Manager app. We'd have half a dozen different loading variables in one component:

function Dashboard() {
  const {
    data: trafficData,
    isLoading: trafficIsLoading,
  } = useSWR('/api/traffic', fetcher);
  const {
    data: offerData,
    isLoading: offerIsLoading,
  } = useSWR('/api/offer', fetcher);
  const {
    data: placementsData,
    isLoading: placementsIsLoading,
  } = useSWR('/api/placements', fetcher);
  const {
    data: audienceData,
    isLoading: audienceIsLoading,
  } = useSWR('/api/audience', fetcher);
  const {
    data: budgetData,
    isLoading: budgetIsLoading,
  } = useSWR('/api/budget', fetcher);
  const {
    data: insightsData,
    isLoading: insightsIsLoading,
  } = useSWR('/api/insights', fetcher);

  // ✂️ Rest of the code trimmed for brevity
}

I don't like this. 😬

What if there was a way for us to keep our original modular component structure, but to strategically “group” UI updates to avoid excessive layout shifts?

This is the problem that Suspense was originally designed to solve.

Introducing the Suspense component

Let's start with some code:

import React from 'react';

function Dashboard() {
  return (
    <React.Suspense fallback={<Spinner />}>
      <TrafficCard />
      <OfferCard />
    </React.Suspense>
  );
}

Suspense is a special React component that can help us orchestrate loading states. In this case, we're saying that <TrafficCard> and <OfferCard> are part of the same “group”.

We specify our loading state with the fallback prop. React will render this fallback until all of its children have finished loading.

This produces the same user experience as our “lifting fetch up” approach:

Traffic
Offer
Grouped

When I first saw this sort of pattern, I found it completely baffling. How on earth does this work?!

In reality, the <React.Suspense> component is only half of the story. The other half of the Suspense API is that the components have to signal whether they're ready or not; they need to be able to say “Hey, don't render yet! I'm still loading my data.”.

A good analogy is that of a rock concert.

A rock show can't start until all of the band members have arrived. It doesn't matter if the guitarist, bassist, and drummer are there; if the lead singer is stuck in traffic, the whole band has to wait until he arrives before they can start playing. The show is suspended, temporarily, until all of the bandmates are ready.

That's where the name “Suspense” comes from. React will suspend rendering until all of the children have finished loading. The curtains stay closed until everyone's ready.

But how do individual components signal their loading state?

Well, this is where it gets tricky. Remember that React has very little insight into what actually happens inside our components. Let's suppose we were using the Fetch API to request our data, something like this:

function TrafficCard() {
  const [data, setData] = React.useState(null);

  React.useEffect(() => {
    fetch('/api/traffic')
      .then((res) => res.json())
      .then((data) => {
        setData(data);
      });
  }, []);

  return <Card>{/* Stuff here */}</Card>;
}

In a situation like this, the only thing React knows is that we have some sort of side effect. React can't “see into” effects. The Fetch API is part of the web platform, not part of React, and so React doesn't even know that a network request is happening!

In other words, that <React.Suspense> parent has no way of knowing that TrafficCard is loading. We need some way to explicitly trigger the “suspend” state during the first render, and then to signal that the component is ready once the data has been received.

This part is intended to be done by library authors, not application developers. This is a rough edge, and the idea is that libraries and frameworks will provide a nicer interface for doing this.

In fact, we've already seen an example of a smooth edge: The loading.js component from the previous lesson uses Suspense under the hood! And libraries like SWR have an option to use Suspense
 under the hood.
*

But just for fun, for academic purposes… how does it work?

It turns out, it works almost exactly like error boundaries.

A new kind of boundary

In the previous module, we learned about Error Boundaries. We wrap an <ErrorBoundary> component around a slice of the React tree, and it will catch any errors thrown by any descendants, to keep the whole app from exploding.

As a quick reminder, the code for this setup looks like this:

function App() {
  return (
    <>
      <Header />
      <ErrorBoundary fallback="Something went wrong…">
        <RealTimeInfo />
      </ErrorBoundary>
      <Stories />
    </>
  );
}

With this error boundary in position, any of the coloured components (RealTimeInfo, Ticker, and Price) can throw an error, and it'll cause the error boundary to swap out the <RealTimeInfo> element for the provided fallback (usually an error message).

<React.Suspense> also creates a boundary, but one that catches loading states instead of errors. We provide a loading fallback instead of an error fallback, and the component automatically swaps between them as-necessary.

Like error boundaries, Suspense boundaries will catch loading states in any descendants, not only the direct children. If SearchForm signals to the Suspense boundary that it's loading, this entire slice of the tree will be suspended, and we'll show the fallback instead.

Here's the really wild part: descendants communicate their loading state by broadcasting it using the throw keyword. But instead of throwing an error, we throw the fetch request itself.

Here's a very rough sketch of what this could look like:

function TrafficCard() {
  const [data, setData] = React.useState(null);

  const [fetchRequest] = React.useState(() => {
    return fetch('/api/traffic')
      .then((res) => res.json())
      .then((data) => {
        setData(data);
      });
  });

  if (fetchRequest.status === 'pending') {
    throw fetchRequest;
  }

  return <Card>{/* Stuff here */}</Card>;
}

What the heck is going on here?! Let me explain.

The Fetch API is Promise-based. This means that every fetch request will have a status property, and it will always be 1 of 3 values: "pending", "fulfilled", or "rejected".

I've created a new state variable, fetchRequest, which holds that promise. I'm keeping it in state so that I can take advantage of the initializer function syntax, so that this component only makes a single network request.
*

Typically, we'd put our network requests inside useEffect, but we can't do that here because effects run after render, and we want to interrupt (“suspend”) the render.

During the render, we check the status of that promise. If it's "pending", we throw it. This is what'll happen in the first render, since we've just started the request.

To put it mildly, this is unusual. The throw keyword is generally used for error-handling, like this:

function registerUser(user) {
  if (!user) {
    throw new Error('Could not find user object');
  }
}

try {
  registerUser(user);
} catch (err) {
  // Do something with the Error instance that was thrown.
}

This is how throw is typically used, but there's no rule that says it needs to be used for errors! The React team cleverly realized that this mechanism would allow the Suspense boundary to “catch” the fetch request (and any other promise-based loading states), from any descendant component within the boundary.

Within React's reconciler implementation, there's a try / catch block that catches the thrown promise, and suspends the render until that promise is resolved.

And so, it's not a metaphor: Suspense boundaries really are like error boundaries, except they catch loading states instead of errors.

This is weird, wild stuff. There's a reason that the React team expects library authors to come up with a smoother interface for this stuff. 😅

If your head is spinning, please know that it isn't critical that you understand this mechanism. It's an implementation detail. You'll never actually have to throw a promise in your own work; this is done under the hood by frameworks and libraries. I shared this technical deep dive because I find it really interesting, but it doesn't really change how we use Suspense.

The most important thing is that you understand the general mental model, the “rock concert” stuff about how the show can't start until all of the bandmates are ready.

This was the original 2018 vision for Suspense: a tool that would help us consolidate loading states, to avoid “Spinner Hell”. In the years since, however, the React team has realized that Suspense boundaries are even more powerful when combined with Server Side Rendering.

That's what we'll talk about in the next lesson.

A more realistic example
(info)

In the example I shared above, we store the Fetch request in a state variable:

const [fetchRequest] = React.useState(() => {
  return fetch('/api/traffic')
    .then((res) => res.json())
    .then((data) =>  setData(data));
});

I set it up this way because it was the most minimal example I could come up with. I needed some way to “save” the Fetch request, and make sure each render didn't start a new one.

In practice, however, this problem is typically solved using an external cache.

If you'd like to see a more-complete implementation, check out this example
, created by the React team. It uses a JavaScript Map as a cache.


---

## Putting It All Together

Source: /joy-of-react/06-full-stack-react/09.04-the-whole-toolkit

Putting It All Together

In the previous lesson, we learned about Suspense's origin story, and dug into the fundamental mechanism that makes it work: we create Suspense boundaries that wrap around slices of our React application, suspending rendering until all of the components within have fetched their data. Our goal was to avoid a bunch of janky layout shifts caused by “lone wolf” components, each operating on their own schedule.

This was the original vision for Suspense, back when it was exclusively used on the client. To get to the true potential of Suspense, we have to talk about how it works in a server-side rendering context. It turns out, Suspense is useful for so much more than avoiding Spinner Hell!

Let's take another look at the Suspense boundary we drew in the previous lesson:

We set up this boundary in order to avoid duplicate loading states, but we've actually done something much more fundamental: we've drawn a circle around the slowest part of our application.

Essentially, we've split the page into two logical “chunks”:

Let's consider the implications in a server-side rendering context. In a “classic” SSR setup, without Suspense, everything happens sequentially:

0
10
20
30
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
Database Query

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

"Database Query" on server. Duration: 12 units of time.
"Render App" on server. Duration: 4 units of time.
Response from server. Duration: 4 units of time.
"Download JS" on client. Duration: 6 units of time.
"Hydrate" on client. Duration: 4 units of time.

In this setup, each step is blocking:

We need to retrieve all of the data from the database before we can start rendering.
We need to generate all of the HTML before we can send anything to the browser.
In the browser, we need to download all of the JavaScript before we can start hydrating.
We need to hydrate all of the components before anything is interactive.

But with Suspense, our app has been broken into multiple chunks. We can work on these chunks in parallel.

First, we'll generate and send the HTML for the first chunk. This happens quickly, since we don't have to wait on any database queries. This HTML includes the fallback loading state for the Suspense boundary:

Then, once the database query is completed, we generate and send the rest of the HTML:

This is how we achieve the incredible performance we saw with Sole&Ankle:

Streaming SSR with Suspense

SSR
SWR
Streaming SSR
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
Render Skeleton
Hydrate
Render
Shoes
Hydrate
Download JS
Database Query

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

"Render Skeleton" on server. Duration: 2 units of time.
Response from server. Duration: 4 units of time.
"Database Query" on server. Duration: 12 units of time.
"Render Shoes" on server. Duration: 2 units of time.
Response from server. Duration: 4 units of time.
"Download JS" on client. Duration: 6 units of time.
"Hydrate" on client. Duration: 2 units of time.
"Hydrate" on client. Duration: 2 units of time.

We're able to send the HTML in chunks like this thanks to a super-power that web servers have: the ability to stream the response.

We see this all the time with videos. When you watch a video on this course platform, for example, you don't have to wait for the entire video to be received before you can start watching it. Instead, the server sends it in chunks.

And so, the modern system we've been building has a few parts:

Server Side Rendering allows us to generate HTML on the server.
Streaming SSR allows us to break the response into chunks, for faster performance.
Suspense lets us define what those chunks are, by drawing boundaries around parts of the React application.

There's one more part as well: React Server Components. We'll see how they fit into this toolkit in the next lesson.

Selective hydration

Earlier in this module, we learned about hydration, the process of booting up the React app on the client so that it can adopt the server-generated HTML, making it interactive.

I demonstrated it with this cute animation:

Static
Interactive
Start Hydration

This is a helpful way to understand hydration, but this is a very 2018 way to look at it. With Suspense and Streaming SSR, the process doesn't happen one step at a time like this.

Instead, it's much more modular:

CLIENT
SERVER
Static
Interactive
Start Hydration

Each Suspense boundary we create is sent as a separate chunk. Each chunk is hydrated separately, a process which starts as soon as the HTML chunk is received (and after React itself has been downloaded).

React will even prioritize which chunk to hydrate based on user activity. If the user clicks a button that hasn't yet been hydrated, React will make that the #1 priority. Once it's been hydrated, React triggers a click event on that element, giving the illusion that it's been interactive all along.

We live in exciting times. The web is about to get a heck of a lot faster, especially for folks in regions without high-speed internet!

Additional resources
(info)

If you'd like to go even deeper, I have two recommended resources:

React core team member Dan Abramov shared a detailed walkthrough of the Suspense + Streaming SSR architecture
 on Github. It's a dense read, but packed with a ton of important insights.
The Suspense API docs
 show lots of different examples of how Suspense can be used.

---

## Putting It All Together

Source: /joy-of-react/06-full-stack-react/09.05-suspense-in-next

Putting It All Together

In the previous lesson, we learned about Suspense's origin story, and dug into the fundamental mechanism that makes it work: we create Suspense boundaries that wrap around slices of our React application, suspending rendering until all of the components within have fetched their data. Our goal was to avoid a bunch of janky layout shifts caused by “lone wolf” components, each operating on their own schedule.

This was the original vision for Suspense, back when it was exclusively used on the client. To get to the true potential of Suspense, we have to talk about how it works in a server-side rendering context. It turns out, Suspense is useful for so much more than avoiding Spinner Hell!

Let's take another look at the Suspense boundary we drew in the previous lesson:

We set up this boundary in order to avoid duplicate loading states, but we've actually done something much more fundamental: we've drawn a circle around the slowest part of our application.

Essentially, we've split the page into two logical “chunks”:

Let's consider the implications in a server-side rendering context. In a “classic” SSR setup, without Suspense, everything happens sequentially:

0
10
20
30
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
Database Query

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

"Database Query" on server. Duration: 12 units of time.
"Render App" on server. Duration: 4 units of time.
Response from server. Duration: 4 units of time.
"Download JS" on client. Duration: 6 units of time.
"Hydrate" on client. Duration: 4 units of time.

In this setup, each step is blocking:

We need to retrieve all of the data from the database before we can start rendering.
We need to generate all of the HTML before we can send anything to the browser.
In the browser, we need to download all of the JavaScript before we can start hydrating.
We need to hydrate all of the components before anything is interactive.

But with Suspense, our app has been broken into multiple chunks. We can work on these chunks in parallel.

First, we'll generate and send the HTML for the first chunk. This happens quickly, since we don't have to wait on any database queries. This HTML includes the fallback loading state for the Suspense boundary:

Then, once the database query is completed, we generate and send the rest of the HTML:

This is how we achieve the incredible performance we saw with Sole&Ankle:

Streaming SSR with Suspense

SSR
SWR
Streaming SSR
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
Render Skeleton
Hydrate
Render
Shoes
Hydrate
Download JS
Database Query

This is a data visualization which shows a sequence of events between client and server. Each event is represented here as a list item.

"Render Skeleton" on server. Duration: 2 units of time.
Response from server. Duration: 4 units of time.
"Database Query" on server. Duration: 12 units of time.
"Render Shoes" on server. Duration: 2 units of time.
Response from server. Duration: 4 units of time.
"Download JS" on client. Duration: 6 units of time.
"Hydrate" on client. Duration: 2 units of time.
"Hydrate" on client. Duration: 2 units of time.

We're able to send the HTML in chunks like this thanks to a super-power that web servers have: the ability to stream the response.

We see this all the time with videos. When you watch a video on this course platform, for example, you don't have to wait for the entire video to be received before you can start watching it. Instead, the server sends it in chunks.

And so, the modern system we've been building has a few parts:

Server Side Rendering allows us to generate HTML on the server.
Streaming SSR allows us to break the response into chunks, for faster performance.
Suspense lets us define what those chunks are, by drawing boundaries around parts of the React application.

There's one more part as well: React Server Components. We'll see how they fit into this toolkit in the next lesson.

Selective hydration

Earlier in this module, we learned about hydration, the process of booting up the React app on the client so that it can adopt the server-generated HTML, making it interactive.

I demonstrated it with this cute animation:

Static
Interactive
Start Hydration

This is a helpful way to understand hydration, but this is a very 2018 way to look at it. With Suspense and Streaming SSR, the process doesn't happen one step at a time like this.

Instead, it's much more modular:

CLIENT
SERVER
Static
Interactive
Start Hydration

Each Suspense boundary we create is sent as a separate chunk. Each chunk is hydrated separately, a process which starts as soon as the HTML chunk is received (and after React itself has been downloaded).

React will even prioritize which chunk to hydrate based on user activity. If the user clicks a button that hasn't yet been hydrated, React will make that the #1 priority. Once it's been hydrated, React triggers a click event on that element, giving the illusion that it's been interactive all along.

We live in exciting times. The web is about to get a heck of a lot faster, especially for folks in regions without high-speed internet!

Additional resources
(info)

If you'd like to go even deeper, I have two recommended resources:

React core team member Dan Abramov shared a detailed walkthrough of the Suspense + Streaming SSR architecture
 on Github. It's a dense read, but packed with a ton of important insights.
The Suspense API docs
 show lots of different examples of how Suspense can be used.

---

## Suspense Exercises

Source: /joy-of-react/06-full-stack-react/09.06-suspense-exercises

Suspense Exercises

Let's get some practice with Suspense! All of the exercises on this page use the same project:

Download from Github
Work on CodeSandbox
Vapor Games

Let's suppose we're building a game manager. As it stands, the user faces a blank white screen until the content has loaded:

Your mission is to update the code so that a placeholder UI is rendered while the data is being loaded:

To help you on this quest, you've been given a helper component, LibraryGameCardSkeleton. You can use it to create a loading state.

A range function has also been provided in /src/utils.js.

Acceptance Criteria:

When the games data is loading, 12 LibraryGameCardSkeleton elements should be rendered in the place of the current LibraryGameCard elements.
The “15 games in library” paragraph can be omitted from the loading state.

The relevant route for this exercise is /src/app/01-vapor.

Hint

You'll want to use the Next.js-specific loading.js file for this. We saw an example of this in the Sole&Ankle project.

You can also learn more in the Next.js documentation
.

Solution:

Solution code
(success)

 Show more
Artist Interview with Comments

In this exercise, a comments section has been added to our “Artist Interview” application:

Unfortunately, it takes a few seconds to load these comments, and right now, that process is blocking the page from loading. Once again, your mission is to use Suspense to improve the loading experience.

You can use the provided <Spinner> component as a loading state:

Acceptance Criteria:

The server shouldn't wait for the comments before sending the first chunk of HTML.
A spinner should be shown as the fallback for the comments.

The relevant route for this exercise is /src/app/02-interview.

Hint

Instead of using Next's loading.js, it might make more sense for us to use React Suspense directly. Can we create a Suspense boundary around the comments?

Check out the official React docs for Suspense
 to see the syntax.

Solution:

Small correction: Since we're moving the async work to a new Comments component, the parent InterviewExercises component doesn't need to be async anymore. This change has been applied to the solution code below:

Solution code
(success)

 Show more
WebBase CMS Navigation

I used to work for a company called Gatsby Inc, creators of the Gatsby.js framework. I spent some time working on the gatsbyjs.org homepage, and I was surprised to learn that the site's main navigation was loaded from Contentful, a CMS?:

This approach makes a lot of sense. It empowers the marketing team to make changes to the site's navigation without having to pester a developer. They edit the links in Contentful/WordPress/Sanity/whatever, and the website updates automatically.

In practice, what this means is that we no longer have the navigation links hardcoded in the JSX. They need to be fetched from the CMS.

In this exercise, we'll work on a landing page for a fictional Platform-as-a-Service company, WebBase:

Your mission is to use Suspense to improve the page-load experience. Specifically, the initial HTML should not include any navigation links, in the header or the footer:

The relevant route for this exercise is /src/app/03-web-base.

Acceptance Criteria:

The initial HTML should be sent immediately, without waiting for the getNavLinks method to complete.
In the server terminal, a message is logged twice on every request, Requesting navigation links from CMS. This message should only be logged once per request.
Hint

The React.cache() API can be used to ensure that the getNavLinks method only performs the underlying work once, even if it's called from multiple components.

For more information, check out the “React Cache” lesson from earlier in the module.

Solution:

Static vs. Dynamic
(info)

In practice, landing pages like this tend to be statically-generated. This means that the navigation data will be fetched when the site is built, not when the site is visited. In this scenario, our solution has no effect: either way, the user will receive the final HTML (including navigation) immediately.

That said, Next.js picks the most optimal rendering strategy on a route-by-route basis. In a real project, this layout would likely be reused across many many routes. Our Suspense boundaries will improve the performance of any route that requires dynamic data.

Solution code
(success)

Check out my final solution on Github
.

---

## Lazy Loading

Source: /joy-of-react/06-full-stack-react/10-lazy-loading

Lazy Loading

Have you ever heard of LaTeX?

It's a formatting system typically used to display math notation, written in the TeX programming language. If you have any mathy friends, you can impress them by knowing that it's pronounced "lah tek".
*

To render this notation, we'll need to use an NPM package. Here's an example using the react-latex-next library:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import 'katex/dist/katex.min.css';
import Latex from 'react-latex-next';

function App() {
  return <Latex>{'$\\sqrt{x^2+1}$'}</Latex>;
}

export default App;
Result
Console
Refresh results pane

The react-latex-next package is essentially a React wrapper for LaTeX. Despite its name, it has nothing to do with Next.js (though it does work fine in Next).

I learned all about LaTeX when I worked for Khan Academy. One of their more popular open-source projects is KaTeX, a JavaScript-based LaTeX parser/renderer. It's used internally by most of the LaTeX NPM packages, including react-latex-next.

One thing I discovered is that there's a lot of different math notation, and KaTeX can handle just about all of it. Including abominations like this one:

As a result, the react-latex-next package is substantial: it'll add 72 gzipped kilobytes
 to your JS bundle, more than React + React DOM!

Now, if you take care to only use this package within Server Components, you don't have to worry about it, since this code will never be shipped to the client. But what if you need to be able to re-render on the client? For example, what if the user can edit the equation?

In cases like this, we'll want to leverage lazy loading.

Understanding lazy loading

The big idea with lazy loading is that we'll defer loading the JavaScript code associated with a particular component until it's needed.

This isn't a new idea. In fact, it's been a core part of the React API for a few years, via the React.lazy()
 method. You can use this in almost all React settings, including client-side-only frameworks like Parcel!

Next.js has their own wrapper around React.lazy(), and we'll talk about that in a bit. For now, though, I think it'll be helpful if we start with React.lazy.

Here's what it looks like:

// Instead of this:
import Latex from 'react-latex-next';

// ...do this:
const Latex = React.lazy(() => import('react-latex-next'));

Either way, Latex will be a React component. The difference when we use React.lazy is that it'll be lazy loaded.

This works using the dynamic import() syntax. Like the standard import statements we've been using throughout the course, dynamic imports are resolved by bundlers like Webpack when we compile our code. Specifically, dynamic imports signal to bundlers that it should split off a new bundle; react-latex-next module, and any sub-dependencies, will not be included in the current bundle.

When I first saw this sort of thing, I had a lot of questions. It felt very magical to me. In this lesson, I'm going to share what I've learned, and hopefully answer a lot of the questions you might have!

Let's start by looking at a scenario:

'use client';
import React from 'react';

const Latex = React.lazy(() => import('react-latex-next'));

function MathQuestion() {
  const [showMath, setShowMath] = React.useState(false);

  return (
    <>
      <button onClick={() => setShowMath(true)}>
        Reveal equation
      </button>

      {showMath && <Latex>{'$2^4 - 4$'}</Latex>}
    </>
  );
}

export default MathQuestion;

In this scenario, the showMath state variable is used to conditionally render math notation. By default, showMath is false, and so we don't render our <Latex> element. The user has to click the button to toggle it on.

The whole idea with lazy loading is that we defer loading the code until it's needed. Because we aren't rendering <Latex> initially, we don't need to download the react-latex-next module code.

As a result, when the user visits our app, this bundle won't immediately be downloaded. We just shaved off 72kb of JavaScript from the initial page load experience! As a result, the app will be hydrated and become interactive more quickly.

Of course, nothing in life is free. We still need to download those 72,000 bytes if we want to render some math notation!

When the user clicks on the button, showMath flips to true, and React will say “Oh shoot, I don't have this component!”. It makes a request to our server, to fetch the 72kb JS bundle. Once it's downloaded and parsed, React has the code it needs to finish the re-render.

Here's what that looks like, on a slow-ish internet connection:

It takes a couple of seconds to download the JS bundle. During that time, the user is given no indication that something is happening. 😬

Fortunately, we can solve this with Suspense. Here's what that looks like:

'use client';
import React from 'react'

import Spinner from '@/components/Spinner';

const Latex = React.lazy(() => import('react-latex-next'));

function MathQuestion() {
  const [showMath, setShowMath] = React.useState(false);

  return (
    <>
      <button onClick={() => setShowMath(true)}>
        Reveal equation
      </button>

      <React.Suspense fallback={<Spinner />}>
        {showMath && <Latex>{'$2^4 - 4$'}</Latex>}
      </React.Suspense>
    </>
  );
}

This will render a spinner while the math-rendering code is downloaded and fetched:

Quite a bit better!

This works because React.lazy() is a Suspense-compatible wrapper around the underlying component. When Latex is rendered for the first time, React realizes that we don't actually have the component (the real Latex component, the one defined in react-latex-next), and so it does the “throw a promise” thing, to suspend this portion of the React tree.

When the data is received and everything's ready, React re-renders using the real Latex component, and this slice of the application un-suspends.

Fundamentally, this is the same sort of client-side Suspense operation we saw with the Facebook Ads Manager example. Except we aren't waiting on a bunch of JSON data, we're waiting on our JavaScript bundles!

Dynamic import gotchas
(warning)

The React.lazy syntax uses the dynamic import() syntax. Annoyingly, this syntax is very limited in how it can be used.

For example, we can't use variables for the import path. This won't work:

const packageName = 'react-latex-next';
const LaTeX = React.lazy(() => import(packageName));

I remember finding this really bizarre and arbitrary. It's valid JavaScript, right? So what's the problem??

The thing to keep in mind is that imports don't actually run in the browser. In a way, there's a smoke-and-mirrors thing happening here, like with import aliases. This code gets picked up and converted by the bundler, during the build process.

import() looks like a function, but it's not. You can think of it more like a token, something to be found-and-replaced. Webpack will analyze our code, looking for import("./some/path/here"), and it'll extract the path from this code. It never actually runs our code, and so it doesn't know how variables will be resolved.

By that same logic, we can't use template strings (import(`/components/${someName}`)), or string concatenation. It needs to be a plain, boring, statically-analyzable string.

It's a bit of a bummer, because there are times where it would be nice to be able to dynamically generate imports. But bundlers like Webpack can't properly evaluate it, so we need to use simple strings.

Lazy loading and Server Side Rendering

In the scenario above, our <Latex> component was being conditionally-rendered, with an initial value of false. But what if our component is there from the very first render?

For example, what if we were doing something like this?

'use client';
import React from 'react'

const Latex = React.lazy(() => import('react-latex-next'));

function LatexEditor() {
  const [expression, setExpression] = React.useState("$2^4 - 4$");

  return (
    <>
      <label htmlFor="expression-input">Enter LaTeX</label>
      <input
        id="expression-input"
        type="text"
        value={expression}
        onChange={(event) => setExpression(event.target.value)}
      />

      <h2>Output:</h2>
      <Latex>{expression}</Latex>
    </>
  );
}

export default LatexEditor;

In this scenario, we've built a LaTeX editor. An expression state variable is controlling a text input, and the value is being passed into our Latex component to render the math notation.

The key difference is that the <Latex> element is always there. It's not being conditionally rendered, to be toggled on at some point in the future.

This raises a couple of questions:

Is there any benefit to doing this? Either way, won't the code need to be downloaded immediately?
In an SSR context, the first render happens on the server. How does lazy loading interact with SSR?

Let's tackle that second question first: Lazy loading has no effect on the server. Our server-generated HTML will include the math notation, no matter whether we do a typical import, or a dynamic lazy load import.

This makes sense when we step back and consider the point of lazy loading. When a user visits our app for the first time, they need to download a boatload of JavaScript before the app is interactive, and we want to improve performance by reducing the number of kilobytes that need to be downloaded.

When we're generating the initial HTML on the server, however, we don't have this concern. The server already has all of the JavaScript code, ready to go. It doesn't have to download anything. And so we might as well use that code to generate the best initial HTML possible.

But what's the point? Why would we lazy load something which is used immediately?

Spend a few moments thinking about this. See if you can figure out why we might still want to do this.

This graph will explain the benefit:

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

Regardless of whether we use lazy loading or not, we still need to download the same amount of JS, and we still have to spend as much time hydrating our components.

But by lazy loading the <Latex> component, we break that work into two chunks. The math notation is deprioritized. All of the non-math parts of the app — the header, the footer, any other widgets and gadgets — will become responsive more quickly.

We can't avoid downloading those 72kb for our math notation, but we can push it back so that it doesn't block everything else from happening.

Where's the <React.Suspense>?
(info)

In our original scenario, we used <React.Suspense> to include a loading state:

<React.Suspense fallback={<Spinner />}>
  {showMath && <Latex>{'$2^4 - 4$'}</Latex>}
</React.Suspense>

We needed to do this because the <Latex> element wasn't rendered by default. As a result, it wasn't included in the server-generated HTML, and it'll take some time for React to figure out what the new UI will be.

When our lazy-loaded component is included in the very first render, we can skip the Suspense wrapper. It's not necessary for us to show a loading indicator, since we already know what the UI looks like.

Lazy loading and Streaming SSR

I remember being very confused about the relationship between lazy loading and the “Streaming SSR” stuff we talked about recently. Do they both sorta do the same thing, in a different way? Is one better than the other? How do we know which one we should use??

While they both have a similar agenda — improving the initial load experience by breaking it up into chunks — they solve different problems. They generally can't be used interchangeably. They're separate tools that are used in different situations.

Streaming SSR is used when our HTML rendering is blocked by some asynchronous work. For example, in Sole&Ankle, we couldn't render the “shoe category” page until we had retrieved the list of shoes from the database. The server was blocked, and we unblocked it by giving it permission to send the HTML in chunks.

By contrast, lazy loading doesn't affect server-side rendering at all. Lazy loading is explicitly about how our client-side JavaScript is split into different bundles.

Here's how I think about it:

We use Streaming SSR when the server is taking too long to generate the HTML.
We use lazy loading when the client is taking too long to download the JavaScript.

Lazy loading is a bit like a less-aggressive version of React Server Components. With lazy loading, we send the JS later, but with Server Components, we don't send the JS at all.

“Suspense” is a low-level tool that is used in all of these situations to define boundaries around logical chunks of our application. Different higher-level tools use those boundaries to control what happens when.

I know that this stuff can feel really overwhelming. If I'm honest, I still find it hard to keep it all straight! But here's the good news: once you start practicing with this stuff, it becomes a lot clearer. And you'll have the chance to practice both of these ideas in the project, coming up soon!

In summary

In this lesson, we've seen how React approaches lazy loading. It's worth noting, though, that “lazy loading” is a much broader term.

For example, we can set native HTML <img> tags to lazy load:

<img
  src="/animals/panda.jpg"
  alt="an adorable panda chewing on bamboo"
  loading="lazy"
/>

This is typically used on images that are “below the fold”, outside the viewport when the page is scrolled to the top. The browser will defer loading the image until it's about to be scrolled into view.

This is the same fundamental idea that we've been talking about: don't load the thing until the user needs it!

This nice neat mental model is clouded by the fact that we can “lazy load” things immediately, like we saw in the Latex editor scenario. But ultimately, it's a twist on the same idea: we want to load the Latex model after everything else, because the other stuff needs to be loaded even more eagerly.

React.lazy() is a handy tool to keep in our back pocket, especially when working with larger NPM packages. It's not something we use every day, since Next is already heavily optimized out of the box. But if you notice your JavaScript bundles starting to balloon, lazy loading is a valve we can twist to release some pressure.

You can learn more about React.lazy() in the official docs
. You can also check out the full versions of the Latex stuff we talked about on Github
.

---

## Lazy Loading in Next

Source: /joy-of-react/06-full-stack-react/10.01-lazy-loading-in-next

Lazy Loading in Next

The React.lazy() method we've been learning about works in all React contexts, including in Next.js. That said, there's a slightly-more-conventional way to tackle this problem in Next apps.

It has a familiar-looking API:

import dynamic from 'next/dynamic';

const Latex = dynamic(() => import('react-latex-next'));

Under the hood, this dynamic function uses React.lazy. It's a drop-in replacement for it, and works exactly the same way. Everything we learned in the previous lesson applies here.

But by switching to dynamic, we get a couple small bells and whistles.

Built-in loading state

With React.lazy, we specify loading states by wrapping the lazy component in <React.Suspense>:

const Latex = React.lazy(() => import('react-latex-next'));

<React.Suspense fallback={<Spinner />}>
  {showMath && <Latex>{'$2^4 - 4$'}</Latex>}
</React.Suspense>

With dynamic, we can pass a second argument for configuration. One of the config options is a loading component:

const Latex = dynamic(
  () => import('react-latex-next'),
  { loading: Spinner }
);

<Latex>{'$2^4 - 4$'}</Latex>

The dynamic function wraps up the <React.Suspense> element for us, so we can “bake in” a loading state for this particular component. We don't have to set up our own Suspense boundary.

This isn't necessarily better. With React.lazy, we have more control, since we're the ones that place the Suspense boundary. This allows us to “batch” multiple lazy-loaded components under one loading state:

const Latex = React.lazy(() => import('react-latex-next'));
const Fireworks = React.lazy(() => import('some-fireworks-package'));

function App() {
  const [showLatex, setShowLatex] = React.useState(false);

  return (
    <>
      <React.Suspense fallback={<Spinner />}>
        <Latex />
        <Fireworks />
      </React.Suspense>
      <button onClick={() => setShowLatex(!showLatex)}>
        Toggle
      </button>
    </>
  );
}

In this scenario, we have two hefty third-party components: <Latex> and <Fireworks> (which, presumably, would render some flashy fireworks on the screen). With React.lazy, we can group both of these components under one Suspense boundary, showing a fallback UI until both have finished loading. It's the same general idea we saw with the Facebook Ads Manager example.

Now, honestly, it's hard to come up with realistic scenarios where we'd want to do this 😅. 99% of the time, the trade-off we make with dynamic is worth it. But every now and then, you might run into a situation where you need more control than dynamic offers.

Disabling SSR

Next gives us the option to disable server-side rendering for lazy-loaded components:

const Fireworks = dynamic(() => import('../components/fireworks'), {
  ssr: false,
  loading: Spinner,
});

When we do this, Next will render the fallback component during the server-side render. The initial HTML will contain a spinner, and it'll be swapped out on the client once the bundle is loaded.

We don't generally want to do this. It's friggin’ awesome that we can include these heavy components in our HTML without affecting the initial JS bundle! But sometimes, we'll find ourselves working with third-party components that just don't work on the server.

In the “SSR Gotchas” lesson, we saw that perfectly-valid JavaScript like window.localStorage.getItem() will crash the server, since there is no “window” object in Node.js.

Some NPM packages, especially ones from outside the React community, assume that they'll only be running in-browser. If you try to use them in a Next.js app, they'll explode.

This dynamic function gives us a tool we can use to skip rendering a component on the server, and only on the client. It's not the only way to do this (we can also use the two-pass rendering strategy), but it is a convenient way, especially if that third-party module is quite hefty!

Ultimately, both React.lazy and dynamic are appropriate tools to use for lazy loading in Next.js. Because they both use the same underlying technique, they have the exact same performance characteristics. It all comes down to which API you prefer. 😄

You can learn more about dynamic in the Next.js docs:

“Lazy Loading” Next.js docs

---

## Baked-in Laziness

Source: /joy-of-react/06-full-stack-react/10.02-lazy-by-default

Baked-in Laziness

Earlier in this course, we talked about producers and consumers. As a quick refresher, this is a mental model that distinguishes between two different kinds of work:

Producing is the act of building something that developers will use to build products. For example, we might build a generic Button component.
Consuming is the act of using that thing. For example, sprinkling the Button component all over the application, creating the actual UI that users will use.

Over the past couple of lessons, we've been looking at how to implement lazy-loading, and we've been thinking about it exclusively from the consumer perspective. When we want to use a component — whether it's a third-party component like react-latex-next or a custom component we produced — we swap out the import:

// From this...
import HeavyComponent from '@/components/HeavyComponent';

// ...to this:
const HeavyComponent = dynamic(() => import('@/components/HeavyComponent'));

This places the burden on the consumer. If we use HeavyComponent 10 different times in our app, we have to remember to use the alternative import() syntax each and every time.

Instead, I prefer to “bake in” the lazy loading on the producer side. That way, we guarantee that the component will always be lazy-loaded, without the consumer needing to do anything special.

Let's talk about how to do this, for our react-latex-next package.

Creating a component wrapper

So, the immediate problem is that we aren't actually the producer of the react-latex-next package. We didn't create it, it's not our code.

We'll solve for that by building our own thin wrapper around this package:

// src/components/Latex.js
import Spinner from '@/components/Spinner';

const LazyLatex = dynamic(
  () => import('react-latex-next'),
  { loading: Spinner }
);

function Latex({ children, ...delegated }) {
  return (
    <LazyLatex {...delegated}>
      {children}
    </LazyLatex>
  );
}

export default Latex;

This new Latex component is a thin wrapper around react-latex-next. We forward all of the props along, so that it can be used exactly the same as the underlying third-party component.

When we need to format some LaTeX, we'll import this new component, using a standard import:

import Latex from '@/components/Latex';

By creating this thin wrapper around the react-latex-next package, we've taken on the mantle of “producer”. This new Latex component is our own creation, and we can use it to lock in whatever we want. In this case, we've implemented a full lazy-loading setup, including the loading indicator.

We've removed the burden from the consumer. When we're in “consumer mode”, we don't have to do anything special to get all the benefits of lazy loading. It's baked in.

Pretty cool, right? 😄

The facade pattern
(success)

There's a name for what we've done here: it's called the facade pattern.

The word “facade” typically refers to the face of a building, the part you actually see as a pedestrian from the street. The building itself is much larger and more complex, but we see a nice friendly exterior.

Similarly, our Latex component is a very thin abstraction. It doesn't really do anything; all of the complexity is handled by the react-latex-next package.

We've actually seen this pattern before. In Module 4, we migrated our Modal component to use an unstyled component library. We were deferring all the hard accessibility stuff to Radix Primitives, but creating a facade to bake in all of the styles and structure.

There's one other huge benefit to using the facade pattern: we can swap one NPM package out for another.

For example, let's imagine that in 6 months, a new LaTeX formatter is released, fancy-new-latex. It's smaller and lighter and better in every way.

If we were using react-latex-next directly, we'd need to sweep the entire codebase, manually swapping the package out. Unless we get very lucky, these two packages won't share the same API, and so it's not something we can find-and-replace. It might be very tedious to do this migration!

But, if we had created a facade, we'd only have to change a single file! We'd swap out the react-latex-next dynamic import for fancy-new-latex, and do any work within the Latex component to “translate” the props so that they're compatible with the new package. The entire migration might only take 5 minutes.

I ran into this exact situation on my course platform. In my CSS course, I had 500+ individual code playgrounds that all used a small open-source library. In 2023, I migrated to Sandpack, a wonderful tool that didn't exist when I first started my course platform. And because I had a thin <Playground> wrapper, I didn't have to change 500+ different files. I edited my facade instead.

You can learn more about this pattern, and other design patterns, on refactoring.guru
.


---

## Dark Mode

Source: /joy-of-react/06-full-stack-react/11-dark-mode

Dark Mode

A few years ago, I created a blog post called The Quest for the Perfect Dark Mode
. In that post, I write:

Maybe the hardest / most complicated part of building this blog was adding Dark Mode.

Not the live-embedded code snippets, not the unified GraphQL layer that manages and aggregates all content and data, not the custom analytics system, not the myriad bits of whimsy. Freaking Dark Mode.

It turns out that “Dark Mode” is a surprisingly deep rabbit hole. It seems relatively straightforward, but there's a fundamental issue that makes it tricky to implement correctly.

In this lesson, we'll look at several “dark mode” implementations and discuss the various trade-offs, before landing on the best solution I'm aware of.

Video Summary

Next 15 update
(warning)

Like params, the cookies helper has also been made asynchronous in Next 15. We need to await it:

async function RootLayout({ children }) {
  const savedTheme = (await cookies()).get('color-theme');
  const theme = savedTheme?.value || 'light';

  const themeColors = theme === 'light' ? LIGHT_COLORS : DARK_COLORS;

  return (
    /* ✂️ */
  );
}

This change has been added to the Github repository
.

Don't forget an expiration date!
(warning)

In the video above, I create a cookie without specifying an expiration date:

Cookie.set('color-theme', nextTheme);

According to the specification, cookies without an expiration date set will become “session cookies”, automatically erased when the user closes the tab! 😬

I should have done this:

Cookie.set('color-theme', nextTheme, {
  expires: 1000,
});

I'm saying that the cookie should expire in 1000 days. In practice, it won't last that long (for example, Chrome caps cookies at 400 days), and any big number will suffice.

This change has been implemented in the code shared below.

Who knew that Dark Mode could be so much trouble? 😅

You can view the complete solution — including the optimizations I promised — on Github:

Dark Mode implementation

Here are the highlights:

// src/constants.js

/*
  I updated the keys on these theme objects to be formatted
  as CSS variables. Honestly this is something I should've done
  from the start, it makes things much simpler! 😅
*/
export const LIGHT_COLORS = {
  '--color-text': 'hsl(0deg 0% 5%)',
  '--color-background': 'hsl(230deg 20% 95%)',
  '--color-primary': 'hsl(245deg 100% 50%)',
  '--color-secondary': 'hsl(345deg 100% 50%)',
};

export const DARK_COLORS = {
  '--color-text': 'hsl(0deg 0% 100%)',
  '--color-background': 'hsl(230deg 20% 8%)',
  '--color-primary': 'hsl(50deg 100% 50%)',
  '--color-secondary': 'hsl(210deg 100% 70%)',
};

Inside the root layout.js, I apply whichever theme object is currently applicable:

// src/app/layout.js

async function RootLayout({ children }) {
  const savedTheme = (await cookies()).get('color-theme');
  const theme = savedTheme?.value || 'light';

  const themeColors = theme === 'light'
    ? LIGHT_COLORS
    : DARK_COLORS;

  return (
    <html
      lang="en"
      data-color-theme={theme}
      style={themeColors}
    >
      {/* Inner content unchanged */}
    </html>
  );
}

Inside DarkLightToggle, I iterate over the key/value pairs in the theme object and overwrite the value for the CSS variable:

function handleClick() {
  const nextTheme = theme === 'light' ? 'dark' : 'light';

  setTheme(nextTheme);

  Cookie.set('color-theme', nextTheme, {
    expires: 1000,
  });

  const root = document.documentElement;
  const colors = nextTheme === 'light' ? LIGHT_COLORS : DARK_COLORS;

  root.setAttribute('data-color-theme', nextTheme);
  Object.entries(colors).forEach(([key, value]) => {
    root.style.setProperty(key, value);
  });
}

Using Router.refresh()?
(warning)

Several students have suggested an alternative solution; instead of editing the styles on the root HTML tag, we can re-render the app using router.refresh():

'use client';
import React from 'react';
import { useRouter } from 'next/navigation'
import { Sun, Moon } from 'react-feather';
import Cookie from 'js-cookie';

import { LIGHT_COLORS, DARK_COLORS } from '@/constants';

function DarkLightToggle({ initialTheme }) {
  const [theme, setTheme] = React.useState(initialTheme);
  const router = useRouter();

  function handleClick() {
    const nextTheme = theme === 'light' ? 'dark' : 'light';

    // Update the state variable.
    // This causes the Sun/Moon icon to flip.
    setTheme(nextTheme);

    // Write the cookie for future visits
    Cookie.set('color-theme', nextTheme, {
      expires: 1000,
    });

    router.refresh();
  }

  // ✂️ The rest unchanged
}

router.refresh() makes a request to the server to re-render all of the Server Components for the current route. By calling it after we've updated the color-theme cookie, the server generates the markup with the updated colors.

Unfortunately, this approach produces a significantly worse user experience. I don't recommend doing it this way.

Our goal should be that when the user clicks the dark/light toggle, the colors should update instantly. In order for something to feel instantaneous, it has to happen within 100 milliseconds. There's just no way to do a server round-trip in that amount of time.

I decided to test it, and found that it took around 400ms on average. When I throttled the internet connection to 3G speeds, it sometimes took over a second. 😬

It's deceptive, because if you test it in localhost, it feels fast, since the server is on the same machine as the browser. But in production, when the server is hundreds or thousands of kilometers away, it's a different story.

I recognize that my solution — editing the HTML tag — feels pretty messy, but that messy approach only takes 3 or 4 milliseconds. I'd rather prioritize the user experience.

You can learn more about the useRouter hook in the Next.js docs
.

