# Joy of React - Project: Toast

---

## About This Project • Josh W Comeau's Course Platform

Source: /joy-of-react/project-toast/01-introduction

Project
Toast Component

In this project, we'll build our very own “Toast” component!

Like so much in front-end development, Toast components are deceptively complex. If we want to build an accessible, production-ready component, we'll need to be really thoughtful about the decisions we make!

This is also a fantastic chance to review what we've learned so far in the course. We'll get to leverage the skills we've been building in every module!

I'm so excited about this one. Let's get into it!

Introduction to the Toast UI component

A toast message is a common UI pattern used to deliver notifications. A toast message pops up, like a piece of toast popping out of a toaster.

Semantically, they're a bit like dialogs/modals, but with 2 big differences:

Dialogs should be used when immediate attention is required. They generally block the user from what they were doing, trapping focus within the dialog. Toast messages, by contrast, should be used for non-urgent status updates. They shouldn't interfere with what the user is doing.
Multiple toasts can be present at once. We aren't limited to one at a time.

In our implementation, toasts will stack up in the bottom corner.

Project format

Like the “Word Game” project, you've been given a good chunk of starter code, using Parcel. Over the course of 6 exercises, you'll finish implementing this component, adding new features and refactoring the code.

All of the required CSS has been provided as well (though you should feel free to change or tweak things, if you want!).

Each exercise has a set of hints, as well as a solution video.

Choose your own adventure

So, I'll be honest with you: This is a hard project. Unless you have previously worked in a production React codebase, it is very likely that you won't be able to complete the last few exercises without some guidance.

Why would I make the project so difficult? Because I believe it's the most effective way to learn something new! You learn so much more from struggling and failing than you do from effortless success.

That said, you should never feel stranded! There are three resources that you can take advantage of:

I've assembled several hints per exercise, designed to give you just enough information to get you “unstuck”.
There are solution videos that walk you through exactly how I'd solve the problem.
You can always ask questions in our community Discord!

If you have a good amount of React experience and/or a high tolerance for frustration, I think the most effective approach looks like this:

Give each exercise a solid attempt.
If you're not sure where to start, or you get stuck on something, check out the hints.
If they don't help, watch the solution video.
If you're still confused, ask questions in Discord.

If you're brand new to React and/or you don't want to feel frustrated, you might prefer a different flow:

Watch the solution videos first, to see how I'd solve the problem. Ask questions in Discord if the solution video doesn't make sense.
See if you can reproduce my solution, without checking the video.
Consult the hints if you get stuck, and re-watch the solution video if the hints don't help.

Ultimately, this course is for you. There is no right/wrong way to go through this material. The most important thing is that you don't give up on it!

No third-party components

In this project, we'll build a Toast component from scratch. We won't use a pre-built component from an unstyled component library.

This might seem like a curious decision; after all, we just learned about all these awesome libraries! Radix Primitives, for example, has a solid Toast component
. Why wouldn't we take advantage of these tools, to make our life easier?

Here's the deal: I want to help you develop a core set of React skills. Libraries are great, but I don't want you to become overly dependent on them.

There will be times where you won't be able to rely on a library. Maybe you have a specialized use case that isn't covered by any of them. Or, maybe the library you depend on becomes unmaintained, and grows incompatible with newer versions of React (this is happening with Reach UI right now!).

Ideally, we shouldn't depend on any component we couldn't build ourselves. I use a handful of helpful third-party components, but if they disappeared tomorrow, I could build them myself. It would be inconvenient, but it wouldn't be catastrophic. And so this project is a great opportunity for us to build those foundational skills, to practice what we've been learning throughout all 4 modules of this course.


---

## Getting Started

Source: /joy-of-react/project-toast/02-getting-started

Getting Started

To get started on this project, you can fork or download the following Github repository:

https://github.com/joy-of-react/project-toast

This project follows the same structure as the “Word Game” project. You might wish to review the “Local Development” instructions 👀 from that project; everything is the same for this one!

If you run into any issues, check out the “Troubleshooting” guide
 from the Wordle project.

After downloading the project repository and starting a development server (npm run dev), you should see the following initial page:

The README.md file is your home base. It will guide you through the project, one exercise at a time. Open it using a markdown renderer for best results!

If you have any questions about this project, feel free to ask in Discord!

