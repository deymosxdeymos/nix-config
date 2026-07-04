# Joy of React - Module 3 React Hooks

---

## Another Tool in the Toolbox • Josh W Comeau's Course Platform

Source: /joy-of-react/03-hooks/00-introduction

React Hooks

Video Summary

Correction: The final snippet from this video mistakenly used this within a function component. Sorry for any confusion! The code should have been:

function Button({ children }) {
  const [hi, setHi] = React.useState(5);

  function handleClick(event) {
    console.log('Clicked!');
    setHi(hi + 1);
  }

  return (
    <button onClick={handleClick}>
      {children}
    </button>
  );
}

---

## The useId Hook

Source: /joy-of-react/03-hooks/01-use-id

The useId Hook

Video Summary

Here's the playground from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
LoginForm.js
import React from 'react';

function LoginForm() {
  const [username, setUsername] = React.useState('');
  const [password, setPassword] = React.useState('');

  // Pluck this instance's unique ID from React
  const id = React.useId();

  // Create element IDs using this unique ID
  const usernameId = `${id}-username`;
  const passwordId = `${id}-password`;

  return (
    <form className="login-form">
      <div>
        {/* Apply these IDs to the label and input */}
        <label htmlFor={usernameId}>
          Username:
        </label>
        <input
          type="text"
          id={usernameId}
          value={username}
          onChange={event => {
            setUsername(event.target.value);
          }}
        />
      </div>
      <div>
        <label htmlFor={passwordId}>
          Password:
        </label>
        <input
          type="password"
          id={passwordId}
Result
Console
Refresh results pane

Another benefit
(success)

The useId hook is special in one more way: It produces the same value across server and client renders. This is a very special property, and something that would be very difficult to reproduce without a special React-provided solution.

Later in this course, we'll learn more about server-side rendering, and the complexities it introduces.

Practice — Toggle component

In this sandbox, you'll find a Toggle component that has been almost fully implemented.

Finish it up by adding a unique ID to the button, and connecting it to the label. You should be able to trigger the toggle by clicking the "Dark Mode" text.

Code Playground

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

Solution code
(success)

 Show more

---

## Rules of Hooks

Source: /joy-of-react/03-hooks/02-rules-of-hooks

Rules of Hooks

So, we've talked about how hooks are special functions that allow us to “hook” into React internals. useState allows us to hook into a component instance's state, for example, while useId allows us to create and store a unique identifier on the component instance.

What happens if we try to call these functions outside of a React context?

Well, let's try it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

try {
  React.useId();
} catch (err) {
  // Swallowing an error that occurs because
  // of the warning shown in the console.
}
Console
Clear Console
Refresh results pane
Dismiss lint warning

Lint Warning

React Hook "React.useId" cannot be called at the top level. React Hooks must be called in a React function component or a custom React Hook function.

Rule: react-hooks/rules-of-hooks

Location: Line 4, Column 3

In addition to the lint error, we're given a console message that looks like this:

Warning: Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:

You might have mismatching versions of React and the renderer (such as React DOM)
You might be breaking the Rules of Hooks
You might have more than one copy of React in the same app

It shows that something's gone horribly wrong, and provides 3 possibilities. Errors 1 and 3 refer to rare edge-case concerns, but that second bullet point is interesting. What are the “Rules of Hooks”?

First, let's understand that hooks are plain old JavaScript functions. They aren't quite as magical as they might seem.

But, when we call these functions, they "hook into" React internals. And we can catch React off-guard. It expects these hook functions to be used in very specific ways, and if we violate those expectations, bad things happen.

There are two “Rules of Hooks” that we should learn, in order to make sure we're always using hooks as React expects.

Hooks have to be called within the scope of a React application. We can't call them outside of our React components.
*
We have to call our hooks at the top level of the component.

That second rule is the one that trips most people up. Let's talk about it.

Video Summary

Here's the sandbox from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
TextInput.js
Result
Console
Refresh results pane

Something's missing
(info)

In this example, our TextInput component is missing some pretty important props: value and onChange. Without these props, it's impossible to drive this component with React state.

I didn't include them because they weren't relevant to this lesson, but they're pretty important if you want to use controlled inputs in your app!

Here's a more complete implementation:

function TextInput({ id, label, type, value, onChange }) {
  let generatedId = React.useId();
  let appliedId = id || generatedId;

  return (
    <div className="text-input">
      <label htmlFor={appliedId}>
        {label}
      </label>
      <input
        id={appliedId}
        type={type}
        value={value}
        onChange={onChange}
      />
    </div>
  );
}

Later in this course, we'll learn how to automatically delegate props in situations like this.

---

## Exercises

Source: /joy-of-react/03-hooks/02.01-rule-exercises

Exercises
Fix the violation

Below, we have a "Search" UI with a conditionally-rendered text input. Clicking the “” icon slides a text input into place:

The code below is violating the Rules of Hooks! Your mission is to update the code to comply with the rules.

Acceptance Criteria:

No lint warnings should be shown.
Clicking the search button should reveal a search input.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';
import { X, Search } from 'react-feather';

import VisuallyHidden from './VisuallyHidden';

function App() {
  const [
    showSearchField,
    setShowSearchField,
  ] = React.useState(false);

  let searchId;
  if (showSearchField) {
    searchId = React.useId();
  }

  function handleToggleSearch(event) {
    event.preventDefault();
    setShowSearchField(!showSearchField);
  }

  return (
    <>
      <form>
        {showSearchField && (
          <div className="search-field-wrapper">
            <label
              htmlFor={searchId}
            >
              <VisuallyHidden>
                Search
              </VisuallyHidden>
            </label>
            <input
              id={searchId}
              className="search-field"
Result
Console
Refresh results pane
Dismiss lint warning

Lint Warning

React Hook "React.useId" is called conditionally. React Hooks must be called in the exact same order in every component render.

Rule: react-hooks/rules-of-hooks

Location: Line 14, Column 16

Solution:

Solution code
(success)

 Show more
Fix another violation

Let's do it one more time, with a different scenario!

In this exercise, our LoginForm component can either render:

A form including email/password fields, if the user isn't logged in
A paragraph, if the user is logged in

You can toggle between these states by submitting the form.

Unfortunately, we're getting a lint warning! Your mission is to figure out what's causing it, and to fix it.

Acceptance Criteria:

Update the code below so that it doesn't violate the Rules of Hooks

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
LoginForm.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

---

## Immutability Revisited

Source: /joy-of-react/03-hooks/03-immutability

Immutability Revisited

Video Summary

Here's the visualization from the video. You can reset the visualization to its initial state with the “” icon.

Set user state
Set items state
Toggle fullscreen

Computer Memory

STATE
user: {
  name: "Ivy"
}
items: [
  1
]
Snapshot #1

And here's the sandbox from the video, showing how this works in code:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane
What are these snapshots exactly?

In the demo above, I show “snapshots” which appear as cards containing pieces of state.

In this course, I use the term “snapshot” to mean the result of performing a render. It's a combination of two things:

The specific values of any props/state at the time that the render occurred
The React element(s) returned from the component, describing the UI calculated in the render.

My demonstration above doesn't show the elements, since we're focusing on state.

It might be worth reviewing the “Core React Loop” lesson from Module 2. We dig deeper into this idea!

You might also be wondering: What's the difference between snapshots and instances?

As we learned in the “Component Instances” lesson, a component instance is a JavaScript object that is the “source of truth” for everything related to a particular instance of a component. It's created when the component is mounted, and it persists until the component is unmounted.

A snapshot, by contrast, is not a specific JavaScript object. It's a more abstract/metaphorical concept. It refers to the data available at a moment in time.

So, we might say that an instance holds the true value of a piece of state, but every time that state changes, we create a snapshot that captures the current value of that state variable.

I realize that I've thrown a lot of terminology at you in this course: components, elements, instances, and snapshots. It's OK if these concepts aren't fully settled in your mind! Our goal is to slowly build confidence in our understanding, as we learn more and more about React.

The React docs can also help solidify things. Check out “State as a Snapshot”


---

## Refs

Source: /joy-of-react/03-hooks/04-refs

Refs

So, typically as web developers, we build user interfaces out of a standard set of DOM primitives: divs, buttons, forms, etc.

But the web also comes with a totally different way to draw UI: HTML Canvas.

If you're not familiar, HTML Canvas offers a “Microsoft Paint” style ability to create graphics by drawing shapes. I use it on my blog to create this fun little "magnetic shavings" effect:

In order to work with HTML Canvas, we start by rendering a <canvas> tag, and then running a bunch of commands on it using JavaScript. It might look like this:

const canvas = document.querySelector('canvas');
const ctx = canvas.getContext('2d');

// Draw a 200 × 100 pink rectangle:
ctx.fillRect(0, 0, 200, 100);

ctx is the drawing surface. We can choose to draw either in 2D or 3D (via webgl).

Here's the question: How might we work with this element in React?

Let's discuss:

Video Summary

Here's the final sandbox from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Not just for DOM nodes!
(info)

The ref object created by the useRef hook should be thought of as a box. We can store whatever we want in this box: DOM nodes, numbers, arrays, objects, functions, etc.

That said, the primary use case for refs is to store DOM nodes. It's pretty rare for me to need to store anything else in a ref.

---

## Exercises

Source: /joy-of-react/03-hooks/04.01-ref-exercises

Exercises
Video playback speed

In the sandbox below, we have a <VideoPlayer> component that includes a playback speed control. Unfortunately, it doesn't work!

For context, here's how we can affect the playback speed of a <video> element in vanilla JavaScript:

const videoElement = document.querySelector('#some-video');
videoElement.playbackRate = 2; // Play at 2x speed

Acceptance Criteria:

When the user changes the "Playback speed" control and then plays the corresponding video, that video should play at the selected speed.
You should use the useRef hook to capture a ref to the <video> element.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
VideoPlayer.js
import React from 'react';

function VideoPlayer({ src, caption }) {
  const playbackRateSelectId = React.useId();

  return (
    <div className="video-player">
      <figure>
        <video
          controls
          src={src}
        />
        <figcaption>
          {caption}
        </figcaption>
      </figure>

      <div className="actions">
        <label htmlFor={playbackRateSelectId}>
          Select playback speed:
        </label>
        <select
          id={playbackRateSelectId}
          defaultValue="1"
        >
          <option value="0.5">0.5</option>
          <option value="1">1</option>
          <option value="1.25">1.25</option>
          <option value="1.5">1.5</option>
          <option value="2">2</option>
          <option value="3">3</option>
        </select>
      </div>
    </div>
  );
}
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Controlled vs. uncontrolled selects
(info)

In my solution, I'm leaving the <select> tag “uncontrolled”, meaning that it isn't being driven by React state.

I chose not to control it with React state because it isn't necessary in this case. I'm not using the playbackRate value anywhere in the UI, aside from the <select> itself.

That said, there's certainly no harm in making it controlled! Here’s what that would look like:

 Show more
Media Player

Let's build a media player!

The UI is ready, and we've loaded an audio file using an <audio> tag. Our job now is to capture a reference to that element, and to trigger it when the user clicks the play/pause button.

For context, here's how we'd solve this problem in vanilla JS:

const audioElement = document.querySelector('#some-audio-elem');

// Start playing the song:
audioElement.play();

// Stop playing it:
audioElement.pause();

Acceptance Criteria:

Clicking the “Play” button should start playing the song.
Clicking the button again should pause the song.
By default, we should render a <Play> icon inside the button, but it should flip to a <Pause> icon while the song is playing.
Hint

To keep track of whether the song is currently playing or not, you should use a React state variable.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
MediaPlayer.js
VisuallyHidden.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

A more complete solution
(info)

Discord user otoropova spotted a small issue with our implementation: the icon doesn't flip back to the initial state when the song ends!

We can fix this by attaching an event handler:

<audio
  ref={audioRef}
  src={src}
  onEnded={() => {
    setIsPlaying(false);
  }}
/>

onEnded is a special handler on <audio> DOM nodes. It fires this callback when the audio finishes playing.


---

## Side Effects

Source: /joy-of-react/03-hooks/05-effects

Side Effects

As we build applications, we often need to synchronize with external systems. This can include things like:

Making network requests
Managing timeouts / intervals
Reading/writing from localStorage
Listening for global events

React calls all of these things “side effects”. In the lessons that follow, we'll learn how to use side effects effectively within our React applications.

About “Best Practices”

So, here's the thing: Effects are hard. They're one of the hardest things in modern React. And it can often feel like we're doing things wrong, that we're not following the best practices.

I have some thoughts about this.

Video Summary

Frozen code editors
(warning)

On this course platform, the changes you make to code editors are automatically saved. This is generally a good thing, but it can be problematic in some circumstances!

In the lessons ahead, you'll be asked to solve a number of problems that involve intervals or loops. If you accidentally write an infinite loop, it can crash the page. Refreshing the page reloads the problematic code, and the lesson is effectively bricked!

If this happens to you, you can delete the code for any individual sandbox
.

Sorry in advance for any issues!


---

## The useEffect hook

Source: /joy-of-react/03-hooks/05.01-use-effect-hook

The useEffect hook

Video Summary

A clarification around speed/performance
(warning)

In the video above, I mention that updating the title isn't quite in real-time. I realized that you might think that this delay is caused by useEffect, since useEffect fires after the render.

In truth, useEffect fires near-instantaneously. The delay is negligible, typically less than a millisecond.

Why is there a delay, then? When we update document.title, the browser doesn't immediately propagate that change to the tab's title. I'm not sure why, but there's always a bit of a delay whenever we change the document's title.

Playing with this example

The tricky thing about this example, and the reason I did it in my local code editor, is that the document's title isn't visible when using the interactive sandboxes in this course playground. 😅

I've included the sandbox below anyway, and added a console.log to show the new value. You're also welcome to run the code locally on your machine
, if you really want to dig into this example.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Counter.js
Preview
Refresh results pane
Console
Clear Console
Strict mode gotcha

Before we get too deep into useEffect, I want to mention a really common stumbling block.

As you use React outside this course platform, you might notice something a bit curious: effects seem to run twice right when the component first mounts.

This is due to a setting known as Strict Mode. In Strict Mode, React will automatically re-run certain chunks of code, while we're working on our applications. This is done to highlight potential issues.

For now, Strict Mode is disabled on this course platform. In a few lessons, we'll learn all about Strict Mode, and from that moment onwards, it'll be enabled in all sandboxes in this course.


---

## Exercises

Source: /joy-of-react/03-hooks/05.02-initial-effect-exercises

Exercises

Alright, let's get some hands-on practice with useEffect!

Logging a particular value

Below, we have a signup form with several React state variables.

Our goal is to add a console.log that fires only when the value of “email” changes. We should see the user's email logged in the console whenever they edit that field.

Acceptance Criteria:

Whenever the user changes the value of the “email” state variable, the new value should be logged to the console.
Nothing should be logged when the user changes another field (for example, their city or postal code).
The logging should be done inside an effect, not within the onChange event handler.

Stretch Goal:

Update the code so that name is also logged whenever it changes.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function SignupForm() {
  const [name, setName] = React.useState('');
  const [email, setEmail] = React.useState('');
  const [city, setCity] = React.useState('');
  const [postalCode, setPostalCode] = React.useState(
    ''
  );

  return (
    <form>
      <Field
        id="name"
        label="Preferred Name"
        value={name}
        onChange={(event) => {
          setName(event.target.value);
        }}
      />
      <Field
        id="email"
        type="email"
        label="Email Address"
        value={email}
        onChange={(event) => {
          setEmail(event.target.value);
        }}
      />
      <div className="row">
        <Field
          id="city"
          label="City"
          grow={2}
          value={city}
          onChange={(event) => {
Preview
Refresh results pane
Console
Clear Console

Solution:

Solution code
(success)

 Show more

What's the best practice here?
(info)

A few students have asked if we should really be using useEffect here. Wouldn't it be better to add the log to the event handler instead?

<Field
  id="name"
  label="Preferred Name"
  value={name}
  onChange={(event) => {
    setName(event.target.value);

    console.log(event.target.value);
  }}
/>

There's a subtle semantic difference here. It depends on whether we care specifically about the user editing text in this input, or if we want to track the state variable more broadly.

 Show more
Locally-persisted state

Let's suppose we're building an application with a “Dark Mode” toggle.

It would be really annoying if users had to keep toggling their preferred mode every time they load our application!

Let's update the code below so that the user's preference is saved in localStorage, and restored when the page loads.

In other words, the current value of isDarkMode should be "remembered", and used when the page is refreshed:

We can do this in plain JS with the following code:

// Save the value:
window.localStorage.setItem('is-dark-mode', true);

// Retrieve the value:
window.localStorage.getItem('is-dark-mode');

Acceptance Criteria:

The value of isDarkMode should be saved in localStorage whenever it changes, using the useEffect hook.
The initial value of the isDarkMode state variable should be retrieved from localStorage (or set to false if no value has been saved).
You can use the string "is-dark-mode" for the key.
Note: Items saved to localStorage are always saved as a string. You'll need to convert the stored value back to boolean. You can do this with JSON.parse().

Local Storage gotchas
(warning)

This exercise uses the Local Storage API, which can lead to some frustrating issues. If you’re getting funky errors even after refreshing the playground or copy/pasting the solution code, you’ll want to clear your browser’s Local Storage.

I've created a Local Storage Troubleshooting Guide
 which shows you how to solve the most common issues with Local Storage. If you're having any issues, please check this guide out.

Code Playground

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

Solution:

In this video, we use a function to initialize our state variable. This pattern is discussed in the “useState Hook” lesson.

One more thing: the solution shared here won't work if using a server-side rendering framework like Next.js, Astro, or Remix. We'll learn more about this scenario and how to work around it in Module 6, when we talk about Server Side Rendering Gotchas.

Solution code
(success)

 Show more

Alternative solution?
(info)

Instead of using useEffect to track the changes in isDarkMode, we could also create a new setter function that tackles the local-storage write:

const [isDarkMode, setIsDarkModeRaw] = React.useState(() => {
  // ✂️ Unchanged code omitted
});

// Wrap around the raw setter, bundling it together
// with the localStorage operation:
function setIsDarkMode(newValue) {
  setIsDarkModeRaw(newValue);
  window.localStorage.setItem('is-dark-mode', newValue);
}

return (
  <div
      className="wrapper"
      style={{
        // ✂️ Unchanged code omitted
      }}
  >
    <Toggle
      label="Dark Mode"
      checked={isDarkMode}
      handleToggle={setIsDarkMode}
    />
  </div>
);

Our new function, setIsDarkMode, “wraps around” the state-setter function we get from React. Whenever we call this function, we'll update the state and persist the result to localStorage.

Like I mentioned in the sidenote above, the React team generally encourages us to put stuff like this inside event handlers rather than using effects, but I disagree with this recommendation 😅. That said, I also don’t think it makes a huge difference; ultimately, both approaches will work just fine.


---

## Effect Lint Rules

Source: /joy-of-react/03-hooks/05.03-effect-lint-rules

Effect Lint Rules

Video Summary

Here's the sandbox + memory visualization from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function App() {
  const [count, setCount] = React.useState(0);

  React.useEffect(() => {
    console.log(count);
  }, []);

  return (
    <>
      <p>The count is: {count}</p>
      <button onClick={() => setCount(count + 1)}>
        Increment
      </button>
    </>
  );
}

export default App;
Result
Console
Refresh results pane
Dismiss lint warning

Lint Warning

React Hook React.useEffect has a missing dependency: 'count'. Either include it or remove the dependency array.

Rule: react-hooks/exhaustive-deps

Location: Line 8, Column 6

Set count state
Toggle fullscreen

Computer Memory

STATE
count: 0
Snapshot #1

Workarounds?
(info)

In rare cases, we need to access the freshest “version” of a state variable inside an effect, but we don't want the effect to re-run whenever that variable changes.

We'll see how to tackle this situation later in this module, when we talk more about stale values.


---

## Running on Mount

Source: /joy-of-react/03-hooks/05.04-running-on-mount

Running on Mount

Video Summary

Here's the sandbox from the video. Uncomment the line in the effect to pull your focus:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function App() {
  const [
    searchTerm,
    setSearchTerm,
  ] = React.useState('');

  const inputRef = React.useRef();

  React.useEffect(() => {
    // Uncomment me!
    // inputRef.current.focus();
  }, []);

  return (
    <>
      <header>
        <img
          className="logo"
          alt="Foobar"
          src="https://sandpack-bundler.vercel.app/img/foogle.svg"
        />
      </header>
      <main>
        <form>
          <input
            ref={inputRef}
            value={searchTerm}
            onChange={(event) => {
              setSearchTerm(event.target.value);
            }}
          />
          <button>Search</button>
        </form>
      </main>
Result
Console
Refresh results pane

The “autofocus” attribute
(warning)

HTML form inputs have an autofocus property that can be used to automatically focus the element on page load:

<input autofocus type="text" />

Given that there's a built-in way to auto-focus an input, why are we going through all the trouble with useRef and useEffect??

Unfortunately, it isn't safe to use the autofocus attribute in React.

The autofocus attribute only works reliably if the element is present when the page first loads. It won't work if the element is dynamically injected into the page afterwards.

And in React, pretty much every element is dynamically injected! The only exception is if you use server-side rendering, and even then, only for the very first page the user visits on your site.

And so, the solution shown above, capturing an input with a ref and triggering .focus() in an effect, is the best way to solve this problem in React.

Subscriptions

Let's suppose we want to track the user's cursor position. Whenever they move their mouse, we'll update some state.

We can add onMouseMove event handlers to specific DOM nodes, like this:

<div
  onMouseMove={event => {
    setMousePosition({
      x: event.clientX,
      y: event.clientY,
    });
  }}
>

This will only work while the user is hovering over this particular <div>, though… What if we want to track their cursor position no matter where the mouse is within the viewport?

Spend a few moments tinkering, if you'd like, to see if you can come up with a solution. A sandbox has been provided:

Hint

In order to listen for global events, you can use window.addEventListener. For more information, check out the “Global Events” Lesson 👀 from the JavaScript Primer.

Specifically, you'll want to listen for mousemove events. You can get the cursor position using event.clientX and event.clientY.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Hot reload disabled for this playground
(warning)

The playground component I use on this course platform features a hot reloader. When you make changes to the code, those changes are instantly applied without the “Result” pane doing a full refresh.

This works great most of the time, but in certain cases, re-running the JavaScript without doing a full refresh causes problems, since the hot reloader isn’t smart enough to clean up or cancel things like global event listeners.

To prevent any potential confusion, I’ve disabled the hot reloader for this playground. As a result, the “Result” pane will completely reload on every code change.

There are a few other playgrounds in this course that also have the hot reloader disabled. This is indicated with a little icon in the playground’s toolbar,
Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
.

Let's talk through it:

Video Summary

Here are the diagrams from the video:

With an empty dependency array:

With no dependency array:

And here's the final solution from the video:

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Missing cleanup!
(warning)

In my solution above, I'm adding an event listener, but I never remove the event listener. This is a problem — it can introduce memory leaks and other problems.

Soon, we'll see how to clean up our subscriptions. Please don't start applying any of these patterns in your real-world projects until you've completed that lesson!


---

## Exercises

Source: /joy-of-react/03-hooks/05.05-on-mount-exercises

Exercises
Window dimensions

Let's use an effect hook to track the window's dimensions over time!

Acceptance Criteria:

As the window is resized, the numbers shown in the “Result” tab should update, accurately showing the width and height of the iframe.
Only a single event listener should be registered.

Note: You can test this by dragging the division between the two tabs. If you're not using a pointer device, you can focus the divider and use the left/right arrow keys:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function WindowSize() {
  const [
    windowDimensions,
    setWindowDimensions,
  ] = React.useState({
    width: window.innerWidth,
    height: window.innerHeight,
  });

  return (
    <div className="wrapper">
      <p>
        {windowDimensions.width} / {windowDimensions.height}
      </p>
    </div>
  );
}

export default WindowSize;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
Toasty!

In the old Mortal Kombat games, a little fella would occasionally pop out the side of the screen and yell Toasty!
, for unclear reasons.

A few years back, I took inspiration from this quirky effect, and used it to slide my 3D mascot out on my blog:

In this exercise, we'll create our own Toasty effect!

It will be tied to scroll position. When the user scrolls to a specific point in the page, a character will slide out from the edge of the screen. We'll use the spiffy IntersectionObserver API
 to help us out.

There's a lot of stuff in this exercise, and it can seem pretty intimidating. To help you make sense of what's going on, I've prepared a two-minute intro video, to provide some context around how this exercise is meant to work:

Acceptance Criteria:

As the user scrolls near the bottom of the page, a ghost character should slide in.
This can be accomplished by observing the styles.wrapper element, and setting the isShown state variable to true/false based on whether it's within the viewport or not.
You shouldn't use document.querySelector! You can capture a reference to the wrapper element with the React.useRef hook.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

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

Solution code
(success)

 Show more

Bonus: How the CSS works
(info)

In the solution video above, we look at how to use JS and React to create the “Toasty!” effect, but there's another aspect to this effect that we haven't talked about: the CSS!

If you're curious, I'll quickly share how the CSS is structured in this video:

---

## Cleanup

Source: /joy-of-react/03-hooks/05.06-cleanup

Cleanup

Video Summary

In the last module, we talked about component instances, and how conditionally rendering components will create and destroy these instances. If you're still feeling fuzzy on this concept, you can review the “Component Instances” lesson from Module 2.

Here's the sandbox from the video, with the cleanup function added:

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
MouseTracker.js
import React from 'react';

function MouseTracker() {
  const [mousePosition, setMousePosition] = React.useState({
    x: 0,
    y: 0,
  });

  React.useEffect(() => {
    // Effect logic:
    function handleMouseMove(event) {
      console.log('move');
      setMousePosition({
        x: event.clientX,
        y: event.clientY,
      });
    }

    window.addEventListener('mousemove', handleMouseMove);

    // Cleanup function:
    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
    };
  }, []);

  return (
    <p>
      {mousePosition.x} / {mousePosition.y}
    </p>
  );
}

export default MouseTracker;
Preview
Refresh results pane
Console
Clear Console

Functions that return functions 😬
(info)

One of the most confusing things to me, earlier in my career, was when functions would return functions. Stuff like this would make my head spin:

function doSomething() {
  const hi = 5;

  return function() {
    return hi * 2;
  };
}

Something similar is happening here with the useEffect cleanup API. Our main effect function is returning a function:

React.useEffect(() => {
  // Effect logic here

  // Cleanup function:
  return () => {
    // Cleanup logic here
  }
});

Here's the good news: This is really more of an implementation detail. We don't need to get too tripped up on this curious bit of syntax.

The most important thing is that you understand the fundamental idea: We give React two functions, an effect function and a cleanup function, and React calls these functions for us at the appropriate time.

That said, there is a good reason for it to be set up this way. If you're curious, you can expand this sidenote for a deep dive:

 Show more
Cleanup with dependencies

Video Summary

Here are the diagrams from the video:

The order of operations:

A view of snapshots and cleanup:

Cleanup functions aren't always provided:

Finally, here's the sandbox from the video. I tweaked the button's text to make it a bit clearer:

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
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

Refs and cleanup functions in React 19
(info)

Starting in React 19, the ref attribute we saw earlier can also be given a cleanup function:

<input
  ref={(element) => {
    // This callback will be called on every render

    return () => {
      // This cleanup function will be called right before
      // every re-render, and when the element is destroyed.
    }
  }}
/>

Personally, I haven’t really found a use for this yet. Unlike useEffect, ref callbacks can’t be given a dependency array, which means the ref callback + cleanup fires every single time.

That said, this is a very new change, and maybe I just haven’t found the right use case yet. Feel free to experiment with this!

You can learn a bit more in the React 19 patch notes
.


---

## Cleanup Exercises

Source: /joy-of-react/03-hooks/05.07-cleanup-exercises

Cleanup Exercises
Fixing previous exercises

Now that we know how to manage cleanup, let's improve our solutions from previous exercises!

Window dimensions

Update our solution to the “Window dimensions” exercise so that the event listener is cleaned up.

Acceptance Criteria:

The "resize" event listener should be removed inside a cleanup function.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
WindowSize.js
import React from 'react';

function WindowSize() {
  const [
    windowDimensions,
    setWindowDimensions,
  ] = React.useState({
    width: window.innerWidth,
    height: window.innerHeight,
  });

  React.useEffect(() => {
    function handleResize() {
      console.log('resize');

      setWindowDimensions({
        width: window.innerWidth,
        height: window.innerHeight,
      });
    }

    window.addEventListener('resize', handleResize);
  }, []);

  return (
    <div className="wrapper">
      <p>
        {windowDimensions.width} / {windowDimensions.height}
      </p>
    </div>
  );
}

export default WindowSize;
Preview
Refresh results pane
Console
Clear Console

Solution:

Solution code
(success)

 Show more
Toasty!

In the “Toasty!” exercise, we implemented an animation using IntersectionObserver, but we never cancel this process!

Here's the code required to stop an IntersectionObserver:

observer.disconnect()

Acceptance Criteria:

The IntersectionObserver should be disconnected within the effect's cleanup function.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

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

Solution code
(success)

 Show more
Digital clock

Let's build a digital clock with React!

Below, you'll find a clock that initializes at the correct value, but it doesn't update. Your mission is to update the code so that the clock shows the correct time:

09:01:51 PM

Acceptance Criteria:

The clock should update once per second, to show the current time.
There should be no memory leaks, no ongoing processes that outlive the Clock instance.
Hint

You might wish to brush up on intervals in the “Intervals and Timeouts” lesson 👀.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Clock.js
Preview
Refresh results pane
Console
Clear Console

Stuck in a loop
(warning)

While working on this exercise, you may experience an issue where the browser tab crashes. This can happen if your code contains an infinite loop.

To solve this problem, you can delete the troublesome snippet, resetting this exercise to its initial state. You can also get to the “Delete Saved Snippets” page through the Account page.

Solution:

Solution code
(success)

 Show more
Useless machine

Have you ever heard of “useless machines”? These small boxes are built by hobbyists, and have a single switch on them. When you flip the switch, the box flips it back:

It's a completely useless machine! But it's fun and whimsical.

Let's build something similar. We'll create a checkbox that automatically ticks itself, whenever it's unticked:

Acceptance Criteria:

When the user unticks the checkbox, it should become re-ticked automatically after half a second. This can be done with a setTimeout.
If the user toggles it off and on really quickly, the timeout should be canceled, since the machine has been left in an "on" state.
If the user clicks it a bunch of times in rapid succession, the machine should wait a full 500ms from the final click before ticking itself back on.

(Your checkbox might look a little bit different, depending on browser/OS.)

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
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

Solution code
(success)

 Show more

Early returns
(info)

In my solution, I use an early return to bail out of the effect early.

Alternatively, I could have moved the entire effect logic into an if condition:

React.useEffect(() => {
  if (!isOn) {
    const timeoutId = window.setTimeout(() => {
      setIsOn(true);
    }, 500);

    return () => {
      window.clearTimeout(timeoutId);
    };
  }
}, [isOn]);

Both of these approaches are equally valid, but personally, I much prefer using an early return.

A well-written effect should have a single primary purpose. In this case, the primary purpose is to flip the machine back on when the user switches it off, after a 500ms timeout. That's why this effect exists. And this is what I want us to focus on.

Early returns allow us to emphasize an effect's primary purpose. We can clear away the conditions, so that they don't obfuscate the primary purpose.

This pattern is useful for all functions, not just React effects! And when we use it consistently, it makes it much easier for us to quickly understand what a function is doing. It's especially beneficial for more-complex functions with multiple conditions.

As another example: which of these two functions is easier for you to understand?

// Option 1
async function logInUser(email, password) {
  const user = await findUser(email);

  if (user) {
    const isValidPassword = await validatePassword(user, password);

    if (isValidPassword) {
      await startSession(user);
      return { user };
    } else {
      return { error: 'invalid password' };
    }
  } else {
    return { error: 'user not found' }
  }
}
// Option 2
async function logInUser(email, password) {
  const user = await findUser(email);

  if (!user) {
    return { error: 'user not found' }
  }

  const isValidPassword = await validatePassword(user, password);
  if (!isValidPassword) {
    return { error: 'invalid password' };
  }

  await startSession(user);
  return { user };
}

The primary purpose of this function is to log the user in. In Option 1, that primary purpose is buried in the middle of the function, nested within two if/else blocks.

In Option 2, we've flattened the structure, bailing out as soon as it's clear that a particular invocation is not fulfilling the function's primary purpose. As a result, we can skip to the bottom to see what the function's primary purpose is.

As I said, this is a subjective preference, but this is one of my favourite patterns. When followed consistently, early returns make it much easier to understand how complex code is structured, in my opinion.

---

## Stale Values

Source: /joy-of-react/03-hooks/05.08-stale-values

Stale Values

When I first started using computers in the late 90s, I used two different media players.

For livestreaming, I had RealPlayer:

RealPlayer was OK, but it didn't really have any personality. To my teenage self, there was a much cooler option available: Winamp.

Between those early days and now, there have been countless media players, but there's something they've all had in common. Every media player I've ever used has implemented the exact same keyboard shortcut:

The spacebar key will play (or pause) the currently-selected song.

Earlier in this module, we built a simple media player, and I think we should update it to include the spacebar shortcut!

If you'd like, I'd encourage you to spend a couple minutes attempting this problem, but I'll warn you now: It's surprisingly tricky.

Focus and iframes
(warning)

The playgrounds in this course platform use iframes for the "Result" pane. This presents a bit of a challenge for things like event listeners!

To test your solution, you'll need to click within the iframe so that the spacebar event triggers within the right context. You can click anywhere within the iframe.

Hint

You'll want to register a keydown event listener. If they've pressed the spacebar, event.code will be equal to the string "Space".

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
MediaPlayer.js
VisuallyHidden.js
Result
Console
Refresh results pane

Let's talk about it.

Video Summary

Here are the graphs from the video:

Missing dependency:

Adding isPlaying as a dependency:

Solving using a callback function:

Solution code
(success)

 Show more

Event bubbling
(info)

In our implementation above, there is a small but pesky bug with the user experience.

It's not related to useEffect or anything we've been talking about in this module, but I wanted to share a quick video on the subject, in case you've tripped over this issue.

Video Summary

Here's our final implementation:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
MediaPlayer.js
VisuallyHidden.js
Result
Console
Refresh results pane

---

## State-Setter Callback

Source: /joy-of-react/03-hooks/05.08.B-state-setter-callback

State-Setter Callback

In the previous lesson, we learned about a new way to set React state. It's an important concept, something we'll be using in the lessons and modules ahead, and so I wanted to cover it in more depth.

So far in this course, we've been updating state by calling the state-setter function with a new value:

const [count, setCount] = React.useState(0);

// sets `count` to `100`
setCount(100);

There is an alternative syntax for state updates. If we want, we can pass a callback, and React will invoke that function for us:

const [count, setCount] = React.useState(0);

// sets `count` to `100`:
setCount(() => {
  return 100;
});

Whatever we return from this function becomes the new value for the state, as if we had passed that value directly.

This is useful because React provides the current value:

const [count, setCount] = React.useState(0);

setCount((currentCount) => {
  return currentCount + 1;
});

In most cases, this isn't necessary, since we already have access to the count variable. But, when working with effects, it becomes possible for us to lose access to the freshest version of a state variable.

In the previous lesson, we saw an example of how this alternative syntax can be useful:

const [isPlaying, setIsPlaying] = React.useState(false);

React.useEffect(() => {
  function handleKeyDown(event) {
    if (event.code === 'Space') {
      // Grab the *current value* of `isPlaying` from React:
      setIsPlaying((currentIsPlaying) => {
        return !currentIsPlaying;
      });
    }
  }

  window.addEventListener('keydown', handleKeyDown);

  return () => {
    window.removeEventListener('keydown', handleKeyDown);
  };

  // No dependency on `isPlaying`!
}, []);

This effect only runs after the very first render, since we've specified an empty dependency array. This means that within the effect, isPlaying will always be equal to false.

Each render is a snapshot in time. We're creating a constant, isPlaying, and initializing it to false. The underlying state variable may change, but that change will only be reflected in future snapshots. And since our effect doesn't have any dependencies, the effect will not re-run when that happens.

And so, instead of trying to read the isPlaying constant created in the first render, we instead give React a callback function, and React invokes that function for us, passing in the current value of the state variable.

I recognize that this is confusing as heck 😅. This is one of the trickiest concepts in React. It's 100% OK if it doesn't quite make sense to you yet. I promise it'll start to click as you get more practice with React.

When to use the callback syntax

Most of the time, we don't need to use the callback syntax. The main use case for this syntax, in my opinion, is to avoid the “stale values” issue we saw in the previous lesson.

Stale values aren't strictly a useEffect thing; we can also run into these sorts of issues when using useMemo and useCallback, discussed later in this module, and also when doing asynchronous work (eg. fetching data), discussed in the next module.

Occasionally, it can be more convenient to use the callback syntax. For example, if we're passing the state-setter function as a prop to a child component, we can use the callback syntax to modify the current value without also having to pass that value through props.

Why not always use the callback syntax?
(info)

You might be wondering: is there ever a reason not to use the callback syntax? Why not use it in every situation?

For example:

function Counter() {
  const [count, setCount] = React.useState(0);

  return (
    <button
      onClick={() => {
        setCount((currentCount) => currentCount + 1);
      }}
    >
      {count}
    </button>
  );
}

This is a typical “counter” app. There are no effects, no asynchronous code. There's no way for the state to grow stale. But the alternative "callback" syntax still works just fine.

Even though it works, I don't suggest doing this. At least, not for now.

In order to truly become comfortable with React, we need to build an intuition for how effects and renders are connected, and the callback syntax can be a bit of a crutch. If we always use the callback syntax, it'll take us a lot longer to build that intuition!

Unfortunately, the callback syntax isn't a silver bullet. Even if you use it all the time, you'll still occasionally run into situations where stale values cause issues. And so it's important to build that intuition, so that you can handle these situations as they come up!

Here's what I suggest: use the default non-callback form by default. When you run into bugs, you can try the callback syntax to see if it helps. If it does, spend a few moments seeing if you can understand why. The more practice you get, the quicker it'll start making sense.


---

## More Exercises

Source: /joy-of-react/03-hooks/05.09-stale-values-exercises

More Exercises
Interval counter

In the sandbox below, we want to count how many seconds have elapsed since the component mounted:

Unfortunately, our attempted solution appears to have a bug: it stops counting at 1. 🤔

Your mission is to fix the bug, so that the number keeps incrementing past 1.

Acceptance Criteria:

The UI should accurately show the # of seconds since mount.
There should be no lint warnings, and no eslint-disable comments.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function Timer() {
  const [count, setCount] = React.useState(0);

  React.useEffect(() => {
    const intervalId = window.setInterval(() => {
      setCount(count + 1);
    }, 1000);

    return () => {
      window.clearInterval(intervalId);
    };
    // eslint-disable-next-line
  }, []);

  return (
    <div className="timer">
      <h1>Seconds since load:</h1>
      <p>{count}</p>
    </div>
  );
}

export default Timer;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

---

## Strict Mode

Source: /joy-of-react/03-hooks/05.10-strict-mode

Strict Mode

In React, there are lots of subtle gotchas, things that can cause significant problems for our users, but that aren't necessarily obvious to us as developers.

To help us find and fix these issues, the React team has introduced a new “Strict Mode”.

To enable “Strict Mode”, we wrap our application in a React.StrictMode element:

import React from 'react';

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

This element flips a switch inside React, adding in a bunch of restrictions and safeguards designed to improve the robustness of our application.

One of these tweaks in particular is pretty controversial, and has led to a lot of confusion.

Let's talk about it.

Video Summary

Here's the sandbox from the video above:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.js
App.js
MediaPlayer.js
Preview
Refresh results pane
Console
Clear Console
More information about Strict Mode

In addition to re-running all effects, Strict Mode changes a number of other things. We can group these changes into 2 categories:

Safeguards designed to amplify potential issues
Warnings about deprecated APIs

Unless you find yourself working in a legacy codebase (at least 5 years old), you're not likely to run into any of the deprecation warnings.

But you are likely to notice some of the safeguards, like the one we saw above about duplicated effects. At this time of writing, all of these safeguards follow the same pattern: running things twice.

For example, in Strict Mode, each render is automatically re-run. If we take another look at the Digital Clock example with Strict Mode enabled, we notice that each re-render happens twice:

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Clock.js
Preview
Refresh results pane
Console
Clear Console

If you're curious, you can see a full list of Strict Mode changes by reading the official documentation
.

The new default

While Strict Mode is technically an optional, “opt in” mode, it's quickly become the standard way to use React. Just about every boilerplate and meta-framework will use Strict Mode by default!

I want to make sure you're learning "real-world" React, and most real-world projects use Strict Mode. And so, from this moment onwards, Strict Mode will be enabled by default on this course platform.

I've added a little toggle to the sandbox which will show you whether Strict Mode is enabled, and allow you to toggle it on:

Try it out for yourself here! You should see two “Mount check!” console logs when Strict Mode is enabled, and only one when it's disabled:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Preview
Refresh results pane
Console
Clear Console

In general, I recommend leaving Strict Mode on. The toggle is provided for troubleshooting purposes.

Simulating Strict Mode

As I was developing this lesson, a thought occurred to me: is it possible to “simulate” this Strict Mode quirk, by unmounting/remounting the component?

Well, let's explore:

Video Summary

Here are the illustrations from the video:

Strict Mode:

Strict Mode (simulated):


---

## Custom Hooks

Source: /joy-of-react/03-hooks/06-custom-hooks

Custom Hooks

React supports custom hooks. This means that in addition to the hooks that come with React, like useState and useEffect, we can create our own hooks, things like useInterval and useOnScroll.

Custom hooks are the best thing about React hooks. They make the entire API shine, and honestly, I've been anxiously waiting for us to reach this point of the course so that I could share them with you!

If you've been struggling to understand why people like hooks, hopefully this lesson will make it clear! 😄

Not as scary as it sounds

The first thing to understand is that we aren't really inventing our own hooks.

When I first heard the term "custom hook", it sounded intimidating, like something only the most advanced power user would use. Hooks are hard enough when we use the default ones!

The lightbulb moment for me came when I started thinking of them as custom hook combos.

Let's look at an example.

Video Summary

Here's the code from the video above:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Clock.js
Result
Console
Refresh results pane

---

## Exercises

Source: /joy-of-react/03-hooks/06.01-custom-hook-exercises

Exercises
useMousePosition

In another earlier exercise, we tracked the user's mouse position to display it in a MouseCoords component.

Let's pull this logic into a generic, reusable hook called useMousePosition.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
use-mouse-position.js
import React from 'react';

import useMousePosition from './hooks/use-mouse-position.js';

// TODO: Pull the mouse-position logic into
// the use-mouse-position.js file!

function App() {
  const [mousePosition, setMousePosition] = React.useState({
    x: 0,
    y: 0,
  });

  React.useEffect(() => {
    function handleMouseMove(event) {
      setMousePosition({
        x: event.clientX,
        y: event.clientY,
      });
    }

    window.addEventListener('mousemove', handleMouseMove);

    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
    };
  }, []);

  return (
    <div className="wrapper">
      <p>
        {mousePosition.x} / {mousePosition.y}
      </p>
    </div>
  );
}
Result
Console
Refresh results pane

Solution:

(If you're curious how the "Magnetic lines" effect works from my blog, I did a walkthrough on some of the basic concepts on the Frontend Horse Holiday Snowtacular
 in 2021. It uses this exact custom hook!)

Solution code
(success)

 Show more
useIsOnscreen

In the Toasty! exercise, we saw how to use IntersectionObserver to trigger a state change when an element enters/exits the viewport.

Let's generalize this solution so that we can easily check if a given element is in the viewport or not.

In the exercise below, you'll see a large red square that can be scrolled into view. Your job is to fill in the useIsOnscreen hook so that we track this element.

Acceptance Criteria:

When the red square is in the viewport, we should see the word “YES” in the top right corner
When the red square is not in the viewport, we should see the word “NO” instead.
We shouldn't use document.querySelector.
There should be no lint warnings

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
use-is-onscreen.js
Result
Console
Refresh results pane

Unwrapping the ref
(warning)

Several students have tried to solve this by passing the DOM node in directly, like this:

const isOnscreen = useIsOnscreen(elementRef.current);
//                                          ^^^^^^^

Curiously, this seemingly-innocuous change breaks everything. 😬

Later in this course 👀, we'll dig deeper into this issue, and understand exactly why this doesn't work.

Solution:

The video mentions a blog post I wrote, Animated Sparkles in React
. It's not particularly relevant, but I thought I'd link it in case you were curious!

Solution code
(success)

 Show more
useToggle

In the Digital Clock exercise, we could click a button to toggle the clock off and on:

This happens because of some conditional rendering inside /App.js. The code looks something like this:

const [
  showClock,
  setShowClock
] = React.useState(true);

return (
  <>
    <button onClick={() => setShowClock(!showClock)}>
      Clock {showClock ? 'ON' : 'OFF'}
    </button>

    {showClock && <Clock />}
  </>
);

This works fine, but one of the coolest things about React hooks is that we can create custom utility hooks that work even better.

For example, what if we created a new useToggle hook? This hook should behave exactly like useState, but instead of setting the state to a specified value, it should toggle back and forth between true and false:

function App() {
  const [
    showClock,
    toggleClock,
  ] = useToggle(true);

  return (
    <>
      <button onClick={toggleClock}>
        Clock {showClock ? 'ON' : 'OFF'}
      </button>

      {showClock && <Clock />}
    </>
  );
}

For the most part, we use this useToggle hook just like we'd use the built-in useState hook: we give it an initial value (true, in this case), and it provides the current value and a function to change the value.

The difference is that the useState hook provides a state-setter function, which accepts the next value for the state variable. Our useToggle hook provides a toggle function (eg. toggleClock). It ignores any arguments passed to it. Calling the toggle function will flip the value from true to false, or from false to true.

Your job is to create this useToggle hook.

Acceptance Criteria:

The useToggle hook should use useState internally, to create and manage a state variable.
We should be able to specify an initial value for the state variable.
It should return an array containing two items:
The state variable
A function that flips the state variable between true and false.
Clicking the button should toggle the clock off and on.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
use-toggle.js
Clock.js
Result
Console
Refresh results pane

Solution:

Correction: In this solution, we restrict initialValue to boolean values, but to truly work as a drop-in replacement for useState, we should also support initializer functions. This tweak has been made to the solution code here:

Solution code
(success)

 Show more

---

## Data Fetching

Source: /joy-of-react/03-hooks/07-data-fetching

Data Fetching

Data fetching is a critical component for most web applications. When we really think about it, most web applications exist to let users interact with data in a database:

Search engines are huge databases that let us filter their billions of entries to find the most suitable results.
Chat applications like Slack let us send and receive messages stored in a database.
Social networks provide feeds pulled from a database, and let us interact with them by updating data in a database.

In the lessons that follow, we'll see how to send network requests in a React context.

Tool of choice

So, there is a huge universe of tools out there to manage network requests for us.

In this course, we're going to use Fetch to make requests. Fetch is a part of the web platform, built right into the browser. If you're not familiar, you can learn about the basics of working with Fetch in the “Fetch Basics” primer lesson 👀.

It's becoming increasingly popular in the React community to use third-party tools like react-query
 or SWR
 to help with network requests. In the lessons that follow, we'll see how SWR can augment our Fetch requests.

Pre-requisites

These lessons will focus on how to use Fetch in a React context. There is a fair amount of “assumed knowledge” here, including:

Synchronous vs Asynchronous code
Promises
Async / Await 👀
HTTP Methods 👀
Fetch basics 👀
Test API

I've created a sample back-end API we can use for learning about network requests.

We'll see exactly how to use it in the lessons ahead, but I wanted to share a little cheatsheet about this sample API:

All requests are artificially slowed by 1-2 seconds, to give us time to check loading states.
We can simulate errors by passing a query parameter, simulatedError=true.
For endpoints that return data, that data will often be randomized / faked.

---

## Fetching on Event

Source: /joy-of-react/03-hooks/07.01-fetching-on-event

Fetching on Event

If you've ever built a developer portfolio for yourself, odds are you've implemented a contact form. These forms are all over the internet.

Let's see how we can implement one:

Video Summary

In this video, we see how to send data to our backend API using fetch. We saw how to send a POST request, how to stringify the body, and how to validate that we received the correct response from the server.

But really, this implementation is not yet complete. We need to update the UI so that the user knows what's happening at all times!

Here's the sandbox from the video above:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

const ENDPOINT =
  'https://jor-test-api.vercel.app/api/contact';

function ContactForm() {
  const [email, setEmail] = React.useState('');
  const [message, setMessage] = React.useState('');

  const id = React.useId();
  const emailId = `${id}-email`;
  const messageId = `${id}-message`;

  async function handleSubmit(event) {
    event.preventDefault();

    const response = await fetch(ENDPOINT, {
      method: 'POST',
      body: JSON.stringify({
        email,
        message,
      }),
    });
    const json = await response.json();
    console.log(json);
  }

  return (
    <form onSubmit={handleSubmit}>
      <div className="row">
        <label htmlFor={emailId}>Email</label>
        <input
          required={true}
          id={emailId}
          type="email"
          value={email}
Result
Console
Refresh results pane
Loading, success, and error statuses

When submitting network requests, we want to update the UI to indicate 3 different statuses:

Loading
Success
Error

In the video below, I'll show you how I'd implement these statuses, and update the UI accordingly, but I'd encourage you to give it a shot yourself, using the playground above. Feel free to structure things however you wish, updating the UI in whichever way you feel makes the most sense.

Here's how I'd approach it:

Video Summary

In the video above, we touch on HTML validation. You can learn more on MDN: “Constraint Validation”
.

We also touched on HTTP status codes. You can learn more in the “HTTP Status Codes” primer lesson 👀.

Here's the final sandbox from the video:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Catching unexpected errors
(info)

In the example above, we're handling expected errors by checking the value of the JSON response, but we're not handling unexpected errors. For example, if the server is down, the whole thing will throw an exception.

To guard against this case, we should also wrap the fetch request in a try / catch:

async function handleSubmit(event) {
  event.preventDefault();

  setStatus('loading');

  try {
    const response = await fetch(ENDPOINT, {
      method: 'POST',
      body: JSON.stringify({
        email,
        message,
      }),
    });
    const json = await response.json();

    if (json.ok) {
      setStatus('success');
      setMessage('');
    } else {
      setStatus('error');
    }
  } catch (err) {
    setStatus('error');
  }
}

---

## Fetching on Mount

Source: /joy-of-react/03-hooks/07.02-fetching-on-mount

Fetching on Mount

In the previous lesson, we saw how to make a network request in response to an event, like a form submission. But what if we need to fetch data to populate the initial view?

For example, let's suppose we're building a weather app. We want to show the user what the current temperature is in their area:

We want to show the temperature immediately, right when the component mounts.

This is a surprisingly thorny problem. It might seem like a slight difference, fetching on mount instead of fetching on event, but it opens a whole can of worms.

First, the ergonomics are tricky. In order to fetch on mount, we'd generally use the useEffect hook, but there are some gotchas around using async/await in an effect (covered in an upcoming lesson).

And also, if we want to solve this problem in a robust, production-ready way, there are all sorts of concerns we need to worry about, including:

Caching the response so that it can be reused by multiple components across the app.
Revalidating the data so that it never becomes too stale.

This is a rabbit hole we could get lost in for days. 😬

As a result, it's become standard in the community to use a tool to help with this stuff. The React docs
,
*
 for example, suggest using a package like React Query
 or SWR
. In fact, on this course platform, I use SWR to solve all of these hard problems for me!

Let's see how it works.

Intro to SWR

Here's an MVP? implementation. Feel free to poke and prod at it. We'll go over how it works below.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Preview
Refresh results pane
Console
Clear Console

What's that syntax?
(info)

This code uses the optional chaining operator (?.). You can learn more about it in my “Operator Lookup” tool
.

Let's dig into this code:

Video Summary

Loading and error states

Our MVP above doesn't include loading or error states. Let's see how to implement them with SWR.

Loading

In addition to providing a data value, the useSWR hook also tells us whether or not the request is currently loading. We can pluck out the isLoading key:

const { data, isLoading } = useSWR(ENDPOINT, fetcher);

isLoading is a boolean value. The initial value is true, and it flips to false once the fetch request has completed.

We can use that value to conditionally render a loading UI like this:

function App() {
  const { data, isLoading } = useSWR(ENDPOINT, fetcher);

  if (isLoading) {
    return (
      <p>Loading…</p>
    );
  }

  return (
    <p>
      Current temperature:
      {typeof data.temperature === 'number' && (
        <span className="temperature">
          {data.temperature}°C
        </span>
      )}
    </p>
  );
}
Error

To simulate an error, we can add a query parameter to the ENDPOINT:

const ENDPOINT =
  'https://jor-test-api.vercel.app/api/get-temperature?simulatedError=true';

This will cause the server to return a 500 status code 👀, instead of 200. It will also return the following JSON:

{
  "error": "This request returns an error, because the “simulatedError” query parameter was specified."
}

With SWR, however, neither of these things is sufficient to mark this as an error.

Remember: we manage the network request! Our fetcher function is responsible for retrieving the data, and passing it along to SWR. If we want this to count as an error, we need to throw it:

async function fetcher(endpoint) {
  const response = await fetch(endpoint);
  const json = await response.json();

  if (!json.ok) {
    throw json;
  }

  return json;
}

With this change done, data will be undefined, and error will be the object we got back from the server.

Throwing an object?!
(info)

It's conventional in JavaScript to throw an Error, like this:

if (!json.ok) {
  throw new Error('Some sort of error message');
}

When working with SWR, however, I prefer to throw the JSON object.

if (!json.ok) {
  throw json;
}

It's equally valid, and it means that error will be an object rather than being an Error instance. This is easier to work with, as I can access the data associated with the error.

Here's the final implementation, with loading and error states:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Preview
Refresh results pane
Console
Clear Console

---

## Exercises

Source: /joy-of-react/03-hooks/07.03-fetch-exercises

Exercises
Book search

Suppose we're building a Goodreads-type site, a place for users to discover new books. Our job is to implement a search feature:

In the sandbox below, you'll find you have a <SearchResult> component ready to be used to display the results. Your mission is to wire up the search form so that the results are fetched from the backend API. An endpoint has been provided.

Here's an example request/response:

// REQUEST:
GET '/api/book-search?searchTerm=winter'

// RESPONSE:
{
  "ok": true,
  "results": [
    {
      "isbn": "1234567890123",
      "name": "Winter's Orbit",
      "author": "Everina Maxwell",
      "coverSrc": "/image-path/cover.png",
      "abstract": "While the Iskat Empire has long dominated the system…"
    }
  ]
}

Acceptance Criteria:

There's quite a bit to do in this one!

Submitting the form should make a GET request to the supplied API endpoint, passing along searchTerm as a query parameter.
If there are search results, we should map over them, rendering a <SearchResult> element for each one.
We should show the text "Searching…" while the search is in progress.
Before the user has searched, we should show a paragraph containing the text "Welcome to Book Search!"
If there are no matching results, we should show a paragraph containing the text "No Results".
If the API returns an error, we should show a paragraph containing the text "Something went wrong!".
You can simulate an error by passing simulatedError=true as a query parameter.
There should be no key warnings in the console.

You don't have to use SWR for this. SWR is primarily useful when fetching data on mount. In this case, it's easier to make the request "on-demand", when the user performs a search.

How to test
(warning)

The backend API has a very small sample library of about 20 books. Most common search queries will likely return 0 results.

Here are some terms you can use, with the expected # of results:

fifth — 1 result
a — 18 results
becky — 4 results
hello — 0 results

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
SearchResult.js
TextInput.js
Result
Console
Refresh results pane

Failed to fetch?
(warning)

When making your request, make sure to avoid adding a trailing slash before the query parameters:

GET '/api/book-search/?searchTerm=winter'
//                   ^ This little fella causes problems

The issue is that the backend API will automatically redirect from /book-search/ to /book-search, but the CORS middleware won’t run during that redirect, and so the request will be rejected.

In the future I hope to update the backend to allow for either URL structure. Sorry for any confusion!

Solution:

Encoding URL parameters
(info)

When constructing URLs for fetch, it’s a good practice to escape characters like & and ?. Otherwise, they could change the structure of the URL.

For example, if the user searches for “Red, White & Royal Blue”, that book title includes an ampersand (&), which is used to separate multiple query parameters (eg. searchTerm=hello&sort=publishedDate). To ensure that the search term doesn’t break the structure of our URL, we want to transform & into its UTF-8 encoding, %26.

We can do this using the built-in function, encodeURIComponent:

const searchTerm = encodeURIComponent('Red, White & Royal Blue');
// → Red%2C%20White%20%26%20Royal%20Blue

When working with multiple query parameters, we can use the URLSearchParams constructor, which will handle the encoding and also combine the parameters in a logical way:

const params = new URLSearchParams({
  searchTerm: 'Red, White & Royal Blue',
  sort: 'publishedDate',
});

The solution code below has been updated to include this encoding.

Solution code
(success)

 Show more
Fetching the current user

In the sandbox below, we want to display a card showing a user's name and email. Before we can do that, however, we need to fetch the user data from the API.

An API endpoint has been provided, which returns data in the following format:

{
  "user": {
    "name": "Ahmed",
    "email": "me@ahmed1234.com",
  }
}

Your mission is to fetch the data from the endpoint provided, and pass the received data to the UserCard component. You should also include a loading state, as well as an error state.

Acceptance Criteria:

You should use the provided useSWR hook to perform the request.
While the request is running, a spinner should be shown. A Spinner component has been provided for this purpose.
If the request succeeds, the <UserCard> component should be shown, populated with the data from the request.
If the request fails, you can show an error message (a standard paragraph with "Something went wrong!" is fine).
You can simulate an error by passing simulatedError=true as a query parameter.
Hint

You can refer to the final sandbox from the previous lesson as a template for making requests with the useSWR hook.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
UserCard.js
Spinner.js
Spinner.module.css
Preview
Refresh results pane
Console
Clear Console

Solution:

Manually deriving isLoading?
(warning)

In the solution above, I'm doing something a bit funny:

const isLoading = !data && !error;

When I filmed this video, SWR didn't yet provide an isLoading value; this is a relatively new feature, as part of the 2.0 release.

I've updated the solution code below to use the built-in isLoading value. Sorry for any confusion!

Solution code
(success)

 Show more

---

## Async Effect Gotcha

Source: /joy-of-react/03-hooks/07.04-async-await

Async Effect Gotcha

Suppose we want to fetch some data on mount, and we don't want to use SWR. We'll make a fetch request inside a useEffect hook.

Using the async/await syntax 👀, most developers would try to do something like this:

React.useEffect(async () => {
  const response = await fetch(ENDPOINT);
  const json = await response.json();

  setTemperature(json.temperature);
}, []);

In order to use the await keyword, we need to be within an async function. It seems logical that we'd make our effect callback async, but unfortunately, it doesn't work:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

const ENDPOINT = 'https://jor-test-api.vercel.app/api/get-temperature';

function App() {
  const [temperature, setTemperature] = React.useState(null);

  React.useEffect(async () => {
    const response = await fetch(ENDPOINT);
    const json = await response.json();

    setTemperature(json.temperature);
  }, []);

  return (
    <p>
      Current temperature:
      {typeof temperature === 'number' && (
        <span className="temperature">
          {temperature}°C
        </span>
      )}
    </p>
  );
}

export default App;
Preview
Refresh results pane
Console
Clear Console

In addition to the cryptic error message, we also see the following warning in the console:

Warning: useEffect must not return anything besides a function, which is used for clean-up.

It looks like you wrote useEffect(async () => ...) or returned a Promise. Instead, write the async function inside your effect and call it immediately.

We're not allowed to make the effect callback async. Instead, we need to create another function within the effect. Here's how I typically solve this problem:

React.useEffect(() => {
  // Create an async function within our effect:
  async function runEffect() {
    const response = await fetch(ENDPOINT);
    const json = await response.json();

    setTemperature(json.temperature);
  }

  // Immediately call this function to run the effect:
  runEffect();
}, []);

Essentially, we move all of our effect logic into this async function. I like to use a generic name like runEffect instead of a specific name like fetchTemperature, to make it clear that we're moving everything related to the effect into this function.

If our effect has a cleanup function, that cleanup function should not be included in our runEffect function:

React.useEffect(() => {
  async function runEffect() {
    // ... Effect logic here
  }

  runEffect();

  return () => {
    //  ... Cleanup logic here
  }
}, []);

To be clear: we don't run into this issue at all when we use a data-fetching library like SWR. This is one of many problems that those tools solve for us!

But I wanted to cover this anyway because not everyone uses data-fetching libraries. And even if you do, there may still be cases where you want to await some sort of async operation unrelated to data fetching.

Why async effect callbacks aren't allowed
(info)

It might seem silly to create and immediately invoke an async function. Why aren't we allowed to pass an async function directly to useEffect??

The first thing to understand about async functions is that they always return a promise.

For example:

async function quickExample() {
  return 5;
}

const result = quickExample();
console.log(result); // Promise

This quickExample function doesn't actually return the number 5. It returns a promise that resolves to 5. This is true for all async functions, even ones that don't await anything.

This is important because React expects us to return a cleanup function, not a promise!

Consider an effect like this:

React.useEffect(() => {
  // Effect logic: start an interval
  const intervalId = window.setInterval(() => {}, 1000);

  // Cleanup logic: stop the interval:
  return () => {
    window.clearInterval(intervalId);
  };
}, []);

When React runs our effect, we hand it a cleanup function. React will invoke this cleanup function when the dependencies change, and when the component unmounts.

Now let's suppose we have some async work to do in this effect:

React.useEffect(async () => {
  const intervalId = window.setInterval(() => {}, 1000);

  await someLongRunningProcess();

  // Even though we're returning a function, it'll actually
  // return a *promise* that resolves to a function:
  return () => {
    window.clearInterval(intervalId);
  };
});

When React runs this effect, it doesn't receive a cleanup function, it receives a promise.

What happens if the component unmounts while that long-running process is running? React can't do any cleanup, because we haven't yet handed React the cleanup function!

To avoid sticky situations like this, the React team decided that effect callbacks can't be async functions. It would open too many cans of worms.

Instead, we can wrap our async logic up in an async function. That way, React receives the cleanup function immediately:

React.useEffect(() => {
  async function runEffect() {
    /* Async stuff */
  }
  runEffect();

  // Cleanup function is returned right away:
  return () => {
    /* Cleanup stuff */
  };
});

---

## Memoization

Source: /joy-of-react/03-hooks/08-memoization

Memoization

If you've ever worked in a midsize or large React application, you've probably noticed that components re-render a lot. In some cases, this can lead to performance problems, where a small change near the top of the application causes a ton of unrelated components to re-render.

In this group of lessons, we're going to go deeper and learn exactly why React components re-render. We'll also see how three React tools can help us optimize this stuff:

The React.memo component wrapper
The useCallback hook
The useMemo hook

As I was building The Joy of React, I sent an email asking prospective students what they were hoping to learn in this course. Many, many people requested help with this stuff.
*
 Hopefully these lessons can offer a lot of clarity!


---

## Why React Re-Renders

Source: /joy-of-react/03-hooks/08.01-why-react-renders

Why React Re-Renders

So, before we can talk about useMemo and useCallback, we need to get really comfortable with the React render cycle.

Throughout this course, we've seen how we can call a state setter function (eg. setCount, setUser) to trigger a re-render. React needs to capture a snapshot of what the UI should look like given this new value for a state variable.

In fact, we've already learned a lot about re-renders. In this lesson, we're going to refine what we've learned, to poke at it a bit and see if we can make things even clearer.

The basic rule

So, let's start with a fundamental truth: Every re-render in React starts with a state change. It's the only “trigger” in React for a component to re-render.
*

Now, that probably doesn't sound right... after all, don't components re-render when their props change?

Here's the thing: when a component re-renders, it also re-renders all of its descendants.

Let's look at an example:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function App() {
  return (
    <>
      <Counter />
      <footer>
        <p>Copyright 2022 Big Count Inc.</p>
      </footer>
    </>
  );
}

function Counter() {
  const [count, setCount] = React.useState(0);

  return (
    <main>
      <BigCountNumber count={count} />
      <button onClick={() => setCount(count + 1)}>
        Increment
      </button>
    </main>
  );
}

function BigCountNumber({ count }) {
  return (
    <p>
      <span className="prefix">Count:</span>
      {count}
    </p>
  );
}

export default App;
Result
Console
Refresh results pane

In this example, we have 3 components: App at the top, which renders Counter, which renders BigCountNumber.

In React, every state variable is attached to a particular component instance. In this example, we have a single piece of state, count, which is associated with the Counter component.

Whenever this state changes, Counter re-renders. And because BigCountNumber is being rendered by Counter, it will re-render as well.

Here's an interactive graph that shows this mechanic in action. Click the “Increment” button to trigger a state change:

App

Counter

count: 0

Increment

BigCountNumber

Props: { count }

(The green flash signifies that a component is re-rendering.)

Alright, let's clear away Big Misconception #1: The entire app re-renders whenever a state variable changes.

I know some developers believe that every state change in React forces an application-wide render, but this isn't true. Re-renders only affect the component that owns the state + its descendants (if any). The App component, in this example, doesn't have to re-render when the count state variable changes.

Rather than memorize this as a rule, though, let's take a step back and see if we can figure out why it works this way.

React's “main job” is to keep the application UI in sync with the React state. The point of a re-render is to figure out what needs to change.

Let's consider the “Counter” example above. When the Counter component first mounts, React renders all the associated elements and comes up with the following sketch for what the DOM should look like:

<main>
  <p>
    <span class="prefix">Count:</span>
    0
  </p>
  <button>
    Increment
  </button>
</main>

When the user clicks on the button, the count state variable flips from 0 to 1. How does this affect the UI? Well, that's what we hope to learn from doing another render!

React re-runs the code for the Counter and BigCountNumber components, and we generate a new picture of the DOM we want:

<main>
  <p>
    <span class="prefix">Count:</span>
    1
  </p>
  <button>
    Increment
  </button>
</main>

As we've learned, each render is like a snapshot, a photo that tells us what the UI should look like, based on the current application state.

React then plays a “find the differences” game to figure out what's changed between snapshots. In this case, it sees that our paragraph has a text node that changed from 0 to 1, and so it edits the text node to match the snapshot. Satisfied that its work is done, React settles back and waits for the next state change. This is what we've called the core React loop.

With this framing in mind, let's look again at our render graph:

App

Counter

count: 0

Increment

BigCountNumber

Props: { count }

Our count state is associated with the Counter component. Because data can't flow "up" in a React application, we know that this state change can't possibly affect <App />. And so we don't need to re-render that component.

But we do need to re-render Counter's child, BigCountNumber. This is the component that actually displays the count state. If we don't render it, we won't know that our paragraph's text node should change from 0 to 1. We need to include this component in our sketch.

The point of a re-render is to figure out how a state change should affect the user interface. And so we need to re-render all potentially-affected components, to get an accurate snapshot.

It's not about the props

Alright, let's talk about Big Misconception #2: A component will re-render because its props change.

Let's explore with an updated example.

In the code below, our “Counter” app has been given a brand new component, Decoration:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Counter.js
Decoration.js
BigCountNumber.js
Result
Console
Refresh results pane

(It was getting a bit crowded, having all of the components in a single big file, so I took the liberty of re-organizing. But the overall component structure is the same, aside from the new Decoration component.)

Our counter now has a cute lil’ sailboat in the corner, rendered by the Decoration component. It doesn't depend on count, so it probably won't re-render when count changes, right?

Well, er, not quite.

App

Counter

count: 0

Increment

BigCountNumber

Props: { count }

Decoration

When a component re-renders, it tries to re-render all descendants, regardless of whether they're being passed a particular state variable through props or not.

Now, this seems counter-intuitive... If we aren't passing count as a prop to <Decoration>, why would it need to re-render??

Here's the answer: it's hard for React to know, with 100% certainty, whether <Decoration> depends, directly or indirectly, on the count state variable.

In an ideal world, React components would always be “pure”. A pure component is one that always produces the same UI when given the same props.

In the real world, many of our components are impure. It's surprisingly easy to create an impure component. For example:

function CurrentTime() {
  const now = new Date();

  return (
    <p>It is currently {now.toString()}</p>
  );
}

This component will display a different value whenever it's rendered, since it relies on the current time!

A sneakier version of this problem has to do with refs. If we pass a ref as a prop, React won't be able to tell whether or not we've mutated it since the last render. And so it chooses to re-render, to be on the safe side.

React's #1 goal is to make sure that the UI that the user sees is kept “in sync” with the application state. And so, React will err on the side of too many renders. It doesn't want to risk showing the user a stale UI.

So, to go back to our misconception: props have nothing to do with re-renders. Our <BigCountNumber> component isn't re-rendering because the count prop changed.

When a component re-renders, because one of its state variables has been updated, that re-render will cascade all the way down the tree, in order for React to figure out what the new snapshot should look like.

That said, there are some things we can do to optimize this process. We'll learn about our options in the next few lessons.

Rendering vs. Painting
(info)

When discussing this stuff, it’s important to remember that “rendering” isn’t the same thing as “painting”. A re-render won’t touch the DOM unless something needs to be updated.

Unnecessary re-renders can be a performance liability, if the reconciliation process has to compare a large number of React elements. In the lessons that follow, we’ll learn how to solve for this. But I think it’s also important to keep in mind that most re-renders are negligible. React is designed to be fast and efficient, and we don’t need to micro-manage it that much!


---

## Pure Components

Source: /joy-of-react/03-hooks/08.02-pure-components

Pure Components

In the last lesson, we saw how a component will automatically re-render when its parent re-renders, regardless of whether or not its props have changed.

In larger applications, this can lead to performance problems. A single state change might re-render dozens or even hundreds of components, even if only a small fraction of them actually need to re-render.

Fortunately, React provides an escape hatch we can use: the React.memo utility.

Here's what it looks like:

function Decoration() {
  return (
    <div className="decoration">
      ⛵️
    </div>
  );
}

const PureDecoration = React.memo(Decoration);

export default PureDecoration;

React.memo is a utility that lets us tell React: “Hey, this component is pure! It doesn't need to re-render unless its props or state changes. It will always return the exact same UI when given the same props + state”.

It takes a component as an argument (Decoration) and augments it, giving it a new super-power: it can selectively ignore re-renders that don't affect it.

When the parent component re-renders, React will try to re-render the child PureDecoration, but PureDecoration steps in and says “None of my props have changed, and so I won't be re-rendering this time.”

This uses a technique known as memoization.

It's missing the R, but we can sorta think of it as “memorization”. The idea is that React will remember the previous snapshot. If none of the props have changed, React will re-use that stale snapshot rather than going through the trouble of generating a brand new one.

Let's suppose I wrap both BigCountNumber and Decoration with the React.memo helper. Here's how this would affect the renders:

App

Counter

count: 0

Increment

BigCountNumber

Props: { count }

Pure Component

Decoration

Pure Component

When count changes, we re-render Counter, and React will try to render both descendant components.

Because BigCountNumber takes count as a prop, and because that prop has changed, BigCountNumber is re-rendered. But because Decoration's props haven't changed (on account of it not having any), the original snapshot is used instead.

I like to pretend that React.memo is a bit like a lazy photographer. If you ask it to take 5 photos of the exact same thing, it'll take 1 photo and give you 5 copies of it. The photographer will only snap a new picture when your instructions change.

Here's a live-code version, if you'd like to poke at it yourself. Each memoized component has a console.info call added, so you can see in the console exactly when each component renders:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Counter.js
Decoration.js
BigCountNumber.js
Preview
Refresh results pane
Console
Clear Console

To summarize:

The only way to re-render anything in React is to update a state variable by calling a state-setter function (eg. setCount).
When a component re-renders, it automatically re-renders all of its descendants, even if none of their props have changed.
We can wrap our component with React.memo to optimize it, so that it only re-renders if at least 1 of its props have changed since the last render.

Why isn't this the default behaviour??
(info)

You might be wondering why the React.memo behaviour isn't the default. Surely we'd improve performance if we skipped rendering components that don't need to be rendered?

I think as developers, we tend to overestimate how expensive re-renders are. In the case of our Decoration component, re-renders are lightning quick. If a component has a bunch of props and not a lot of descendants, it can actually be slower to check if any of the props have changed compared to re-rendering the component.
*

And so, the official recommendation is to use React.memo as-needed, when trying to fix a performance issue. You shouldn't need to apply it pre-emptively.


---

## The useMemo Hook

Source: /joy-of-react/03-hooks/08.03-use-memo

The useMemo Hook

In the last lesson, we saw how the React.memo helper lets us memoize a component, so that it only re-renders when its props/state changes.

In this lesson, we're going to learn about another tool that lets us do a different sort of memoization: the useMemo hook.

The fundamental idea with useMemo is that it allows us to “remember” a computed value between renders.

We generally use this hook for performance optimizations. It can be used in two separate-but-related ways:

We can reduce the amount of work that needs to be done in a given render.
We can reduce the number of times that a component is re-rendered.

Let's talk about these strategies, one at a time.

Use case 1: Heavy computations

Let's suppose we're building a tool to help users find all of the prime numbers between 0 and selectedNum, where selectedNum is a user-supplied value. A prime number is a number that can only be divided by 1 and itself, like 17.

Here's one possible implementation. Try changing "Your number" to see how it works:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';

function App() {
  // We hold the user's selected number in state.
  const [selectedNum, setSelectedNum] = React.useState(100);

  // We calculate all of the prime numbers between 0 and the
  // user's chosen number, `selectedNum`:
  const allPrimes = [];
  for (let counter = 2; counter < selectedNum; counter++) {
    if (isPrime(counter)) {
      allPrimes.push(counter);
    }
  }

  return (
    <>
      <form>
        <label htmlFor="num">Your number:</label>
        <input
          id="num"
          type="number"
          value={selectedNum}
          onChange={(event) => {
            // To prevent computers from exploding,
            // we'll max out at 100k
            const num = Math.min(
              100_000,
              Number(event.target.value)
            );

            setSelectedNum(num);
          }}
        />
      </form>
      <p>
Result
Console
Refresh results pane

In this code, we have a single piece of state, selectedNum. Using a for loop, we manually calculate all of the prime numbers between 0 and selectedNum. The user can change selectedNum by editing a controlled number input.

This code requires a significant amount of computation. If the user picks a large selectedNum, we'll need to go through tens of thousands of numbers, checking if each one is prime. And, while there are more efficient prime-checking algorithms than the one I used above, it's always going to be computationally intensive.

Now, we can't avoid this work altogether. We need to do all this work at least once, and again whenever the user picks a new number. But if we wind up doing this work gratuitously, we can run into performance problems.

For example, let's suppose our example also features a digital clock, using the useTime hook we created.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
use-time.js
Result
Console
Refresh results pane

Our application now has two pieces of state, selectedNum and time. Once per second, the time variable is updated to reflect the current time, and that value is used to render a digital clock in the top-right corner.

Here's the issue: whenever either of these state variables change, the component re-renders, and we re-run all of these expensive computations. And because time changes once per second, it means we're constantly re-generating that list of primes, even when the user's selected number hasn't changed!

In JavaScript, we only have one main thread, and we're keeping it super busy by running this code over and over, every single second. It means that the application might feel sluggish as the user tries to do other things, especially on lower-end devices.

But what if we could “skip” these calculations? If we already have the list of primes for a given number, why not re-use that value instead of calculating it from scratch every time?

This is precisely what useMemo allows us to do. Here's what it looks like:

const allPrimes = React.useMemo(() => {
  const result = [];

  for (let counter = 2; counter < selectedNum; counter++) {
    if (isPrime(counter)) {
      result.push(counter);
    }
  }

  return result;
}, [selectedNum]);

useMemo takes two arguments:

A chunk of work to be performed, wrapped up in a callback function
A list of dependencies

During mount, when this component is rendered for the very first time, React will invoke this function to run all of this logic, calculating all of the primes. Whatever we return from this function is assigned to the allPrimes variable.

For every subsequent render, however, React has a choice to make. Should it:

Invoke the function again, to re-calculate the value, or
Re-use the data it already has, from the last time it did this work.

To answer this question, React looks at the supplied list of dependencies. Have any of them changed since the previous render? If so, React will rerun the supplied function, to calculate a new value. Otherwise, it'll skip all that work and reuse the previously-calculated value.

useMemo is essentially like a lil’ cache, and the dependencies are the cache invalidation strategy.

In this case, we're essentially saying “recalculate the list of primes only when selectedNum changes”. When the component re-renders for other reasons (eg. the time state variable changing), useMemo ignores the function and passes along the cached value.

Similarities to other stuff
(info)

You may have noticed: the structure for useMemo is quite a lot like the structure for useEffect! They both take a callback function and a dependency array.

The main difference is that useMemo is used to calculate a value during render. Effects, meanwhile, invoke the callback function after the render, to synchronize React state with some sort of external system.

You might also have noticed: the useMemo hook has a similar name to the React.memo helper we saw in the previous lesson.

This is no coincidence! In fact, they both do similar things:

React.memo memoizes the result of rendering a component, only re-running when the props change.
React.useMemo memoizes the result of a computation, only re-running when the dependencies change.

We'll talk more about how they interact later in this lesson.

Here's the live version of our solution, implementing the useMemo hook:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
use-time.js
Result
Console
Refresh results pane
Use case 2: Preserved references

So we've seen how useMemo can help improve performance by caching expensive calculations. This is one of the ways that this hook can be used, but it's not the only way! Let's talk about the other use case.

In the example below, I've created a Boxes component. It displays a set of colorful boxes, to be used for some sort of decorative purpose.

I also have a bit of unrelated state, the user's name.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Boxes.js
Result
Console
Refresh results pane

Our Boxes component has been made pure by React.memo(). This means that it should only re-render whenever its props change.

And yet, whenever the user changes their name, PureBoxes re-renders as well!

Here's a graph showing this dynamic. Try typing in the text input, and notice how both components re-render:

App

name:

Boxes

Props: { boxes }

Pure Component

What the heck?! Why isn't our React.memo() force field protecting us here??

The PureBoxes component only has 1 prop, boxes, and it appears as though we're giving it the exact same data on every render. It's always the same thing: a red box, a wide purple box, a yellow box. We do have a boxWidth state variable that affects the boxes array, but we aren't changing it!

Here's the problem: every time React re-renders, we're producing a brand new array. They're equivalent in terms of value, but not in terms of reference.

I think it'll be helpful if we forget about React for a second, and talk about plain old JavaScript. Let's look at a similar situation:

function getNumbers() {
  return [1, 2, 3];
}

const firstResult = getNumbers();
const secondResult = getNumbers();

console.log(firstResult === secondResult);

What do you think? Is firstResult equal to secondResult?

In a sense, they are. Both variables hold an identical structure, [1, 2, 3]. But that's not what the === operator is actually checking.

Instead, === is checking whether two expressions are the same thing.

This is something we talked about in the “Immutability Revisited” lesson. When it comes to objects and arrays, it's not enough for them to look the same. They have to be the same. Both variables need to point to the same entity held in the computer's memory.

Every time we invoke the getNumbers function, we create a brand-new array, a distinct thing held in the computer's memory. If we invoke it multiple times, we'll store multiple copies of this array in-memory.

Note that simple data types — things like strings, numbers, and boolean values — can be compared by value. But when it comes to arrays and objects, they're only compared by reference. For more information on this distinction, check out this wonderful blog post by Dave Ceddia: A Visual Guide to References in JavaScript
.

Taking this back to React: Our PureBoxes React component is also a JavaScript function. When we render it, we invoke that function:

// Every time we render this component, we call this function...
function App() {
  // ...and wind up creating a brand new array...
  const boxes = [
    { flex: boxWidth, background: 'hsl(345deg 100% 50%)' },
    { flex: 3, background: 'hsl(260deg 100% 40%)' },
    { flex: 1, background: 'hsl(50deg 100% 60%)' },
  ];

  // ...which is then passed as a prop to this component!
  return (
    <PureBoxes boxes={boxes} />
  );
}

When the name state changes, our App component re-renders, which re-runs all of the code. We construct a brand-new boxes array, and pass it onto our PureBoxes component.

And PureBoxes re-renders, because we gave it a brand new array!

The structure of the boxes array hasn't changed between renders, but that isn't relevant. All React knows is that the boxes prop has received a freshly-created, never-before-seen array.

To solve this problem, we can use the useMemo hook:

const boxes = React.useMemo(() => {
  return [
    { flex: boxWidth, background: 'hsl(345deg 100% 50%)' },
    { flex: 3, background: 'hsl(260deg 100% 40%)' },
    { flex: 1, background: 'hsl(50deg 100% 60%)' },
  ];
}, [boxWidth]);

Unlike the example we saw earlier, with the prime numbers, we're not worried about a computationally-expensive calculation here. Our only goal is to preserve a reference to a particular array.

We list boxWidth as a dependency, because we do want the PureBoxes component to re-render when the user tweaks the width of the red box.

I think a quick sketch will help illustrate. Before, we were creating a brand new array, as part of each snapshot:

With useMemo, however, we're re-using a previously-created boxes array:

By preserving the same reference across multiple renders, we allow pure components to function the way we want them to, ignoring renders that don't affect the UI.

Here's an updated sandbox, including the useMemo fix. Try typing in the “Name” field, and keep an eye on the console:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Boxes.js
Preview
Refresh results pane
Console
Clear Console

---

## The useCallback Hook

Source: /joy-of-react/03-hooks/08.04-use-callback

The useCallback Hook

Alright, so that just about covers useMemo… what about useCallback?

Here's the short version: It solves the same “preserved references” problem as useMemo, but for functions instead of arrays / objects.

Similar to arrays and objects, functions are compared by reference, not by value:

const functionOne = function(){ return 5; };
const functionTwo = function(){ return 5; };

console.log(functionOne === functionTwo); // false

This means that if we define a function within our components, it'll be re-generated on every single render, producing an identical-but-unique function each time.

Let's look at an example:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
MegaBoost.js
import React from 'react';

import MegaBoost from './MegaBoost';

function App() {
  const [count, setCount] = React.useState(0);

  function handleMegaBoost() {
    setCount((currentValue) => currentValue + 1234);
  }

  return (
    <>
      Count: {count}
      <button
        onClick={() => {
          setCount(count + 1)
        }}
      >
        Click me!
      </button>
      <MegaBoost handleClick={handleMegaBoost} />
    </>
  );
}

export default App;
Preview
Refresh results pane
Console
Clear Console

This sandbox depicts a typical counter application, but with a special “Mega Boost” button. This button increases the count by a large amount, in case you're in a hurry and don't want to click the standard button a bunch of times.

The MegaBoost component is a pure component, thanks to React.memo (you'll find it wrapping around the default export inside MegaBoost.js). This component doesn't receive count as a prop, but it re-renders whenever count changes!

The problem here is that we're generating a brand new function on every render. If we render 3 times, we'll create 3 separate handleMegaBoost functions, breaking through the React.memo force field.

It's the same problem we saw with the boxes array in the last lesson, but instead of a twin array being passed as a prop, we have a twin function being passed as a prop.

Using what we've learned about useMemo, we could solve the problem like this:

const handleMegaBoost = React.useMemo(() => {
  return function() {
    setCount((currentValue) => currentValue + 1234);
  }
}, []);

Instead of returning an array, we're returning a function. This function is then stored in the handleMegaBoost variable.

This works… but there's a more conventional way to do this:

const handleMegaBoost = React.useCallback(() => {
  setCount((currentValue) => currentValue + 1234);
}, []);

useCallback serves the same purpose as useMemo, but it's built specifically for functions. We hand it a function directly, and it memoizes that function, threading it between renders.

Put another way, these two expressions have the same effect:

// This:
React.useCallback(function helloWorld(){}, []);

// ...Is functionally equivalent to this:
React.useMemo(() => function helloWorld(){}, []);

Essentially, useCallback is syntactic sugar?. It exists purely to make our lives a bit nicer when trying to memoize callback functions.

State-setter callback
(info)

In this example, we're using the alternative syntax for updating a state variable. If you'd like a refresher on this syntax, check out the “State-Setter Callback” lesson.

Why are we using it here? Well, let's consider what would happen if we used the standard syntax:

const handleMegaBoost = React.useCallback(() => {
  setCount(count + 1234);

  // ⚠️ ESLint warning ⚠️
  // `count` is missing from the dependency array:
}, []);

We're trying to access count, but we haven't listed it as a dependency. Like we saw with effects, this means that count will grow stale; the count variable inside this function will always be equal to 0, no matter what happens to the real count value. This effectively breaks this button.

We can fix this by adding count to the dependency array:

const handleMegaBoost = React.useCallback(() => {
  setCount(count + 1234);
}, [count]);

This works, but it also means that handleMegaBoost will be re-generated whenever count changes. Which means our MegaBoost component will re-render whenever count is updated, which is exactly what we wanted to avoid.

The alternative syntax allows us to access the freshest value of the count state without producing a new function whenever count changes. We can have our cake and eat it too.

This stuff is hard!

When learning React, a lot of developers struggle to get comfortable with useMemo and useCallback. It's tough!

But here's the good news: you can build complex, production-ready apps without using either of these hooks!

These hooks are intended for advanced developers to optimize their applications, but React is already pretty fast out-of-the-box, and the devices that people use continue to get faster and faster.

If you've been struggling with the ideas in these “memoization” lessons, I'd encourage you to set them aside and continue on with the course. You can come back in a few months, when you're more comfortable with React.

In other words, these lessons shouldn't be "blocking". Feel free to move on for now!


---

## Exercises

Source: /joy-of-react/03-hooks/08.05-memo-exercises

Exercises
A pure grid

Below, you'll find a customizable two-dimensional grid. In the same application, we're tracking the user's mouse position, and displaying it above the grid.

Your task is to optimize the grid so that it doesn't have to re-render when the user's mouse position changes.

Acceptance Criteria:

Grid should only re-render when either numRows or numCols changes. Moving the mouse across the viewport should not re-render the Grid component.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Grid.js
utils.js
import React from 'react';

import Grid from './Grid';

function App() {
  const [
    mousePosition,
    setMousePosition,
  ] = React.useState({ x: 0, y: 0 });

  const [numRows, setNumRows] = React.useState(12);
  const [numCols, setNumCols] = React.useState(12);

  const id = React.useId();

  React.useEffect(() => {
    function handleMouseMove(event) {
      setMousePosition({
        x: event.clientX,
        y: event.clientY,
      });
    }

    window.addEventListener('mousemove', handleMouseMove);

    return () => {
      window.removeEventListener(
        'mousemove',
        handleMouseMove
      );
    };
  }, []);

  return (
    <>
      <form>
Preview
Refresh results pane
Console
Clear Console

Solution:

Solution code
(success)

 Show more
Shopping cart

Let's revisit the “Shopping Cart” exercise back from Module 1!

Update the code so that CartTable doesn't re-render unnecessarily.

Acceptance Criteria:

Editing the postal code should not trigger a re-render in the CartTable component.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
ShoppingCart.js
CartTable.js
Preview
Refresh results pane
Console
Clear Console

Solution:

Solution code
(success)

 Show more
Memoized clock toggle

In the “Custom Hooks” exercises, we created a handy-dandy useToggle hook:

function useToggle(initialValue = false) {
  if (typeof initialValue !== 'boolean') {
    console.warn('Invalid type for useToggle');
  }

  const [value, setValue] = React.useState(
    initialValue
  );

  function toggleValue() {
    setValue((currentValue) => !currentValue);
  }

  return [value, toggleValue];
}

We've updated our digital clock application to use this hook.

In the sandbox below, you'll find that everything works well... but our ClockToggle component is rendering on every state change, even ones that don't affect it.

Update the code so that ClockToggle doesn't re-render unnecessarily.

Acceptance Criteria:

The ClockToggle component should become a pure component
ClockToggle should not re-render when the time or showClock state variables change.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
use-toggle.js
ClockToggle.js
Clock.js
Preview
Refresh results pane
Console
Clear Console

Solution:

Note: I filmed this solution video before Strict Mode was built into the sandbox, and so it only shows one “ClockToggle render” log per tick instead of two. Everything else, however, should be the same regardless.

Solution code
(success)

 Show more

---

## Alternatives

Source: /joy-of-react/03-hooks/08.06-alternatives

Alternatives

Video Summary

Here's the interactive graphs from the video above:

Sibling Clock and PrimeCalculator:

App

Clock

time: 21:03:33

PrimeCalculator

selectedNum: 10

Increment

Pure PrimeCalculator with lifted time state:

App

time: 21:03:33

Clock

PrimeCalculator

selectedNum: 10

Increment

Pure Component

Even more alternatives
(info)

In his blog post “Before you memo()”
, React core team member Dan Abramov shares another approach based around restructuring the app using children, to avoid needing to do any memoization.

We'll talk about this approach later in the course, when we learn about lifting content up.


---

## React Compiler

Source: /joy-of-react/03-hooks/08.07-react-forget

React Compiler

Over the previous lessons, we’ve learned a lot about how to optimize React by skipping unnecessary work, using React.memo() to memoize entire components, and the React.useMemo()/React.useCallback() hooks to memoize calculations within components.

For many years, developers have been wondering: couldn’t this stuff be done automatically? Instead of writing these optimizations ourselves, couldn’t React analyze the code and add these optimizations for us, when they would be useful?

This is something that the React team has been working on for years. They’ve known that it’s possible in theory, but there were so many complicating factors. In March 2023, they began testing their solution in production
. Their solution is called the React Compiler.

Here’s the basic idea: the React compiler is a new process that is integrated with the bundler (eg. Webpack). As the bundler does its work, packaging all of your modules together into bundles and compiling JSX/TypeScript to plain JavaScript, the new React Compiler will also manually add React.memo(), React.useMemo(), and React.useCallback(). This effectively means that all components become pure components, and many functions will become memoized.

Current status

I remember testing it back in 2023, and I ran into a ton of problems. Every non-trivial React application becomes its own unique collection of dependencies, build tools, configurations, and workarounds. The React Compiler worked for basic “hello world” React apps, but it seemed like it would be a while until this new tool would actually work in complex real-world codebases.

Well, I gave it another shot in October 2025, and it works way better! I installed it on this course platform, and after a bit of configuration/cleanup, everything seems to work perfectly. 😄

The React team has said that they’re using the React Compiler in production extensively at Meta, and they’re confident that this tool is safe to use in production environments. So I think it’s worth trying in your own projects, to see if it works for you!

What about my existing memoizations?
(info)

The React Compiler is smart enough to spot any existing React.memo() / React.useMemo() / React.useCallback() calls, so it won’t “double-memoize” anything. This means that you shouldn’t need to make any changes to your existing code. Don’t worry about removing your manual memoization calls!

Getting started

You can learn more about the React Compiler in the React docs:

React Compiler docs

If you use Next.js, you can learn how to integrate it in the Next.js docs

Unfortunately, the bulk of this course was created before the React Compiler was a thing, and so it’s not something you’ll see in this course, going forward. That said, the React Compiler is intended to be a “set it and forget it” kind of thing; once it’s installed, you shouldn’t really need to do anything else.

Why did we spend all that time learning about memoization?!
(warning)

Given that the React Compiler is now stable, you may wonder why we spent the past few lessons learning about React.memo() and the memoization hooks.

There are a few reasons I’ve decided not to remove these lessons from the course:

Most real-world React codebases don’t use the React Compiler yet. There are plenty of legacy projects that either can’t use it because of their tech stack or don’t use it because they’re wary of adding such a complicated tool.
Memoization still comes up very frequently in technical job interviews, so you’ll be at a disadvantage if you don’t know how to set up memoization by hand.
It’s still super important to understand how all of this stuff works, since memoization is still being applied. Whether or not you add memoization explicitly or it gets added implicitly by the React compiler, it’s the same code running in-browser.

To expand on that final point: it’s a little bit like how CSS frameworks like Tailwind compile to CSS. The browser only understands raw CSS, so whether you write vanilla CSS by hand or use a super-abstracted tool like Material UI, it’s still super important to understand how CSS works; when you’re trying to debug some weird UI quirk in-browser, it doesn’t matter what tool you used to write your CSS, it only matters what the resulting CSS is. If you don’t understand the output, you’ll have a hard time fixing your problem.

Similarly, the React Compiler will add things like React.useCallback() for us, but we still need to understand how these functions work! Otherwise, we won’t understand how to debug our applications when things go awry.

If you’d like to learn more about the philosophy and rationale behind the React Compiler, you can check out this conference talk: “React without memo”
. It’s from Meta developer Xuan Huang. It’s a few years old, but it does a great job exploring the purpose of the compiler, and sharing the fundamental strategies that they’re using.

The React Compiler docs
 are also a terrific resource for learning more about it.


---

## More To Discover

Source: /joy-of-react/03-hooks/09-additional-hooks

More To Discover

Throughout this module, we've learned how to use a handful of built-in hooks, including useId, useRef, and useEffect. We've also learned how to combine these hooks to create our own abstractions with custom hooks.

When it comes to hooks, the rabbit hole goes deep. There are more official hooks for us to discover, and we'll continue to learn about them throughout this course. We'll cover useContext in Module 4, and useReducer in Module 5.

Leveraging the ecosystem

When the React team released hooks, they unlocked a new abstraction — custom hooks — that could be used to bundle up and reuse a chunk of React logic. In the years since, the community has built a ton of amazing libraries and resources that leverage custom hooks.

We've already seen one example, in the “Fetching on Mount” lesson. We saw how the SWR library exposes a custom hook, useSWR, that abstracts away all of the surprisingly-tricky challenges when it comes to data-fetching in a React application.

There are also third-party collections of “utility hooks”. For example, react-hookz
 is an NPM package that includes a few dozen hooks:

Some of these hooks will look familiar; their useIntersectionObserver hook
, for example, is quite a bit like the useIsOnscreen hook we built earlier in this module.

Why did we build our own IntersectionObserver hook, when libraries like this exist?? There is tremendous value in building and maintaining our own custom hooks. Every application is unique, and no matter how expansive a library is, there will always be situations where we have to build something from scratch.

For example, I built a custom hook called useBoop
, which allows me to trigger a very specific kind of animation on an element. You won't find this hook in any utility libraries!

But what if we need a generic utility, something like useWindowSize
? Should we build it from scratch, or use the library?

Here's my suggestion: you should build it yourself if you think you'd learn something from the process. That's a solid investment of your time and energy.

As you get more experience, you may find yourself creating the same utilities over and over again, across different projects. In this situation, you won't learn much by doing it again, and so a library is a nifty time-saver.

If you try to build it yourself, you might discover that certain hooks are beyond your reach. This rabbit hole goes deep, and some hooks require expert-level skills to create. In these cases, it can also make sense to use a library. Though I'd suggest giving it a solid attempt first! You might surprise yourself with how much you can do.

I do think there's a danger in becoming too dependent on these libraries. If you automatically reach for a library whenever you encounter a new problem, your skills will atrophy. Sooner or later, you'll run into a problem that can't be solved with a library, and you won't have the skills to be able to solve it yourself!

As we go through this course, we'll use a combination approach, building our own custom hooks most of the time, and using libraries in special cases.


