# Joy of React - Module 2: Working With State

---

## Introduction • Josh W Comeau's Course Platform

Source: /joy-of-react/02-state/01-introduction

Working With State

In the early days of the web, websites were essentially fancy documents. We'd load one HTML file, read the content, and then load another one.

The beautiful, amazing, magical thing about the modern web is that web applications are interactive. The app can respond to user actions in real-time, without needing to fetch a whole new page.

React has a really novel approach towards managing this interactivity. And once you get used to it, it's really hard to imagine managing it any other way.

In this module, we'll learn about:

How to respond to user actions with event binding.
How React manages the DOM for us, and what it actually means to "re-render".
The useState hook, and how to use it to build interactive components.
Understanding the difference between props and state.
Working with forms in React (everyone's favourite topic!).
Working with complex state, like objects and arrays.
Avoiding common pitfalls (eg. bugs related to state mutation).
How to share state across the application by lifting it up.

This is a really exciting module, because we go from static websites to dynamic, alive applications. Let's do this!


Event Handlers

---

## Event Handlers

Source: /joy-of-react/02-state/02-event-handlers

Event Handlers

Before we look at the nuts and bolts of working with state in React, we need to speak a little bit about events.

As the user interacts with the page, hundreds of events are fired off in response. The browser is like an invasive private investigator, tracking every little thing you do.

The following demo logs a bunch of different common events. Try interacting with this widget, and notice the stream of events that are subsequently logged:

When we're building dynamic web applications, these events become super important. We'll listen for these events, and use them to trigger state changes. When the user clicks the "X" button, we dismiss the prompt. When the user submits the form, we show a loading spinner.

In order to respond to an event, we need to listen for it. JavaScript provides a built-in way to do this, with the addEventListener method:

const button = document.querySelector('.btn');

function doSomething() {
  // Stuff here
}

button.addEventListener('click', doSomething);

In this code, we're listening for a specific event (clicks) targeting a specific element (.btn). We have a function which is meant to handle this event, doSomething. When the user clicks this particular button, our handler function will be invoked, allowing us to do something in response.

The web platform offers another way to do this as well. We can embed our handler right in the HTML:

<button onclick="doSomething()">
  Click me!
</button>

React piggybacks on this pattern, allowing us to pass an event handler right in the JSX:

function App() {
  function doSomething() {
    // Stuff here
  }

  return (
    <button onClick={doSomething}>
      Click me!
    </button>
  );
}

As with addEventListener, this code will perform the same duty: when the user clicks the button, the doSomething function will be called.

This is the recommended way to handle events in React. While we do sometimes have to use addEventListener for window-level events (covered in Module 3), we should try and use the “on X” props like onClick and onChange whenever possible.

There are a few good reasons why:

Automatic cleanup. Whenever we add an event listener, we're also supposed to remove it when we're done, with removeEventListener. If we forget to do this, we'll introduce a memory leak?. React automatically removes listeners for us when we use “on X” handler functions.
Improved performance. By giving React control over the event listeners, it can optimize things for us, like batching multiple event listeners together to reduce memory consumption.
No DOM interaction. React likes for us to stay within its abstraction. We generally try and avoid interacting with the DOM directly. In order to use addEventListener, we have to look up the element with querySelector. This is something we should avoid. The “happy path” in React involves letting React do the DOM manipulation for us.

Staying within the abstraction
(info)

I want to expand on that last bullet point a bit, because it gets at something really important.

One of the core ideas behind React is that it does the DOM manipulation for you. When using React, you shouldn't really be using querySelector at all. We want to stay within React's abstraction, rather than trying to compete with it to manage the DOM.

When I first started learning React in 2015, my tool of choice was jQuery. If you're not familiar, jQuery is a tool that makes it easy to select and modify the DOM. It's a DOM manipulation tool.

I remember being frustrated that my “tried and true” conventions were suddenly considered bad practices in React. Sometimes, it seems much simpler to manage the DOM with jQuery, rather than trying to figure out how to do it with React.

Honestly, though, I set myself back with this mindset. I tried to bend React into a shape that was familiar to me, but React just isn't that flexible. Once I finally learned how to do things properly, everything became so much simpler and easier.

When learning a new technology, it's natural to try and squeeze it into a familiar shape. But I promise you, you'll have a much better time learning to swim with the current, rather than trying to fight against it.

Differences from HTML

When we look at the onChange prop, it looks very similar to the “in HTML” method of adding event handlers. There are some key differences though.

Camel Casing

As we saw in the last module, we need to write “camelCased” attribute names in JSX. Be careful to write onClick, with a capital “C”, instead of onclick. Same thing with onChange, onKeyDown, onTransitionEnd, etc.

Here's the good news: if you forget, you'll get a helpful console warning letting you know about your mistake:

Warning: Invalid event handler property onclick. Did you mean onClick?

This common mistake tends to be pretty easy to spot. Let's look at another common issue that, unfortunately, is harder to spot.

Passing a function reference

When working with event handlers in React, we need to pass a reference to the function. We don't call the function, like we do in HTML:

// ✅ We want to do this:
<button onClick={doSomething} />

// 🚫 Not this:
<button onClick={doSomething()} />

When we include the parentheses, we invoke the function right away, the moment the React application is rendered. We don't want to do that; we want to give React a reference to the function, so that React can call the function at a later time, when the user clicks on the button.

In case JSX is getting in the way, here's the same code written in compiled JavaScript:

// ✅ Correct.
// Will be called when the user clicks the button.
React.createElement(
  'button',
  {
    onClick: doSomething,
  }
);

// 🚫 Incorrect
// Will be called immediately, when the element is created.
React.createElement(
  'button',
  {
    onClick: doSomething(),
  }
);

Specifying Arguments

---

## Specifying Arguments

Source: /joy-of-react/02-state/02.01-args

Specifying Arguments

Here's a conundrum? for you: what if we want to specify arguments to this function?

For example, let's suppose that our function is called setTheme, and we'll use it to change the user's color theme from Light Mode to Dark Mode.

In order for this to work, we need to supply the name of the theme we're switching to, like this:

// Switch to light mode:
setTheme('light');

// Switch to dark mode:
setTheme('dark');

How do we do this, though?

If we pass setTheme as a reference to onClick, we can't supply arguments:

// 🚫 Invalid: calls the function without 'dark'
<button onClick={setTheme}>
  Toggle theme
</button>

In order to specify the argument, we need to wrap it in parentheses, but then it gets called right away:

// 🚫 Invalid: calls the function right away
<button onClick={setTheme('dark')}>
  Toggle theme
</button>

We can solve this problem with a wrapper function:

// ✅ Valid:
<button onClick={() => setTheme('dark')}>
  Toggle theme
</button>

We're creating a brand-new anonymous arrow function, () => setTheme('dark'), and passing it to React. When the user clicks the button, the function will run, and the code inside the function is executed (setTheme('dark')).

If you're not super comfortable with arrow functions, be sure to check out the “Arrow Functions” primer lesson 👀.

If it's still confusing, there's no need to worry: this pattern is very common in React, and there will be ample opportunity in this course for you to become familiar and comfortable with it!

Bad for performance?
(warning)

You may have heard that creating anonymous functions like this is bad for performance.

There's a lot of misinformation out there around this topic, and it's frustrating to me because it makes developers worry about things they really don't need to be worrying about.

To quickly summarize:

There isn't a measurable performance difference between creating anonymous functions vs. named functions. Same thing for arrow vs. traditional functions.
The cost of creating a new function is extremely low. Even low-end devices can create hundreds of thousands of functions in the span of a human blink.
React has a built-in event delegation system that implements a bunch of optimizations for us.

Now, there is a kernel of truth to the concerns around functions in React, but React gives us a tool to manage them. It's called useCallback, and we'll learn about it in Module 3.

What about .bind?
(info)

There is another way we could have solved this problem: using the function bind method:

 Show more

---

## Exercises

Source: /joy-of-react/02-state/02.02-event-exercises

Exercises
Click the ball

Let's build a simple game!

In the playground below, a ball moves around randomly. The goal of the game is to click the ball. We want to show an alert when the ball is successfully clicked:

We can use window.alert() to show the message.

Acceptance Criteria:

When the user clicks the ball, a winning message should be shown.
You should handle “click” events specifically, as this event is triggered on click, on tap, and even when the user focuses the element with the keyboard and hits the “Enter” key.
If you don't use a pointer device, you can use the keyboard method to test your code.

NOTE: If you find the ball movement distracting, you can disable it. Pop over to the CSS tab and comment out the first chunk of CSS.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
import React from 'react';

import VisuallyHidden from './VisuallyHidden';

function ballClick() {
  window.alert('You win');
}

function ClickBallGame() {
  return (
    <div className="wrapper">
      <button className="ball" onClick={ballClick}>
        <VisuallyHidden>Ball</VisuallyHidden>
      </button>
    </div>
  );
}

export default ClickBallGame;
Result
Console
Refresh results pane

Not seeing the ball moving?
(warning)

If the pink ball isn't moving around for you, it's likely that you've ticked the “reduce motion” checkbox in your operating system's accessibility settings.

Fortunately, the motion isn't actually required for you to solve this exercise. Feel free to leave motion disabled!

We'll learn more about motion accessibility towards the end of the course
.

Solution:

Solution code
(success)

 Show more
Click the ball v2

Let's make our game a bit more interesting.

In addition to the ball, it now features a bomb. If the bomb is clicked, we want to show a "lose" message:

Below, you'll find a mostly-complete implementation, but there's a problem. Clicking either item—bomb or ball—shows the “lose” message.

Your mission is to fix the code below so that it shows the right message depending on which item is clicked.

Acceptance Criteria:

When the user clicks the ball, a winning message should be shown.
When the user clicks the bomb, a losing message should be shown.
The handleClick function should still be used, and you shouldn't have to change anything about the function itself.

Once again, you can comment out the first chunk of CSS to disable the movement.

Code Playground
(Restored)

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

Solution code
(success)

 Show more

Do we need to pass the “lose” argument?
(warning)

Several students have pointed out that the type isn't strictly necessary for the bomb button.

Instead of doing this…

<button
  className="bomb"
  onClick={() => handleClick('lose')}
>

…we can do this:

<button
  className="bomb"
  onClick={handleClick}
>

Our handleClick function, after all, only checks for "win", it doesn't check for "lose":

function handleClick(type) {
  if (type === 'win') {
    alert('You win!');
  } else {
    alert('You lose :(');
  }
}

But just because we can omit the argument, should we?

Here's a question for you: in this new version of the code, what do you suppose type will be assigned to, within the handleClick function?

function handleClick(type) {
  console.log(type);
  // What will this log, when we click the bomb?
}

Think about it for a second, and then expand:

 Show more

---

## The useState Hook

Source: /joy-of-react/02-state/03-use-state

The useState Hook

Let's start by looking at a common example, a minimal “counter” demo.

Click the button, and watch the count increase:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function Counter() {
  const [count, setCount] = React.useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      Value: {count}
    </button>
  );
}

