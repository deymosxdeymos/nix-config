# Joy of React - Project Word Game

---

## About This Project • Josh W Comeau's Course Platform

Source: /joy-of-react/project-wordle/01-introduction

Project
Word Game

In the first two modules of this course, we've learned a lot about how React works, and how to use React state to create dynamic user interfaces. It's time to use those skills to build an app!

In this first project, we'll create a clone of popular word game Wordle
:

Video Summary

This project is a substantially larger and more in-depth challenge than the exercises we've seen throughout the course so far. This is where the rubber meets the road. It's time to see how to use our newfound skills in a real-world context!

Housekeeping

I'm eager for you to get started, but there's a little bit of housekeeping to go over first.

In the very next lesson, we'll talk about the different strategies you can use to approach this project with. This project provides you with several resources, and it's important to figure out how best to apply them!

Because this is the first project, we'll also cover some of the fundamentals around local development: downloading the source code, installing dependencies, and running a local dev server.


---

## Strategies and Mindset

Source: /joy-of-react/project-wordle/02-strategies

Strategies and Mindset

This project is broken into 5 discrete exercises. We build our Wordle clone step by step, working up to a finished game. Each exercise has its own solution, accompanied with a video walkthrough.

Here's what the “intended flow” looks like, for tackling this project:

Following the instructions in the project's README.md, attempt to solve the first exercise.
Once you've either solved the exercise, or have spent 15-30 minutes trying, watch the solution video for the first exercise, to see how I tackled the same problem.
Repeat steps 1 and 2 for all 5 exercises.

Here's why I think this flow is effective:

It encourages you to try each exercise without guidance, challenging you to solve the problem.
If you get stuck on a problem, the time limit keeps you from wallowing in frustration and spinning your wheels.
It'll help keep you engaged since you'll be bouncing between active learning (trying to solve the problem) and passive learning (watching the solution videos).

I should also point out: each solution video is between 9 and 15 minutes long, totalling almost an hour. If you wait until the very end to watch the solution videos, you'll have a lot of stuff to watch!

All of that said: There is no “one size fits all” solution. You might prefer to opt for a different approach. Here are some alternative strategies you can try:

Code-along. With the solution video playing in the corner, code along with me, typing what I type and absorbing the lessons as we go
Freestyle. Try and solve the problem in your own way, using your own tools and methods. Use the README and the solution as a rough guide instead of step-by-step instructions.
Solution first, exercise after. Start by watching the solution videos to see how I attempt the problem. Then, close the video and see if you can reconstruct my solution from memory. If you get stuck, refer back to the video.

This course is for you. Ultimately, all of these strategies are way more effective than trying to follow the “intended flow” if it causes you to get so frustrated that you give up on the project altogether!

Growth mindset

This project is meant to be challenging, especially if you're coming to this course without any React experience. You may find yourself frustrated at times, not sure how to complete the exercise.

Here's the thing, though: Struggling and failing is so much more productive than effortlessly breezing through an easier challenge. It's not as much fun, to be sure, but it'll help you become a rockstar React developer much more quickly.

If you feel yourself starting to feel frustrated because you can't solve the exercise, I encourage you to try and reframe it as a successful learning experience. This is much easier said than done. Failure is inherently frustrating, after all. But if you can learn to see things this way, you'll become unstoppable. ✨

Earlier in the course, we dug a bit deeper into this idea. Here are some additional links you can use, to cultivate a growth mindset:

“Mindset: The New Psychology of Success”
, a talk given by researcher Carol Dweck at Google HQ.
Growth Mindset Activities on Khan Academy
. It claims it's for high school students, but I think it's helpful for everyone!
Stretch goals

So, what happens if you make it through the 5 exercises without really breaking a sweat?

This project includes 2 stretch goals that offer additional challenge. There are no solution videos for the stretch goals, though I have personally attempted them, and I do make my solution code available.

You can also invent your own stretch goals! Because we're building a game, there are tons of fun things you can do to extend the functionality.


---

## Local Development

Source: /joy-of-react/project-wordle/03-dev-server

Local Development

Throughout this course so far, you've been building your React skills in the embedded code playgrounds within this course platform. This widget is great for smaller self-contained exercises, but it's not quite up to the task here.

