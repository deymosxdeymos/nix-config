# Joy of React - Module 5: Happy Practices

---

## Introduction • Josh W Comeau's Course Platform

Source: /joy-of-react/05-happy-practices/00-introduction

Happy Practices

As developers, we tend to seek out the “Best Practices”, the established patterns and conventions that will make our code good and professional.

Best practices don't really exist, though. 😅

The real world is messy and full of nuance. The exact same code snippet might be a good idea in one situation, and a bad idea in another. “Best Practices” makes it sound like there's some sort of pinnacle, something that is the absolute right approach in all circumstances. And that's just not true.

In this module, I'm going to share my favourite “Happy Practices”, the design patterns and good habits I've built throughout years and years of React experience. I'll show you how to apply them to familiar situations, and discuss the trade-offs.

We'll also dig deeper into how React works, building a clearer mental model for things like keys and refs.

And we'll also explore more of the React API, things like the useReducer hook, portals, and error boundaries.

I'm really friggin’ excited about this module: we'll cover a ton of really valuable stuff!


---

## Leveraging Keys

Source: /joy-of-react/05-happy-practices/01-leveraging-keys

Leveraging Keys

Video Summary

Here's the playground from the video. Spend up to 15 minutes seeing if you can re-trigger the CSS keyframe animation whenever the price prop changes:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
PlanSelection.js
PriceDisplay.js
PriceDisplay.module.css
import React from 'react';

import PriceDisplay from './PriceDisplay';
import styles from './PlanSelection.module.css';

function PlanSelection({ plans }) {
  const id = React.useId();

  const [selectedPlan, setSelectedPlan] = React.useState(plans[0]);

  return (
    <>
      <PriceDisplay price={selectedPlan.price} />

      <fieldset className={styles.fieldset}>
        <legend>Select plan:</legend>
        <div className={styles.optionGroup}>
          {plans.map((plan) => {
            const uniquePlanId = `${id}-${plan.id}`;

            return (
              <div className={styles.option} key={plan.id}>
                <input
                  type="radio"
                  name={id}
                  id={uniquePlanId}
                  checked={plan === selectedPlan}
                  onChange={() => setSelectedPlan(plan)}
                />
                <label htmlFor={uniquePlanId}>
                  {plan.label}
                </label>
              </div>
            );
          })}
        </div>
Result
Console
Refresh results pane

Alright, let's talk about how I'd solve this problem today:

Video Summary

As discussed in the video above, here's the full solution:

// PriceDisplay.js
function PriceDisplay({ price }) {
  const formattedPrice = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  }).format(price);

  return (
    <div className={styles.wrapper}>
      <div key={price} className={styles.animated}>
        {formattedPrice}
      </div>
    </div>
  );
}
Alternative approaches

We've seen how the key attribute can help us solve this problem, but how else might we approach this sort of problem?

Let's discuss.

Video Summary

You Might Not Need An Effect
(info)

The new React docs has a must-read page called “You Might Not Need An Effect”
. It covers the same key approach we learned about in this lesson, under “Resetting all state when a prop changes”
, along with lots of other important stuff.

It's a dense article, with tons of examples. I recommend spending an hour or so going through it in depth.


---

## Exercises

Source: /joy-of-react/05-happy-practices/01.01-key-exercises

Exercises
Pricing Woes

The solution we came up with in the previous lesson has one potential issue: if multiple plans share the same price, the price won't animate:

Update the sandbox below so that the price animates when the user changes plans, even if those plans have the same price.

Acceptance Criteria:

The displayed price should animate whenever the user changes the plan, even if the price doesn't change.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
PlanSelection.js
PriceDisplay.js
PriceDisplay.module.css
import React from 'react';

import PriceDisplay from './PriceDisplay';
import styles from './PlanSelection.module.css';