export default Counter;
Result
Console
Refresh results pane

There's a lot going on here, so let's break it down.

Our goal is to keep track of the number of times the user has clicked the button. Whenever we have “dynamic” values like this, we need to use React state. State is used for values that change over time.

To create a state variable, we use the useState function. This function takes a single argument: the initial value. In this case, that value initializes to 0. This value is chosen because when the page first loads, we've clicked the button 0 times.

useState is a hook. A hook is a special type of function that allows us to "hook into" React internals. We'll learn much more about hooks later in this course.

The useState hook returns an array containing two items:

The current value of the state variable. We've decided to call it count.
A function we can use to update the state variable. We named it setCount.

Destructuring Assignment
(info)

If you're not familiar with array destructuring, this syntax might look a little wild to you!

To help you understand what's going on, here's the same logic, but expressed without using destructuring assignment:

const countArray = React.useState(0);

const count = countArray[0];
const setCount = countArray[1];

You can learn more in the “Array Destructuring” lesson 👀 from the JavaScript Primer reference module.

Naming conventions

When we create a state variable, we can name the two variables whatever we want. For example, this is equally valid:

const [hello, world] = React.useState(0);

That said, it's customary to follow the “x, setX” convention:

const [user, setUser] = React.useState();
const [errorMessage, setErrorMessage] = React.useState();
const [flowerBouquet, setFlowerBouquet] = React.useState();

The first destructured variable is the name of the thing we're tracking. The second variable prefixes that name with set, signifying that it's a function that can be called to change the thing. This is sometimes referred to as a “setter function”, since it sets the new value of the state variable.

Importing the hook?
(info)

Some React tutorials write this sort of code in a slightly different way:

import React, { useState } from 'react';

function App() {
  const [num, setNum] = useState(0);

  return (
    <div>{num}</div>
  );
}

Instead of writing React.useState, we're importing the useState function at the top of the file and using it on its own, useState.

Here's the bottom line: these methods are completely equivalent, and either one works just fine.

Personally, I don't want to have to fuss with imports. It's a tiny distraction to me, and I'd rather write a few extra characters every time. But this is 100% personal preference, you can manage this however you wish.

Initial value

React state variables can be given an initial value:

const [count, setCount] = React.useState(1);
console.log(count); // 1

We can also supply a function. React will call this function on the very first render to calculate the initial value:

const [count, setCount] = React.useState(() => {
  return 1 + 1;
});

console.log(count); // 2

This is sometimes called an initializer function. It can occasionally be useful if we need to do an expensive operation to calculate the initial value. For example, reading from Local Storage:

const [count, setCount] = React.useState(() => {
  return window.localStorage.getItem('saved-count');
});

If you're not familiar with the Local Storage API, it's a way for us to save values on the user's device, so that it persists even after the browser tab is closed, and can be accessed on their next visit.

The benefit here is that we're only doing the expensive work (reading from Local Storage) once, on the initial render, rather than doing it on every single render.

We'll see a full example of how to persist React state to Local Storage later in the course.

Hang on a sec… what?
(info)

Several students have wondered why this "secondary form" makes a difference. Aren't we only calculating it once, in either case?

What exactly is the difference between these two forms?

// Form 1:
const [count, setCount] = React.useState(
  window.localStorage.getItem('saved-count')
);

// Form 2:
const [count, setCount] = React.useState(() => {
  return window.localStorage.getItem('saved-count');
});
 Show more

Core React Loop

---

## Core React Loop

Source: /joy-of-react/02-state/03.01-core-react-loop

Core React Loop

So, we've seen that when we update a state variable by calling the setter function (setCount), the UI gets updated. But how does this work, exactly?

This question cuts straight to the core of React. The library, after all, is literally named for how it reacts to state changes!

This is a question we're going to keep coming back to, throughout this course, as we build our mental model for how React works. But let's see if we can start answering it!

Let's keep working with our “counter” example:

function Counter() {
  const [count, setCount] = React.useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      Value: {count}
    </button>
  );
}

As a bit of a review, let's talk about what happens when this component is rendered for the first time.

Our Counter function returns a bunch of JSX. Let's rewrite it in pure JavaScript, so we can see what's really going on here:

function Counter() {
  const [count, setCount] = React.useState(0);

  return React.createElement(
    'button',
    { onClick: () => setCount(count + 1) },
    'Value: ',
    count
  );
}

When this code runs, React.createElement produces a React element, which is a plain JavaScript object. It looks something like this:

{
  type: 'button',
  key: null,
  ref: null,
  props: {
    onClick: () => setCount(count + 1),
    children: 'Value: 0',
  },
  _owner: null,
  _store: { validated: false }
}

As we learned in the last module, React elements are essentially descriptions of the UI we want. We're saying in this case that we want a button that contains the text “Value: 0”.

We could visualize this JavaScript object as the following HTML snippet:

<button>
  Value: 0
</button>

Our React element, that JavaScript object, is describing this DOM structure. React takes that description, and turns it into the real thing. It creates a <button> DOM node and appends it to the page.

I didn't show the onClick handler in this little sketch, but it's very much a part of this process. When React creates and injects the <button> DOM node, it attaches our handler function.

Now, let's think about what happens when this button is clicked.

The setCount function will be called, and we'll pass in a new value. count will be incremented, from 0 to 1.

Whenever a state variable is updated, it triggers a re-render. Once again, React will call the Counter function. This creates a brand-new React element, a new description of the UI we want.

The new React element describes this DOM structure:

<button>
  Value: 1
</button>

(I'm showing it here as HTML since it's easier to demonstrate, but really, React deals with JavaScript objects that describe this markup.)

Each render is like taking a snapshot. We generate a description that shows what the UI should look like, based on the component's props/state. It's like a photo that captures what things were like at a moment in time.

And so, React has two snapshots:

<button>
  Value: 0
</button>
<button>
  Value: 1
</button>

The user clicked the button, and this second snapshot was generated. React now has to figure out how to update the DOM, so that it matches this latest snapshot.

You know those games where you're shown two slightly-different images, and you have to spot the differences?

(Source: Wikipedia
)

React essentially has to play this sort of game, hunting for changes between the two snapshots.

This process is known as reconciliation. Using fancy optimized algorithms, React figures out what's changed. It sees that the button's text content has changed from "Value: 0" to "Value: 1".

Once React has solved the puzzle and worked out what's different, it will need to commit these changes. With surgical precision, it updates the DOM, taking care to only tweak the things that need to be tweaked.

In this case, the operation would be something like:

button.innerText = "Value: 1";

This is the fundamental "flow" of React, the core loop. We can visualize this sequence like this:

Mount
Trigger
Render
Commit
Mount

When we render the component for the first time, there is no previous snapshot to compare to. And so, React will create all of the necessary DOM nodes from scratch, and inject them into the page.

Note: You can click the boxes to explore each of the 4 stages described above. ✨


Rendering Vs. Painting

---

## Rendering Vs. Painting

Source: /joy-of-react/02-state/03.02-rendering-vs-painting

Rendering Vs. Painting

So in this course, each module starts with a custom 3D illustration. You might remember seeing this complex machine from the initial lesson in this module.

I create these illustrations using 3D modeling software called Blender
:

In Blender, I can render my project to create a final image:

(This recording is sped up 150x, it's not actually that quick!)

The term “render” generally refers to this sort of thing: we're taking some sort of unprocessed raw input, and generating the final ready-to-use output.

Even in web frameworks, this definition is pretty consistent. In Express, for example, a request ends when we render an HTML template:

app.get('/user/profile', (req, res) => {
  const user = database.get(req.query.userId);

  // Generate the final HTML file and send it to the client:
  return res.render('profile', { name: user.name });
});

In React, however, the term “render” means something slightly different. I think so much confusion in React stems from this misunderstanding.

Let's look at an example. Suppose I have the following component:

function AgeLimit({ age }) {
  if (age < 18) {
    return (
      <p>You're not old enough!</p>
    );
  }

  return (
    <p>Hello, adult!</p>
  );
}

Our AgeLimit component checks an age prop and returns one of two paragraphs.

Now, let's suppose we re-render this component, and wind up with the following before/after pair of snapshots:

age: 16

{
  type: 'p',
  key: null,
  ref: null,
  props: {},
  children: "You're not old enough!",
}
age: 17

{
  type: 'p',
  key: null,
  ref: null,
  props: {},
  children: "You're not old enough!",
}

In both cases, age is less than 18, and so we wind up with the exact same UI. As a result, no DOM mutation happens at all.

So, when we talk about “re-rendering” a component, we aren't necessarily saying that anything will change in the DOM! We're saying that React is going to check if anything's changed. If React spots a difference between snapshots, it'll need to update the DOM, but it will be a precisely-targeted minimal change.

When React does change a part of the DOM, the browser will need to re-paint. A re-paint is when the pixels on the screen are re-drawn because a part of the DOM was mutated. This is done natively by the browser when the DOM is edited with JavaScript (whether by React, Angular, jQuery, vanilla JS, anything).

To summarize:

A re-render is a React process where it figures out what needs to change (AKA. “reconciliation”, the spot-the-differences game).
If something has changed between the two snapshots, React will “commit” those changes by editing the DOM, so that it matches the latest snapshot.
Whenever a DOM node is edited, the browser will re-paint, re-drawing the relevant pixels so that the user sees the correct UI.
Not all re-renders require re-paints! If nothing has changed between snapshots, React won't edit any DOM nodes, and nothing will be re-painted.

The critical thing to understand is that when we talk about “re-rendering”, we're not saying that we should throw away the current UI and re-build everything from scratch.

React tries to keep the re-painting to a minimum, because re-painting is slow. Instead of generating a bunch of new DOM nodes from scratch (lots of painting), it figures out what's changed between snapshots, and makes the required tweaks with surgical precision.

Additional resources
(info)

The official React docs cover this topic in depth in their new article, Render and Commit
.


Asynchronous Updates

---

## Asynchronous Updates

Source: /joy-of-react/02-state/03.03-async-updates

Asynchronous Updates

Alright, time to cover our first state-based footgun?!

Consider the following code. What value would you expect to see in the developer console when the user clicks the button for the first time?

function App() {
  const [count, setCount] = React.useState(0);

  return (
    <>
      <p>
        You've clicked {count} times.
      </p>
      <button
        onClick={() => {
          setCount(count + 1);

          console.log(count)
        }}
      >
        Click me!
      </button>
    </>
  );
}
1
0
2
1
3
undefined
4
None of the above

Pretty weird, right?

When we create our state variable, we initialize it to 0. Then, when we click the button, we increment it by 1, to 1. So shouldn't it log 1, and not 0?

Here's the catch: state setters aren't immediate.

When we call setCount, we tell React that we'd like to request a change to a state variable. React doesn't immediately drop everything; it waits until the current operation is completed (processing the click), and then it updates the value and triggers a re-render.

For now, the important thing to know is that updating a state variable is asynchronous. It affects what the state will be for the next render. It's a scheduled update.

Here's how to fix the code, so that we have access to the newer value right away:

function App() {
  const [count, setCount] = React.useState(0);

  return (
    <>
      <p>
        You've clicked {count} times.
      </p>
      <button
        onClick={() => {
          const nextCount = count + 1;
          setCount(nextCount);

          console.log(nextCount)
        }}
      >
        Click me!
      </button>
    </>
  );
}

Instead of passing that expression directly into the state-setter function, setCount(count + 1), we're “saving” it by storing it in a variable. We can then use that variable in our console.log statements, or anywhere else inside this onClick handler.

I like to use the prefix “next”, like nextCount or nextUser, since it conveys that we're talking about the future value of the state, what it will be on the next render. Ultimately, though, that's just my own personal preference. You can name these variables whatever you like.

Why does it work this way?

Given that this is such a common stumbling block, it's worth asking why it's set up this way. Wouldn't it be simpler if React updated the state variables right away?

Let's talk about it.

Video Summary

Here's the sandbox from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Exercises

---

## Exercises

Source: /joy-of-react/02-state/03.04-use-state-exercises

Exercises
Bastions and Basilisks Bug

You're building an in-browser role-playing game, Bastions and Basilisks, but you've hit a snag! The wrong values are being shown to the user when their character levels up.

Your mission is to fix the bug.

Acceptance Criteria:

When the “Level up” button is clicked, the alert that pops up should show the updated values for strength/dexterity/intelligence.
For example, when clicking the button for the first time, “strength” should be displayed as 7, not 6.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Character.js
import React from 'react';

function Character() {
  const [strength, setStrength] = React.useState(6);
  const [dexterity, setDexterity] = React.useState(9);
  const [intelligence, setIntelligence] = React.useState(15);

  function triggerLevelUp() {
    const nextStrength = strength + 1;
    const nextDexterity = dexterity + 2;
    const nextIntelligence = intelligence + 3;

    setStrength(nextStrength);
    setDexterity(nextDexterity);
    setIntelligence(nextIntelligence);

    window.alert(`
      Congratulations! Your hero now has the following stats:
      Str: ${nextStrength}
      Dex: ${nextDexterity}
      Int: ${nextIntelligence}
    `);
  }

  return (
    <div className="wrapper">
      <img
        alt="8-bit wizard character"
        src="https://sandpack-bundler.vercel.app/img/mage-sprite.gif"
      />
      <button onClick={triggerLevelUp}>Level Up</button>
    </div>
  );
}

export default Character;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
Counter 2.0

The counter has been upgraded, and now supports several functions.

The buttons have already been added to the page, but they don't do anything yet. Your job is to wire up the buttons.

Acceptance Criteria:

The
 button should increase the count by 1.
The
 button should increase the count by 10.
The
 button should reset the count to 0.
The
 button should set the count to a random number between 1 and 100.
The
 button should decrease the count by 10.
The
 button should decrease the count by 1.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Icons and visually-hidden?
(warning)

This playground makes use of a third-party dependency, react-feather, to provide the handy-dandy icons within each button. This is my go-to icon package for React, and we'll see it throughout the course.

We're also using the “visually hidden” trick we saw in the Conditional Rendering exercises.

Solution:

Solution code
(success)

 Show more

Avoiding the clamp function
(info)

Several students have reached out to say that a random value from 1 to 100 can also be generated with the following expression: Math.floor(Math.random() * 100) + 1. This seems like a good approach to me. 👍


Why the Dance?

---

## Why the Dance?

Source: /joy-of-react/02-state/03.05-why-the-dance

Why the Dance?

Video Summary

Outdated syntax
(info)

In this video, I doodle some code that looks like this:

ReactDOM.render(<App />);

I'm showing my age here 😅 this is how we used to render React apps, but it changed in React 18. It should have been this instead:

import { createRoot } from 'react-dom/client';

const root = createRoot(container);
root.render(<App />);

Rest assured, we used the correct / modern syntax earlier in the course when we covered this process. Sorry for any confusion!


Forms

---

## Forms

Source: /joy-of-react/02-state/04-forms

Forms

So, forms are one of the most-disliked aspects of front-end development. We hate building them.

And yet, forms are super important! They're everywhere. The world's most popular website, Google.com, is literally just a form.

The React ecosystem is huge, and there are lots of packages out there claiming to solve forms. In my opinion, however, they aren't necessary most of the time. Forms aren't actually that bad to work with in React!

In the lessons that follow, we'll learn how to set up data binding with form inputs, learn about one of the most critical concepts in React development, and see how we can build longer forms with fewer headaches.


Data Binding

---

## Data Binding

Source: /joy-of-react/02-state/04.01-data-binding

Data Binding

When building web applications, we often want to sync a bit of state to a particular form input. For example, a "username" field should be bound to the value of a username state variable.

This is commonly known as “data binding”. Most front-end frameworks offer a way to bind a particular bit of state to a particular form control.

Here's what this typically looks like in React:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function SearchForm() {
  const [searchTerm, setSearchTerm] = React.useState('');

  return (
    <>
      <form>
        <label htmlFor="search-input">
          Search:
        </label>
        <input
          type="text"
          id="search-input"
          value={searchTerm}
          onChange={(event) => {
            setSearchTerm(event.target.value);
          }}
        />
      </form>
      <p>
        Search term: {searchTerm}
      </p>
    </>
  );
}

export default SearchForm;
Result
Console
Refresh results pane

If you'd like, take a few minutes and poke at this. What happens if you change or remove the value or onChange attributes?

Let's dig into it:

Video Summary

Here's the sandbox from the end of the video:

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

Synthetic events
(info)

I mentioned in the video above that React uses a “synthetic” event system. The events are special objects created by React, not the standard events used in JavaScript.

Why does React do this? Several reasons:

It can ensure consistency, removing some edge-case issues with native events being implemented slightly differently between browsers.
It can include a few helpful “extras”, to improve the developer experience
In earlier versions, this event system had a slight beneficial impact on performance, though those changes have since been removed. If you see references online to “event pooling” or event.persist(), you can ignore them, since this system was removed in React 17.

If you ever need to access the “real” event object, you can access it like this:

<input
  onChange={(event) => {
    const realEvent = event.nativeEvent;

    console.log(realEvent); // DOM InputEvent object
  }}
/>

If you're particularly curious about events, you can learn more by reading the official “Events” documentation
.

Controlled vs. Uncontrolled inputs

When we set the value attribute on a form input, we tell React that it should be a controlled input. The word “controlled” has a specific definition in React; it means that React is managing the input.

By contrast, if we don't set value, the input is an uncontrolled input. This means that React doesn't do any management.

There's a golden rule here: An input should always either be controlled or uncontrolled. React doesn't like when we flip an element from one to the other.

This can lead to a common footgun. Let's learn about it, so that we can avoid it.

Consider this situation:

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

Try typing in the text input, and then switch to the “Console” tab. You should see a warning that begins like this:

Warning: A component is changing an uncontrolled input to be controlled.

This is weird, right? This input is controlled! We're setting value={username} from the very first render!

Here's the problem: username is undefined at first, since there is no default value in the state hook. Here's a simplified version of what we're doing:

const username = undefined;

<input
  type="text"
  id="username"
  value={username}
  onChange={event => {
    setUsername(event.target.value);
  }}
/>

When we set value to undefined, it's the same as not setting it at all. React will treat the input as an uncontrolled input.

When the user starts typing in the input, the onChange event updates the value of username from undefined to a string. And so, React flips the element to a controlled input, and raises the warning.

Here's how to solve the problem: We always want to make sure we're passing a defined value. We can do this by initializing username to an empty string:

// 🚫 Incorrect. `username` will flip from `undefined` to a string:
const [username, setUsername] = React.useState();

// ✅ Correct. `username` will always be a string:
const [username, setUsername] = React.useState('');

With this change, our input is being controlled by React state from the very first render, since we're always passing a defined value. Even though empty strings are considered falsy 👀, they still “count” when it comes to controlling React inputs.

Actions in React 19
(warning)

React 19 introduced a new way of working with forms called Actions. Here’s what it looks like:

function ContactForm() {
  const [error, submitAction, isPending] = React.useActionState(
    async (previousState, formData) => {
      const name = formData.get("name");
      const msg = formData.get("message")

      const error = await sendMessageToServer(name, msg);

      if (error) {
        return error;
      }

      redirect("/path");
      return null;
    },
    null,
  );

  return (
    <form action={submitAction}>
      <input type="text" name="name" />
      <textarea type="text" name="message" />
      <button type="submit" disabled={isPending}>Update</button>
      {error && <p>{error}</p>}
    </form>
  );
}

As discussed in the “About React 19” lesson, this course doesn’t yet cover the Actions API. If/when this API is adopted by the community, I will likely add some content to this course. But even if that becomes the case, the stuff you’re learning in these lessons will still be relevant.

With Actions, we don’t use controlled inputs at all. There is no data binding; instead, React collects all of the data from all of the inputs when the form is submitted. We can then do whatever we need with this data (eg. sending it to the server).

The main advantage of this method is that it’s less tedious, since we don’t have to set up state variables for every single form field. For long forms with lots of fields, this can be a bit of a timesaver. Actions also includes additional abstractions to help with things like optimistic updates (changing the UI before that change has been confirmed by the server).

But Actions won’t solve all of our form-related problems. Consider the first example in this lesson, the search form. In that example, we're displaying the user's search term in realtime, below the form:

With Actions, we only have access to the form data on submit. If we want to do something with it before submitting the form, we’ll need to store it in state. And so in cases like this, we’d still want to use a controlled input, even if we adopt Actions for other forms.


The onClick Parable

---

## The onClick Parable

Source: /joy-of-react/02-state/04.02-on-click-parable

The onClick Parable

