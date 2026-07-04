# Joy of React - Project: Blog

---

## About This Project • Josh W Comeau's Course Platform

Source: /joy-of-react/project-blog/00-introduction

Project
Interactive MDX-Based Blog

Video Summary

In this final project, we're going to build an interactive MDX-based blog.

As I mention in the video above, this is not a typical static blog. It uses MDX to embed dynamic, custom components right inside the content, just like I do on joshwcomeau.com
.

I'm so excited to show you all of the bells and whistles we use in this one. This is a great opportunity to practice all of the bleeding-edge stuff we talked about in Module 6, and it'll be super valuable regardless of whether you have any interest in starting a new blog or not. 😄

Making it your own!
(info)

If you've been thinking of starting your own developer blog, you're welcome to use the code from this project as the basis for your new blog!

There are some conditions though. They're outlined in the project's LICENSE.md:

View blog license

---

## Intro to MDX

Source: /joy-of-react/project-blog/01-mdx

Intro to MDX

This blog uses a key bit of technology we haven't yet learned about: MDX. It's an absolutely indispensable tool when it comes to creating interactive content.

Let's learn about it.

Video Summary

Add Note

MDX downsides?
(info)

In the video above, I paint a pretty rosy picture of MDX. What are the downsides? When should we not use it?

The biggest downside is that it's a non-trivial technology. We need to use a third-party package in order to get it to work, and those third-party packages might become deprecated in the future, or start throwing funky errors.

The other thing is, it's not really suitable if you're expecting non-developers to write content. This is true of Markdown as well: we're used to it as developers, but it's an intimidating syntax for folks who are used to working with rich-text editors like Microsoft Word. In situations like this, it's better to use a CMS? like WordPress or Contentful. It might be possible to wire it up so that a CMS can use custom components, though it's not something I have much experience with.

---

## MDX in Next.js

Source: /joy-of-react/project-blog/01.02-mdx-in-next

MDX in Next.js

When it comes to using MDX in the context of a Next.js app, there are quite a few options, including:

@next/mdx
, the official package.
mdx-bundler
 by Kent C. Dodds.
next-mdx-remote
 by Hashicorp.

I've experimented with all of these options (and others!), and I've found that the best option for me is next-mdx-remote.

The official @next/mdx package is the simplest option to get started with, but we sacrifice a lot of flexibility. It's a bit too prescriptive for me.

Kent's mdx-bundler, on the other hand, feels a little too robust. It includes its own bundler, meaning that our application now has two separate bundlers that have to co-operate. Things like import aliases need to be configured separately; I ran into several issues when I tried to use mdx-bundler on joshwcomeau.com.

Hashicorp's next-mdx-remote is in the Goldilocks zone for me. It's incredibly powerful and flexible. It doesn't include its own bundler, so there's no extra maintenance or compatibility issues. Of the 3 options, I think it has the clearest mental model, in terms of how it works.

Also, next-mdx-remote was recently updated to work with React Server Components, and honestly, it got way more user-friendly in the process. next-mdx-remote is easier to use than ever.

Now, as always, there are some trade-offs. The biggest downside with next-mdx-remote is that we can't import directly inside our MDX files. But this isn't a huge deal, as you'll soon learn.

Alright, let's learn how to use next-mdx-remote!

The big idea

Here's how it works — we load up our MDX and feed it into an <MDXRemote /> component:

import { MDXRemote } from 'next-mdx-remote/rsc';

export default function BlogPost() {
  const content = ```
# Hello world!

This is the content of an MDX file.

- Yes
- it
- is
  ```;

  return (
    <MDXRemote source={content} />
  );
}

The <MDXRemote> component will take this raw content string and transform it into a bunch of React elements. In this particular case, it'll be as if we had returned the following JSX:

return (
  <>
    <h1>Hello world!</h1>
    <p>This is the content of an MDX file.</p>
    <ul>
      <li>Yes</li>
      <li>it</li>
      <li>is</li>
    </ul>
  </>
)

next-mdx-remote doesn't care where the MDX comes from. In the example above, it's a hardcoded string, but in a more realistic scenario, we'd load it from somewhere, like a database, a CMS, or the local file system.

For example, using the Node fs (File System) module, we could do something like this:

import path from 'path';
import fs from 'fs/promises';
import { MDXRemote } from 'next-mdx-remote/rsc';

export default async function BlogPost({ params }) {
  const { slug } = await params;

  // Read the content of a locally-stored file as a string:
  const content = await fs.readFile(
    path.join(process.cwd(), `/content/${slug}.mdx`),
    'utf8'
  );

  return (
    <MDXRemote source={content} />
  );
}