function PlanSelection({ plans }) {
  const id = React.useId();

  const [plan, setPlan] = React.useState(plans[0]);

  return (
    <>
      <PriceDisplay price={plan.price} />

      <fieldset className={styles.fieldset}>
        <legend>Select plan:</legend>
        <div className={styles.optionGroup}>
          {plans.map((plan) => {
            const uniquePlanId = `${id}-${plan.id}`;

            return (
              <div className={styles.option} key={plan.id}>
                <input
                  type="radio"
                  name={id}
                  id={uniquePlanId}
                  value={plan.value}
                  onChange={() => setPlan(plan)}
                />
                <label htmlFor={uniquePlanId}>
                  {plan.label}
                </label>
              </div>
            );
          })}
        </div>
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Passing the entire “plan”?
(info)

Our PriceDisplay component is using 2 of the 3 properties on the plan object (both id and price). You might be wondering, might it be a bit simpler to pass the entire plan through?

// Instead of this…
<PriceDisplay id={plan.id} price={plan.price} />

// …why not do this?
<PriceDisplay plan={plan} />

In the last module, we learned about the “Spectrum of Components” 👀. I shared my mental model about how each component should fit neatly on the spectrum between generic, reusable LEGO bricks and high-level business-logic template-like components.

The PriceDisplay component feels to me like a pretty low-level component; I might use it anywhere I want to display a nicely-formatted animated price.

If we pass the entire plan object in, we're saddling the PriceDisplay component. It now has to know exactly how this object is structured, that it has an id field and a price field.

I prefer to pass individual props in situations like this, to keep the low-level component disconnected from any particular higher-level use case.

Toonie Clicker, revisited

Earlier in the course, we created a “Toonie Clicker” game, as a way to learn about lifting state up.

Let's suppose we want to add a little “+2” that shows whenever the coin is clicked:

The markup you need has been provided. Your job is to retrigger the animation whenever the toonie is clicked.

Acceptance Criteria:

Clicking the toonie should show the +2 animation.
The animation should not show when the page originally loads. It should only show when the number of coins changes.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
FloatingText.js
FloatingText.module.css
BigCoin.js
style.css
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Applying the same solution to the earlier exercise?
(info)

Now that we know that we can use keys to unmount/remount components, you might be wondering: would it make sense to use the same approach on the PriceDisplay component from Exercise 1?

<PriceDisplay
  key={plan.id}
  price={plan.price}
/>

The answer is yes! We can definitely structure things this way. 😄

In terms of performance, PriceDisplay can be destroyed and recreated pretty quickly (fortunately, the Intl.NumberFormat API is pretty quick). So I'm not worried about that.

The question is: Should PriceDisplay always animate when the price changes? If so, I think it's worth embedding that behaviour within the component, and putting the key on the DOM node within. But if we want to give the consumer the power to decide whether or not to apply the animation, we can lift the key up to the <PriceDisplay> element.

We'll dig a bit more into this distinction in a couple of lessons.

Stretch goal: Only showing on increment

In the real “Cookie Clicker” game, the currency that you build can be spent on tools that improve your cookie-harvesting power. This means that the # of cookies you have goes up when clicking the cookie, but goes down when buying something.

The solution we've come up with above works because the numOfCoins variable can only ever go up by 2, but what if our balance can also decrease?

In the sandbox below, we've added the ability to buy a “piggy bank” for 9 coins. Your goal is to update it so that buying a piggy bank doesn't show the FloatingText keyframe animation.

Acceptance Criteria:

Buying a piggy bank shouldn't re-trigger the “+2” animation.
Piggy banks cost 9 coins, so to test this, you need to click the toonie 5 times, and then click "Buy Piggy Bank"
Clicking the toonie should still show the “+2” animation
The “+2” animation should still not be shown when the page first loads.
Hint

You don't need a useEffect to solve this problem, but you might need a new state variable!

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
FloatingText.js
FloatingText.module.css
BigCoin.js
Result
Console
Refresh results pane

Solution:

Two notes about this:

In the solution video, piggy banks cost 10 coins, rather than 9. I decreased the cost after filming this video, to highlight the issue we're trying to fix. The "+2" animation is already hidden when the user has 0 coins.
Discord user AbiTyasTunggal came up with a solution that doesn't require a new state variable! I think I prefer it to my solution. I'll share it in the solution block below.

Solution code
(success)

 Show more

---

## Elements Revisited

Source: /joy-of-react/05-happy-practices/02-elements

Elements Revisited

Video Summary

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.js
App.js
import React from 'react';

function App() {
  const counterElem = <Counter />;

  return (
    <div>
      {counterElem}
      {counterElem}
    </div>
  );
}

function Counter() {
  const [count, setCount] = React.useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      {count}
    </button>
  );
}

export default App;
Result
Console
Refresh results pane

Let's discuss.

Video Summary

This idea is covered in even more depth in the official React documentation:

Preserving and Resetting State

Here's the second sandbox from the video, the one with a color control:

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

---

## Deriving State

Source: /joy-of-react/05-happy-practices/03-deriving-state

Deriving State

So, one of the established “Best Practices” with React is to always store the minimum amount of data in state. If something can be derived from state, it should be.

But what does that actually mean? How does it work in practice?

Let's walk through an example, from the Wordle project we saw earlier.

Video Summary

Small correction
(info)

In the video above, I say that the checkGuess function completes in 0.5 nanoseconds. I've since learned that a nanosecond is a billionth of a second. I should have said microsecond (millionth of a second).

You can check out the alternative approach, without deriving state, on Github
. But please keep in mind, I don't recommend this approach.

More info:

How to benchmark code and test our intuition on performance
Memoization in React

---

## Exercises

Source: /joy-of-react/05-happy-practices/03.01-deriving-exercises

Exercises
Compose Tweet

In older versions of Twitter, a number showed you how many characters you had left to use in your message:

In the playground below, we've recreated this UI, but our implementation isn't as nice as it could be. Your job is to refactor this code, to improve it.

Acceptance Criteria:

The number of characters remaining should be derived from the message state, not stored in a state variable.
No effects should be used.
Bonus question: Can you think of any reasons why an effect is not the right tool for this problem?

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
ComposeTweet.js
ComposeTweet.module.css
import React from 'react';

import VisuallyHidden from './VisuallyHidden';
import styles from './ComposeTweet.module.css';

function ComposeTweet({ maxChars, handleSubmit }) {
  const [message, setMessage] = React.useState('');
  const [charsRemaining, setCharsRemaining] =
    React.useState(maxChars);

  const id = React.useId();

  React.useEffect(() => {
    setCharsRemaining(maxChars - message.length);
  }, [maxChars, message]);

  return (
    <form
      className={styles.wrapper}
      onSubmit={(event) => {
        event.preventDefault();
        handleSubmit(message);
        setMessage('');
      }}
    >
      <div className={styles.header}>
        <label htmlFor={id}>Compose Tweet:</label>
        <span
          className={styles.count}
          style={{
            color: getCharacterColor(
              charsRemaining
            ),
          }}
        >
          <VisuallyHidden>
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
Checkout flow

In this exercise, we're working with a checkout flow. The “shopping cart” we saw back in Module 1 now includes some info underneath about the price.

Unfortunately, this code has a pretty big bug: removing an item from the cart doesn't update the subtotal/tax/total values!

Your mission is to fix this bug.

Acceptance Criteria:

The numbers at the bottom of the page (Subtotal / Taxes / Total) should recalculate when removing an item from the cart.
You should remove any state variables that aren't necessary. Derive state whenever possible.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
CheckoutFlow.js
CartTable.js
utils.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
Thermostat

Below, you'll find a thermostat that lets us set the temperature. We can also switch between Celsius and Fahrenheit modes for displaying the current temperature.

With the current code, we're storing two state variables, one for the celsius value, and one for the fahrenheit value.

Your task is to simplify this code by having a single state variable that holds information about the temperature (as well as a 2nd state variable for the displayed format).

This is a surprisingly tricky challenge. I thought this would be pretty straightforward, and I struggled to come up with a solution I was 100% happy with. Please don't be discouraged if you can't solve this one!

Acceptance Criteria:

A single state variable should be used to keep track of the thermostat's current temperature.
The
 and
 buttons should increase/decrease the current temperature by 1 degree.
Note: It doesn't matter what the current mode is. Whether we're in “celsius” mode or “fahrenheit” mode, these buttons should increase/decrease the displayed temperature by 1 (eg. from 77°F to 78°F, or from 25°C to 26°C).
You can use the helper functions convertToCelsius and convertToFahrenheit to convert between units.

Annoying gotcha
(warning)

Both “celsius” and “fahrenheit” are difficult words to spell. If you run into X is not defined errors, check that you're spelling these variables correctly!

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Thermostat.js
ToggleButton.js
utils.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Moving by half-degrees in Celsius
(info)

As we've learned, changing the Celsius temperature by 1 degree is equivalent to changing the Fahrenheit temperature by 1.8 degrees.

This means that for folks who use Celsius, they effectively have less control over the temperature. Each press of the button changes the temperature by almost 2 degrees Fahrenheit!

I live in Canada, and most of our thermostats are in celsius. They generally let us go up/down in 0.5° increments:

I didn't want to go too far down this rabbit hole, but if you want even more of a challenge, you can update the solution to allow the temperature to be adjusted by 0.5 degrees while in Celsius.

There's a roundToNearest method in utils that can help, by letting you round a value to the nearest 0.5:

roundToNearest(12.34, 0.5); // 12.5
roundToNearest(10.9, 0.5); // 11

Here's what my updated solution looks like:

 Show more

---

## Breaking the Rules

Source: /joy-of-react/05-happy-practices/03.02-breaking-the-rules

Breaking the Rules

In the “Wordle” clone project, we have a gameStatus state variable:

function Game() {
  // running | won | lost
  const [gameStatus, setGameStatus] = React.useState('running');
  const [guesses, setGuesses] = React.useState([]);
}

A couple of students have realized that this variable can be derived! We can calculate it exclusively using the guesses, using logic like this:

let gameStatus;

// Have they correctly guessed the answer?
const hasCorrectGuess = guesses.some(guess => (
  guess === answer
));

if (hasCorrectGuess) {
  // If so, it means they've won!
  gameStatus = 'won';
} else if (guesses.length === 6) {
  // If they have submitted 6 guesses, and none
  // of them are correct, it means they've lost
  gameStatus = 'lost';
} else {
  // With no right answer and at least 1
  // guess remaining, the game continues!
  gameStatus = 'running';
}

The golden rule we've been following is that if something can be derived from state, it should be derived from state. And as it turns out, we can derive the game's status from the guesses state variable!

But hmm… I'm not sure I prefer this approach. 😅

The status of the game seems like its own “thing”, semantically. It feels coincidental that it can be derived from the guesses array, that it just so happens to work based on the current game functionality.

I can imagine lots of ways the game could evolve which would make it impossible to derive the status:

We might want to have an intro/welcome screen. The initial status would be something like initial, and it would flip to running when they click a start button.
In the real Wordle game, input is disabled for a second or two after submitting a guess, so that an animation can run. This could be implemented as a separate status (revealing-guess).
If we add a timer to the game, and wanted to integrate the ability to "pause" things. We'd need a new status, paused.

Granted, none of those issues exist today, and I don't generally advocate for “pre-emptive” problem-solving! We can always refactor things if/when the game evolves in one of these ways.

But even if we say that the game is 100% complete, that we'll never add any of these features… I'd still choose to keep gameStatus as a state variable, rather than deriving it from guesses.

In my mental model, gameStatus is a separate concern. I don't think of it merely as a consequence of the user's guesses! By deriving gameStatus from guesses, it's like I'm tying the two things together when they should be independent. I want my code to reflect my mental model.

Ultimately, you might disagree, and that's totally valid. When it comes to our mental model, there is no right/wrong answer. I’m not really trying to convince you that gameStatus should be its own state variable.

The more-important takeaway is that it's OK to break the rules sometimes.

As I mentioned in the intro, there are no “best practices”. Deriving state is a good idea 95% of the time, but there are always going to be exceptions! That's why it's important to know why these patterns exist, rather than memorizing rules that you don’t really understand and following them unquestioningly.

Granted, it takes a while to develop a deep intuition about these things. When I taught at a bootcamp, I'd tell students to follow the recommended practices 100% of the time. As you become more experienced, however, you'll start to run into situations where the “best practices” feel like a bit of an awkward fit to you. In cases like this, you should absolutely do what feels right!

Hm, maybe one tweak…
(info)

Thinking about this more, I think the best approach would be something like this:

// running | over
const [gameStatus, setGameStatus] = React.useState('running');
const [guesses, setGuesses] = React.useState([]);

const isVictorious =
  gameStatus === 'over' && guesses.some((guess) => guess === answer);

In this version, the gameStatus state variable isn't concerned with whether the user won or lost. It only tracks whether the game is running or not. Once the game has ended, we derive whether they've won or lost from the guesses array; if it includes the correct answer, they've won!

This feels right to me: we're storing the minimum amount of stuff in state while still staying true to the mental model. But really, I think any of the approaches discussed in this lesson are fine.


---

## Lifting Content Up

Source: /joy-of-react/05-happy-practices/04-lifting-content-up

Lifting Content Up

Video Summary

Spend a few minutes and see if you can refactor this code. As I said in the video, I don't expect you to be able to solve this! The value here is in spending a few minutes thinking about it, poking and prodding at the problem.

Acceptance Criteria:

Refactor the code so that Article receives the articleSlug prop directly: without using context, and without funnelling the prop through an intermediary component.
The DOM structure shouldn't change at all.
We can't remove a component altogether. For example, you're not allowed to “merge” ArticlePage and MainContent into a single component.
It isn't some fancy trick with custom hooks, you won't have to touch useArticle at all, or use any other custom hook.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
ArticlePage.js
use-article.js
Result
Console
Refresh results pane

Alright, let's break this down.

Video Summary

Solution code
(success)

 Show more

Restructuring for the win!
(info)

In this lesson, we've been trying to solve a specific problem, in terms of passing the articleSlug value to the Article component.

Our solution was to refactor the MainContent component:

function MainContent({ children }) {
  return (
    <main>
      <aside>
        <SocialSharingWidget />
      </aside>
      {children}
    </main>
  );
}

Let's forget about the problem at hand, and consider this refactor on its own merits. What do you think of it?

Personally, I think this is an improvement! If we think about it in terms of the Spectrum of Components 👀, we've slid this component towards the generic/reusable side, and it feels like a better fit!

Suppose our news website also had a “classifieds” section. We could reuse this same component, to wrap it up in the same semantic structure + include the social sharing widget!

<MainContent>
  <Classifieds />
</MainContent>

Do all elements have an owner?
(info)

In the video above, I mentioned that most React elements have an owner. You might be wondering: in which circumstances do React elements not have an owner?

I can only really think of one common example: the element we pass to root.render:

// index.js
import React from 'react';
import { createRoot } from 'react-dom/client';

const container = document.querySelector('#root');
const root = createRoot(container);

root.render(
  <div>Hello World!</div>
);

In this example, that <div> doesn't have an owner, because it isn't being rendered within a component.

But yeah, in practice, virtually all of the JSX we write will be owned by some component.


---

## Exercises

Source: /joy-of-react/05-happy-practices/04.01-lifting-content-up-exercises

Exercises
Art Store

In the sandbox below, we're building an e-commerce store for an artist.

The header has a cute shopping cart button, and the button has a badge that increments as the user starts adding items to their cart:

The components are structured in the following hierarchy:

App
Header
CartButton

Using what we learned in the previous lesson, restructure things so that App owns the CartButton component, without changing the DOM structure at all.

Acceptance Criteria:

The <CartButton> element should be owned by the App component, rather than <Header>.
The DOM structure should not be affected (the cart button should still be a child of the <header> DOM node).
Bonus: Using what we learned in the “Leveraging Keys” lesson, update the code so that the “fade” animation retriggers whenever the number changes:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
Header.js
Shop.js
CartButton.js
import React from 'react';

import Shop from './Shop';
import Header from './Header';

function App() {
  const [cartItems, setCartItems] = React.useState([]);

  function addToCart(item) {
    setCartItems([...cartItems, item]);
  }

  return (
    <>
      <Header numOfItemsInCart={cartItems.length} />
      <Shop paintings={DATA} addToCart={addToCart} />
    </>
  );
}

const DATA = [
  {
    id: 'summer-jubilee',
    title: 'Summer Jubilee',
    caption: 'Oil on canvas, 80" × 64"',
    src: '/img/painting-01.jpg',
    price: 12000,
  },
  {
    id: 'spectacular-end',
    title: 'A Spectacular End',
    caption: 'Oil on canvas, 40" × 32"',
    src: '/img/painting-02.jpg',
    price: 4000,
  },
  {
Result
Console
Refresh results pane

Solution:

Note: In this video, I share my solution, but I also talk about whether this solution is actually a good idea or not. Even if you solved the exercise without issue, I'd suggest checking out the second half of this video.

Solution code
(success)

 Show more
More info

This “lifting content up” concept has been covered extensively online, largely as a way to potentially improve performance. If you'd like to go deeper, I recommend the following resources:

“Before You Context”
, from the legacy React docs
The same concept is covered in the new React docs
, but I actually think the legacy docs offer a clearer explanation.
“Before you Memo”
, by Dan Abramov
“One Simple Trick to Optimize Re-Renders”
, by Kent C. Dodds

Please consider these as optional resources, if you want to go deeper into this stuff. It's absolutely not required!


---

## Single Source of Truth

Source: /joy-of-react/05-happy-practices/05-single-source-of-truth

Single Source of Truth

Earlier in this course, when we talked about working with forms, we saw how a form input could either be controlled or uncontrolled.

A controlled input is bound to a piece of React state:

function App() {
  const [name, setName] = React.useState('');

  return (
    <>
      <label htmlFor="name-input">
        Name:
      </label>
      <input
        id="name-input"
        value={name}
        onChange={(event) => {
          setName(event);
        }}
      />
    </>
  );
}

By contrast, an uncontrolled input is free to do its own thing. We might specify an initial value, but we won't control it with React state:

function App() {
  return (
    <>
      <label htmlFor="name-input">
        Name:
      </label>
      <input
        id="name-input"
        defaultValue="Enzo Matrix"
      />
    </>
  );
}

When we think about it, what we're really doing here is setting the “source of truth” for this input:

Controlled inputs use React state as the source of truth.
Uncontrolled inputs use the internal DOM state as the source of truth.

I'm not a browser engineer, so I don't know exactly how it works, but form controls like <input> must have some sort of internal state, managed by the browser, to track what the user has typed in.

A few years ago, my mind was blown by a realization: we can apply this same controlled/uncontrolled idea to the components that we create!

Let's consider the Counter component we saw earlier:

function Counter() {
  const [count, setCount] = React.useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      {count}
    </button>
  );
}

We then render this component without any props, like this:

function App() {
  return (
    <Counter />
  );
}

From the consumer perspective, this element is totally self-contained. It has its own internal state, and I can't access it. It's like an uncontrolled input!

Now, suppose we re-write this code:

function App() {
  const [count, setCount] = React.useState(0);

  return (
    <Counter
      count={count}
      onIncrement={() => setCount(count + 1)}
    />
  );
}

function Counter({ count, onIncrement }) {
  return (
    <button onClick={onIncrement}>
      {count}
    </button>
  );
}

In this new version, Counter is controlled by the consumer. The consumer owns the state, and we're effectively data-binding this Counter element to our state variable. Like a controlled text input!

Now, it's not exactly the same, since either way, we're using a React state variable as the source of truth, not the DOM. But from the perspective of the consumer, pretending that Counter is a black box, it's remarkably similar!

Which approach is better? Well, it depends on the circumstances! If the consumer needs to access / change the state, a controlled component makes that possible. Otherwise, it's more convenient to go with uncontrolled components.

The most important thing is that there should always be a single source of truth. We get into trouble when we start treating a component as both controlled and uncontrolled.

Spend a couple minutes considering this setup. Can you make sense of what's going on here?

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Thermostat.js
Result
Console
Refresh results pane

Let's discuss:

Video Summary

Here's the final code from the video:

Solution code
(success)

 Show more

---

## Exercises

Source: /joy-of-react/05-happy-practices/05.01-sst-exercises

Exercises

These exercises are a little bit different. Instead of being given Acceptance Criteria and asked to change the code, these exercises are more like thought experiments. You'll be shown solutions from previous exercises in the course, and asked to consider whether you think they work, in terms of having a single source of truth.

You're welcome to still make changes to the code if you'd like, but the point of the exercises is to evaluate the code. Does it comply with the idea of having a single source of truth? Why or why not?

Counter 2.0 Revisited

Back in Module 2, we wired up a “Counter 2.0”, a souped-up version of a typical Counter component.

Let's look at our solution through this lens of controlled/uncontrolled components, having a single source of truth. What do you think? Does it follow the rules, or should we make some changes?

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Counter.js
import React from 'react';
import {
  ChevronUp,
  ChevronsUp,
  ChevronDown,
  ChevronsDown,
  RotateCcw,
  Hash,
} from 'react-feather';

function Counter({ initialVal = 0 }) {
  const [
    count,
    setCount,
  ] = React.useState(initialVal);

  return (
    <div className="wrapper">
      <p>
        <span>Current value:</span>
        <span className="count">
          {count}
        </span>
      </p>
      <div className="button-row">
        <button
          onClick={() =>
            setCount(count + 1)
          }
        >
          <ChevronUp />
          <span className="visually-hidden">
            Increase slightly
          </span>
        </button>
        <button
Result
Console
Refresh results pane

My explanation:

Video Summary

In React, we're 100% allowed to copy props into state as long as it's clear that we're setting the initial value, and that changes to that prop won't affect the state.

This isn't just my opinion, this is according to the React docs
.

Shopping List Revisited

In this exercise, we're taking another look at the “Shopping List” exercise from Module 2.

Once again, consider this code. Is the AddNewItemForm controlled or uncontrolled? Do we have a single source of truth for every concern? Are we synchronizing between state variables?

Essentially, is this code OK, or should we make some changes so that it conforms better with the ideas we've been discussing?

Code Playground

STRICT MODE
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

My explanation:

Video Summary


---

## Principle of Least Privilege

Source: /joy-of-react/05-happy-practices/06-principle-of-least-privilege

Principle of Least Privilege

Video Summary

Here's the original solution, with the handleAddItems handler function:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
AddNewItemForm.js
import React from 'react';

import AddNewItemForm from './AddNewItemForm';

function App() {
  const [items, setItems] = React.useState([]);

  function handleAddItem(label) {
    const newItem = {
      label,
      id: Math.random(),
    };

    const nextItems = [...items, newItem];
    setItems(nextItems);
  }

  return (
    <div className="wrapper">
      <div className="list-wrapper">
        <ol className="shopping-list">
          {items.map(({ id, label }) => (
            <li key={id}>{label}</li>
          ))}
        </ol>
      </div>
      <AddNewItemForm
        handleAddItem={handleAddItem}
      />
    </div>
  );
}

export default App;
Result
Console
Refresh results pane

And here's the not-recommended alternative, where we pass the state-setter function directly:

Code Playground

STRICT MODE
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

---

## Exercises

Source: /joy-of-react/05-happy-practices/06.01-least-privilege-exercises

Exercises
Todo List Application

Let's suppose we're building a Todo app:

This app has 3 main pieces of functionality:

Adding new todos
Marking a todo as complete/incomplete
Deleting a todo

Your mission is to refactor the code below so that none of the descendant components have more privilege than they need to accomplish these tasks.

Acceptance Criteria:

The CreateNewTodo component should only be able to modify the state in one specific way: to add a new todo to the list
The TodoList component should only be able to modify the state in two specific ways: toggling a todo between complete/incomplete, and deleting a todo.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
CreateNewTodo.js
TodoList.js
Result
Console
Refresh results pane

Solution:

In this video, I share my solution, but also a pretty important takeaway near the end. There's another benefit to structuring things this way.

Before, our business logic was sprinkled throughout the application, mixed in with the JSX at the extremities of our application, within CreateNewTodo and TodoList.

Now, though, we've centralized this logic in three handy functions, grouped together:

function App() {
  const [todos, setTodos] = React.useState([]);

  function handleCreateTodo(value) {
    ...
  }

  function handleToggleTodo(id) {
    ...
  }

  function handleDeleteTodo(id) {
    ...
  }

  return (
    <div className="wrapper">
      ...
    </div>
  );
}

Imagine you're brand-new to this codebase. Which version do you think is easier for you to make sense of?

Solution code
(success)

 Show more

---

## useReducer

Source: /joy-of-react/05-happy-practices/07-use-reducer

useReducer

Way back in Module 2, I shared my thoughts on global state management tools like Redux. One of the things I said is that React has “absorbed” some of the best parts of Redux.

In this lesson, we're going to talk about reducers, a feature plucked straight out of Redux, and implemented in React with the useReducer hook.

Now, Redux is known for having a pretty steep learning curve; there are a bunch of abstract concepts and vernacular that we need to become familiarized with. Unfortunately, the useReducer hook has imported all of that complexity as well. We're going to cover a lot of new ideas in this lesson!

A room full of confused faces
(info)

I'm not sure how common this is around the world, but in North America, Computer Science programs at universities often have a “co-op” component, where students spend a few months doing an internship at a real-world company or organization. At Khan Academy, we hired about a dozen interns every summer.

To help them get started, we'd run training sessions during their first week on every major part of our stack. One developer would do one on Python, another on Google App Engine, etc.

My first year at Khan Academy, I volunteered to do the Redux training, and it was an unmitigated disaster 😅. It turns out, it's super hard to explain how Redux works! Pretty much from the beginning, those poor students were very, very confused.

The following year, I got another chance, and I totally changed how I covered it. Fortunately, it went a bit more smoothly that time. But it really made me appreciate how tricky Redux can be!

Intro to useReducer

Video Summary

A relatively niche hook
(info)

The useReducer hook, in my experience, isn't used super widely. In the codebase for this course platform, for example, I use the useReducer hook exactly 3 times. To put that in perspective, I use the useState hook >300 times.

I even debated not covering it in this course, since I don't want to waste your time with something you won't use every day. But I decided to include it for 2 reasons:

This module is called “happy practices”, and few things make me as happy as a well-structured reducer. It can be a fantastic tool for organizing components with complex state requirements. I don't use it often, but I find it really great when I do use it.
It's a core part of the React library, and you will stumble upon it every now and then. Some developers really enjoy useReducer and use it as their primary tool for state management. And so, to prevent any confusion when you encounter these resources, it's worth understanding it at a high level.

All of that said, it is 100% possible to build a production-ready app that never uses useReducer. If you're having trouble making sense of it, please don't stress about it. You can definitely skip this part of the course if you'd prefer. 😄

Here's the original playground, without useReducer:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
CreateNewTodo.js
TodoList.js
Result
Console
Refresh results pane

And here's the final code from the video above, with useReducer:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
CreateNewTodo.js
TodoList.js
Result
Console
Refresh results pane

Note: I made one small tweak to this code from the video. Before, the ID was generated inside the reducer, using crypto.randomUUID(). In this updated playground, we create that ID in the handleCreateTodo function, passing it in with the action. This was done to keep the reducer pure; more on this below.

Why is it called a “reducer”?
(info)

The name “reducer” comes from the JavaScript array method, reduce. It allows us to combine an array of items into a single final value.

We don't cover the reduce array method in this course because I don't recommend using reduce. It used to be one of my favourite methods, until I realized that it was making my code unnecessarily difficult to understand. I have yet to find any situation in which reduce improves code readability, compared to a similar approach that uses something like forEach.

For example: the most common use case for reduce is to add up an array of numbers. Most tutorials use this example to introduce the reduce method, because it shows how useful it can be:

function sumNumbers(list) {
  return list.reduce((acc, item) => {
    return acc + item;
  }, 0);
}

That's pretty slick, but we can solve the same problem using a more-widely-understood .forEach loop:

function sumNumbers(list) {
  let sum = 0;
  list.forEach(item => {
    sum += item;
  });

  return sum;
}

But yeah, if you'd like to learn more about the reduce method, or understand where the name “reducer” came from, I recommend checking out this blog post from Dave Ceddia:

What is a Redux Reducer?
Reducers should be pure functions

One gotcha with reducers is that they must be pure functions.

A pure function is a function that always returns the same output given the same inputs. For example, this is a pure function:

function addNums(a, b) {
  return a + b;
}

When I run the code addNums(1, 1), it will return 2 every single time.

By contrast, here's an impure function:

function getRandomNumber() {
  return Math.random();
}

Every time I run the code getRandomNumber(), I get a different result, since it generates a random value every single time:

getRandomNumber(); // 0.0564345954320411
getRandomNumber(); // 0.8482841158362815

When it comes to the useReducer hook, our reducer functions must be pure. They must always return the same output, given the same input.

It's startlingly easy to make this mistake. In fact, I made this mistake myself, while filming the video for this lesson. 😅

In the video above, I wind up with a reducer that looks like this:

function reducer(todos, action) {
  if (action.type === 'create-todo') {
    return [
      ...todos,
      {
        value: action.value,
        id: crypto.randomUUID(),
      },
    ];
  }
  // ✂️ Other actions omitted for brevity
}

That crypto.randomUUID() expression produces a different value every time. As a result, we get a different output when calling the function with the same input:

reducer([], { type: 'create-todo', value: 'buy groceries' });
// -> [{ value: 'buy-groceries', id: 'c455ebae-db9f-42f7-8ec5-c3a0e169938c' }]

reducer([], { type: 'create-todo', value: 'buy groceries' });
// -> [{ value: 'buy-groceries', id: '5f3c38bb-1b32-430e-8282-d489b546ac1b' }]

Here's the solution: We can pass these impure values into the reducer, through the action.

For example:

function reducer(todos, action) {
  if (action.type === 'create-todo') {
    return [
      ...todos,
      {
        value: action.value,
        id: action.id,
      },
    ];
  }
  // ✂️ Other actions omitted for brevity
}

// We would then use it like this:
const action = {
  type: 'create-todo',
  value: 'buy groceries',
  id: crypto.randomUUID(),
};

reducer([], action);

As I mentioned, it's an easy mistake to make, but fortunately, the solution tends to be pretty straightforward, most of the time.

You can learn more about the useReducer hook in the official documentation
.

Do reducers actually need to be pure?
(warning)

So, you might have noticed: despite the fact that I was breaking the rules in the above video, everything still seemed to work! It didn't seem to matter that my reducer was impure.

In practice, impure reducers actually do work in most situations, but there are some rare edge cases where strange things can happen if our reducers are impure.

What are those rare edge-cases? One example has to do with Suspense, which we'll discuss in the next module. In certain situations, React will re-run the reducer, with the original state + action. When that happens, our todo will be recreated with a different ID.

Now, suppose we were persisting the todo in a database, using the ID as its identifier. It could cause some weird bugs if React decides to randomly change the ID later on!

Honestly, things will probably be fine if your reducers aren't 100% pure, but here's the thing: the React team expects us to write pure reducers. They make a big deal
 about this in the official docs.

Just because an impure reducer works properly today doesn't mean it'll work properly with future versions of React. Personally, I don't want a ticking time bomb in my codebase!


---

## Switch / Case

Source: /joy-of-react/05-happy-practices/07.01-switch-case

Switch / Case

In the last example, our reducer was comprised of a bunch of if/else statements:

function reducer(todos, action) {
  if (action.type === 'create-todo') {
    return /* ✂️ */;
  } else if (action.type === 'toggle-todo') {
    return /* ✂️ */;
  } else if (action.type === 'delete-todo') {
    return /* ✂️ */;
  }
}

This works perfectly well, but there's a more common convention when it comes to Redux: switch/case statements.

Here's what it looks like, if we rewrite this reducer to use a switch/case:

function reducer(todos, action) {
  switch (action.type) {
    case 'create-todo': {
      return /* ✂️ */;
    }
    case 'toggle-todo': {
      return /* ✂️ */;
    }
    case 'delete-todo': {
      return /* ✂️ */;
    }
  }
}

Inside the switch() parens, we place some sort of JS expression that can have multiple acceptable values. In this case, we want to switch between different branches of logic depending on the value of action.type.

Each case is given a matching value. And so, if action.type is equal to "delete-todo", it skips over the first 2 case statements, and the third one is executed.

Functionally, it's the exact same thing as our if/else combo above. It's a different syntactical option for the same result.

But, it happens to be an incredibly common convention. Pretty much every reducer I've seen in the wild has a switch/case in it, checking the value of action.type.

There are a couple of gotchas to be aware of with switch/case.

Added brackets

Strictly speaking, the example I showed above has some unnecessary grammar: we don't need brackets around each case:

switch (status) {
  case 'loading': // <-- No "{"!
    const showSpinner = !action.invisible;

    return {
      loading: true,
      showSpinner,
    };

  case 'ready':
    return {
      loading: false,
      data: action.data,
    }
}

By adding the squiggly brackets, we create a scope for each case. That means that any variables created within the case will be scoped to that particular case.

Without the squigglies, we can run into issues like this:

switch (status) {
  case 'loading':
    const showSpinner = !action.invisible;

    return {
      loading: true,
      showSpinner,
    };

  case 'ready':
    // 🚫 Uncaught SyntaxError:
    // Identifier 'showSpinner' has already been declared
    const showSpinner = false;

    return {
      loading: false,
      showSpinner,
      data: action.data,
    }
}

We declare a showSpinner variable in the first case, but because the entire switch is one big scope, we get an error when we try and create a variable with the same name in another case.

When we add the squiggly brackets, this problem is solved:

switch (status) {
  case 'loading': {
    const showSpinner = !action.invisible;

    return {
      loading: true,
      showSpinner,
    };
  }

  case 'ready': {
    // ✅ No problem!
    const showSpinner = false;

    return {
      loading: false,
      showSpinner,
      data: action.data,
    }
  }
}

In my mental model, each case is its own branch, its own mini environment. By adding squiggly brackets, we align reality to this mental model. Any variables created with let or const will be scoped to its branch.

Fall-through

So there's one totally bewildering thing about switch/case.

Take a look at the following snippet. What do you expect to be logged to the console?

const n = 2;

switch (n) {
  case 1: {
    console.log(1);
  }
  case 2: {
    console.log(2);
  }
  case 3: {
    console.log(3);
  }
  case 4: {
    console.log(4);
  }
}

Well, n is equal to 2, and so I'd expect the number 2 to be logged, right?

Here's what actually gets logged:

2
3
4

By default, once we've found a matching case, the code within that case will be run… along with every subsequent case!

In order to avoid this behaviour, we need to end each case with the special keyword break:

switch (n) {
  case 1: {
    console.log(1);
    break;
  }
  case 2: {
    console.log(2);
    break;
  }
  case 3: {
    console.log(3);
    break;
  }
  case 4: {
    console.log(4);
    break;
  }
}

When the switch/case is within a function, like it is with useReducer, we have another option: we can bail out of the entire function, using the return keyword:

function reducer(todos, action) {
  switch (action.type) {
    case 'create-todo': {
      return /* ✂️ */;
    }

    case 'toggle-todo': {
      return /* ✂️ */;
    }

    case 'delete-todo': {
      return /* ✂️ */;
    }
  }
}

We aren't using break here, but it's fine, since we abort the entire reducer() function call. Instead of halting execution of the switch/case, we halt execution of the entire function!

I wanted to bring this up for two reasons:

Sometimes, when I'm hacking on the business logic, I want to run the code before it's finished, to log a value and see if I'm on the right track. If I haven't yet added the return statement to my work-in-progress reducer, I might see some very peculiar behaviour!
In a couple of lessons, we'll talk about Immer. When working with Immer, the break keyword is more common.
Default cases

With switch statements, it's possible to add a default case:

switch (fruit) {
  case 'apple': {
    console.log('Keep the doctor away');
    break;
  }
  case 'banana': {
    console.log("You're the top banana!");
    break;
  }
  default: {
    console.log('Unrecognized fruit');
  }
}

If none of the cases match, the code inside the default block will run.

In Redux, default cases are necessary, due to a quirk of how state gets initialized. With useReducer, however, we don't typically need a default case.

Frustratingly, certain ESLint 👀 configurations will throw a warning if the switch statement doesn't have a default case. The rule in question is default-case
. I recommend disabling this rule when working with useReducer.


---

## Exercises

Source: /joy-of-react/05-happy-practices/07.02-use-reducer-exercises

Exercises
Art Store, Revisited

Let's get some practice! We'll update the “art store” example we saw earlier in this module to use useReducer.

Acceptance Criteria:

The cartItems state should use the useReducer hook.
You should use the conventional switch/case structure discussed in the previous lesson within your reducer.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Header.js
Shop.js
CartButton.js
import React from 'react';

import Shop from './Shop';
import Header from './Header';
import CartButton from './CartButton';

function App() {
  const [cartItems, setCartItems] = React.useState(
    []
  );

  function addToCart(item) {
    setCartItems([...cartItems, item]);
  }

  return (
    <>
      <Header
        actions={
          <CartButton
            numOfItems={cartItems.length}
          />
        }
      />

      <Shop
        paintings={DATA}
        addToCart={addToCart}
      />
    </>
  );
}

const DATA = [
  {
    id: 'summer-jubilee',
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
Counter 2.0, One Last Time

I promise, this is the last time we'll hack on this counter example in this course!

Update the code below so that it uses the useReducer hook for the count state.

Acceptance Criteria:

The count state should use the useReducer hook.
You should use the conventional switch/case structure discussed in the previous lesson within your reducer.
Each button should get its own action type.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Counter.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

A simpler approach?
(warning)

You might be wondering: wouldn't it be simpler to have a single action, something like updateCount?

function reducer(count, action) {
  switch (action.type) {
    case 'update-count': {
      return action.value;
    }
  }
}

// And then, in our JSX, we could do things like:
<button
  onClick={() => {
    dispatch({
      type: 'update-count',
      value: count + 1,
    })
  }}
>
  Increase slightly
</button>
<button
  onClick={() => {
    dispatch({
      type: 'update-count',
      value: count + 10,
    })
  }}
>
  Increase a lot
</button>

This approach sorta misses the point of useReducer. The beautiful thing about reducers is that it splits out the state-updating logic from the actions:

Actions describe what's happening, like a story being told about what the user is doing.
Reducers control how those actions affect the state.

There are a few benefits to structuring it this way:

All of the state-updating logic is grouped together, inside the reducer, instead of being sprinkled around the application.
Debugging becomes way easier (we can throw a console.log in the reducer and get a literal log of all the actions the user is performing!).

Now, in certain cases, we do need to do some pre-calculation in the action, to keep the reducer pure, like with our “Randomize” button. That's fine.

The thing you want to watch out for is having lots of action types that start with “update” or “set”. Remember, your actions should describe the events that are taking place in your application. It's the reducer's job to figure out how to respond to those actions!

It can take a while for the reducer philosophy to really click, but hopefully this is starting to make a bit more sense. Feel free to ask in Discord if you're not following!

Gradient Generator, Revisited

Let's tackle one more example: the “Gradient Generator” tool from Module 2.

This one is a bit trickier, because there are two state variables. Your goal is to merge them into a single reducer.

Acceptance Criteria:

All state should be managed with the useReducer hook.
In order for this to work, the state will need to be stored as an object that contains both the colors array and the numOfVisibleColors number.

This is a difficult challenge — I haven't yet shown you exactly how to solve these sorts of problems. Unless you have previous experience with Redux, you might not be able to solve it, and that's OK! The goal here is to spend 15 minutes giving it your best shot.

I'll explain everything in the solution video below. ❤️

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

Solution:

Solution code
(success)

 Show more

Is this actually better?
(info)

You might be wondering: is it actually worth migrating to useReducer in a situation like this? It might feel more complicated to you than it did before, when it was a couple of useState hooks!

This is very much a matter of taste. Some developers love useReducer and use it quite a bit. Others almost never use it. I tend not to use it much myself, but whenever I do, I find myself wishing I remembered to use it more often!

One more thing: useReducer is very often paired with a third-party tool like Immer, which makes reducers much nicer to work with. We'll learn about it next!


---

## Immer

Source: /joy-of-react/05-happy-practices/08-immer

Immer

One of the cardinal rules in React is that state is immutable. This is true whether we're talking about useState or useReducer.

The more complex our state is, the trickier it is to figure out how to make the necessary changes without mutating anything.

Let's suppose we're building a calendar app, and we have an array of events. It might look something like this:

const [events, setEvents] = React.useState([
  {
    eventId: 'coffee-with-samantha',
    date: '2023-01-01T12:30:00.000Z',
    metadata: {
      invitees: [
        {
          name: 'Samantha',
          email: 'samboombox123@aol.com',
        },
      ],
    },
  },
  {
    eventId: 'focus-time',
    date: '2023-01-01T15:00:00.000Z',
    metadata: {
      notes: 'Time for me to focus!',
    },
  },
  {
    eventId: 'team-meeting',
    date: '2023-01-02T10:00:00.000Z',
    metadata: {
      notes: 'Weekly team catch-up call!',
      invitees: [
        {
          name: 'Sadb Fabian',
          email: 'sfabian@widgetco.com',
        },
        {
          name: 'Gerarda Nicomedes',
          email: 'gnicomedes@widgetco.com',
        },
        {
          name: 'Sagit Edvaldo',
          email: 'sedvaldo@widgetco.com',
        },
        {
          name: 'Denis Seppo',
          email: 'dseppo@widgetco.com',
        },
      ],
    },
  },
]);

Now, let's suppose we want to remove Gerarda Nicomedes from the team meeting. How do we do that without mutating any of the arrays or objects held in React state?

I've set up a little playground for you to try and solve this. If you'd like, you can spend a few minutes trying to solve this problem.

The playground is like a mini test framework. It'll show you the expected result alongside the actual value you return. When you've successfully completed the problem, a "✅" will appear in the top right corner.

Frozen objects and arrays
(info)

To make sure you aren't mutating anything, I've locked all objects/arrays with Object.freeze
. If your changes don't seem to be having any effect, or if you're getting weird error messages, it could be because you're trying to mutate a frozen object/array.

Hint

You may wish to review the “Filter” JavaScript Primer lesson 👀, as well as the “Spread Syntax” JavaScript Primer lesson 👀.

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

Solution code
(success)

 Show more

If you're curious about how this playground actually works, in terms of the validation, you can open it in CodeSandbox to view all files. Click the
 icon in the top-right corner of the playground.

Phew!

So, I have a lot of experience doing this sort of thing; in the early days of Redux, a lot of our state looked like this! And even with that experience, I still found this to be a pretty thorny problem.

The fact that we're not allowed to mutate anything makes this problem much harder than it should be. If only we could mutate the state, we could solve this problem in 1 line of code:

function updateState(currentState) {
  currentState[2].metadata.invitees.splice(1, 1);

  return currentState;
}

(Admittedly, the splice method
 isn't exactly user-friendly either. But overall, this solution requires much less head-scratching!)

What if there was a way to solve things this way without actually mutating the underlying data?

That's where Immer comes in. 😄


---

## Immer 101

Source: /joy-of-react/05-happy-practices/08.01-immer-intro

Immer 101

Immer is an NPM package
 built by Michel Weststrate (creator of MobX). Michel was frustrated by how tricky immutable updates could be, and so he created a tool to make it more manageable.

It's pretty incredible. I can't even imagine working on a complex project without it. It's become absolutely indispensable for me.

Here's what Immer does in a nutshell: it allows us to write code that looks like it mutates the data. Using some modern JS trickery, however, the data is never actually mutated.

For example, here's how we'd solve the calendar problem using Immer:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
updateState.js
import { produce } from 'immer';

function updateState(currentState) {
  return produce(currentState, (draftState) => {
    draftState[2].metadata.invitees.splice(1, 1);
  });
}

export default updateState;
Result
Console
Refresh results pane

Let's dig into how it works.

A working draft

The produce function we get from Immer takes two arguments:

The state we'd like to edit (currentState)
A callback function ((draftState) => {})

draftState is a special “wrapped” version of currentState. I like to think of it as a shielded version: Immer is its guardian, and will make sure that the original object is never mutated, no matter what we try to do to this wrapped version.

After running the code in our callback function, produce will resolve to a brand-new object, with all of the modifications applied.

Here's a more-complete example, using the useState hook:

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

This sorta feels like cheating, but critically, we're not actually mutating the numbers array held in React state. No arrays were mutated in the making of this app.

Performance

When I first learned about Immer, I assumed it was making a deep copy of the original state variable. A deep copy is where we clone all of the objects/arrays that are nested within our main state variable.
*

This would be very effective: by copying everything we guarantee that it's impossible to mutate the original!

But it would also be very slow, and require a lot of memory. If a slice of the state wasn't modified, it shouldn't need to be cloned!

Fortunately, Immer doesn't do anything as mundane as a deep copy. It does something much more impressive. Immer uses a technique known as structural sharing, and it's made possible using Proxies
.

Most of us have never even heard of proxies, much less used them. They're a pretty obscure feature. But they allow us to do some pretty wild things.

Specifically, proxies are special object wrappers that allow us to "intercept" mutations. We wrap the React state in a Proxy, and then when we try to mutate that object, the Proxy swoops in and converts our mutation into an immutable operation.

So, suppose we have this code:

const state = {
  customer: {
    name: 'Daria Hakimi',
  },
  toppings: {
    pepperoni: true,
    anchovies: true,
    kale: true,
  },
};

const nextState = produce(state, (draftState) => {
  draftState.toppings.pepperoni = false;
});

draftState is a proxy-wrapped version of state. When we try and change the value of draftState.toppings.pepperoni, the Proxy jumps in the path of the bullet, deflecting it, and replacing it with an immutable operation, something like:

const newState = {
  ...state,
  toppings: {
    ...state.toppings,
    pepperoni: false,
  },
};

Notice that the customer object is reused! It gets spread into the newState object. If Immer was doing a typical “deep copy” operation, everything would be reconstructed from scratch. But thanks to this “structural sharing” magic with Proxies, we only reconstruct the parts of the state that change.

And so, the performance. There is a cost to using Immer, since this proxying business isn't free. But it's nowhere near as expensive as a true deep copy would be. I've used Immer quite a bit, and I've never had any performance issues with it.

There is some benchmarking
 you can check out. It also includes some tips you can follow to improve performance. But honestly, I've never found it necessary to do these sorts of optimizations. As we've spoken about before, we typically don't work with hundreds of thousands of items on the front-end, and so the data shouldn't be large enough for these sorts of things to matter.

Browser support
(warning)

Immer is supported out-of-the-box across all modern browsers: Edge 12+, Firefox 18+, Chrome 49+, Safari 10+.

And, if you're willing to use a plugin, Immer can even be made to work in Internet Explorer, giving it the same browser support as React itself. Check out the installation instructions
 for more information on enabling IE support.

Bundle size
(info)

The immer package is about 5kb gzip
, though that includes all of the plugins (for example, the polyfills necessary for Internet Explorer). If you're not worried about IE support, the bundle size drops to about 3kb gzip.

For context, React + React DOM combined are about 45kb. Immer is a very tiny library!

Drawbacks

No tool is perfect, and every NPM package will have some trade-offs.

The biggest issue is that proxies can't easily be logged. Trying to console.log produces some pretty inscrutable results:

import { produce } from 'immer';

const arr = [1, 2, 3];

produce(arr, (draftArr) => {
  draftArr.push(4);

  console.log(draftArr);
  // Proxy {
  //   [[Handler]]: null
  //   [[Target]]: null
  //   [[isRevoked]]: true
  // }
});

Here's the good news: Immer ships with a tool, current, which can help "unpack" a proxy, for debugging purposes:

import { produce, current } from 'immer';

const arr = [1, 2, 3];
produce(arr, (draftArr) => {
  draftArr.push(4);

  console.log(current(draftArr));
  // [1, 2, 3, 4]
});

To be clear, you shouldn't ever need to use current in your final production code. It's a tool that exists purely to help you debug, while you're solving the problem at hand.

It can be a bit annoying to need to import and apply a function just to see what the current value is, but in my opinion, it's a small price to pay.


---

## Exercises

Source: /joy-of-react/05-happy-practices/08.02-immer-exercises

Exercises

Alright, let's get some practice with Immer!

Gradient Generator

Below, you'll find our previous solution for the Gradient Generator, using useReducer. Your job is to update it to use Immer.

Acceptance Criteria:

You should use the produce function from Immer to produce the new state, within the reducer function
Tweak the state-updating logic to edit the draft state using mutation, instead of returning a new state object.
The import has already been provided for you, just under the React import.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import React from 'react';
import { produce } from 'immer';

const INITIAL_STATE = {
  colors: [
    '#FFD500',
    '#FF0040',
    '#FF0040',
    '#FF0040',
    '#FF0040',
  ],
  numOfVisibleColors: 2,
};

function reducer(state, action) {
  switch (action.type) {
    case 'add-color': {
      return {
        ...state,
        numOfVisibleColors:
          state.numOfVisibleColors + 1,
      };
    }

    case 'remove-color': {
      return {
        ...state,
        numOfVisibleColors:
          state.numOfVisibleColors - 1,
      };
    }

    case 'change-color': {
      const nextColors = [...state.colors];
      nextColors[action.index] = action.value;

Result
Console
Refresh results pane

Solution:

Named vs. default export
(warning)

In this video, I'm importing the produce function as if it was a default export:

import produce from 'immer';

In the previous lesson, however, we import a named export:

import { produce } from 'immer';

In a recent version of Immer (v 10.0), the produce function was switched from the default export to a named export. I've updated all of the lessons / playgrounds, but the solution videos still show the old import style.

Fortunately, this is the only substantial difference; the produce function itself works the same way (with some edge-case exceptions, you can check out the release notes
 if you're curious).

Sorry for any confusion!

Solution code
(success)

 Show more
Todo List

Let's update our “Todo List” application to use Immer.

Acceptance Criteria:

The reducer should be updated so that Immer is used to update the state
Go through each action, and see if we can simplify the state-updating logic using mutation. It's up to you to decide what will work best in each situation!
Feel free to edit things beyond the reducer, eg. to change which data gets passed through in the action.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
CreateNewTodo.js
TodoList.js
Result
Console
Refresh results pane

Solution:

Correction: As I mentioned in the “useReducer” lesson, reducers should be pure functions. As a result, we shouldn't be generating the unique ID within the reducer. The solution below has been updated, so that the ID is passed in through the action:

Solution code
(success)

 Show more
Pizza Toppings

Below, you'll find a pizza ordering form. All of the UI is done, but there isn't any state management yet. Your mission is to manage the state using useReducer and Immer.

Acceptance Criteria:

When the user submits the form, a window.alert should show us what size and toppings they've selected.
The radio buttons and checkboxes should be controlled by the reducer's state.
The “Select All” button should add all of the toppings.
If all of the toppings are selected, however, the button label should flip to "Remove All", and it should toggle all of the toppings off.

This is a challenging exercise. You'll need to figure out how to bind the values of checkboxes/radio buttons to reducer state, which is not something we've explicitly covered! The “Input Cheatsheet” should get you 75% of the way there, but you'll need to do some experimenting to figure it out.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
styles.css
OrderPizza.js
Result
Console
Refresh results pane

Solution:

Correction: There is a more semantic way to prevent the “Select All” button from submitting the form: we can add type="button". That way, we don't need the event.preventDefault(). This improvement has been added to the solution code:

Solution code
(success)

 Show more

---

## The “useImmer” Hook

Source: /joy-of-react/05-happy-practices/08.03-use-immer

The “useImmer” Hook

So, hopefully you agree that Immer is pretty darn cool. Especially when working with complex / deeply-nested data, it's often so much simpler to use mutation. Immer gives us the best of both worlds.

But it does come at a price. Reducers are already quite boilerplate-heavy, and Immer adds even more:

function reducer(state, action) {
  return produce(state, (draftState) => {
    switch (action.type) {
      ...
    }
  });
}

That's a lot of stuff to type out whenever we need a reducer!

Now, personally, I don't mind this. As I mentioned recently, I find it helps build momentum, to get the ball rolling. But a lot of developers find it irksome, to have to write this chunk of scaffolding every time they need a reducer.

The Immer team has released an official NPM package called use-immer
. It includes a custom hook called useImmerReducer which automatically applies the produce function.

It looks like this:

import React from 'react';
import { useImmerReducer } from 'use-immer';

const initialState = { count: 0 };

function reducer(draftState, action) {
  switch (action.type) {
    case 'increment': {
      draftState.count++;
      return;
    }

    case 'decrement': {
      draftState.count--;
      return;
    }

    case 'reset': {
      return initialState;
    }
  }
}

function Counter() {
  const [state, dispatch] = useImmerReducer(reducer, initialState);

  return (
    <>
      Count: {state.count}
      <button onClick={() => dispatch({ type: 'increment' })}>
        Increment
      </button>
      <button onClick={() => dispatch({ type: 'decrement' })}>
        Decrement
      </button>
      <button onClick={() => dispatch({ type: 'reset' })}>
        Reset
      </button>
    </>
  );
}

Within this reducer function, we're never given the original state, only the draftState created by the produce function.

Essentially, it allows us to turn this:

function reducer(state, action) {
  return produce(state, (draftState) => {
    switch (action.type) {
      ...
    }
  });
}

…into this:

function reducer(draftState, action) {
  switch (action.type) {
    ...
  }
}

The same package also includes a useImmer hook, which is essentially an immer-wrapped useState alternative:

import React from 'react';
import { useImmer } from 'use-immer';

function App() {
  const [person, updatePerson] = useImmer({
    name: 'Michel',
    age: 33
  });

  function becomeOlder() {
    updatePerson((draft) => {
      draft.age++;
    });
  }

  return (
    <div className="App">
      <h1>
        Hello {person.name} ({person.age})
      </h1>

      <button onClick={becomeOlder}>Older</button>
    </div>
  );
}

Now, I don't personally use this package. Immer's boilerplate doesn't bug me, and it worries me a little that this package makes Immer so implicit. You can't tell from looking at the reducer function whether we're allowed to mutate the state or not (aside from the fact that we've named the parameter draftState). I want to be super, super explicit when it comes to using Immer, because I don't want newer developers to be confused about when they are/aren't allowed to mutate things.

That said, I suspect I'm in the minority. A lot of developers really benefit from this package. So I wanted to share it with you, in case you found it useful!

You can learn more about this package over on Github
. Thanks to Discord user Nachos for reminding me that this package exists!

Getting some practice?
(info)

So, I don't have any new exercises, but I've made sure to include the use-immer dependency in all of the sandboxes in the previous set of exercises.

You can update your solutions to use this package, if you'd like the opportunity to practice using this hook!

You'll want to start by replacing the import:

// Remove this:
import { produce } from 'immer';

// ...and replace with this:
import { useImmerReducer } from 'use-immer';

---

## Portals

Source: /joy-of-react/05-happy-practices/09-portals

Portals

Video Summary

Normally, React elements are turned into DOM nodes in a symmetrical fashion, but as we saw in the video above, portals allow us to "teleport" the output DOM nodes to a target container.

Here's the syntax, for easy reference:

import { createPortal } from 'react-dom';

function Modal({ children }) {
  return createPortal(
    // The React elements to render:
    <div className="modal">
      {children}
    </div>,
    // The target DOM container to hold the output:
    document.querySelector('#modal-root')
  );
}

You'll also need to edit the HTML file to create that target container:

<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
  </head>
  <body>
    <div id="root"></div>
    <div id="modal-root"></div>
  </body>
</html>

Here's the final sandbox from the video:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
index.html
Header.js
Header.module.css
LoginForm.js
Modal.js
LoginForm.module.css
Modal.module.css
Result
Console
Refresh results pane

document.querySelector??
(info)

In the video above, I use document.querySelector to select the #modal-root DOM node. Isn't this a bad practice in React?

The thing that makes it a bit different in this case is that we're selecting a DOM node that exists outside of React. The <div id="modal-root"> was not created by React, and so we can't do the typical thing of capturing it with a ref.

That said, there is a way for us to solve this problem without using document.querySelector. There's an exercise coming up on this very topic!

Peeking under the hood

You might be wondering: what does this createPortal function actually do? And why am I returning it?

I was curious as well, and so I decided to log it out:

import React from 'react';
import { createPortal } from 'react-dom';

function Modal({ title, handleDismiss, children }) {
  const portal = createPortal(
    <FocusLock returnFocus={true}>
      {/* All the same stuff inside */}
    </FocusLock>,
    document.querySelector('#modal-root')
  );

  console.log(portal);

  return portal;
}

As a result, I see an object that looks like this:

{
  "$$typeof": Symbol(react.portal),
  "children": {
    "$$typeof": Symbol(react.element),
    "type": {…},
    "key": null,
    "ref": null,
    "props": {…},
  },
  "containerInfo": div#modal-root,
  "key": null,
}

In this course, we've been talking about how React elements are descriptions of part of the UI. The JSX we write gets compiled into React.createElement calls, and these calls create descriptive objects (the “Virtual DOM”).

It turns out, createPortal is very similar! It creates a description of a portal we want React to create.

This portal object “wraps around” the elements; the children property contains all of the React elements that we want to teleport. And the containerInfo property holds a reference to the DOM node that will host them.

In other words, the createPortal function doesn't directly do any of this work. It creates a description that React uses in the render process, to let the renderer know that this slice of the app needs to be injected into a different container.


---

## Exercise

Source: /joy-of-react/05-happy-practices/09.01-portals-exercises

Exercise
ToastShelf portal

In the 2nd project, we built a generic Toast component from scratch:

In addition to the Toast component, we also created a ToastShelf component, which was responsible for rendering a list of toasts in the bottom-right corner of the page.

Let's use a portal to ensure that the ToastShelf component always renders without issue!

Acceptance Criteria:

The ToastShelf component should use the createPortal function from React DOM to render its contents (the <ol>) in a different root node.
You'll need to add this new root to the index.html file.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
index.html
ToastShelf.js
import React from 'react';

import { ToastContext } from '../ToastProvider';
import Toast from '../Toast';
import styles from './ToastShelf.module.css';

function ToastShelf() {
  const { toasts } = React.useContext(ToastContext);

  return (
    <ol
      className={styles.wrapper}
      role="region"
      aria-live="assertive"
      aria-label="Notification"
    >
      {toasts.map((toast) => (
        <li key={toast.id} className={styles.toastWrapper}>
          <Toast id={toast.id} variant={toast.variant}>
            {toast.message}
          </Toast>
        </li>
      ))}
    </ol>
  );
}

export default ToastShelf;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
A Portal Component

Alright, let's do something fun and/or challenging: let's create a reusable Portal component!

This time, instead of editing the HTML to include a <div id="toast-root">, our Portal component will create this node dynamically. When the component mounts, it should create a brand-new DOM node, and use it as the portal's root node.

This is a challenging problem, and I don't expect you to be able to solve it. This is one of those things where we can learn a heck of a lot by fiddling and experimenting with different ideas. Give it a shot, and then watch the solution video for a breakdown.

Acceptance Criteria:

The Portal component should use the createPortal function from React DOM to render its children in a portal.
When the component is unmounted, it should clean up after itself; any dynamically-created nodes should be destroyed.
You'll know it's working when the inner box is teleported outside its parent:
Hint

Creating a DOM node is definitely a side-effect, and so we should do this work inside a useEffect hook.

Because effects run after the render, it means we won't have a DOM node for that first render. That's alright! We'll need to re-render once the container node exists.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Portal.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Using document.body as the target container
(info)

Discord user ancepsinfans discovered that the following approach seems to work:

function Portal({ children }) {
  return createPortal(children, document.body);
}

Instead of creating and destroying a container node, why not use document.body as the target?

I'll be honest, I really didn't expect this to work. When it comes to rendering our main application, it's a well-known bad practice to render directly into document.body:

import { createRoot } from 'react-dom/client';

// 🛑 Don't do this:
const root = createRoot(document.body);
root.render(<App />);

Why is this a bad practice? Because React expects to be the only thing managing the content of the root node. Lots of third-party scripts and browser extensions will create and inject DOM nodes into the <body>, and this can lead to all sorts of problems. React doesn't like to “share” its DOM container with anyone else.

Apparently, though, this same rule doesn't apply to portals; the official docs
 show examples using document.body as the target container. Popular component library MaterialUI has been doing this for years
, without issue.

So, it seems as though my solution might be a bit over-engineered. At least we got some good practice with useEffect? 😅

Here's a revised solution, using the same data-attribute for easy debugging:

function Portal({ children }) {
  return createPortal(
    <div data-react-portal-host>
      {children}
    </div>,
    document.body
  );
}

---

## Refs Revisited

Source: /joy-of-react/05-happy-practices/10-refs-revisited

Refs Revisited

Earlier in this course, we built a custom useIsOnscreen hook.

There's something peculiar about it, though. When we really think about it, it's sorta surprising that it works at all!

Let's dig a bit deeper.

Video Summary

Here's the sandbox from the video:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
use-is-onscreen.js
import React from 'react';

import useIsOnscreen from './hooks/use-is-onscreen.js';

function App() {
  const elementRef = React.useRef();

  const isOnscreen = useIsOnscreen(elementRef);

  return (
    <>
      <header>
        Red box visible: {isOnscreen ? 'YES' : 'NO'}
      </header>
      <div className="wrapper">
        <div ref={elementRef} className="red box" />
      </div>
    </>
  );
}

export default App;
Result
Console
Refresh results pane

And here's the memory visualization:

Modify elementRef ref
Toggle fullscreen

Computer Memory

REFS
elementRef: {
  current: undefined
}
Snapshot #1

---

## Error Boundaries

Source: /joy-of-react/05-happy-practices/11-error-boundaries

Error Boundaries

Video Summary

Here's the sandbox from the video:

Error boundaries in development
(warning)

Since filming the video above, React's development “error overlay” has been updated, so that it still shows the standard error screen, even when an Error Boundary has successfully caught an error. You can read more about this change on Github
, if you're curious.

Frustratingly, this means that we can't tell whether the error boundary is working in development (at least, not when using the particular build tool used by my code playground).

The good news is that things still work correctly in production. Nothing has changed from the user's perspective. So we should still use Error Boundaries in our applications. It's just not possible to test them on this course platform.

Sorry for the confusion!

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Ticker.js
ErrorBoundary.js
Result
Console
Refresh results pane
Error tracking

Error boundaries allow us to soften the blow of an unexpected code failure, but what if we wanted to be notified about them, so that we can fix the problem altogether for future users?

Error trackers like Sentry
 and LogRocket
 can help us catalog these unexpected issues. They'll let us see how often the issues are occurring, and provide a bunch of metadata to help us understand and fix the problem.

The Sentry SDK even has an ErrorBoundary component
. It's quite a bit like the one we saw in this lesson, but it also collects data about the failure for us.

Error tracking is beyond the scope of this course, but feel free to dig into this if you're interested in this topic!

Drawing logical boundaries

One of the cool things about error boundaries is that they wrap around the entire slice of the React tree. They'll catch errors that are thrown in children, grandchildren, great-grandchildren… All the way down.

For example, suppose that we refactor our news-reader app, and now there are several components involved in showing the real-time market prices:

function App() {
  return (
    <>
      <Header />

      <ErrorBoundary>
        <RealTimeInfo />
      </ErrorBoundary>

      <Stories />
    </>
  );
}

function RealTimeInfo() {
  return (
    <Ticker />
  );
}

function Ticker() {
  const { data, isLoading } = useSWR(ENDPOINT, fetcher);

  return data.map(item => (
    <Price key={item.id} item={item} />
  ));
}

function Price({ item }) {
  // ✂️ Display the item info
}

RealTimeInfo is the component being rendered within the <ErrorBoundary>, but the boundary also wraps around Ticker and Price. If an error is thrown in any of these components, it'll be caught by the error boundary.

If we draw out our React tree, the boundary wraps around this entire slice of the app:

I like to think about it like a force-field that protects the rest of the app from any explosions that happen inside this slice of the tree. 💥

We're even allowed to nest error boundaries. When an error is thrown, it bubbles up through the tree until it hits the nearest boundary:

Suppose an error is thrown inside <Comment />. It bubbles up to the nearest error boundary, which wraps around <Discussion />. We'll render some sort of fallback UI in lieu of the comment section, but the article itself will still be accessible.

This is a good example of how we can use error boundaries strategically. Our goal is to minimize the damage when things go wrong.

Brandon Dail has a wonderful blog post: “Fault Tolerance”
. This blog post digs deep into this exact question, looking at where to apply error boundaries in several real-world scenarios. I highly recommend checking it out, right now.

To provide a real-world example of my own, here are some of ways I use error boundaries in this course platform:

Each playground is wrapped in an error boundary, so that explosions in one playground don't break the entire lesson.
The “Create Note” drawer is wrapped in an error boundary, in case there's some unexpected issue with the notes feature.
Some lessons have multiple "pages". Each page is wrapped in an error boundary, so that a broken lesson segment won't torch the entire lesson.

For more information on error boundaries, check out the official docs
.