Have fun! 😄


---

## Getting Started

Source: /joy-of-react/project-toast/03-hints

Getting Started

To get started on this project, you can fork or download the following Github repository:

https://github.com/joy-of-react/project-toast

This project follows the same structure as the “Word Game” project. You might wish to review the “Local Development” instructions 👀 from that project; everything is the same for this one!

If you run into any issues, check out the “Troubleshooting” guide
 from the Wordle project.

After downloading the project repository and starting a development server (npm run dev), you should see the following initial page:

The README.md file is your home base. It will guide you through the project, one exercise at a time. Open it using a markdown renderer for best results!

If you have any questions about this project, feel free to ask in Discord!

Have fun! 😄


---

## Submit Your Project

Source: /joy-of-react/project-toast/04-submit

Submit Your Project

When you've completed your Toast component, you can submit the URL in the blue box below! Upon submission, you'll be granted full credit for this module.

On the following lesson, you'll find solution videos for every exercise, as well as links to the solution code on Github, and other notes and clarifications about the project.

If you downloaded a .zip file from Github, I'm afraid I don't currently have a way for you to submit your project. Instead, you can click the “Mark as Complete” button below, to claim credit without submitting a URL.


I review a small percentage of submitted projects, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## Solution

Source: /joy-of-react/project-toast/05-solution

Solution
Exercise 1: Wiring up form controls
Exercise 2: Live-editable toast preview

In this video, we assign a component to the Icon constant, and then render it in the JSX like any other component. This strategy was first seen in the “Polymorphism” lesson, as well as in the “Icon Buttons” exercise stretch goal.

Exercise 3: Toast shelf
Exercise 4: Context

You can learn more about the npm run new-component command in the Wordle “Getting Started” video.

Exercise 5: Keyboard and screen reader support
Exercise 6: Extracting a custom hook

You can view all of the final code on the “solution” branch
 on Github.


---

## Unguided Practice

Source: /joy-of-react/project-toast/06-whats-next

Unguided Practice

At this point in the course, we've covered all of the “need-to-know” fundamentals for using React. The first 3 modules were all about the core syntax and features, and the 4th module shared some of the patterns and techniques I use in my real-world work.

There's plenty more stuff to cover, but I think it's time to get a bit of unguided practice.

In my blog post “How To Learn Stuff Quickly”
, I share the following graph:

This graph shows my approach to learning over time. When I'm just starting out with a new language/framework/whatever, I seek out high-quality guided resources to teach me the fundamentals. As I get more comfortable, I start mixing in some unguided learning.

“Guided” learning is where you're being explicitly guided by an instructor. Most of the content in this course counts as “guided” learning. By contrast, “unguided” learning is where you're setting your own goals, creating your own projects, and experimenting with the technology.

Hopefully, the first few modules of this course have helped build a foundation. I think it's about time you start getting some practice on your own!

Let's look at some different options for getting unguided practice.

Extending from the course

In this course, we've built a lot of things, across the various exercises and projects. Maybe you can extend them, adding new functionality?

For example: in Module 2, we built a gradient generator. This is essentially a “mini version” of the gradient generator from my blog
.

Could you extend the “Gradient generator” exercise to include some of the features found on my blog? Maybe:

Adding an angle number input that lets the user change the gradient's angle.
Including CSS output that lets the user copy the CSS snippet, to use the gradient in their code.
Implementing color modes or easing functions (if you want a challenge and are willing to do some research!).

There are lots of exercises in this course that could be interesting to extend. Give it a shot!

Building similar things

In this Toast component project, we went deep into a single UI component. Maybe you can do something similar for other UI components!

Radix Primitives
 has a list of dozens of different UI components. Try to pick one at random, and see if you can implement it from scratch!

You might not be able to—some of their components are quite complex—but I bet you'll learn a lot in the process regardless!

Scratching your own itch

In 2014, I was interested in learning D3, a data-visualization tool. I was also passionate about yoyoing.

I built a tool
 that allowed me to compare the width/diameter/weight of all yoyos from Caribou Lodge Yoyo Works, a Canadian yoyo manufacturer:

Because I chose something I was genuinely interested in—yoyoing—I had way more motivation. When I got stuck on a bug, it gave me the determination to spend the time it took to get myself unstuck.
*