This is a Server Component, meaning that this code runs exclusively on the server. We look up the .mdx file associated with the provided slug, read all of its content, and pass it into <MDXRemote> to be rendered.

File helpers
(success)

If you haven't worked with the Node fs module before, it can be pretty intimidating. There are a lot of rough edges, like getting the current working directory with process.cwd(), and generating the path in an OS-agnostic way with path.join().

For the purposes of this project, I've provided a little helper module that sands off these rough edges and simplifies the process of loading MDX files.

I'll share more details in the project README.

Custom components

The thing that makes MDX so special is the ability to render custom components. We're not limited to the handful of built-in HTML tags!

Consider this code:

import Link from 'next/link';
import { MDXRemote } from 'next-mdx-remote/rsc';

import ContentImage from '@/components/ContentImage';

export default async function BlogPost() {
  const content = `
If you run into any problems, you can
[contact us](/contact).

<img
  alt="Mailbox clipart"
  src="/img/mailbox.svg"
/>
`;

  return (
    <MDXRemote
      source={content}
      components={{
        a: Link,
        img: ContentImage,
      }}
    />
  );
}

If this was a typical Markdown document, it would get compiled into the following HTML:

<p>
  If you run into any problems, you can <a href="/contact">contact us</a>.
</p>

<img
  alt="Mailbox clipart"
  src="/img/mailbox.svg"
/>

In MDX, however, we don't compile to HTML, we compile to JSX. And we're able to “remap” Markdown tags to custom React components.

And so, here's the JSX that gets compiled:

<p>
  If you run into any problems, you can <Link href="/contact">contact us</Link>.
</p>

<ContentImage
  alt="Mailbox clipart"
  src="/img/mailbox.svg"
/>

Pretty cool right? We can “redefine” any of the built-in HTML tags, to render our own versions instead.

Additionally, we can also specify brand-new tags which can be used in our MDX:

import { MDXRemote } from 'next-mdx-remote/rsc'

import FlexDemo from '@/components/FlexDemo';
import SocialShareWidget from '@/components/SocialShareWidget';

export default async function BlogPost() {
  const content = `
# Intro to Flexbox

Play around with this demo to get a sense of the Flexbox algorithm:

<FlexDemo />

If you enjoyed this blog post, let your friends know:

<SocialShareWidget />
  `;

  return (
    <MDXRemote
      source={content}
      components={{
        FlexDemo,
        SocialShareWidget,
      }}
    />
  );
}

This is the magic of MDX. We can create custom components like <FlexDemo> and embed them in our MDX documents. We can create as many custom components as we want.

Two versions of next-mdx-remote
(warning)

The original version of next-mdx-remote was built before React Server Components was a thing. It has a more-complicated API, with two different parts to run across the client and server.

We're going to be using the newer React Server Components version of this dependency. I've used both, and honestly, the RSC version is way better.

Just be careful when reading the docs, to make sure you're looking at the correct section. It's described towards the end of the README, under “React Server Components (RSC) & Next.js app Directory Support”
.