There's a mistake I've seen lots of React developers make. This lesson is a cautionary tale about it.

Let's suppose we're building a search form:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
SearchForm.js
import React from 'react';

function SearchForm({ runSearch }) {
  const [searchTerm, setSearchTerm] = React.useState('');

  return (
    <div className="search-form">
      <input
        type="text"
        value={searchTerm}
        onChange={event => {
          setSearchTerm(event.target.value);
        }}
      />
      <button>
        Search!
      </button>
    </div>
  );
}

export default SearchForm;
Result
Console
Refresh results pane

In this example, runSearch is the function we want to call when the user clicks/taps the "Search!" button. In Module 3, we'll learn how to make network requests, but for now, it's a stub?.

Here's the question: how should I use this function?

A lot of developers instinctively solve for this by adding an onClick handler to the submit button:

<button onClick={() => runSearch(searchTerm)}>
  Search!
</button>

There are a number of problems with this approach. For example, what if the user tries to search by pressing "Enter" after typing in the text input?

Well… I suppose we could tackle that with an onKeyDown event listener?

<input
  type="text"
  value={searchTerm}
  onChange={event => {
    setSearchTerm(event.target.value);
  }}
  onKeyDown={event => {
    if (event.key === 'Enter') {
      runSearch(searchTerm);
    }
  }}
/>

We're going down a bad road here. We're re-implementing stuff that the browser already knows how to do!

Use a form

To solve this problem, along with so many others, we should wrap our form controls in a <form> tag.

Then, instead of listening for clicks and keys, we can listen for the form submit event.

Look how much simpler the code gets:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
SearchForm.js
Result
Console
Refresh results pane

The form submit event will be called automatically when the user clicks the button, or presses "Enter" whenever the input or button is focused. When that event fires, we'll run our search.

Instead of trying to re-create a bunch of standard web platform stuff, we should use the platform and let it solve these sorts of problems for us!

By using a form submit event, we get to use client-side validation:

<input
  type="password"
  required={true}
  minLength={8}
/>

Learn more about validation attributes like required, minLength, and pattern on MDN
.

Default form behavior

Alright, so there is one little quirk with using onSubmit. We need to prevent the default submission behavior:

<form
  className="search-form"
  onSubmit={event => {
    event.preventDefault();
    runSearch(searchTerm);
  }}
>

To understand why this is necessary, we need to take a trip back through time, to an era without client-side requests. Before fetch, before XMLHttpRequest, before JSON.

If you wanted to make a request to a server, like when fetching search results, you couldn't request only the data. You needed to request a whole new HTML file. Essentially, the user would be redirected to a new URL, and the server would then render a template into an HTML document, using the data sent with the request.

Forms still operate this way by default. When you submit a form, the browser will try to send the user to the URL specified by the action attribute:

<!--
  Submitting this form will redirect the user to the
  /search page, sending along the data collected from
  the form fields.
-->
<form
  method="POST"
  action="/search"
>

If we omit the action attribute, the browser will use the current URL, effectively reloading the page.

In the context of a modern React application, this isn't usually what we want. We don't want to reload the entire page, we want to fetch a bit of data and re-render a few components with that data. This produces a faster, smoother user experience.

That's why we need to include event.preventDefault(). It stops the browser from executing a full page reload.


Other Form Controls

---

## Other Form Controls

Source: /joy-of-react/02-state/04.03-other-form-controls

Other Form Controls

In addition to the text inputs we've been using so far, the web platform provides lots of additional form controls. They include:

Textareas
Radio buttons
Checkboxes
Selects
Ranges
Color pickers

If you've ever had to work with these form controls outside of React, you've likely been surprised/frustrated by how dissimilar they are from one another.

For example, textareas define the current value as children, rather than using a value prop:

<textarea>
  This is the current value
</textarea>

As another example, select tags use a selected prop on one of the <option> children to signify the selected value:

<select>
  <option value="a">
    Option 1
  </option>
  <option value="b" selected>
    Option 2
  </option>
  <option value="c">
    Option 3
  </option>
</select>

Here's the good news: React has tweaked many of these form controls so that they all behave much more similarly. There's a lot less chaos with form controls in React.

Essentially, all form controls follow the same pattern:

The current value is locked using either value (for most inputs) or checked (for checkboxes and radio buttons).
We respond to changes with the onChange event listener.

In this lesson, we're going to go over a couple of common examples. You'll also find a bonus cheatsheet at the end of this module that provides a quick reference for all form controls!

Quick terminology clarification
(warning)

In the “Data Binding” lesson, we learned about “controlled inputs”. The word input in this case refers not only to the <input> HTML element, but to any form control, including <textarea>, <select>, etc.

In fact, when I talk about “inputs”, you can generally assume I mean any form element that accepts user input. If I'm referring specifically to the <input> tag, I'll say “text input”.

Select tag

The <select> tag allows the user to select a single option from a list of predefined options.
*

When working with select tags in React, they work pretty much exactly like text inputs. We use value and onChange. Here's an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

By setting the value prop, we make this a controlled component, binding the selected option to our React state. When we add the onChange event listener, we allow this state to be changed by selecting a different option from the list.

Honestly, this feels like a huge improvement to me, compared to the default functionality of this form control. We don't have to fuss with adding the selected attribute to one of the <option> children; instead, we use the same pattern we know and love.

Radio buttons

Alright, so radio buttons are a bit trickier.

Ostensibly, they serve the same purpose as a <select> tag; they allow the user to select 1 choice from a group of options.

The tricky thing, though, is that this state is split across multiple independent HTML elements. There's only one <select> tag, but there are multiple <input type="radio"> buttons!

Let's start by looking at an example of a controlled radio button group in React:

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

Phew, that's a lot of properties! Let's look at each one in turn.

name — The browser needs to know that each button is part of the same group, so that ticking one option will untick the others. This is done through the name prop. Each radio button in a group should share the same name.
value — Each radio button has its own value. This property will be copied over to our React state when the option is ticked. This is the definition / meaning for each radio button.
id — like other form controls, this is needed so that the <label> can be associated with the right input, so that clicking the label focuses the input.
checked — This is the prop that binds a given radio button to our React state, making it a controlled value. It should be set to a boolean value: true if it's ticked, false if it's not. Only one radio button should be set to true at a time.

Even though it looks quite different, it does follow the same rough formula. We use an onChange event listener to detect when a given option is ticked. When that happens, we update the React state.

For most other inputs, we bind React state to the value prop. In this case, though, we don't have a single value prop to bind to, since we have multiple radio buttons. So instead, we bind to checked, controlling the ticked/unticked status for each button in the group with React state.

Radio buttons or select?
(info)

Both radio buttons and <select> tags are used for the same purpose: to allow the user to select a single value from a list of possible options. So which one should we use, in any given circumstance?

 Show more

There are lots of other form controls, but React does a good job making sure that they all follow the same conventions. For a complete reference, check out the bonus cheatsheet at the end of the module


Exercises

---

## Exercises

Source: /joy-of-react/02-state/04.04-exercises

Exercises
Controlled Country Picker

The “Big List O’ Countries” select is a staple of e-commerce sites. Let's build one!

Using the data provided in the COUNTRIES object, create a <select> tag with options for every country. Bind this <select> tag to the provided country state variable.

Acceptance Criteria:

Use the COUNTRIES constant to dynamically generate the set of <option> elements.
In order to map over an object, you'll need to use something like Object.keys()
 or Object.entries()
There should be a "blank" option, selected by default. It shouldn't default to the first country in the list.
The indicator at the bottom should update when the user changes their selected country.
No warnings in the dev console

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
data.js
import React from 'react';

import { COUNTRIES } from './data';

const countryNames = Object.entries(COUNTRIES);

/*
  “COUNTRIES” is a dictionary-like object
  with the following shape:

  {
    AF: "Afghanistan",
    AL: "Albania",
    DZ: "Algeria",
  }
*/