Instead, we'll download and run the project on our local development machine.

Not your first rodeo?
(info)

This lesson is all about getting the project downloaded and running on your local development machine. If you're already familiar with Git and NPM, you can skip this lesson.

Here's the Github repo URL, for you to clone and run with NPM:

https://github.com/joy-of-react/project-wordle

An online backup
(success)

For best results, I recommend running this project on your local machine. That said, if you’re having trouble getting a development environment up and running, there is a backup option using CodeSandbox:

Work on CodeSandbox

CodeSandbox is an online development environment. You’ll need to create an account in order to create your own editable copy of the project.

The README.md file contains all the info you’ll need to complete this project.

Node, NPM, and the command line

In this lesson, we'll be using Node.js via the command line to install dependencies and run a local development server.

Not sure how to use these tools? The Tools of the Trade bonus module covers everything you need to know. Here are the most critical lessons:

The Terminal
, and related sub-lessons
Code Editor
Node.js and NPM
, and related sub-lessons

If you're relatively new to modern front-end development, I suggest going through the entire bonus module!

If you have any questions, feel free to ask on Discord.

Downloading the source code

The project source code exists on Github, at the following URL: https://github.com/joy-of-react/project-wordle
.

If you're familiar with Git, you can fork this project and clone it onto your own computer.

If you're not familiar with Git, you can download a .zip file containing everything you need:

I recommend creating a /joy-of-react directory to house this and future Joy of React projects, but you can clone/copy the project wherever works best for you!

Running a local development server

As we've learned so far in the course, modern React applications require some pretty sophisticated tooling. We need to do things like:

Compile our JSX into plain JavaScript.
Bundle all of our individual .js files together, so the browser doesn't have to download dozens/hundreds of files.
Compress and minify our JS so that the bundles are smaller.

These days, fortunately, we don't have to configure any of this manually. There are many wonderful tools that will manage all of this for us, giving us a friendly way to benefit from these features.

In this project, we'll use Parcel
. It's a modern, super-fast, batteries-included build tool that hides all of this complexity for us.

To run a local development server, we first need to install third-party dependencies (eg. React, Parcel). This can be done by cd-ing into the root project folder and running the following command:

npm install

Once the dependencies have been downloaded, you can run a dev server with the following command:

npm run dev

This will start a local development server. The terminal output should look something like this:

We can see from this output that a local development server is running at http://localhost:1234. In most terminal applications, you should be able to click this URL to visit it in-browser. If clicking it doesn't work, you can copy/paste.

You should see the following:

If you're seeing this, you're all set!

Troubleshooting
Malloc issue

Recently, several students have reported hitting this error:

malloc: Incorrect checksum for freed object 0x1234: probably modified after being freed.

This seems to be an issue with the latest release of Node.js. To fix it, you can switch to the LTS (Long Term Support) version. At the time of writing, that’s version 20.18.

I recommend using NVM
 (Node Version Manager), which lets you install and hop between multiple versions of Node/NPM. This is really convenient, since different projects have different Node version requirements.

If you're a windows user, you'll need to set up WSL
 in order to take advantage of NVM.

win32-x64 issues

If you're using Windows, you might run into an issue like this:

Error: The specified module could not be found.
C:\Users\josh\project-wordle\node_modules\@parcel\fs-search\fs-search.win32-x64-msvc.node
    at Object.Module._extensions..node (internal/modules/cjs/loader.js:1144:18)
  code: 'ERR_DLOPEN_FAILED'

This can happen if your computer is missing Microsoft Visual C++. You can download it here:

Visual C++ Redistributable for Visual Studio 2015

You can also fix this issue by moving to WSL (Windows Subsystem for Linux). This allows you to run Linux within Windows, and this generally solves a lot of issues, since many packages and tools in the JavaScript community were built with Linux/macOS in mind.

I share instructions for setting up WSL here:

Tools of the Trade, Windows Setup
Hot Reload not working

Some students have reported that the “hot reload” feature doesn’t work. When saving their changes, the page wasn’t updating automatically, and they had to kill and restart the dev server to see their changes.

We’ve discovered two main causes for this:

If you’re using WSL (Windows Subsystem for Linux), it’s important that the project files are stored within Linux, so that Parcel can manage all of the dev server files. The easiest way to set this up is to run the git clone command directly from the WSL terminal.
Neovim will destroy and recreate files when editing them, which means that Parcel never gets the “edit” signal. You can fix this by running :set backupcopy=yes within Neovim.
Missing @parcel/core dependency

Several students have gotten an error like this:

@parcel/core: Failed to resolve 'public/index.html'
@parcel/resolver-default: Could not resolve module "@parcel/core" from ".../node_modules/@parcel/resolver-default/node_modules/@parcel/fs/lib/index.js"

This is an issue with older versions of NPM. If you update to the latest versions of Node/NPM, it should solve this issue.

I recommend using NVM
 (Node Version Manager), which lets you install and hop between multiple versions of Node/NPM. This is really convenient, since different projects have different Node version requirements.

If you're a windows user, you'll need to set up WSL
 in order to take advantage of NVM.

Audit warnings

When you first run npm install, you'll likely notice some warnings, including some pretty scary-sounding ones about vulnerabilities:

Here's the good news: No action is required. There aren't any actual vulnerabilities, and this scary message is a false alarm.

NPM will do a security audit when installing dependencies, but the audit process is deeply flawed right now for React developers, to the point that it's completely untrustworthy.

99% of the dependencies we're installing will only ever run on our local development machine. They won't be included in our final bundles, or shipped to the end user. And so the actual risk of a vulnerability making it into our applications is negligible.

If you're curious to learn more, you can read a deep dive about NPM audit
 by React core team member Dan Abramov.

Viewing the README

For the projects in this course, the README.md is your home base. It includes instructions for each exercise, and includes helpful GIFs that show the expected result.

If you use VS Code as your editor, I strongly suggest using its built-in markdown renderer:

In addition to the helpful formatting, this view allows you to see the images, which is critical.

The command we want is Markdown: Open Preview. To enter this command, open the Command Palette by pressing Ctrl + Shift + P.


---

## Getting Started

Source: /joy-of-react/project-wordle/04-overview

Getting Started

Alright, so you've downloaded the source code, you have a dev server running… now what?

Video Summary

One small caveat I forgot to mention in the video: the end-result.html is meant to serve as an example. Your final markup might not look exactly the same, and that's OK! In particular, there is no validation in the provided markup, which probably isn't ideal.

“Delightful” file/folder structure
(info)

As shown in the video above, each component is given its own directory, with a peculiar structure:

src/
└── components/
    ├── App/
    │   ├── App.js
    │   └── index.js
    └── Game/
        ├── Game.js
        └── index.js

You might be wondering why I've structured things this way… it seems pretty over-engineered, doesn't it?

Over the years, I've experimented with lots of different file/folder conventions, and this is the best structure I've found. It solves a number of small-but-annoying problems.

I go into detail about this structure in my blog post, “Delightful React File/Directory Structure”
. I'd suggest giving it a read if you're curious about it!

This pattern is also much easier to follow with the new-component package. It's been installed automatically for you in this project. To install it in other projects, you can follow the instructions on GitHub
.

---

## Submit Your Project

Source: /joy-of-react/project-wordle/05-submit

Submit Your Project

When you've completed your Wordle clone, you can submit the URL in the blue box below! Upon submission, you'll be granted full credit for this module.

On the following lesson, you'll find solution videos for every exercise, as well as links to the solution code on Github, and other notes and clarifications about the project.

If you downloaded a .zip file from Github, I'm afraid I don't currently have a way for you to submit your project. Instead, you can click the “Mark as Complete” button below, to claim credit without submitting a URL.


I review a small percentage of submitted projects, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## Solution

Source: /joy-of-react/project-wordle/06-solution

Solution
Exercise 1: GuessInput
Hint

This exercise requires us to wire up a text input and a form. Check out the Data Binding and Form Submission lessons for a refresher!


You can learn more about the npm run new-component command in the “Getting Started” video.

Switching from “minLength” to “pattern”
(warning)

In the video above, I mentioned that the minLength attribute sometimes seems not to work. Several other students have run into this issue. It turns out, bewildering, that the .toUpperCase() is to blame!