(There's also a warning about the Next.js app directory being unstable. This warning is outdated, and can be ignored; The Next app directory has been stable since May 2023.)


---

## Getting Started

Source: /joy-of-react/project-blog/02-getting-started

Getting Started

This project takes the same format as previous projects, like our Word game clone and our Toast component.

First, you'll download the starter repository. This repo has a bunch of the less-interesting bits scaffolded out, so that we can focus on the most novel / challenging parts. The README.md document will guide you through the various exercises.

Here's the Github project link:

https://github.com/joy-of-react/project-blog

The README is your home base. It includes the instructions for what to do for each exercise, and some helpful pointers. It also contains the terminal commands you'll need to install dependencies, run a development server, and more.

Getting comfortable with the project

In addition to the code itself, it's worth taking a moment or two to familiarize yourself with what we're building!

You can view the end result here:

Blog homepage

This project includes 4 blog posts. 3 of them are placeholders, created using AI. The only real blog post is “Understanding the JavaScript Modulo Operator”
. Incidentally, if you're not familiar with the Modulo operator (%), you should read this post! It'll help solve one of the exercises in the project.

A quick reminder about mindset
(success)

This project might very well be the greatest challenge you've faced in this course. You'll need to draw on the skills we've been building throughout the entire course, from Module 1 through Module 6.

You should think of this project as the final boss of a notoriously-difficult video game. Unless you have a ton of prior React experience, it's very likely that you'll hit some turbulence on some of these exercises.

That's okay, though! That's how we learn. It's like going to the gym: If you always stick to the really light weights, you won't get any stronger.

When you get stuck, check the README for links to helpful resources. You can revisit the content in earlier modules, and ask questions in Discord. There's also zero shame in watching the solution videos, to see how I'd solve the problem, before giving it another shot.

Here's that link to the repository one more time. Good luck, and have fun!

https://github.com/joy-of-react/project-blog

---

## Submit Your Project

Source: /joy-of-react/project-blog/03-submit

Submit Your Project

When you've completed this project, you can submit the URL in the blue box below! Upon submission, you'll be granted full credit for this module.

On the following lesson, you'll find solution videos for every exercise, as well as links to the solution code on Github, and other notes and clarifications about the project.


I review a small percentage of submitted projects, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## Solution

Source: /joy-of-react/project-blog/03.01-solution

Solution

Updated for Next 15
(warning)

As we’ve seen throughout this module, Next 15 made several APIs asynchronous, including params, searchParams, and cookies. The solution videos below were recorded on an earlier version of Next, and so they did not use the await keyword for these values.

Also, in the time since these videos were filmed, Framer Motion has rebranded to Motion. Fortunately, the API is the same, but any component that imports something from the library should import from motion/react rather than framer-motion.

These issues have been fixed on GitHub, so please check out the “View solution code” links to see the fully-up-to-date solutions.

Exercise 1: Homepage list of posts
Exercise 2: Displaying MDX

Optimizing with Suspense?
(info)

You might be wondering: should we be optimizing this page load experience with Suspense?

The answer is a bit complicated. We'll address this in-depth in a special bonus lesson.

Exercise 3: Adding metadata
Exercise 4: Code snippets with Bright

Recommendations for code snippet tools
(info)

When I rebuilt my personal blog
 in 2024, I had initially planned on using Bright, but I ran into some issues. Specifically, I needed a code snippet tool that could also run on the client, because some of my code snippets are dynamically updated on the client (eg. the snippet at the bottom of my Gradient Generator tool
).

I wound up using Shiki
 instead, which is a lower-level tool which offers more control and customization. It’s also a lot harder to use, and significantly slower; I had to switch from dynamic rendering to static rendering on my blog because running Shiki on-demand made the server-side-render significantly slower.

If you don’t need dynamic code snippets and aren’t looking to build something super-custom, I thinK Bright is still the best choice I’ve seen. If you’re not sure which tool to use in your own project, I’d suggest starting with Bright; you can always migrate to something else if you hit a roadblock.

Exercise 5: Animated division widget
5A: Rendering embedded components

Currently buggy
(warning)

In the solution above, I made a mistake: I forgot to include "use client" in the file that does the dynamic import:

// /src/components/DivisionGroupsDemo/index.js
+"use client";

import dynamic from 'next/dynamic';

const DivisionGroupsDemo = dynamic(() =>
  import('./DivisionGroupsDemo')
);

export default DivisionGroupsDemo;

Unfortunately, adding this line adds a “Flash of Unstyled Content”:

I've opened an issue on Github
, and my hope is that this bug will be fixed in future versions of Next.js.

Depending on which CSS solution you use, this may or may not be an issue for you. But if you use CSS Modules, I'd probably suggest disabling lazy-loading for now, until this issue is addressed.

5B: Animations with Motion
5C: Wiring up the “Remainder”

Bikeshedding?
(info)

In this video, I use the term “bikeshedding”. This term refers to the tendency for developers to focus on shallow / unimportant details.

Cyril Parkinson coined this term all the way back in 1957. From Wikipedia
:

Parkinson provides the example of a fictional committee whose job was to approve the plans for a nuclear power plant spending the majority of its time on discussions about relatively minor but easy-to-grasp issues, such as what materials to use for the staff bicycle shed, while neglecting the proposed design of the plant itself, which is far more important and a far more difficult and complex task.

Alternative solution
(success)

Several students have discovered another way to solve this problem:

{range(remainder).map((index) => {
  // get layout index from the end, minus 1 to account for 0 indexing
  const finalIndex = numOfItems - 1
  const layoutIndex = finalIndex - index;
  const layoutId = `${id}-${layoutIndex}`;

  // Rest unchanged
})}

Instead of calculating the items in previous groups, we're instead counting from the end.

I think this is a clever approach. 👍

Using CSS instead of JS
(success)

Towards the end of the solution video, we address the fact that the items appear to be "crossing over", stacking at the front of the “Remainder Area”. We address this using .reverse():

<div className={styles.remainderArea}>
  <p className={styles.remainderHeading}>
    Remainder Area
  </p>

  {range(totalNumInGroups, numOfItems)
    .reverse()
    .map((index) => {
      const layoutId = `${id}-${index}`;

      return (
        <motion.div
          key={layoutId}
          layoutId={layoutId}
          className={styles.item}
        />
      );
    })}
</div>

Discord user Northerner_V1 realized that we can solve this with CSS. Instead of reversing the array, we can flip the order that they’re rendered with flex-direction:

.remainderArea {
  position: relative;
  display: flex;
  flex-direction: row-reverse;
  justify-content: center;
  align-items: center;
  /* The rest unchanged */
}

While this alternative solution doesn’t materially affect performance or the user experience, it feels much nicer to me. In general, it's better to solve layout issues in CSS rather than JS.

Exercise 6: Circular colors widget
Exercise 7: Dark mode
Stretch goals

Sadly, I don't have videos for the stretch goals, but you can look through my solution code on Github for each stretch goal. I've added comments that should hopefully explain what's going on.

Stretch Goal 1: RSS Feed
Stretch Goal 2: 404 Page

---

## Suspense Investigations

Source: /joy-of-react/project-blog/04-suspense-investigations

Suspense Investigations

Initially, I had planned to have an exercise in the project where we improve the loading experience using Suspense, showing a loading state while we open and parse the MDX content.

When I actually tried to set it up, however, I discovered that in this particular case, Suspense comes with some pretty hefty trade-offs. In this special bonus lesson, we'll dig into it. 😄

If you'd like, spend a few minutes experimenting yourself. As a starting point, you can create a loading.js file that sits beside the blog post page component, and see what the experience is like. See if you're as surprised as I was!

We'll dig in here:

Video Summary

Add Note

---

## Navigation Performance

Source: /joy-of-react/project-blog/05-navigation-perf

Navigation Performance

Several students have noticed something a bit curious about the performance of our blog when deployed: the initial load is pretty quick, but following links can feel a bit sluggish:

In the previous lesson, we talked a bit about how this process works. When the user clicks to read one of our blog posts on the homepage, the client makes a request to the server, to fetch the content for that page. The server renders our page component, and sends a chunk of JS that React uses to re-render. This JS includes all of the MDX content for the requested blog post.

It doesn't take the server long to do this work; as we saw, it should only take a handful of milliseconds! And so, when we run the production build on our local machine, everything feels pretty snappy, even when throttling our network speeds.

But when we deploy to a service provider like Vercel or Netlify, things get noticeably slower. I believe the issue has to do with cold starts.

Providers like Vercel/Netlify use a “serverless” architecture. If nobody's visited our site for a few minutes, it has to initialize our function, and that setup process can take a while. It isn't really an issue for popular sites with lots of traffic, but it's really noticeable on smaller projects.

Fortunately, Discord user Olly found a solution. We can tell Next to pre-fetch all of this MDX content when the user first visits the page.

We do this by applying a new prop to the <Link> element:

import React from 'react';
import Link from 'next/link';

function BlogSummaryCard({
  slug,
  title,
}) {
  const href = `/${slug}`;

  return (
    <Card className={styles.wrapper}>
      <Link
        prefetch={true}
        href={href}
        className={styles.title}
      >
        {title}
      </Link>
      {/* Other content trimmed out */}
    </Card>
  );
}

The prefetch prop instructs Next to pre-emptively fetch the content for this link, and cache it. When the user goes to click on the link, the work has already been completed, and the transition is instantaneous:

Trade-offs

You might be wondering: given that this prefetch prop makes the experience so much better, why isn't this the default value??

In fact, it used to be the default value. When I recorded the solution for this blog, prefetch was set to true by default, and things felt much snappier!

But nothing in life is free, and there are indeed some trade-offs to consider. Let's talk about them.

Stale pages

One of the core assumptions with pre-fetching is that the user will quickly follow one of the pre-fetched links. But what if it takes them a while?

Suppose that someone visits our homepage, but then they switch tabs. They might not come back for hours, or days, or weeks. By then, we might have published significant changes to our blog post, but when the user clicks a link to the post, Next will use the stale cached value, and they'll see the content that was downloaded when they originally loaded the page.

To address this issue, Next added a time limit to cached pages. The exact time limit depends on the pre-fetch strategy used:

The default value, null, only keeps the cache for 30 seconds.
true keeps the cache for 5 minutes.
false doesn't pre-fetch anything.

And so, if you're building something where fresh data is super important (eg. an app that lets users view stock prices), you'll want to explicitly disable pre-fetching, to ensure that the data is 100% up-to-date.

Cost considerations

The blog we've been working on only has 4 separate blog posts. What if we had 100 posts listed on the homepage?

With prefetch={true}, the browser will make 100 separate requests for 100 chunks of JavaScript. This can eat up a lot of bandwidth, for users on limited network connections.

It can also cost us more money. Providers like Vercel charge in part based on the amount of time spent executing serverless functions. When we pre-fetch all of the blog posts, we have to run 100 different serverless functions.

The default pre-fetch behaviour fetches the "shell" for this route, and so it only has to make 1 request, no matter how many blog posts there are; each blog post uses the same layout / loading state, after all!
*

And so, we can pick the pre-fetching value strategically. For example, we can check the prefers-reduced-data media query
 to see if users care more about data efficiency than speed. Or, we can choose which blog posts to pre-fetch (eg. the first 5 in the list), if we're concerned about our own hosting costs.

Personally, I plan on using prefetch={true} as my default strategy, since it offers the best user experience, but I'll be keeping an eye on it, to make sure I'm not pre-fetching too much. Think of this as another tool in your toolbelt, a lever you can pull to tweak the experience!


---

## The Journey Continues

Source: /joy-of-react/project-blog/06-the-journey-continues

The Journey Continues

Well, this is the final lesson of the final project. Once again, a huge congratulations for making it this far! 🎉

My goal with this course has been to help you build a solid, sturdy foundation with React. What you build on top of that foundation is up to you.

The most important thing is to keep practicing. A lot of people get stuck in tutorial hell because they go from tutorial to tutorial, from course to course, without trying to practice what they've learned in an unguided way.

As I mentioned earlier in the course, I published a blog post that shares my entire strategy when it comes to learning new tech skills. It's called “How To Learn Stuff Quickly”
. If you haven't seen it already, I highly recommend checking it out. I think it'll give you some ideas on what to do next!

Now that you've made it through this course, my biggest recommendation would be to start a passion project:

If you've wanted to start a dev blog, you can use the project we've been working on as the starter for your new blog! This would make an excellent passion project. 😄
If you have a non-tech interest (knitting, golf, photography, gardening, whatever), can you create something that'll help you in those pursuits?
If not, do you have any friends or family who could benefit from your newfound skills? Maybe a sibling who wants to start their own e-commerce store, or an artist friend who could use a portfolio site?

Ultimately, it doesn't really matter what you choose to build, as long as you have some level of interest in it. If you're passionate about the thing you're building, if you genuinely want it to exist, it'll be so much easier to find the motivation to work on it.

I'd also suggest trying to mix in some new tools, to expand your learning. Maybe your new project can use TypeScript, or include some unit tests, or use an authentication provider! Challenge yourself, but don't push yourself too hard — if it's too overwhelming, you're likely to give up, and that's the worst-case scenario!

If you have any questions around what to do next, feel free to ask in Discord!

Thanks so much for the support, and best of luck on your journey with React. ❤️

CSS for JavaScript Developers
(success)

If you’ve enjoyed my teaching style and would like to keep learning from me, you might be interested in my other course, CSS for JavaScript Developers
!

This course aims to help you develop a deep understanding of CSS, so that you can build all sorts of complex layouts and user interfaces. It uses the exact same multi-format style as The Joy of React. We also learn CSS in the context of React, so your React skills will come in handy!

You can use the coupon code REACT_CHAMPION to take 10% off the purchase price. This is a special coupon I created exclusively for folks like you, who have completed The Joy of React. 😄

You can learn more about the course here:

CSS for JavaScript Developers

This coupon code will also work for any future courses I release, like my upcoming animations course
!

The Job-Hunting Kit
(info)

This is the final bit of the official curriculum, but there's one more bonus feature you may not have seen yet: it's called the Job-Hunting Kit.

Getting a job as a developer is tough, especially at the start of your career. I spent a few years doing career coaching for a local coding bootcamp, and helped many aspiring developers land their first full-time software developer role.

I've compiled all the most important stuff I've learned into this final bonus feature. We'll talk about cover letters, portfolio sites, and how to survive the interview process. It includes 10+ mock technical interviews, to help you practice.

Check it out:

Job-Hunting Kit