There's something to be said for scratching your own itch, for building something that is personally relevant for you.

One more example: A couple years ago, I got really into Beat Saber, a VR rhythm video game. I built my own level editor called Beatmapper
:

Before this project, I knew almost nothing about 3D stuff, but I really wanted this project to exist. I got stuck on lots of hard problems, but I was motivated enough to see it through.

What are your hobbies outside of coding? Are there tools you wish existed? If you can find an idea that aligns with your passions, you'll be so much more motivated.

If you can't think of anything, how about for your friends/family? Can you build anything to make their life easier or better? This can also be really motivating.

My recommendation

Here's what I suggest: spend a bit of time trying one or more of these “unguided” ideas, before continuing on with the course.

Why now? The next module, Module 5, is all about refining the things we've learned in the first 4 modules. I think the concepts in the next module will stick better if you spend some time solidifying what we've learned so far.

Unguided practice is a great way to figure out where your weak spots are. You might realize pretty quickly that your understanding of effects is still pretty shaky. By getting some hands-on practice, you'll strengthen your understanding, and prepare you for the next module of the course.

(Don't forget, you can review the content we've covered so far! Many students have told me that they've found it helpful to go through some of the more dense lessons several times.)

How much time should I spend on unguided practice? That's up to you! I would commit to spending at least a couple of days. If it goes well, feel free to spend longer. 😄

I'd also suggest reading my “How To Learn Stuff Quickly” blog post
 in full — there are lots of other little tips and tricks in there, in terms of how to learn effectively!

Starting a new React project
(info)

Some of my “unguided practice” suggestions involve creating a brand-new React project from scratch. This isn't something we've explicitly seen how to do!

Later in the course, we cover all of this stuff (starting new projects, deploying, analyzing builds, etc) using Next.js. In the meantime, I suggest using a more lightweight tool.

The easiest way to get started is to use CodeSandbox
. You can create a new React project, and it'll scaffold out everything you need.

You can also use a tool like Vite to bootstrap a new project on your local machine. Follow the instructions in their “Getting Started” guide
, choosing the “React” template.

If you run into any trouble or have questions, feel free to ask in Discord!


---

## Synthesized implementation checklist for agent use

This project reference is lighter than the main module notes because much of the original work happens in the starter repository README and solution videos. When using it as a skill reference, preserve these implementation constraints:

- Use toasts for non-blocking, non-urgent status updates. Use dialogs/modals for blocking decisions, urgent attention, or workflows that require focus trapping.
- Model the system with a provider/shelf/toast architecture:
  - `ToastProvider` owns toast state and exposes narrow actions such as `addToast` and `dismissToast`.
  - `ToastShelf` renders the stack in a consistent screen region, commonly a corner.
  - `Toast` renders one notification with variant/icon/message/dismiss controls.
- Keep toast data as the source of truth: stable ID, message/title, variant/status, optional duration, and optional persistence/dismissibility.
- Generate toast IDs when creating a toast, not during render. Stable keys preserve identity and allow animations/dismissals.
- Prefer least-privilege APIs. Components should call semantic actions like `addToast({ message, variant })`, not mutate provider state directly.
- Context is appropriate because many components may need to enqueue notifications. Split unrelated context/provider values if toast state churn causes unnecessary consumer updates.
- A toast is not a modal: do not trap focus, do not steal focus by default, and do not block underlying page interaction.
- Include an explicit dismiss button for user control. Make icon-only controls accessible with visible or visually-hidden labels.
- Consider accessible live-region semantics for status updates. Use polite announcements for ordinary success/info updates and assertive announcements only for genuinely important errors.
- Timed auto-dismiss should be optional and should not make important information impossible to read. Pause-on-hover/focus can be useful when auto-dismiss is enabled.
- Multiple toasts should stack predictably. Newest-first vs oldest-first is a product decision; keep DOM, visual, and announcement order intentional.
- Portals can help position the shelf outside local stacking/overflow contexts while preserving React ownership/context.
- Variants should be semantic (`success`, `error`, `info`, `warning`) and map to consistent icons/colors. Do not rely on color alone.
- Keyboard support should cover reaching and activating dismiss buttons, preserving focus behavior after dismissal, and avoiding focus loss when a focused toast is removed.
- Extract reusable behavior into custom hooks only after the shape is clear; do not abstract prematurely.