The reason I wasn't running into the problem in the video is because I was holding “shift” as I typed. The issue occurs when the .toUpperCase() method actually changes the characters entered.

This isn't a problem with React specifically; I was able to reproduce the same issue in vanilla JavaScript and HTML. For some reason, transforming the value on an input causes the minLength attribute to fail.

To address this issue, I've updated the solution to use the pattern validation attribute instead:

<input
  required
  minLength={5}
  maxLength={5}
  pattern="[a-zA-Z]{5}"
  title="5 letter word"
/>

The pattern attribute uses Regular Expression syntax
. Specifically what we're saying here is that the acceptable characters are letters ([a-zA-Z]), and that there should be exactly 5 of them {5}.

We also add the title attribute for clarification; if the user tries to submit the form and the validation isn't met, they'll be shown a message like this:

I decided to keep minLength and maxLength even though they're being overruled by pattern; hopefully, browsers will fix this issue someday and we can remove the pattern and title.

I've also removed the conditional window.alert from the solution as well, since this validation works reliably.

Missing help circle?
(info)

In the video above, a help circle appears in the top-right corner of the page. You might be wondering why your project doesn't include this icon.

When I recorded this video, I had created a help component that provided context about what this game was, but the code for it wound up being non-trivial, and I worried about distracting you from the tasks at hand. So I removed it from the version of the project you're working on.

Sorry for the confusion!

Exercise 2: Keeping track of guesses
Hint

In our Game component, we probably want to keep track of the user's guesses in an array, held in state.

You might wish to revisit the Iteration lessons.


We see some modern JS tricks in this one, including spread syntax 👀, array destructuring 👀, and object destructuring 👀. Check out those respective lessons in the JavaScript Primer bonus module if you're not sure how they work!

Exercise 3: Guess slots
Hint

You'll need to generate a bunch of squares for each guess. This can be done using the provided range utility.

Exercise 4: Game logic
Hint

In this exercise, we need to conditionally apply CSS classes. We see some examples of this in the Styling exercises.


A different structure?
(success)

Several students have taken a different approach for this one: they've evaluated the guess before adding it to the state, like this:

function Game() {
  const [guesses, setGuesses] = React.useState([]);

  function handleSubmitGuess(tentativeGuess) {
    const checkedGuess = checkGuess(tentativeGuess, answer);
    setGuesses([...guesses, checkedGuess]);
  }

  return (
    <>
      <GuessResults guesses={guesses} />
      <GuessInput handleSubmitGuess={handleSubmitGuess} />
    </>
  );
}

At this point in the course, we're still getting comfortable with the fundamentals, and either solution is 100% valid. You can absolutely solve it this way!

That said, one of my “happy practices” is to store the minimum amount of stuff in state, and to derive things whenever possible.

Later in the course, we'll revisit this exact problem, and I'll share my rationale for why I prefer to store the “raw” guesses in state. It's not something you need to worry about now though. 😄

Importing instead of passing props?
(warning)

In my solution, I pass the answer prop through the application, so that our Guess component can tell whether the guess is correct or not.

Some students have instead solved this problem by exporting the correct answer and importing it in the Guess.js file, and have wondered if this is an acceptable approach.

This is totally valid. Honestly, it keeps the code a lot simpler!

So why didn't I do it this way? Well, here's the catch: it only works for immutable data. We aren't allowed to ever update or change an import.

One of the stretch goals for this project is to implement a "restart" feature, where the user can start again with a brand-new word. In that case, answer changes over time, and so we can't rely on import/export.

Similarly, in real-world projects, we're often dealing with data pulled from a database and sent over the network. In these cases, we also can't rely on import/export, because the data isn't known at first.

That said, for this exercise, either approach is acceptable. You can always refactor later if you want to give the stretch goal a shot!

Exercise 5: Winning and losing
Hint

To keep track of the game status, I recommend creating a status variable that can hold 3 possible values: running, won, and lost.

Then, we can conditionally render a banner based on this status. No banner for running, a win banner for won, and a lose banner for lost.

You might wish to review the lesson on Conditional Rendering with &&.


You can view all of the final code on the “solution” branch
 on Github.

Stretch Goals

This solution solves the two stretch goal examples provided:

Adding a visible keyboard.
Adding a “restart” button when the game ends.