function App() {
  const [country, setCountry] = React.useState('');

  return (
    <form>
      <fieldset>
        <legend>Shipping Info</legend>
        <label htmlFor="country">Country:</label>
        <select
          id="country"
          name="country"
          value={country}
          onChange={(event) => {
            setCountry(event.target.value);
          }}
        >
          <option value="">- Set Countries -</option>
          <optgroup label="Countries">
            {countryNames.map(([id, label]) => (
Result
Console
Refresh results pane

Controversial Countries
(info)

The world is a big and complex place, and not everyone agrees on whether certain regions are countries or not.

These sorts of geo-political considerations are wayyy above my head, and so I've outsourced this calculation. I'm relying on ISO country codes
 to make the determination for me.

Solution:

Solution code
(success)

 Show more
Two-Factor Authentication

Two-factor authentication has quickly become a best practice in terms of securing logins for highly-sensitive accounts. The most common form I've seen is that the user is prompted to enter a short code, generated from an app.

In this exercise, we'll build this form!

Acceptance Criteria:

The input's value should be held in React state.
When the user submits their code, a window.alert should let them know whether it's correct or not, by comparing their submitted value with the CORRECT_CODE constant.
A <form> tag should be used.
Hint

Seeing the page refresh after the user clicks "Validate"? You need to manage the default behavior.

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

Solution code
(success)

 Show more
Generative Art

In this exercise, we're building a tool to produce generative art!

The tool is nearly complete, but the form controls need to be wired up. Your job is to connect the React state to the form controls, so that tweaking the controls will update the art.

Acceptance Criteria:

The range slider should be bound to the numOfLines state.
The select control should be bound to the colorTheme state.
The radio buttons should be bound to the shape state.
The radio button labels should work correctly. The user should be able to click the text "Polygons" to select that option.
The inputs should conform to HTML standards (eg. radio buttons should be grouped using the “name” attribute).

Note: All of your changes should happen in App.js. The other files are shown in case you're curious how it works, but you can safely ignore them and focus exclusively on App.js.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
constants.js
utils.js
GenerativeArt.js
Result
Console
Refresh results pane

Solution:

Video Summary

Solution code
(success)

 Show more

Props Vs. State

---

## Props Vs. State

Source: /joy-of-react/02-state/05-props-vs-state

Props Vs. State

When learning React, it's normal for the concepts of "props" and "state" to be a bit intermingled. What's the difference between them, exactly? When do you use props, and when do you use state?

In this lesson, our goal is to clarify this common source of confusion.

Props

“Props” is short for “properties”. At a micro level, they're like the attributes we place on HTML elements, like class or href:

<a
  class="nav-link"
  href="/category/stuff"
>

For example, the Button component below takes a “variant” prop. This prop will be used internally to control styling, like how the class attribute works in HTML.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Button.js
Button.module.css
import React from 'react';

import Button from './Button';

function App() {
  const [hasAgreed, setHasAgreed] = React.useState(true);

  return (
    <div className="box">
      <p>
        Are you sure you want to continue?
      </p>
      <label htmlFor="confirm-checkbox">
        <span className="required">*</span>
        <input
          id="confirm-checkbox"
          type="checkbox"
          value={hasAgreed}
          onChange={() => setHasAgreed(!hasAgreed)}
        />
        <span>
          I agree with <a href="/terms">the terms</a>.
        </span>
      </label>
      <div className="actions">
        <Button
          variant="secondary"
          isEnabled={true}
        >
          Cancel
        </Button>
        <Button
          variant="primary"
          isEnabled={hasAgreed}
        >
          Confirm
Result
Console
Refresh results pane

Props allow us to customize the behaviour of a given component, so that the exact same component can do different things in different scenarios.

Props are the inputs to our components, like arguments passed to a function.

State

In the example above, our application is completely static. Every time we run this code, we get the same result. This will be true until the heat death of the universe.

But what if we wanted stuff to change over time? That's where state comes in.

Let's tweak our example a bit:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Button.js
Button.module.css
Result
Console
Refresh results pane

We have a new bit of state, hasAgreed, and we need to use that data to power our “Confirm” button. This reveals an important truth about props: they're the tunnels that allow data to flow through our application.

Let's dig into this idea.

Video Summary

Coming up with the right prop names
(info)

Instead of making up an isEnabled prop, I could have chosen to name my prop disabled, like this:

function Button({ variant, disabled, children }) {
  return (
    <button
      className={`${styles.wrapper} ${styles[variant]}`}
      disabled={disabled}
    >
      {children}
    </button>
  );
}

In fact, this is how I would likely do it in a real-world context, but I chose isEnabled in this example to avoid the ambiguity of having two things — our custom prop, and the HTML attribute — both named disabled.

Don't disable buttons
(warning)

In this example, I disable a button using the disabled attribute. I’ve since learned that we generally don’t want to disable buttons, since they don’t provide any feedback to the user. It’s not always clear why a button can’t be clicked, and it can lead to very frustrating user experiences.

Instead, buttons should always be clickable, and if they’re clicked before the form is ready to be submitted, we can provide an explanation so that the user knows what they need to fix. Native HTML validation already works like this, and we can use the same pattern for more-complex use cases.


Complex state

---

## Complex state

Source: /joy-of-react/02-state/06-complex-state

Complex state

So far, we've seen how we can store numbers and strings in React state. In many real-world cases, however, our state will be in a more complex shape, like an object or an array.

For example: a while back, I built a gradient generator tool
. Users can select 2 to 5 colors, and we'll use that state to generate a gradient.

How would you track the state for the colors?

In my case, I created a colors state variable. It holds an array of strings:

const [colors, setColors] = React.useState(['#FFD500', '#FF0040']);

React doesn't care what type our state is. We can store numbers or strings or arrays or objects. We can even store functions in state if we want!
*

But there's a catch: React state changes have to be immutable. When we call setColors, we need to provide a brand new array. We should never mutate arrays or objects held in state.

Immutability is a big topic in JavaScript, and one we'll chip away at in the lessons ahead, and throughout the course.

Assignment vs. Mutation
(info)

Before jumping into these lessons, it's important to understand the distinction between “assignment” and “mutation”. There's a lesson on this topic in the JavaScript Primer. If you're not already super comfortable with JavaScript, I'd recommend giving it a look before continuing:

Assignment Vs. Mutation 👀

Mutation Bugs

---

## Mutation Bugs

Source: /joy-of-react/02-state/06.01-mutation-bugs

Mutation Bugs

Video Summary

References:

“Rest / Spread” JavaScript Primer lesson 👀
“Assignment Vs. Mutation” JavaScript Primer lesson 👀

Initial code from video:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
import React from 'react';

function App() {
  const [colors, setColors] = React.useState([
    '#FFD500',
    '#FF0040',
  ]);

  const colorStops = colors.join(', ');
  const backgroundImage = `linear-gradient(${colorStops})`;

  return (
    <>
      <div
        className="gradient-preview"
        style={{
          backgroundImage,
        }}
      /> knhn  cvb

      <form>
        {colors.map((color, index) => {
          const colorId = `color-${index}`;

          return (
            <div key={colorId} className="color-row">
              <label htmlFor={colorId}>
                Color {index + 1}:
              </label>
              <input
                id={colorId}
                type="color"
                value={color}
yg
              />
            </div>
Result
Console
Refresh results pane

Solution code
(success)

 Show more

Tricky business
(warning)

In this video, we cover some pretty tricky advanced topics around mutation and object references. If you haven't been exposed to these ideas before, this video was probably pretty overwhelming!

If you're feeling lost, check out this blog post by Dave Ceddia: A Visual Guide to References in JavaScript
. It's a wonderful exploration of these ideas, and hopefully can help clarify things quite a bit!

And if you're still feeling confused, please don't worry too much. Later in this course, we'll learn about a tool called Immer
. When we use Immer, we don't really have to worry about this stuff, since Immer makes it impossible to accidentally mutate objects and arrays.

Never mutate React state (even when it seems to work)

In the solution above, the order of operations was:

Create a new array
Modify that new array
Set the new array into state

You might be wondering: is it OK to flip the order of the first two steps? What if we modify the array, then clone it? Like this:

<input
  onChange={event => {
    // Mutate the array:
    colors[index] = event.target.value;

    // Create a new copy, and set it into state:
    setColors([...colors]);
  }}
/>

Seems a bit simpler, right? Make whatever modifications we want, and then copy the array right before we call setColors, so that we're providing a new value. And if you try this in the above sandbox, it appears to work?

Here's the problem: By doing it this way, we're modifying the values held in React state. React really doesn't expect us to do this, and there are no guardrails in place to warn us if we try.

You might get away doing this once, but if you make a habit of it, you'll likely start encountering weird / glitchy behaviour. Maybe a random part of the page won't update when it's supposed to. Or maybe the DOM structure will get shuffled, teleporting an element so that it sits in a totally different DOM container.

These bugs are really hard to diagnose and fix. You'll save yourself a whole lot of trouble if you do your best to avoid mutating React state.

But isn't this inefficient?

Some students have asked: isn't it inefficient to be creating brand-new arrays on every single change? Wouldn't it be much more performant to mutate the existing array instead?

When it comes to React state, there is no choice; we need to produce a new array whenever the state changes.

Fortunately, though, this isn't an issue. Cloning an array is an incredibly quick operation.

I decided to time it, to see how long it actually takes:

<input
  id={colorId}
  type="color"
  value={color}
  onChange={event => {
    console.time('perf-check')

    const nextColors = [...colors];
    nextColors[index] = event.target.value;

    console.timeEnd('perf-check')

    setColors(nextColors);
  }}
/>

console.time is a utility built into browsers which allows us to measure the amount of time that passes between the initial console.time call and the console.timeEnd call. The value we’re passing ('perf-check') is a name we provide for this particular timer (this allows us to run multiple timers simultaneously).

And what are the results? When I test this code on my Macbook Pro, it takes approximately 0.02 milliseconds (1/50,000th of a second).

Let's make it worse. What if we do the same work a thousand times?

<input
  id={colorId}
  type="color"
  value={color}
  onChange={event => {
    console.time('perf-check')

    let nextColors;
    for (let i = 0; i < 1000; i++) {
      nextColors = [...colors];
      nextColors[index] = event.target.value;
    }

    console.timeEnd('perf-check')

    setColors(nextColors);
  }}
/>

This work takes between 0.2ms and 0.3ms. It’s not 1000 times slower, presumably because the browser has ways to optimize this sort of work.

Hang on, though: my expensive Apple laptop is significantly more powerful than a typical computer. How does it perform on lower-end hardware?

I repeated the test on my Acer NX TravelMate laptop, an Intel Celeron device which costs less than US$150 when I purchased it new, several years ago. On this machine, this work takes around 2 milliseconds.

To put these numbers into perspective, an average human blink lasts ~100 milliseconds. If something takes less than 100 milliseconds, we generally perceive it as instantaneous. And so, even when we do 1000x more work than is actually necessary, we’re still nowhere near a perceptible amount of time.

To be fair, it does depend on the size of the array. If we had a million items in the array, that might be a different story. But we generally don't work with enormous data sets on the front-end, since it would take too long to transfer that much data over the network, and low-end devices wouldn't have the memory to hold it all. Iteration speed is rarely the limiting factor on the front-end.

It's a good idea to test our intuition with this stuff. If you ever find yourself wondering whether a chunk of code is slow or not, give it a quick test and see for yourself!

I've done these sorts of tests a lot, and I've really come to appreciate how ⚡️ blazing fast ⚡️ modern JS engines are, even on lower-end devices. When it comes to front-end performance, we have bigger things to worry about than this stuff. We'll talk more about performance later in this course.


Exercises

---

## Exercises

Source: /joy-of-react/02-state/06.02-state-exercises

Exercises
Gradient generator

Let's keep working on our gradient generator tool! Instead of limiting the user to 2 colors, we'll let them add up to 5 colors.

Acceptance Criteria:

The color inputs should work; picking a new color should update the gradient accordingly.
Clicking “Add color” should add a new color, at the end of the array.
Clicking "Remove color" should remove the last color in the array.
When adding new colors, they should default to #FF0000 (bright red).
There should always be between 2 and 5 colors. No more, no less.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
import React from 'react';
function App() {
  const [colors, setColors] = React.useState([
    '#FFD500',
    '#FF0040',
  ]);

  const colorStops = colors.join(', ');
  const backgroundImage = `linear-gradient(${colorStops})`;

  return (
    <div className="wrapper">
      <div className="actions">
        <button>
          Remove color
        </button>
        <button>
          Add color
        </button>
      </div>

      <div
        className="gradient-preview"
        style={{
          backgroundImage,
        }}
      />

      <div className="colors">
        {colors.map((color, index) => {
          const colorId = `color-${index}`;
          return (
            <div key={colorId} className="color-wrapper">
              <label htmlFor={colorId}>
                Color {index + 1}:
              </label>
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Avoiding window.alert
(warning)

In the solution above, I provide the user with feedback about why certain actions are disallowed using window.alert.

This is a quick and dirty way to give the user some feedback, but it’s not recommended for real applications. Instead, we should come up with some sort of error UI (a tooltip, a banner, etc), and we should conditionally show/hide this UI using an extra bit of React state.

It’s beyond the scope of this lesson, but we’ll see several examples of how to do this later in the course, in both the word game project and Toast component project.

Stretch Goal

When the user removes and then re-adds a color, it should be restored to the previously-set value, rather than being reset to #FF0000.

Here's an example. Notice how the blue and green colors are "remembered", instead of being re-added as bright red:

If your solution already works this way, you're done! But I suspect most students will need to make some pretty substantial tweaks to implement this new requirement.

You can continue working in the sandbox above. Also, we cover some very interesting ground in the “stretch” solution video below, so be sure to check it out!

Stretch goal solution:

Solution code
(success)

 Show more

Dynamic Key Generation

---

## Dynamic Key Generation

Source: /joy-of-react/02-state/07-key-generation

Dynamic Key Generation

In the last module, we learned about React keys. When iterating over data with .map, we need to give each React element a unique key attribute so that React knows which DOM operations to trigger between renders.

In the earlier examples, our data conveniently came with unique tokens for each item, and we were able to use those tokens:

const inventory = [
  {
    id: 'abc123',
    name: 'Soft-boiled egg press',
  },
  {
    id: 'def456',
    name: 'Hello Kitty toothbrush',
  },
];

// We can use the `id` field in our iterations:
inventory.map(item => (
  <ShopItem key={item.id} item={item} />
));

But what if our data doesn't have a unique token we can use?

In fact, this is one of the most common questions that developers have. React needs a unique value for each item, but we don't always have one!

Let's explore with an example.

Stickers!

In the sandbox below, you can click to produce randomized stickers:

The core logic has been completed, but we're getting a key warning in the console! Let's fix it.

I'll walk through exactly how this code works and how we can solve this problem, but I'd encourage you to spend a few minutes tinkering with it yourself, to see if you can understand what's going on and come up with any solutions.

The goal is to fix the key warning by dynamically generating the keys for each sticker.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
StickerPad.js
Stickers.data.js
StickerPad.module.css
Result
Console
Refresh results pane

This code is pretty complex. Let's talk about it, and see how we can fix the key warning:

Video Summary

Here's the final code from the video:

function StickerPad() {
  const [stickers, setStickers] = React.useState([]);

  return (
    <button
      className={styles.wrapper}
      onClick={(event) => {
        const stickerData = getSticker();
        const newSticker = {
          ...stickerData,
          x: event.clientX,
          y: event.clientY,
          // Come up with a unique value for this sticker.
          id: crypto.randomUUID(),
        };

        const nextStickers = [...stickers, newSticker];
        setStickers(nextStickers);
      }}
    >
      {stickers.map((sticker) => (
        <img
          // Use that previously-created unique value
          // for the key:
          key={sticker.id}
          className={styles.sticker}
          src={sticker.src}
          alt={sticker.alt}
          style={{
            left: sticker.x,
            top: sticker.y,
            width: sticker.width,
            height: sticker.height,
          }}
        />
      ))}
    </button>
  );
}

Solved it another way?
(warning)

If you gave this problem a shot, it's very likely that you came up with a different solution. Your solution might even be a lot simpler than the one I came up with!

It turns out, many of the seemingly-simpler solutions have pretty substantial drawbacks in certain situations: they can lead to performance problems, or glitchy UI bugs.

We'll dig into two common alternative solutions in the next lesson, and see exactly what those risks are.


---

## Key Gotchas

Source: /joy-of-react/02-state/07.01-key-gotchas

Key Gotchas

Video Summary

Here are the two sandboxes from the videos above, with comments explaining some things that were glossed over in the video:

Removable stickers:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
StickerPad.js
Stickers.data.js
StickerPad.module.css
import React from 'react';

import styles from './StickerPad.module.css';
import { getSticker } from './Stickers.data';

function StickerPad() {
  const [stickers, setStickers] = React.useState(
    []
  );

  function addSticker(event) {
    const stickerData = getSticker();
    const newSticker = {
      ...stickerData,
      x: event.clientX,
      y: event.clientY,
    };

    const nextStickers = [...stickers, newSticker];
    setStickers(nextStickers);
  }

  // This method removes the sticker at the specified
  // index. Since we're not allowed to mutate arrays
  // that are held in state, we create a copy of the
  // array using the spread syntax (...), and then use
  // the `splice` method to remove the sticker:
  function deleteSticker(index) {
    const nextStickers = [...stickers];
    nextStickers.splice(index, 1);
    setStickers(nextStickers);
  }

  return (
    <>
      <button
Result
Console
Refresh results pane

Invitee List:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Preview
Refresh results pane
Console
Clear Console

Bending the rules
(info)

In this lesson, we saw some examples of how using the array index as the key can lead to trouble. I mention at the end of the video that you can avoid all of these problems by following the “generate a random value” strategy I shared in the previous lesson.

But, do we always need to do this? Or is it sometimes OK to use the array index as the key?

Technically, it is safe to use the array index as the key if the order stays 100% consistent. If the items never change position, there won't be any issues.

But here's the thing: it's not always obvious when the order changes. There are lots of situations that can lead to problems. Here's an incomplete list:

Deleting items.
Adding new items to the start/middle of the array.
Changing the way the items are sorted (eg. ascending → descending).
Filtering the items to show/hide certain elements.

There have been times where I thought it was safe to use the array index as the key, and I turned out to be wrong. 😬

Eventually, I reached a point where I got really comfortable with this stuff, and these days, I do occasionally use the array index as the key, when I'm 100% confident that it won't cause any problems (and I'm feeling a bit lazy 😅).

But until you reach that level of comfort, I'd recommend always taking a couple of extra minutes and doing things the right way, generating a truly unique value for each element in the array. It's a bit more work upfront, but it can avoid a lot of confusion down the road.


---

## Lifting State Up

Source: /joy-of-react/02-state/08-lifting-state-up

Lifting State Up

If you've spent time in React communities, there's a very good chance you've overheard the term lift state up. It's sorta become the catchphrase of the React developer!

There's a good reason for this, though. Lifting state up is an incredibly important idea, a vital tool in every React developer's toolbox. As a result, this is one of the most critical lessons in this entire course!

We'll explore the concept of lifting state up by seeing how it helps us in a sample application:

Video Summary

Is your head spinning?
(info)

I remember when I first encountered the idea of lifting state up. It hurt my brain a bit. The idea that the parent passes down a function so that the child can update the parent's state is wild, the first time you see it!

Take some time and play with the playgrounds provided below. Hopefully, a bit of hands-on experimentation will help the idea sink in. I'd encourage you to add lots of console.log calls so you can see exactly which components render, and when!

Here's the original code from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
SearchForm.js
SearchResults.js
Result
Console
Refresh results pane

And here's the final code, with the state lifted up:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
SearchForm.js
SearchResults.js
Result
Console
Refresh results pane

---

## Exercises

Source: /joy-of-react/02-state/08.01-lift-exercises

Exercises
Toonie Clicker

“Cookie Clicker” is a casual web-based game. You click a big cookie to earn points, and then use those points to buy items that click the cookie for you.

In this exercise, we'll build a simple version of the game. Instead of a cookie, we'll use a Canadian toonie.

Acceptance Criteria:

“Your coin balance”, at the bottom of the page, should update to show the value of numOfCoins.
Clicking the coin should increment this value by 2 (since it's a $2 coin).

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
BigCoin.js
import React from 'react';

import BigCoin from './BigCoin';

function App() {
  return (
    <div className="wrapper">
      <main>
        <BigCoin />
      </main>
      <footer>
        Your coin balance:
        <strong>0</strong>
      </footer>
    </div>
  );
}

export default App;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Calling state-setters with a callback function
(info)

If you have some previous React experience, you might be wondering why we haven't talked about the callback form for state-setter functions:

setNumOfCoins((currentValue) => {
  return currentValue + 2;
});

This is something we'll cover in depth later in this course, including why this secondary form exists and when you should use it. For now, I think it'll be easier if we pretend that this option doesn't exist. 😄

Shopping List

Unsatisfied with the plethora of shopping-list applications out there, we've decided to build our own!

A fellow developer has implemented the design in JSX, but it's entirely static. Your job is to update the code so that it works, like this:

Note: This exercise touches on some ideas we haven't explicitly learned about yet. It's OK if you can't come up with the solution; the important thing is that you give it a shot!

Acceptance Criteria:

The shown list of items should be driven from React state. We can remove the placeholder foods, and start with an empty list
Submitting the form should add a new item to the list, and show it in the UI
When submitting the form, the text input should be reset, so that it's empty. This way, users can easily add multiple items without having to erase their previous entry.
There should be no “key” warnings in the console. Ideally, you shouldn't use the index for the key.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
AddNewItemForm.js
Result
Console
Refresh results pane

Solution:

In this video, I use the “property value shorthand” when creating new items, for the label property. You can learn more about this in the “Property Value Shorthand” lesson 👀 in the JavaScript Primer.

Math.random() or crypto.randomUUID()
(warning)

In this solution, I say that Math.random() is the nicest way to come up with a unique value, but earlier, I used crypto.randomUUID() for this purpose. Which option is better?

Ultimately, both methods accomplish the same goal, and there aren't any significant differences between them. You can use whichever you prefer. I probably should've used crypto.randomUUID() here for consistency with the earlier lesson, but old habits die hard!

Solution code
(success)

 Show more
Why not pass the setter function directly?

Several students have wondered: wouldn't it be simpler to pass the setItems function down to AddNewItemForm?

Something like this:

function AddNewItemForm({ items, setItems }) {
  const [label, setLabel] = React.useState('');

  return (
    <div className="new-list-item-form">
      <form
        onSubmit={(event) => {
          event.preventDefault();

          const newItem = {
            label,
            id: Math.random(),
          };

          const nextItems = [...items, newItem];
          setItems(nextItems);

          setLabel('')
        }}
      >
        {/* Everything else unchanged */}
      </form>
    </div>
  );
}

export default AddNewItemForm;

This is a valid solution, and there's nothing wrong with it, but in my opinion, it's not the best approach to this problem.

Later in this course, in Module 5, we'll dig into exactly why I prefer not to pass the state-setter function directly in most cases.

For now, feel free to structure things however you like, especially if you're newer to React! My explanations will make more sense once you have more first-hand experience solving these sorts of problems.

---

## Component Instances

Source: /joy-of-react/02-state/09-component-instances

Component Instances

There's an important concept in React that is rarely discussed: whenever we render a component in React, we create a component instance.

A lot of the information online about component instances is very, very outdated; the most popular blog post on the topic is from 2016! React has changed a ton since then, and many things mentioned in the article just aren't true anymore.

Let's dig into it.

Video Summary

Here's the first sandbox from the video, the minimal React app:

Code Playground

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
import React from 'react';
import { createRoot } from 'react-dom/client';

function RandomNumber() {
  const [num, setNum] = React.useState(0);

  return (
    <button onClick={() => setNum(Math.random())}>
      Current number: {num}
    </button>
  );
}

const root = createRoot(document.querySelector('#root'));
root.render(
  <>
    <RandomNumber />
  </>
);
Result
Console
Refresh results pane

…And here's the second sandbox from the video, the more-complex application with toggleable footer.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Elements don't create instances, rendering does
(info)

Suppose we have the following code:

import React from 'react';

function Counter({ initialValue = 0 }) {
  const [count, setCount] = React.useState(initialValue);

  return (
    <button onClick={() => setCount(count + 1)}>
      {count}
    </button>
  );
}

const elem = <Counter initialValue={10} />;

console.log(elem);

We're creating a <Counter /> element, but we aren't doing anything with it. As a result, the Counter component won't actually be rendered. There will be no component instance, no count state variable, none of that.

Elements are descriptions of what we want to create. In this case, we're describing a Counter with an initial value of 10:

{
  type: ƒ Counter,
  key: null,
  ref: null,
  props: {
    initialValue: 10
  },
  _owner: null,
  _store: {}
}

In order to create a component instance, we have to render it:

import { createRoot } from 'react-dom/client';

const root = createRoot(document.querySelector('#root'));
root.render(<Counter initialValue={10} />);

We're passing along this <Counter /> description to React, so that React can make it real. React renders the Counter component, creating the instance in the process, and adds a <button> to the DOM.

In our day-to-day work with React, it's easy to forget that this is the root of all React applications. It's one of those “set it and forget it” things, it doesn't require any maintenance. But fundamentally, React elements don't do anything until we pass them to React to be rendered.


---

## State Management Tools

Source: /joy-of-react/02-state/10-global-state

State Management Tools
(Optional lesson)

So here's one of the most common React questions I've been asked:

Should we use something like Redux to manage global state for us? Or is React capable enough on its own?

Frustratingly, I don't have a simple yes/no answer to these questions. The unfortunate answer is it depends!

In this lesson, we're going to dig into these questions. We'll explore some of the history around what Redux is, why it's been useful, and how things stand today. I'll also share the formula I use when deciding how I want to manage state in my applications.

Some background info

In the early days of React, it was expected that React would only be one piece of your front-end stack. The best practice was to combine React with something like Flux, Redux, or MobX.

Specifically, the idea was to use React for local state, and a tool like Redux for global state.

"Local state" is state that is only needed in one particular part of the application. Most of the examples we've seen in this module have been local state. Things like how many times you've clicked the toonie, or what the current value is of a controlled text input.

"Global state", on the other hand, is for broader things. For example, data about the currently-logged-in user. Or maybe the currently-selected color theme (dark/light). A single piece of global state might be used in a dozen different corners of the application.

(The line between these two categories can be blurry; it's more of a spectrum than a binary choice.)

The thinking was that React state was well-suited for small, simple pieces of local state, but it wasn't powerful or flexible enough for global state. It was too difficult to move a state variable across the application, and it was hard to orchestrate complex state changes.

From ~2014-2016, a number of packages were competing to be the "global state" partner for React. In the end, the undisputed champion was Redux
.

Intro to Redux

It's difficult to describe Redux without going on a huge tangent, but I'll do my best to summarize it quickly.

In Redux, our global state is represented as a single object that floats outside our React application. This state can't be directly edited; instead, Redux listens for "actions", events that signify that something's happening in our application.

All of the actions are meticulously logged by Redux, and can almost be read like a story to understand what's going on in our application. For example, the log for an e-commerce app might look like this:

User logs in
User submits search form
Search results received from server
User clicks on "Page 2" of search results
Search results received from server
User adds "Hello Kitty Coffee Machine" item to cart

Each of these actions fires through Redux, and we can write some code that controls how these actions should affect the state. For example, here's how we might process that last "add item to cart" action:

// This isn't *exactly* how code looks in Redux,
// but the core idea is the same:
function addItemToCart(state, action) {
  const nextState = [
    // All of the current items in our cart...
    ...state,
    // ...and this one new item:
    {
      id: action.item.id,
      quantity: action.quantity,
    }
  ];

  return nextState;
}

Like in React, state updates in Redux are immutable. In fact, Redux state has a lot in common with React state! But Redux gives us additional super-powers.

The Redux devtools, for example, has a feature known as "time-travel debugging". We can step through Redux's meticulous log of actions and inspect the UI at each moment in time, rewinding and pausing. Redux is the ultimate detective tool when it comes to debugging.

And Redux is incredibly customizable. It offers a bunch of additional APIs, like middleware and store enhancers, to extend what Redux does out-of-the-box. As a result, there is a rich ecosystem of Redux add-ons, tools that make Redux even more powerful.

But all of this power and flexibility comes at a cost: there's a significant amount of friction when using Redux. Everything takes a bit longer and requires a bit more code, because you have to scaffold out a bunch of stuff. The #1 complaint about Redux is that there's "too much boilerplate".

It also has a pretty steep learning curve. Redux leans heavily on functional programming principles that take a while to wrap your mind around.

Relevance in modern React

So, it was considered a "best practice" a few years ago to use Redux to manage global state. But how do things stand today, in the era of modern hooks-based React? Is Redux still relevant?

This is a controversial question, and something that still gets debated a lot in the community. There isn't a widely-accepted answer.

Some say that Redux is as useful as ever; it provides a ton of sophisticated tooling and insights. They'll point to the NPM download numbers, which show that Redux is still growing in popularity:

On the other side, folks will point out that React has evolved quite a bit in the past few years. It's become much more capable on its own. It's even integrated some of Redux's features, like the useReducer hook! Modern React offers most of the benefits, and none of the drawbacks.

Interestingly, Redux was created by Dan Abramov and Andrew Clark. Both of them now work on the React core team, and have distanced themselves from Redux. Here's what Dan had to say about when he would choose to use Redux:

дэн
@dan_abramov
i struggle to think of a case where i’d want to use it myself

Sep 1, 2022

Here's what I think: Both groups make some good points, and I think they're both right in certain contexts. But it really depends on the type of application we're building.

My own biases

I'm going to elaborate on my viewpoint, but first I want to share a bit of my personal history with Redux.

I was an “early adopter” with Redux. I started using it in side projects when it was brand new, and I friggin’ loved it. Once I got the hang of it, it felt so elegant and delightful to me.

I worked with Redux at multiple jobs, including Breather, Unsplash, and Khan Academy. I've also built lots of side-projects using Redux.

For example: a few years ago, I created Beatmapper
, a 3D level editor for the VR rhythm game “Beat Saber”:

This project uses Redux extensively, and I believe it helped quite a bit in terms of keeping the application maintainable!

That said, I have lots of other projects that don't use Redux. This course platform, for example, doesn't use Redux at all! Neither does my blog, joshwcomeau.com
.

For me, whether or not to use Redux really depends on the type of application. A blog, a course platform, and a Beat Saber level editor are all very different types of projects, and different jobs require different tools.

Application types

Broadly speaking, I think all web applications can be grouped into 3 categories:

1. Not much state

This first category includes most things we'd call "websites". Static sites, news websites, and blogs all fit into this category.

To be clear, these applications might still have quite a bit of local state! My blog, for example, has some very dynamic widgets. But in terms of global state, things are fairly minimal.

2. Mostly client state

This category is mostly "things that used to be desktop applications". Photoshop, video editors, and word processors all fit into this category.

In this category, there's a lot of complex global state. We're doing a lot of state manipulation in the browser. We may still save the result "in the cloud" rather than on the user's device, but they're fundamentally client-heavy applications.

3. Mostly server state

In this final category, we have web applications that work primarily with server state.

I think the clearest example is an analytics dashboard:

We have a bunch of complex data in a database, and our app fetches that data and presents it to the user. These applications are essentially interfaces that let users read and manipulate data that lives in a database somewhere.

This is a broad category. Most CRUD? apps fit into it, including most SaaS applications, social networks, search engines, e-commerce sites, etc.

Alright, now that we've defined these categories, let's talk about why they matter.

The right tool for the job

So, the reason I think it's valuable to split apps into these categories is that the challenges are different.

For the mostly-static websites in Category 1, we don't really have to worry when it comes to global state. There isn't much of it, and it tends to be (relatively) straightforward. My blog fits into this category, and while there are plenty of challenges, global state isn't one of them. I use React exclusively for all state, and it works great.

For the client-heavy applications in Category 2, Redux is awesome. I wouldn't go as far as to say that it's necessary—React really has become much more capable in the past few years—but it's still a very helpful tool! Redux helps keep the code simple even as the features become more and more complex. And it has a lot of built-in performance optimizations.

Things get interesting when we talk about the server-heavy applications in Category 3.

The biggest state-related challenges in this category are all network-related:

Fetching the right data at the right time.
Making sure the data doesn't grow stale by revalidating it (fetching it again), and customizing the revalidation for the specific situation.
Caching the data so that multiple components don't repeat requests unnecessarily.
Optimistic UI updates, so that we "predict" how network requests will resolve.
Pagination, requesting small slices of the data and letting the user pull new data as-needed.

And here's the thing: Redux doesn't really address any of them! Redux is a state-management tool, it doesn't help with network stuff.

Over the past few years, several tools have popped up which are purpose-built to help us manage these sorts of network-related challenges. These tools include Apollo
, react-query
, and SWR
. We'll learn more about them in Module 3!

If you're building a video game, or an audio editor, Redux is great. But most of us aren't building those sorts of applications. I'd guess that 95% of React applications are either Category 1 or Category 3.

And so, this is the mental model I use when figuring out which tool to use:

If it's a static website, like my blog, I use React alone (with the help of context, discussed in Module 4).
If it's a client-heavy application like my Beat Saber level editor, I use Redux for global state.
If it's a server-heavy application like this course platform, I use React + something to help with the network stuff. I'm using Vercel's SWR
 on this course platform and I have no complaints.

This is the formula I've found works best, after years of experience and dozens of projects, but a lot of this really does come down to subjective preference.

But here's something I can say pretty objectively: React has evolved tremendously over the past few years, and has become way more capable. You can absolutely build large, sophisticated applications without any other state-management libraries. You don't need Redux, and you shouldn't feel pressured to learn it.

If you're new to React, here's what I suggest: spend a year or two getting comfortable building apps with React, using the tools covered in this course. You can always explore Redux in the future, and see if you find it helpful!

Honestly, there aren't very many "wrong" ways to build apps. We live in an era of abundance, and there are lots of amazing tools. The most important thing is not to become overwhelmed by trying to learn everything at once!

All of that said, there's one more wrinkle we should talk about: Redux Toolkit.

Redux Toolkit and RTK-Query

Over the past few years, the Redux team has been hard at work creating Redux Toolkit
, an opinionated toolset that aims to sand down some of the rough edges of working with Redux.

This toolkit includes a project, RTK Query
, a tool which is more-or-less a Redux-compatible version of react-query / SWR.

I would be pretty excited about this development… but unfortunately, I have a fundamental disagreement with the opinions that are baked into Redux Toolkit 😅. I'll share my quibbles below for anyone curious, but the takeaway is that I plan on continuing to use "Classic" Redux, without Redux Toolkit.

If you're already using Redux Toolkit, I think RTK Query is a slam dunk. It makes way more sense to use something tightly-integrated, rather than trying to get Redux and SWR to play nicely together.

Otherwise, it's hard for me to say whether you should use this combination over something else. It wouldn't be my first choice, but as I said above, there are lots of great options nowadays, and this one might work best for you, depending on the type of app you're building and your subjective preferences.

My quibbles with Redux Toolkit
(info)

So, as I mentioned above, Redux Toolkit is an opinionated set of tools, built on top of Redux, which enforces a number of conventions. Regrettably, these conventions are not well-aligned with how I personally prefer to use Redux.

I should say, before anything else, that I have a ton of respect for the work that the Redux team has done. You should take everything I'm about to say with several large grains of salt: I could very well be an outlier. By and large, the community seems happy with Redux Toolkit.

Alright, let me explain what my issue is.

 Show more

---

## Bonus: Input Cheatsheet

Source: /joy-of-react/02-state/11-bonus-cheatsheet

Bonus: Input Cheatsheet
(Optional lesson)

There are lots of different form controls on the web, and it can be hard to remember exactly which properties each one takes.

This lesson is an appendix that details how to use the most common form inputs.

I suggest bookmarking this lesson. Whenever you're building a form, I hope this lesson can jog your memory!

Text inputs

For controlled text inputs, we bind the React state to the value attribute. We can set the initial value for uncontrolled text inputs with defaultValue.

Here's how to use a controlled text input:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function App() {
  const [name, setName] = React.useState('');

  return (
    <>
      <form
        onSubmit={(event) => {
          event.preventDefault();

          // Do something with `name` here
        }}
      >
        <label htmlFor="name-field">
          Name:
        </label>
        <input
          id="name-field"
          value={name}
          onChange={event => {
            setName(event.target.value);
          }}
        />
      </form>

      <p>
        <strong>Current value:</strong>
        {name || '(empty)'}
      </p>
    </>
  );
}

export default App;
Result
Console
Refresh results pane
Gotchas

When working with controlled text inputs, be sure to use an empty string ('') as the initial state. Otherwise, you risk running into edge-cases caused by the flip from uncontrolled to controlled.

// 🚫 Incorrect:
const [email, setEmail] = React.useState();

// ✅ Correct:
const [email, setEmail] = React.useState('');

For more information about why this is necessary, check out the “Data Binding” lesson.

Text input variants

In addition to plain text inputs, we can pick from different “formatted” text inputs, for things like email addresses, phone numbers, and passwords.

Here's the good news: These variants all work the same way, as far as data binding is concerned.

For example, here's how we'd bind a password input:

const [secret, setSecret] = React.useState('');

<input
  type="password"
  value={secret}
  onChange={(event) => {
    setSecret(event.target.value);
  }}
/>

In addition to text input variants, the <input> tag can also shape-shift into entirely separate form controls. Later in this lesson, we'll talk about radio buttons, checkboxes, and specialty inputs like sliders and color pickers.

Textareas

In React, <textarea> elements work exactly like text inputs. We set value to bind it to React state, and defaultValue to set an initial value for uncontrolled components.

Here's how to use a controlled textarea:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane
Gotchas

As with text inputs, be sure to use an empty string ('') as the initial state. Otherwise, you risk running into edge-cases caused by the flip from uncontrolled to controlled.

// 🚫 Incorrect:
const [email, setEmail] = React.useState();

// ✅ Correct:
const [email, setEmail] = React.useState('');
Radio buttons

Things are a bit different when it comes to radio buttons. To wire up a radio button so that it's controlled by React, we need to set the checked property to a boolean value. It specifies whether the radio button is currently ticked or not.

The defaultChecked property can be used to set the initial value without making it a controlled input.

Minimal controlled example

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

When it comes to radio buttons, there are lots of attributes to keep in mind. Here's a table summarizing them:

Attribute	Type	Explanation
id	string	A globally-unique identifier for this radio button, used to improve accessibility and usability.
name	string	Groups a set of radio buttons together, so that only one can be selected at a time. Must be the same value for all radio buttons in the group.
value	string	Specifies the “thing” that this radio button represents. This is what will be captured/stored if this particular option is selected.
checked	boolean	Controls whether the radio button is checked or not. By passing a boolean value, React will make this a “controlled” input.
onChange	function	Like other form controls, this function will be invoked when the user changes the selected option. We use this function to update our state.
Iterative controlled example

Because radio buttons have so many dang attributes, it often helps to generate them iteratively; that way, we only have to write the JSX once!

This is also required when the options themselves are dynamic (eg. fetched from the server).

Here's an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane
Gotchas

When using iteration to dynamically create radio buttons, we need to be careful not to accidentally “re-use” a variable name used by our state variable.

Avoid doing this:

const [language, setLanguage] = React.useState();

return VALID_LANGUAGES.map((language) => (
  <input
    type="radio"
    name="current-language"
    id={language}
    value={language}
    checked={language === language}
    onChange={event => {
      setLanguage(event.target.value);
    }}
  />
));

In our .map() call, we're naming the map parameter language, but that name is already taken! Our state variable is also called language.

This is known as “shadowing”, and it essentially means that we've lost access to the outer language value. This is a problem, because we need it to accurately set the checked attribute!

For this reason, I like to use the generic option name when iterating over possible options:

VALID_LANGUAGES.map(option => {
  <input
    type="radio"
    name="current-language"
    id={option}
    value={option}
    checked={option === language}
    onChange={event => {
      setLanguage(event.target.value);
    }}
  />
})
Checkboxes

As with radio buttons, the checked property is used to create a controlled element. It should be a boolean value, specifying whether the checkbox is currently ticked or not.

The defaultChecked property can be used to set the initial value without making it a controlled input.

With checkboxes, the approach differs depending on whether we're working with a single checkbox or a group of checkboxes. Let's look at each in turn.

Single checkbox example

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

We store a boolean state variable, optIn, and set it as the checked value. When optIn is true, the checkbox is ticked. Otherwise, the checkbox is unticked.

Things get trickier when we need to drive multiple checkboxes.

Multiple checkbox example

There are several ways to do this, but my favourite is to use a map-like object. Here's an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

With radio buttons, we can fit everything we need to know into a single string: the value of the selected option. But when we have a group of checkboxes, we need to store more data, since the user can select multiple options.

Here is how I choose to represent this state:

const initialToppings = {
  anchovies: false,
  chicken: false,
  tomatoes: false,
}

In the JSX, we map over the keys from this object, and render a checkbox for each one. In the iteration, we look up whether this particular option is selected, and use it to control the checkbox with the checked attribute.

We also pass a function to onChange that will flip the value of the checkbox in question. Because React state needs to be immutable, we solve this by creating a near-identical new object, with the option in question flipped between true/false. I'm doing this with the help of the “spread” syntax 👀.

Here's a table showing each attribute's purpose:

Attribute	Type	Explanation
id	string	A globally-unique identifier for this checkbox, used to improve accessibility and usability.
value	string	Specifies the “thing” that we're ticking off and on with this checkbox.
checked	boolean	Controls whether the checkbox is checked or not.
onChange	function	Like other form controls, this function will be invoked when the user ticks or unticks the checkbox. We use this function to update our state.

(We can also specify a name, as with radio buttons, though this isn't strictly necessary when working with controlled inputs.)

It may help to revisit the lessons on complex state.

Select

To create a controlled select tag, we use the value attribute. We update the value with an onChange handler. In effect, it works exactly like a text input!

For uncontrolled select tags, the initial value can be set with defaultValue.

Here's how to use a controlled select:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Perhaps more than any other tag, <select> has been modified for React. In a vanilla HTML/JS context, you'd need to reach down and toggle the selected attribute on the appropriate <option> child. Fortunately, this is not required when working with controlled select tags in React.

Gotchas

As with text inputs, we need to initialize the state to a valid value. This means that our state variable's initial value must match one of the options:

// This initial value:
const [age, setAge] = React.useState("0-18");

// Must match one of the options:
<select>
  <option
    value="0-18"
  >
    18 and under
  </option>
</select>

This is a smelly fish. One small typo, and we risk running into some very confusing bugs.

To avoid this potential footgun, I prefer to generate the <option> tags dynamically, using a single source of truth:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane
Specialty inputs

As we've seen, the <input> HTML tag can take many different forms. Depending on the type attribute, it can be a text input, a password input, a checkbox, a radio button…

In fact, MDN lists 22 different valid values
 for the type attribute. Some of these are “special”, and have a unique appearance:

Sliders (with type="range")
Date pickers (with type="date")
Color pickers (with type="color")

Fortunately, they all follow the same pattern as text inputs. We use value to lock the input to the state's value, and onChange to update that value when the input is edited.

Here's an example using <input type="range">:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Gotcha: range inputs and strings
(info)

One common gotcha with <input type="range"> is that the values are always strings. In the playground above, event.target.value would be a string like "50" rather than the number 50.

I like to solve for this by converting it to a number right before setting it into state:

<input
  type="range"
  value={volume}
  onChange={event => {
    setVolume(
      Number(event.target.value)
    );
  }}
/>

To be clear, this isn’t some React quirk; you’ll run into the same surprising behaviour even when working with vanilla JS. All inputs in the DOM have string values (even <input type="number">!).

And we don’t have to worry about turning volume back into a string when passing it to value. That type coersion happens automatically.

Here's another example, with <input type="color">:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane
Gotchas

As with text inputs, we don't want to flip from uncontrolled to controlled. We need to initialize our state variable to a valid value.

For example, for color inputs, this would be a hex code:

// 🚫 Incorrect:
const [color, setColor] = React.useState();

// ✅ Correct:
const [color, setColor] = React.useState('#FF0000');

