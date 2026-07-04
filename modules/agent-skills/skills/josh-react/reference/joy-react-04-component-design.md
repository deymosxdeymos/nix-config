# Joy of React - Module 4: Component Design

---

## Introduction • Josh W Comeau's Course Platform

Source: /joy-of-react/04-component-design/00-introduction

Component API Design

One of the most common questions I've gotten goes like this:

How do I create React applications that scale?

Working in an application with hundreds of React components is a very different ballgame than working in a Todo app with 6 components. In order to keep things maintainable, we need different mental models, different tools, different techniques.

That's what this module is all about.

We're going to learn about lots of individual techniques that I've used in my work to keep complexity manageable as applications grow larger and larger.

We're also going to gain new mental models, ways of thinking that will help us make architectural decisions in our applications.

I'm super excited about this module. Let's get started!

Producers and consumers

Video Summary

---

## The Spectrum of Components

Source: /joy-of-react/04-component-design/01-spectrum-of-components

The Spectrum of Components

So, here's an implementation of a <Banner /> component, meant to show the user a message:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Banner.js
Banner.module.css
import React from 'react';

import styles from './Banner.module.css';

function Banner({ type, user, children }) {
  const backgroundColor = type === 'success'
    ? 'var(--color-success)'
    : 'var(--color-error)';

  // Only logged in, verified users are
  // allowed to see the banner
  if (
    !user ||
    user.registrationStatus === 'unverified'
  ) {
    return null;
  }

  return (
    <div
      className={styles.banner}
      style={{ backgroundColor }}
    >
      {children}
    </div>
  );
}

export default Banner;
Result
Console
Refresh results pane

Take a few moments to consider this component, and how it's structured. What do you think about it?

Let's discuss.

Video Summary

Small correction
(info)

In the video above, I discuss a hypothetical BlackFridaySaleBanner. This hypothetical component took type and children as props.

Thinking about it more, though, this component probably wouldn't need these props, since a Black Friday sale banner should always have the same type, and probably the same content.

Here's the final code from the video:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Banner.js
Banner.module.css
Result
Console
Refresh results pane

Atomic Design
(info)

Several students have asked how this concept compares to Atomic Design
.

If you’re not familiar, the core idea with Atomic Design is that our UI is broken into 5 levels:

(Image courtesy of Brad Frost, from the Atomic Design homepage
.)

Conceptually, it's quite similar; “atoms” are the super-reusable primitives like <Button> or <Slider>. Atoms are combined into molecules, which are a bit less reusable (eg. maybe a <Modal> which uses a <Button> internally). On the other end, “pages” are the sum collection of everything rendered for a given route.

The main difference: my “Spectrum of Components” idea doesn't have discrete groups. It's a fluid spectrum.

The problem with the real world is that it’s messy. In simple cases, it's easy to categorize them: <Button> is an atom, <CheckoutPage> is a page. But in practice, things are a lot more ambiguous. Two different developers might look at the same component and disagree about how it should be categorized.

The reason I prefer a fluid spectrum is that there aren’t rigid categories that we need to fit our components within, and so there's less opportunities for debate about which side of the line a component falls on. It's a bit more forgiving, while still giving us a helpful mental model we can use to see if our components are well-structured.

This becomes especially relevant when it comes to file/directory structure. I prefer to keep all of my components in a flat components directory. With Atomic Design, some teams try to organize their components by type (/components/atoms, /components/molecules, etc). This, in my opinion, is a bad idea; it means that developers will burn calories and waste time trying to figure out which box each component fits into. Counter-intuitively, this can make components harder to find, since different developers on the same team have their own ideas about where each component belongs.

But yeah, that’s just my experience! Your mileage may vary.

Additional resources
(success)

A few years ago, Facebook developer Cheng Lou gave a talk at React Europe, “On the Spectrum of Abstraction”
. It's a difficult talk to understand; Cheng has a computer science background, and it shows. I had to watch it several times to really get a handle on what he's saying. But it's a mindblowing talk, full of really interesting insights.

---

## Exercises

Source: /joy-of-react/04-component-design/01.01-spectrum-exercises

Exercises
Product Details page

Let's suppose we're building an e-commerce site. We received a mockup, and we implemented it as one big component.

In terms of our spectrum of abstraction, we've created a very high-level component, but there are two lower-level components hiding within, begging to be extracted into their own components.

Your mission is to identify a spectrum-related problem, and to extract at least 1 lower-level component.

Acceptance Criteria:

Extract at least 1 lower-level, potentially-reusable component
The extracted component(s) can be defined inside /ProductDetails.js, below the main component.
If you're not sure where to start / which components should be extracted, I provide my suggestions below the sandbox:

Back to CSS classes?
(warning)

In the exercise below, we're using standard CSS classes rather than CSS modules. This is done for two reasons:

To make it a bit quicker/easier to refactor the components, without having to touch the styles / move them between modules
The sandbox software I use, Sandpack
, doesn't make it possible for users to create their own files, and so you wouldn't be able to create new CSS modules for newly-extracted components

In a real-world context, I absolutely recommend using a tool like CSS Modules or styled-components. But, in this course, we'll occasionally use “plain” CSS when I want us to focus on React logic stuff without tripping over CSS abstractions.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
ProductDetails.js
VisuallyHidden.js
utils.js
import React from 'react';
import { Star } from 'react-feather';

import { range } from './utils';
import VisuallyHidden from './VisuallyHidden';

function ProductDetails({ product }) {
  const [
    selectedPhotoIndex,
    setSelectedPhotoIndex,
  ] = React.useState(0);

  return (
    <article className="product-details">
      <div className="photos-wrapper">
        <div>
          <img
            className="primary-photo"
            alt=""
            src={product.photos[selectedPhotoIndex]}
          />
          <div className="buttons">
            {product.photos.map((photoSrc, index) => {
              const isSelected = selectedPhotoIndex === index;

              return (
                <button
                  key={index}
                  className="thumbnail-button"
                  onClick={() => setSelectedPhotoIndex(index)}
                >
                  <VisuallyHidden>
                    Toggle image #{index + 1}
                  </VisuallyHidden>
                  <img alt="" src={photoSrc} />
                  <span
Result
Console
Refresh results pane

Suggestions
(info)

Not sure which components to extract? Here are some suggestions:

 Show more

Solution:

Solution code
(success)

 Show more
Extracting a Card component

In the sandbox below, we have two separate components that each implement a similar "card" design. Let's extract it into its own Card component!

Acceptance Criteria:

Two files, Card.js and Card.module.css, have been created for you. Your mission is to populate them with the component + styles.
You should then use this component within UserProfileCard and ProductInfoCard.
Note that the two cards have slightly different styles: they have a different box-shadow value. Each card should be able to specify the elevation level for the shadow, to be applied dynamically inside Card.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
Card.js
Card.module.css
UserProfileCard.js
UserProfileCard.module.css
ProductInfoCard.js
ProductInfoCard.module.css
Result
Console
Refresh results pane

Solution:

In this video, I use the “property value shorthand” when applying the boxShadow style. For more information, check out the “Property Value Shorthand” lesson 👀 in the JavaScript Primer.

Solution code
(success)

 Show more

What's the deal with CSS variables?
(info)

The example above uses CSS variables to share box-shadow values across the app.

It's a bit beyond the scope of this course, but I love CSS variables, especially when working with React.

If you're curious, I wrote a blog post all about this: CSS Variables for React Developers
.


---

## Component Libraries

Source: /joy-of-react/04-component-design/02-component-libraries

Component Libraries

A component library is a collection of low-level generic components, the LEGO bricks that every application needs. Things like buttons, date pickers, and auto-completes.

When most developers talk about component libraries, they generally mean third-party component libraries. The most popular third-party component library is Material UI
.

Honestly, I don't recommend using these sorts of tools in most cases. They can be useful in a few limited use cases (eg. prototyping, building internal tools), but I personally don't believe they're well-suited to production applications.

Why not? I wrote a blog post answering this question. If you'd like to see my unabridged thoughts about this topic, I recommend giving it a read!

You Don't Need A UI Framework

Here's the most critical point: very few tech companies actually rely on these tools. If your goal is to get a job as a React developer, you'll need to know how to build applications without relying on these tools.

I've worked at 6 tech companies, and 0 of them have used tools like Material UI.
*
 Typically, we built our own first-party component libraries. At DigitalOcean, we built Walrus
. At Khan Academy, we built Wonder Blocks
.

Design systems

To understand why very few product-focused companies use third-party component libraries, we need to talk about design systems.

A design system is what gives a brand its unique identity. It's a collection of rules that govern how a product looks, feels, and behaves. It includes tokens for colors and typography styles, as well as in-depth designs for specific UI elements.

Design systems are built by designers using design software, like Figma or Sketch. They provide these documents to us, the developer, to implement components based on their designs.

In terms of an analogy, the design system is like a recipe book. The component library is the set of prepared ingredients required — the chopped tomatoes, the puréed carrots. And then the web application is the finished meal.

Here's the problem: third-party component libraries have their own design system baked in.

Material UI, for example, uses Google's “Material Design” system. It's a very specific aesthetic, used by official Google applications across web and Android.

Now, third-party component libraries do allow us to customize/tweak the styles, but it would be incredibly difficult and annoying to try and swap out an entire design system this way. I've spoken to several developers who have tried to do this, and all have regretted it.

Here's the bottom line: very few tech companies rely on “pre-styled” component libraries like Material UI, because they want to have complete control over the branding / aesthetic. And so, to best prepare you for real-world work as a React developer, we won't use these tools either.

Accessibility and usability
(info)

Unfortunately, the web does not have a comprehensive “standard library”. Things like tooltips, for example, have historically been incredibly hard to implement
*
, especially when considering accessibility. If we're not careful, we'll wind up producing an application that can't be used by someone using a screen reader or a keyboard to navigate.

As we'll learn later in this module, there are specialty libraries we can use for this. Accessibility-focused libraries like Radix Primitives
 treat equity as a first-class concern, filling in the “standard library” of components without imposing a design system on us.

Application structure

When building a first-party component library like Wonder Blocks, it's common for the component library to be its own project: it has its own git repository, its own landing page, its own documentation.

This is useful when our components need to be shared across multiple projects, but honestly, it adds a ton of friction.

In this course, we'll focus on the strategy I use in my actual products, like this course platform. I keep all of my components, from all over the spectrum, in a single directory.

For fun, I took a screenshot of the first few component directories from this course platform, and labeled a few of them in terms of their spot on the spectrum:

Components with a single purple asterisk, *, are the lowest-level components. It includes generic components you'd find in any component library, like Breadcrumbs, but also some of the funkier things I use in my projects, like Boop
.

Moving up the spectrum, components marked with **, are a bit higher-level, things like AccountDropdown, which renders this fella in the top-right:

Finally, I have high-level components marked with ***, things like AccountPage, which renders all of the main content on the Account page
.

It may seem a bit chaotic to have everything mixed together like this, but this is my favourite way to work. There's no false binary between "component library components" and "everything else". It's a spectrum, and every component has a spot on the spectrum. All of the components I need are right here at my fingertips, and I'm free to compose and enhance them however I wish.

One final note: Some of these directories hold multiple components. For example, AccountPage has the following files:

This allows me to keep related content together. I know that the MyAccountInfo component will never be used outside the AccountPage component, and so it doesn't make sense to clutter up my /src/components directory with it.

More information about this pattern
(info)

I go into more detail around how I structure the files and directories in my React applications. You can check it out here:

“Delightful React File/Directory Structure”

---

## Prop Delegation

Source: /joy-of-react/04-component-design/03-delegating-props

Prop Delegation

In the Banner example from the Spectrum of Components lesson, we saw how our LoggedIn banner had to “forward” some props along:

function LoggedInBanner({
  user,
  // These two props:
  type,
  children,
}) {
  if (
    !user ||
    user.registrationStatus === 'unverified'
  ) {
    return null;
  }

  // ...are forwarded along to Banner:
  return <Banner type={type}>{children}</Banner>;
}

What if this component had 10 forwarded props instead of 2? Would we have to list them all out, one by one?

Fortunately, React won't make us do that. Instead, we can take advantage of rest parameters and spread syntax 👀.

Here's what it looks like:

function LoggedInBanner({
  user,
  // Collect all unspecified props:
  ...delegated
}) {
  if (
    !user ||
    user.registrationStatus === 'unverified'
  ) {
    return null;
  }

  // And pass them onto Banner:
  return <Banner {...delegated} />
}

I've chosen the name delegated because I feel like it's semantically appropriate, but we can name this variable whatever we want. Some folks prefer rest:

function LoggedInBanner({
  user,
  ...rest
}) {
  if (
    !user ||
    user.registrationStatus === 'unverified'
  ) {
    return null;
  }

  return <Banner {...rest} />
}

For consistency, I'll use delegated throughout this course.

If we were to console.log the delegated variable, we'd see an object containing all of the other props provided to this component. For example:

console.log(delegated);
/*
  {
    type: 'success',
    children: 'Account registered!',
  }
*/

To apply these props onto our Banner element, we create an expression slot with curly brackets, and spread the props along using spread syntax (...):

// This code:
<Banner {...delegated} />

// ...is equivalent to this code:
<Banner
  type={delegated.type}
  children={delegated.children}
/>

// ...which is the same thing as this code:
<Banner type={delegated.type}>
  {delegated.children}
</Banner>

To go one step further in demystifying this new syntax, here's how it gets transpiled to plain JavaScript:

// This JSX...
<UserProfileCard user={currentUser} {...delegated} />

// ...turns into this JavaScript:
React.createElement(
  UserProfileCard,
  {
    user: currentUser,
    ...delegated
  }
);

Spread syntax gotcha
(warning)

It's common in the React community to use “trailing commas”, like this:

const someObject = {
  id: 1234,
  createdAt: '2022/07/01',
  modifiedAt: '2022/07/02',
  avatar: '/src/avatar.png', // <-- Lil’ comma here!
}

I like using trailing commas because it means I don't have to worry about forgetting a comma if I add a new key/value pair after the final item (plus, it reduces the "noise" in code reviews!).

If you try to use a trailing comma with our ...delegated, however, we'll get an error:

function Slider({
  label,
  ...delegated, // <-- This comma is a problem
}) {}

Unexpected trailing comma after rest element.

When we use rest parameters like this, it needs to be the final item in the list, and so the JavaScript language designers decided to disallow trailing commas here.

It's annoying, but fortunately the error message is pretty clear, so we shouldn't lose a bunch of time over this one.

Supercharged HTML tags

Video Summary

This video revisits the TextInput component we created in Module 3, when learning about the Rules of Hooks

Here's the sandbox from the video:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
LoginForm.js
TextInput.js
Result
Console
Refresh results pane

Prop delegation and TypeScript
(info)

In JavaScript, we can use this pattern to catch and forward all props onto the underlying DOM node. But how does this work in TypeScript? Do we need to add each and every possible attribute to our props interface?

Thankfully not! We can use the ComponentProps helper. It's beyond the scope of this course, but you can learn more about it in this lovely article from Matt Pocock, “ComponentProps: React's Most Useful Type Helper”
.


---

## Exercises

Source: /joy-of-react/04-component-design/03.01-delegating-props-exercises

Exercises
A Slider component

In the sandbox below, you'll see that we've built a Slider component.

Internally, this component renders an <input type="range">, the built-in DOM node for creating ranges and sliders. And so we can think of this Slider component as a “supercharged” range input.

Unfortunately, we've only exposed a subset of the attributes we might wish to set on this DOM node through props. Your mission is to forward all props onto the input, so that we can treat <Slider> as a supercharged range input.

Acceptance Criteria:

The Slider component should use the prop delegation technique to forward all unspecified props to the <input type="range"> that it renders.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Slider.js
Slider.module.css
import React from 'react';

import styles from './Slider.module.css';

function Slider({ label, min, max, value, onChange }) {
  const id = React.useId();

  return (
    <div className={styles.wrapper}>
      <label
        htmlFor={id}
        className={styles.label}
      >
        {label}
      </label>
      <input
        type="range"
        id={id}
        className={styles.slider}
        min={min}
        max={max}
        value={value}
        onChange={onChange}
      />
    </div>
  );
}

export default Slider;
Result
Console
Refresh results pane

Solution:

Note: In addition to sharing my solution, I also dig into the implementation of this Slider component a bit in the video above. If you're not familiar with <input type="range">, I suggest checking it out!

You can learn more about range inputs on MDN
.

Solution code
(success)

 Show more
A Toggle component

Toggle components are similar to checkboxes. They're often used to flip a value on or off.

In this exercise, we have a custom <Toggle> component. It looks like this:

We want to be able to pass a custom className to provide custom styles. For example, maybe we want to pass a CSS class that updates the color of the toggle circle:

Your mission is to update the Toggle component so that it can be customized, by passing a className. It should also support additional custom props, like data attributes.

Acceptance Criteria:

In the example below, the second <Toggle> instance has a prop: className="green-toggle". This class should be applied to the <button> inside the Toggle component, producing the green circle shown in the GIF above.
Other props (eg. data attributes) should also be forwarded along to the <button> element.

Note: It may be helpful to review the Rest/Spread primer lesson 👀.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
Toggle.js
use-toggle.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

---

## Conflicts

Source: /joy-of-react/04-component-design/03.02-conflicts

Conflicts

In the “Toggle” exercise from the previous lesson, we saw how delegating all props can lead to some issues if there are conflicts.

Let's look at a minimal example:

function Checkbox({ label, ...delegated}) {
  const id = React.useId();

  return (
    <>
      <label htmlFor={id}>
        {label}
      </label>
      <input
        id={id}
        type="checkbox"
        {...delegated}
      />
    </>
  );
}

This Checkbox component applies two hardcoded attributes to the <input>: type and id.

Now, suppose the consumer of this component uses it like this:

<Checkbox
  label="Do you agree to the terms?"
  type="button"
  onClick={handleAgreeToTerms}
/>

The type and onClick props aren't specified in the Checkbox component, and so they're collected into the delegated object, and pasted onto the <input>:

// Here's the React element that will be created:
<input
  id={id}
  type="checkbox"
  type="button"
  onClick={handleAgreeToTerms}
/>

We've specified two different values for type, and when there are conflicts like this, later values overwrite earlier ones. And so, this input will be a button instead of a checkbox.

Essentially, the consumer has “hacked” our Checkbox component to not render a checkbox!

Let's rewrite our Checkbox component to spread the provided props first:

function Checkbox({ label, ...delegated}) {
  const id = React.useId();

  return (
    <>
      <label htmlFor={id}>
        {label}
      </label>
      <input
        {...delegated}
        id={id}
        type="checkbox"
      />
    </>
  );
}

With this change, the same <Checkbox> element produces a different result:

<input
  // Delegated props:
  type="button"
  onClick={handleAgreeToTerms}
  // Built-in attributes:
  id={id}
  type="checkbox"
/>

// After removing the duplicate `type`, we're left with:
<input
  onClick={handleAgreeToTerms}
  id={id}
  type="checkbox"
/>

Because we've flipped the order, the user-supplied type="button" will now be overwritten by the built-in type="checkbox".

A powerful tool in API design

When we produce React components, we get to decide how much power we want to give consumers. We can choose which properties they're allowed to overwrite, and which ones are mandatory / locked in.

In the example above, I feel pretty strongly that a Checkbox component should always render an <input type="checkbox">, and so I don't want to let consumers overwrite the type attribute.

But this won't always be the case! Sometimes, I do want to let users overwrite the built-in attributes.

For example, suppose I have a component that generates an SVG icon:

function ArrowIcon({ size, ...delegated }) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      width={size}
      height={size}
    >
      <path
        d="M 20 0 L 24 12 L 0 12 L 24 12 L 20 24"
        stroke="black"
        strokeLinecap="round"
        {...delegated}
      />
    </svg>
  );
}

By default, this component will render a black arrow with rounded lines, but I can supply my own overrides:

<ArrowIcon stroke="red" strokeLinecap="square" />

There's no right/wrong answer when it comes to where the {...delegated} should go. Rather, it's a choice we can use as a tool, to decide how much power/flexibility I want to grant to the developers consuming this component.

Manually managing conflicts

Sometimes, delegated props is too blunt of a tool, and we need to do some manual work to resolve the conflict.

For example, when it comes to CSS classes, we often want to apply both the user-supplied class as well as the built-in one.

In the Toggle exercise, we manually merged the two classes together so that we were applying the toggle class (which provided all of the standard toggle styling) as well as the green-toggle class (a user-specified class with an override for the toggle's color).

I've built a lot of components that follow this exact template. Here's a minimum viable example, with all the other stuff stripped away:

function Template({ className = '' }) {
  const appliedClass = `built-in-class ${className}`;

  return (
    <div
      className={appliedClass}
    />
  );
}

In a sense, we've actually seen an example of this pattern already, when we talked about the Rules of Hooks:

function TextInput({ id, label, type }) {
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
      />
    </div>
  );
}

If the user supplies an id prop, it will be used for the input's id, and the label's htmlFor. If they don't, we'll use the generated value we get from the React.useId hook.

We could rely on rest/spread to apply the correct id on the <input>, but we also need to set the exact same value on the <label>, via the htmlFor attribute. As a result, we need to manage this conflict manually.

Here's one more example, where we can supply custom inline styles to a component that already has some:

function ExampleComponent({
  // User-specified styles.
  // Defaults to an empty object so that we always receive an
  // object, never “undefined”:
  style = {},
  children,
  ...delegated
}) {
  const builtInStyle = {
    padding: 16,
    background: 'red',
  };

  return (
    <div
      {...delegated}
      style={{
        // Merge both sets of styles, prioritizing the
        // built-in styles:
        ...style,
        ...builtInStyle,
      }}
    >
      {children}
    </div>
  );
}

To review, we have several options when it comes to conflicting attributes.

If we want to allow the consumer to overwrite a particular hardcoded attribute, we can place the {...delegated} syntax afterwards.
If we want to prioritize the hardcoded attribute, however, the {...delegated} syntax should come first.
If we want to merge both values, we'll need to manage it ourselves, without using {...delegated}.

All 3 of these options are valid in different situations. It all comes down to how much control we want to grant the consumer.


---

## Delegating Styles

Source: /joy-of-react/04-component-design/03.03-delegating-styles

Delegating Styles

Video Summary

My question for you: Which option do you prefer, and why? What are the pros/cons of each approach?

Here's the sandbox from the video, for you to tinker with:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
VolumeSlider.js
VolumeSlider.module.css
Slider_props.js
Slider_className.js
Slider.module.css
import React from 'react';

import Slider from './Slider_props';
import styles from './VolumeSlider.module.css';

function VolumeSlider({ volume, setVolume }) {
  return (
    <Slider
      label="Volume"
      min={0}
      max={100}
      value={volume}
      onChange={(event) => {
        setVolume(event.target.value);
      }}
    />
  );
}

export default VolumeSlider;
Result
Console
Refresh results pane

Alright, let's talk about the tradeoffs!

The first thing I should say is that there is no consensus in the React community. People have strong opinions about this.

The big difference between these approaches is how much power is granted to the consumer. With the className option, developers can apply any CSS they want to the <input> tag. For example, with a bit of CSS, we could force it to be a vertical slider:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
VolumeSlider.js
VolumeSlider.module.css
Slider_props.js
Slider_className.js
Slider.module.css
Result
Console
Refresh results pane

By exposing a className prop, we’ve granted the consumer the authority to extend this component however they wish, but is this a good thing or a bad thing?

Honestly, I can make a pretty good argument either way. Let’s look at both sides, and then I’ll share my own opinion below.

The arguments for specific props

When building low-level components, we're likely implementing them according to a design system.

As we learned earlier, a design system is a document that provides guidelines and rules for using each component. It specifies which changes are allowed, and which changes are not allowed. The components we implement should only allow the customizations specified in the design system.

In other words, we want to make sure that developers “color within the lines”. By exposing a className prop, a rogue developer could radically change how this component is styled, bending it into whatever shape they like, in violation of the design system.

A professional-looking app is one that is consistent, where each Slider instance is part of a visual set. With the className prop, the app will eventually lose that consistency.

Components are meant to encapsulate markup, logic, and styles. If developers can apply any styles they want, then we don't truly have encapsulation. What's the point of having a design system if the developer can do whatever they want with the aesthetic?

Design systems are living, breathing documents, and we can always update them as requirements change. But it's chaos to allow developers to apply any CSS they'd like to these components.

The arguments for a “className” prop

In the real world, the "specific props" approach tends to become completely unwieldy.

In our example above, we added 3 props, but this is only the tip of the iceberg. For example, what if we want to allow the consumer to specify a hover color? Or, what if we want to customize the handle size, but only for a specific media query?

CSS is a huge, sprawling language. We could wind up with 50+ props, which would be a nightmare to maintain, and no fun at all to consume. Each new prop is another Jenga™ brick being added to the top of the tower.

Also, designers have a knack for creating exceptions and one-offs. It won't be long until they come up with a legitimate use case that doesn't work with our specific props. And then what?

Here's what tends to happen: developers will “reach around” React altogether, and apply whatever CSS they need:

/* HACK: Apply rotation to Slider component */
.some-wrapper form input[type="range"] {
  margin: 50px !important;
  transform: rotate(90deg) !important;
}

Remember, we can't literally stop developers from applying CSS to a particular element! Whether or not we have a className prop, a determined developer can still apply whatever styles they want.

Or, maybe even worse, they'll decide to create their own component, SliderAlt, that is 95% the same, but different in this one regard. Some codebases have multiple near-identical components because the prop interface wasn't flexible enough for them.

It's just not realistic to come up with a handful of style-related props that will work for every possible use case. The real world is too messy for that.

My take

Alright, I've done my best to summarize both sets of arguments! But what do I think?

I've worked on teams that have tried to restrict the ability to apply custom styles, and it just doesn't work. The real world really is too messy, and CSS really is too big and sprawling. So I like to add a className prop.

It's true that a rogue developer can apply whatever CSS they want, bending the component into an unrecognizeable shape… but why would they do that?

In my experience, it's designers who sometimes want to bend the rules of the system, in order to create the best possible user experience. Usually, it's a small tweak, something that still fits within the spirit of the design system.

What about consistency? Personally, I think polish and UX is more important than consistency. I don't want a worse user experience because we got boxed in by the design system! Obviously, we don't want it to be so inconsistent that the project looks like a disorganized mess, but I trust our design friends not to push things that far.

A lot of this does come down to trust. No matter what restrictions we try and put into place, a determined developer will be able to work around them. But we should trust our teammates!

But yeah, that's just my opinion, and like I say, there isn't a consensus on this topic! I'd encourage you to experiment with different patterns and see what works best.


---

## Forwarding Refs

Source: /joy-of-react/04-component-design/04-forwarding-refs

Forwarding Refs
(Optional lesson)

In the previous module, we saw how to focus an input on mount using refs.

In React 18 and earlier, this technique worked great when everything was contained within the same component, but it stopped working when multiple components became involved. If we wanted to pass a ref down to a child component, we had to jump through an annoying hoop, the “forwardRef” API.

Starting in React 19, however, this is no longer required! Refs can be passed down to children, just like any other prop.

This lesson was created before React 19 was released. In order to showcase the problem being described, I’ve “downgraded” the playground to use React 18.

Feel free to skip this lesson. Unless you’re maintaining an older application that uses React 18 or earlier, you won’t really get any benefit out of this lesson, and the exercises that follow.

We saw how the Slider component from earlier was essentially a "supercharged range input". With prop delegation, I can pass any attributes I like to it, and they'll be forwarded onto the <input type="range"> automatically.

But what if I want to focus this slider on mount?

Here's a broken implementation. If you'd like, spend a couple of moments poking at the code, and see what you can learn about what's going on here:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Slider.js
Slider.module.css
import React from 'react';

import Slider from './Slider';

function App() {
  const [volume, setVolume] = React.useState(50);

  // Create a React ref:
  const sliderRef = React.useRef();

  React.useEffect(() => {
    // Focus the slider on mount:
    sliderRef.current.focus();
  }, []);

  return (
    <main>
      <Slider
        // Capture a reference to the slider:
        ref={sliderRef}
        label="Volume"
        min={0}
        max={100}
        value={volume}
        onChange={(event) => {
          setVolume(event.target.value);
        }}
      />
    </main>
  );
}

export default App;
Result
Console
Refresh results pane

Let's dig into it:

Video Summary

Here's the solution from the video:

Solution code
(success)

 Show more

Memo and forwardRef?
(info)

What if we want both React.memo and React.forwardRef on the same component?

We can do it like this:

export default React.memo(React.forwardRef(Slider));

Each of these functions is known as a higher-order component — it takes a component as input, and produces a new component as output. And so we can "nest" these functions, and everything works the way you'd expect.

Improved in React 19
(success)

As I mentioned above, the forwardRef API is no longer needed in React 19. Instead, we can pass the ref prop like any other prop:

function Slider({
  label,
  ref,
  ...delegated
}) {
  const id = React.useId();

  return (
    <div className={styles.wrapper}>
      <label htmlFor={id} className={styles.label}>
        {label}
      </label>
      <input
        ref={ref}
        {...delegated}
        type="range"
        id={id}
        className={styles.slider}
      />
    </div>
  );
}

// When using the component:
<Slider ref={sliderRef} />

The playground on this lesson uses React 18, and so this trick won’t work here, but feel free to try it in one of the other lessons!

Also, fortunately, React 19 hasn’t yet removed forwardRef, so our React 18 code will still work just fine in React 19. The React team has also signaled that they’re working on a codemod? that will replace forwardRef with a ref prop, so if forwardRef is ever removed, it will be easy to migrate.


---

## Exercises

Source: /joy-of-react/04-component-design/04.01-forwardref-exercises

Exercises
(Optional lesson)

Optional exercises
(info)

As mentioned in the previous lesson, forwardRef is no longer required in React 19, since React 19 treats ref the same as any other prop.

If you know you’ll be working exclusively with React 19+, feel free to skip these exercises. That said, plenty of companies are still using older versions of React. If your workplace hasn’t yet updated to React 19+, it’s a good idea for you to get some practice with this stuff!

The playgrounds in this lesson use React 18.

Supercharged Button

Alright, let's get some practice forwarding refs along!

In the sandbox below, we have a <Button> component, and we want to set it up to be a “supercharged” button. This means that we should be able to capture a reference to it, as well as forward all props along to it.

Acceptance Criteria:

When hovering or focusing the button in the DOM, it should log "Captured ref: HTMLElement" in the console.
There should be no console warnings.

Code Playground

STRICT MODE
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
  const buttonRef = React.useRef();

  function logRef() {
    console.log('Captured ref:', buttonRef.current);
  }

  return (
    <Button
      ref={buttonRef}
      onMouseEnter={logRef}
      onFocus={logRef}
    >
      Hover or Focus Me
    </Button>
  );
}

export default App;
Preview
Refresh results pane
Console
Clear Console

Solution:

Solution code
(success)

 Show more
SquareSlider forwarding

One of the great things about React is the ability to “compose” components. For example, we can build a SquareSlider component that builds on the lower-level Slider component, locking in specific values.

In the sandbox below, we're trying to capture a ref on a <SquareSlider> component, but it isn't working. Your job is to fix it.

Acceptance Criteria:

The sliderRef ref should hold a reference to the <input type="range">.
You can verify this in the console. It should show that sliderRef holds an HTMLElement.

Hot reload is disabled for this playground. The “Result” pane will refresh on every code change.
Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
SquareSlider.js
SquareSlider.module.css
Slider.js
Slider.module.css
Preview
Refresh results pane
Console
Clear Console

Solution:

Solution code
(success)

 Show more

---

## Polymorphism

Source: /joy-of-react/04-component-design/05-polymorphism

Polymorphism

In order to build usable, accessible interfaces, it's important that we understand the semantics of different HTML tags.

For example: if an element can be clicked to perform an action in JS, it should be a button! Unless that action changes the URL, in which case, it should be an anchor (<a>).

(If you'd like to learn more about why adding a click-handler to a <div> is such a bad idea, I recommend checking out React Podcast #34, “Just Use A Button”
, with superstar developer Jen Luker. The entire episode is worth listening to, but the button-specific part is around 26:30.)

When choosing an HTML tag, it's much more important to focus on the semantics than the aesthetics. You should use a <button> even if you don't want it to look like a button. With CSS, we can strip away all of those built-in button styles. It's much easier to remove a handful of CSS rules than it is to recreate all of the usability benefits built into the <button> tag.

With all of that in mind, let's suppose our designer wants us to build the following UI:

In the top right, there are some actions the user can take:

These look like links, but are they? It depends on whether clicking them changes the URL or not. “Export All Data” doesn't sound like a link to me; I imagine it generating a .csv and emailing it to the user.

So, here's what we're going to do. We're going to build a LinkButton component. It's always going to look like a link, but it's going to be flexible in its implementation: it can either render an <a> tag, or a <button> tag, depending on whether an href is supplied.

Spend a few minutes tinkering, and then watch the video below to see how I'd approach this problem.

Acceptance Criteria:

The LinkButton component has an optional prop, href.
If an href is provided, LinkButton should render an <a> tag. Otherwise, it should render a <button> tag.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
LinkButton.js
LinkButton.module.css
Result
Console
Refresh results pane

Let's explore:

Video Summary

Here's the final code from the video:

Solution code
(success)

 Show more

Is the typeof check necessary?
(info)

In the code above, I perform the following check:

const Tag = typeof href === 'string'
  ? 'a'
  : 'button';

One student asked: “is the typeof check really necessary?”. They wondered if they could do this instead:

const Tag = href ? 'a' : 'button';

The subtle bug with this approach is that it's possible for href to be an empty string. <a href=""> will create a link to the current page, essentially acting as a refresh button. This is a rare but valid use case. Because empty strings are falsy 👀, however, this alternative approach would create a button, not an anchor.

Now, I'll be honest: I hadn't actually considered this when I wrote this lesson. 😅

When we opt for “broad” checks like href, we need to think carefully about all of the different edge cases. What if they pass a falsy string? Or a truthy value that isn't a string?

I'm lazy, and I don't want to have to consider all of these possibilities. And so, over the years, I've learned to use a “precise” check by default. It's a bit more typing, but a heck of a lot less thinking.

(That said, there are likely quite a few places in this course where I use “broad” checks. The slightly-more-complicated truth is that my intuition suggests different approaches depending on the situation. As a general rule, though, I prefer to use precise checks unless it's immediately obvious to me that a broad check is fine.)


---

## Exercises

Source: /joy-of-react/04-component-design/05.01-polymorphism-exercises

Exercises
A List component

Let's suppose we're building a List component.

There are two types of lists in HTML: unordered lists (<ul>) and ordered lists (<ol>). Our List component should be able to render either.

Acceptance Criteria:

The consumer should be able to specify whether they want to render an ol or a ul, by passing a prop to List.
The component should restrict the user so that it can only render ul and ol (and not, for example, p or button).

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
List.js
List.module.css
import React from 'react';

import styles from './List.module.css';

function List({ className = '', children, ...delegated }) {
  return (
    <ul
      {...delegated}
      className={`${styles.wrapper} ${className}`}
    >
      {children}
    </ul>
  )
}

export default List;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

In this solution, we use object destructuring to extract the as prop, and rename it to Tag. You can learn more about this syntax in the “Object Destructuring” reference lesson 👀.

A simpler approach?
(info)

Several students have taken an alternative approach:

function List({
  ordered,
  className = '',
  children,
  ...delegated
}) {
  const Tag = ordered ? 'ol' : 'ul'

  return (
    <Tag
      {...delegated}
      className={`${styles.wrapper} ${className}`}
    >
      {children}
    </Tag>
  );
}

Instead of having an as prop that could be any string, the ordered prop is a boolean value. If it's true, we'll render an <ol>. Otherwise, it'll be a <ul>.

I think this is a perfectly valid approach. I opted to use the as prop in my solution because I wanted to teach a broadly-applicable pattern, something that can be used in many different situations. The ordered prop makes a lot of sense for this particular exercise, but it can only be used when there are exactly 2 valid options.

If your solution uses a boolean prop like this, I think that's great! You don't have to change anything. But I do hope you'll keep this as alternative in mind, since it's handy in all sorts of situations.

Customized heading levels

HTML gives us 6 different heading tags, <h1> through <h6>.

Some developers believe that you're supposed to pick the one based on the size of the text: <h1> for large headings, <h6> for small ones. But this isn't true. We can use CSS to make any heading tag any size. We should never pick HTML tags based on their aesthetics, we should pick them based on their semantics!

Instead, the goal with the heading tags is to organize the content as a hierarchy.

For example, consider this article from Wikipedia
:

Imagine you were responsible for generating the "table of contents" for this page. You'd probably structure it something like this:

George Mouzalon
Biography
Early life and service under Theodore II
Appointment as regent and assassination
Treatment by Historians (not pictured, below the fold)

The page is all about “George Mouzalon”. But that page is split into a few chunks, like the biography, the treatment by historians...

And within those sections, we have subsections!

Documents tend to be hierarchical like this. In HTML, the heading levels are meant to represent this hierarchy.

Inspecting the HTML, we see that Wikipedia has chosen the following heading levels:

Every page should have a single <h1> that covers the entire page (eg. the title of a blog post, the headline of a news article). Each section is labeled with <h2>, each sub-section with <h3>, each sub-sub-section with <h4>, etc.

This presents a bit of a challenge for us React developers.

For example: Suppose we have a component like this:

function SectionWithHeading({ heading, children, ...delegated }) {
  return (
    <section {...delegated}>
      <h2>{heading}</h2>
      {children}
    </section>
  );
}

This component bundles together a chunk of stuff with a heading. But it hardcodes an <h2> tag, which might not always be the right heading level!

Let's fix this code using polymorphism.

Acceptance Criteria:

Update the <SectionWithHeading> component so that it allows the consumer to specify the heading level.
In App.js, add a prop to each instance to set the heading level to the correct value.
When properly set, styles will be applied automatically to the heading tags, and the final result should look like this:

Note: Depending on your operating system, the serif headings might look a bit different. This is due to each operating system using a different default serif font.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
SectionWithHeading.js
Result
Console
Refresh results pane

Solution:

Correction: In the solution, we throw an error when the level is less than 0. Given that <h0> is not a valid tag, it should actually throw when level is less than 1, not 0. This correction has been applied to the solution below:

Solution code
(success)

 Show more

Why this matters
(warning)

You might be wondering why it matters to pick the correct heading level. After all, users can't actually tell whether we use an <h2> or an <h3>… can they?

It matters for two reasons:

For people using screen readers, headings serve as landmarks, and can be used like a table of contents. They can expand or collapse sections to quickly find the content they're after, much like sighted users will scan visually.
Search engines rely on well-specified markup to analyze your page, meaning that poorly-formatted HTML can have a negative impact on search engine optimization.

---

## Compound Components

Source: /joy-of-react/04-component-design/06-compound-components

Compound Components

Every now and then, you might encounter a component library or other third-party package that does something a bit strange:

// Example from React Bootstrap
import Dropdown from 'react-bootstrap/Dropdown';

function UserButton() {
  return (
    <Dropdown>
      <Dropdown.Toggle>
        Actions
      </Dropdown.Toggle>

      <Dropdown.Menu>
        <Dropdown.Item href="/change-email">
          Change Email
        </Dropdown.Item>
        <Dropdown.Item href="/reset-pwd">
        Reset Password
        </Dropdown.Item>
        <Dropdown.Item href="/delete">
        Delete account
        </Dropdown.Item>
      </Dropdown.Menu>
    </Dropdown>
  );
}

If you're not familiar with this pattern, it can be pretty bewildering. Why do some elements have dots in the names?? And where are they coming from?

This pattern is called compound components. And honestly, I'm not a big fan.

I wasn't planning on covering this pattern at all, but frustratingly, it's used by quite a few component libraries and other third-party packages. And so, in this lesson, we'll unpack what's going on, to help you understand this pattern when you see it in the wild. I'll also share an alternative way to achieve the same goals.

The big trick

So, here's a fun JavaScript quirk: functions can have properties.

function addNums(a, b) {
  return a + b;
}

addNums.hello = "world";

console.log(addNums.hello); // "world"

In JavaScript, functions are secretly objects. This means we can assign properties to them, the same way we read/write the properties on an object.

This means we can attach one component to another, using this same notation:

function Dropdown({ children }) {
  return (
    <div>{children}</div>
  );
}

function DropdownToggle({ children }) {
  return (
    <button>{children}</button>
  );
}
function DropdownMenu({ children }) {
  return (
    <nav>{children}</nav>
  );
}
function DropdownItem({ href, children }) {
  return (
    <a href={href}>{children}</a>
  );
}

Dropdown.Toggle = DropdownToggle;
Dropdown.Menu = DropdownMenu;
Dropdown.Item = DropdownItem;

export default Dropdown;

That's how this pattern works, from a syntax perspective. We “hang” a bunch of smaller components on one main component.

This is one of those situations where the JSX can obfuscate things a bit, to make them seem more magical than they really are. Let's consider how these compound components get compiled:

// in JSX:
<Dropdown.Item href="/change-email">
  Change Email
</Dropdown.Item>

// Compiled to JS:
React.createElement(
  Dropdown.Item,
  { href: '/change-email' },
  'Change Email'
)

We're accessing the Item property on the Dropdown function, which resolves to the DropdownItem component we defined above.

An alternative structure

Let's look at another way we could structure things:

function Dropdown({ children }) {
  return (
    <div>{children}</div>
  );
}

export function DropdownToggle({ children }) {
  return (
    <button>{children}</button>
  );
}
export function DropdownMenu({ children }) {
  return (
    <nav>{children}</nav>
  );
}
export function DropdownItem({ href, children }) {
  return (
    <a href={href}>{children}</a>
  );
}

export default Dropdown;

Instead of hanging all of our secondary components on the Dropdown function, we're exporting them as named exports.

Then, on the consumer side, we can import and render them:

import Dropdown, {
  DropdownToggle,
  DropdownMenu,
  DropdownItem,
} from 'hypothetical-react-bootstrap/Dropdown';

function UserButton() {
  return (
    <Dropdown>
      <DropdownToggle>
        Actions
      </DropdownToggle>

      <DropdownMenu>
        <DropdownItem href="/change-email">
          Change Email
        </DropdownItem>
        <DropdownItem href="/reset-pwd">
        Reset Password
        </DropdownItem>
        <DropdownItem href="/delete">
        Delete account
        </DropdownItem>
      </DropdownMenu>
    </Dropdown>
  );
}

I think the reason that libraries tend to prefer the compound component pattern is because it simplifies the import statement. We only need to specify a single Dropdown component import and we get all the secondary components for free! No need to list them out one-by-one.

But that's a pretty small benefit when we consider the costs:

It's confusing! When I taught React at a local coding bootcamp, a surprising number of students would ask questions about this strange syntax they saw in third-party libraries.
We lose access to bundler optimizations like tree-shaking?.
There can be compatibility issues, like with Next.js (described below).

The import/export keywords are the main mechanism we have in JS to share code between modules. The whole ecosystem is built on the assumption that this is how we do things!

If we're going to deviate from the standard way of doing things, there had better be some really compelling advantages to make it worth it. In my opinion, trimming down the number of imports doesn't come close to balancing the scales.

Issues with Next.js
(warning)

If you try to use compound components inside Next 13.4+, you'll get an error:

Unsupported Server Component type: undefined

This happens because Next has some special module-proxying logic, and it isn't expecting components to have properties like this. Unfortunately, I'm not aware of any workarounds, other than “un-compounding” your compound components, using named exports.

We'll learn all about Next.js and React Server Components later in the course.

DIY API design

In this lesson, we've been focusing on the syntax of compound components, to understand what the heck <Dropdown.Item> is.

Syntax aside, there's kind of a cool idea here!

Sticking with the “Dropdown” example, let's consider two different possible APIs for this component:

// Version 1: A closed system
<Dropdown
  label="Actions"
  options={[
    { href: '/change-email', label: "Change Email" },
    { href: '/reset-pwd', label: "Reset Password" },
    { href: '/delete', label: "Delete Account" },
  ]}
/>
// Version 2: DIY sub-components
<Dropdown>
  <DropdownToggle>
    Actions
  </DropdownToggle>

  <DropdownMenu>
    <DropdownItem href="/change-email">
      Change Email
    </DropdownItem>
    <DropdownItem href="/reset-pwd">
      Reset Password
    </DropdownItem>
    <DropdownItem href="/delete">
      Delete account
    </DropdownItem>
  </DropdownMenu>
</Dropdown>

In Version 1, the Dropdown component is a black box. We give it the raw data, and it produces a chunk of UI for us.

In Version 2, however, the Dropdown component is more like a piece of furniture from IKEA. We're given all of the parts, and we have to assemble it ourselves.

Ultimately, both approaches have their use cases. There's no right/wrong answer here, just different tradeoffs:

Version 1 is easier to use, but rigid. We can't customize it at all.
Version 2 is a bit more work to set up, but a lot more flexible. We can combine the pieces in different ways, or even substitute in our own sub-components!

In practice, this “DIY” approach is most often used with third-party component libraries. These tools need to be flexible, since they'll be used in all sorts of different applications.

Flexibility isn't always a good thing. We don't necessarily want the components we create to be so customizable! We'll talk about this more in the next lesson.

I should also warn you, producing components using this sort of “DIY” API is quite tricky. It's a can of worms we won't be opening in this course. But hopefully this lesson has helped prepare you for libraries that use this sort of design, and down the line you can explore building components using this kind of structure!

Wasn't there something about breadcrumbs here?
(info)

In an earlier version of this course, this lesson featured a video + exercise combo that dug into this pattern using a Breadcrumbs example.

I got a lot of feedback that this lesson was a bit confusing / hard-to-follow, and it was a bit lengthy for a pattern that I don't even recommend. 😅

You can access the previous version of this lesson if you'd like, though I don't recommend it.


---

## Slots

Source: /joy-of-react/04-component-design/07-slots

Slots

Video Summary

So much trouble!
(info)

In the example above, we use a <picture> tag to leverage 4 different image files.

You might be thinking: that seems like a lot of work! We have to create 4 different copies of each image??

Personally, I only go through this amount of trouble for critical images, things like my lil’ clay mascot on my blog’s homepage
. For less important images, I might just use a single 2x webp image and serve it for everyone.

There are also third-party services that can abstract away a lot of this stuff, like Imgix
 or the Next.js Image component
. Just be warned, these services can become pretty pricy if you get a lot of traffic!

Here's the starting code from the video above:

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

…And here's the final code, with all of our tweaks:

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

## Exercises

Source: /joy-of-react/04-component-design/07.01-slots-exercises

Exercises
Icon Buttons

Let's build an IconButton component!

We'll use the react-feather package to provide the icons. As a quick refresher, here's how we render an icon from react-feather:

import { Award } from 'react-feather';

<Award size={32} />

Acceptance Criteria:

We should be able to pass any icon we want, as a React element, to the button. We can test using the imported icons from the react-feather package
The IconButton component should render the icon in the appropriate slot

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
IconButton.js
IconButton.module.css
import React from 'react';
import {
  Award,
  Camera,
  Frown,
  Slash,
  XCircle,
} from 'react-feather';

import IconButton from './IconButton';

function App() {
  // TODO: Render an “IconButton”.
}

export default App;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Icons in React
(info)

My favourite collection of icons is Feather Icons
. They're beautifully designed, built using well-crafted SVGs, and come with official React bindings (the react-feather NPM package
 we've been using).

The only drawback is that it's a relatively modest collection. There are only 287 icons.

I recently discovered Lucide
, a fork of Feather Icons which adds almost 1000 new icons, in the same style! There are official React bindings
 as well.

I also recently learned about Phosphor Icons
 a set of over 9000 icons in a similar friendly style. It includes icons in stroke and fill styles, and there are official React bindings
 as well.

Stretch Goal: Restricting control

So, as we saw at the end of the solution video, it's not ideal that the consumer has so much control over the icon.

For example, there's nothing stopping them from doing this:

<IconButton
  icon={
    <Frown size={128} />
  }
>
  Rate Our Product
</IconButton>

Alternatively, what if we want to "hardcode" certain props on the provided element?

For example, I personally feel it looks better when the icons are drawn with a slightly thinner line:

<IconButton
  icon={
    <Frown strokeWidth={1.5} />
  }
>
  Rate Our Product
</IconButton>
Before:
After:

The problem here is that we need the consumers to always remember to apply this prop. I don't think that's a reasonable burden to place on them. The IconButton should be the one specifying how large the icon should be!

So, in this stretch goal, your mission is to come up with a way to satisfy these conditions:

Acceptance Criteria:

The IconButton should still have an icon prop, which gives it an icon to render. IconButton should not be the one importing the icons from "react-feather".
IconButton should have 100% control over the props being applied to the icon.

I don't expect you to be able to solve this. It's a challenging exercise, and I haven't shown you how to solve it. But I think it will be helpful if you spend a few moments experimenting, and seeing what you can come up with.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
IconButton.js
IconButton.module.css
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

Legacy APIs
(info)

A couple of students have pointed out that cloneElement is considered a legacy API
. It's not quite deprecated, but it seems the React team is trying to discourage us from using it.

Truthfully, it's not something I've actually used in years. I prefer to solve this sort of problem using the 2nd method we explored.

In this video, we rename the icon prop to Icon using destructuring. If this syntax caught you off-guard, check out the “Object Destructuring” lesson 👀 in the JavaScript Primer.

Why not let IconButton own the icons?
(warning)

Instead of passing the element/component to IconButton, what if we let IconButton “own” the icons? That way, the consumer could pick which icon they want, like selecting a dish from a menu:

<IconButton icon="award">
  Collect Reward
</IconButton>

We could implement it like this:

// IconButton.js
import React from 'react';
import {
  Award,
  Camera,
  Frown,
} from 'react-feather';

// Create a big object that maps a bunch of strings
// onto their respective icons
const ICON_MAP = {
  'award': Award,
  'camera': Camera,
  'frown': Frown,
};

function IconButton({ icon, children }) {
  // `icon` is a string, like "award".
  // We get the real component by looking it up:
  const IconComponent = ICON_MAP[icon];

  return (
    <button className={styles.wrapper}>
      <span className={styles.iconWrapper}>
        {/* Then, we render that component: */}
        <IconComponent />
      </span>
      <span className={styles.childrenWrapper}>
        {children}
      </span>
    </button>
  );
}

This approach might seem a bit simpler. So why didn't we solve it this way?

 Show more

---

## Context

Source: /joy-of-react/04-component-design/08-context

Context

The main way to pass data inside a React application is through props. Like a train network, props allow us to pass state and other data across the application.

But sometimes, it can be a bit tedious to pass data through props. To help improve quality of life, React includes a secondary mode of transportation: Context.

Context is sorta like an express train. It allows us to "skip" certain stops, and hop straight from one component to another.

In this series of lessons, we'll learn all about it. 😄

---

## The Problem

Source: /joy-of-react/04-component-design/08.01-prop-drilling

The Problem

So, before we learn about context, we should talk about what problem it solves.

Video Summary

Component names in the devtools
(info)

In the video above, I briefly use the React devtools to show the set of components rendered on the course platform. If you try to do this yourself, you’ll discover that the components have short 1 or 2 letter names:

When I filmed this video, I was running the devtools on my local development server. This means that React was running in “Development” mode. When I deploy the site, React runs in “Production” mode, and the build process strips out all of the full component names, to shave a few bytes off the bundle sizes.

We’ll learn more about building for production in Module 6.

Here's the sandbox from the video, in case you wanted to experience prop-drilling firsthand:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
AccountDropdown.js
CourseIndexLayout.js
CoursePage.js
Hero.js
SubRouteWrapper.js
CourseModuleBlock.js
ModuleLessons.js
Result
Console
Refresh results pane

---

## Syntax

Source: /joy-of-react/04-component-design/08.02-syntax

Syntax

As an example, let's suppose we have a favouriteColor held in state, and we want to make it available to every component in the application, using context.

There are two steps: providing and consuming.

Step 1: Providing

In Step 1, we use a provider to make a particular value available through context. We do this by wrapping our application in a Provider component, which we get from React when creating a context.

Here's what it looks like:

// App.js
import React from 'react';

import Home from './Home';

// Create a new context
export const FavouriteColorContext = React.createContext();

function App() {
  const [
    favouriteColor,
    setFavouriteColor
  ] = React.useState('#EBDEFB');

  // Wrap everything `App` would normally render inside
  // a Provider, and pass our `favouriteColor` state
  // variable as the value:
  return (
    <FavouriteColorContext.Provider value={favouriteColor}>
      <Home />
    </FavouriteColorContext.Provider>
  );
}

export default App;

First, we create a “context” with the React.createContext() method.

A “context” can be thought of as a channel, a radio frequency we can use to broadcast data down through the app. It's the vehicle we use to deliver a value from one spot to another.

More concretely, FavouriteColorContext is a plain ol’ JavaScript object. It includes a bunch of stuff that React uses internally. It also includes a Provider component for us to render.

When we render <FavouriteColorContext.Provider>, we start broadcasting a value, making it available to any descendant component. In this case, we're broadcasting the favouriteColor state variable.

Often, Provider components are kept at the very top of our applications, so that their broadcast can reach anywhere in the app.

Slight improvement in React 19
(warning)

In React 19, the context object itself functions as the provider:

export const ThemeContext = React.createContext();

function App() {
  return (
    <ThemeContext value={/* ... */}>
      <Home />
    </ThemeContext>
  );
}

Instead of rendering <ThemeContext.Provider>, you can save a few characters and render <ThemeContext> instead. .Provider is no longer required.

Fortunately, your existing React 18 code will still work just fine in React 19; the .Provider suffix is still supported, even if it’s no longer necessary. The React team has signaled that they will provide a codemod? to do this conversion automatically.

Step 2: Consuming

When we want to access this value, we do so like this:

import { FavouriteColorContext } from './App';

function Sidebar() {
  const favouriteColor = React.useContext(FavouriteColorContext);
}

useContext is a hook designed to “plug in” to a particular context and pluck out its current value. In this case, we're handing it the FavouriteColorContext object we created in App, and it's grabbing the favouriteColor value that was funneled through.

To extend the channel/frequency analogy, useContext is like a radio. By passing it the FavouriteColorContext value, we're tuning this radio to the correct frequency, and the favouriteColor music starts playing.

Slight improvement in React 19
(warning)

In React 19, we can use the new use hook to consume context:

import { FavouriteColorContext } from './App';

function Sidebar() {
- const favouriteColor = React.useContext(FavouriteColorContext);
+ const favouriteColor = React.use(FavouriteColorContext);
}

The new use hook
 is designed to let us pluck values either from context or from a Promise (though the latter only works with specific data-fetching libraries).

Unlike other React hooks, use can be used conditionally. This means that, unlike useContext, we can use it after an early return:

function SomeComponent({ isEnabled, children }) {
  if (!isEnabled) {
    return null;
  }

  // ✅ No problems with this hook after the early return:
  const theme = use(ThemeContext);

  return (
    <div style={{ color: theme.color }}>
      {children}
    </div>
  );
}

Here's a sandbox that implements this pattern. Take a few minutes and poke around, getting a feel for how it's set up and how it works!

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Home.js
Sidebar.js
Result
Console
Refresh results pane
Updating values in context

In the example above, the favouriteColor state variable is being passed through context as a read-only value. There is no way to change that value.

What if we wanted to allow some descendant to be able to change the color?

We can solve for this by passing the setter function through context as well. This is similar to the pattern we learned in the Lifting State Up lesson.

Here's an updated sandbox. Notice that the Sidebar component now uses both the current state value and the setter function, to allow the user to change the sidebar's color:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Home.js
Sidebar.js
Result
Console
Refresh results pane

In practice, we almost always pass an object through context, since this allows us to package up multiple values together.

And so, here's the basic formula:

Create a new context with React.createContext.
Use the Provider component, from that context, to wrap around the application. Pass it a bundle of values that you need in other parts of the app.
Pluck the data you need from context, with the useContext hook.

In the next lesson, we'll get some practice!

When to use context
(info)

You might be wondering: when should we use context to pass state around the application, and when should we use prop-drilling?

Context is most commonly used for global state. The term “global state” is used for state that is needed across many different parts of the application, like the color theme, or the currently-logged-in user. This is in contrast to local state, which is only used in a single place within the application.

That said, there's a spectrum between local state and global state; it isn't binary! And so it's not quite as simple as “use context for global state”.

Here's my rule of thumb: If I find I keep having to pass a prop through a component, I should probably use context for it.

For example, consider this component:

function AccountSettings({ user }) {
  return (
    <section>
      <UserProfile user={user} />
    </section>
  );
}

The AccountSettings component doesn't actually use the user prop, it passes it right along to UserProfile.

I don't mind doing this sometimes, but if I find I keep having to pass a specific prop along, it's a sign that I should probably switch to context.

This is the strategy that works best for me, but this is subjective, and there's no right/wrong answer!


---

## Exercises

Source: /joy-of-react/04-component-design/08.03-syntax-exercises

Exercises
Passing a user object

Let's update the “Prop Drilling” sandbox from a couple lessons ago so that it uses context!

Acceptance Criteria:

A new context should be created in App.js, making the user state variable available to all other components
The ModuleLessons component should pluck user from context, instead of receiving it through props.
No need to update AccountDropdown, it can continue to receive user via props.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
use-user.hook.js
AccountDropdown.js
CourseIndexLayout.js
CoursePage.js
Hero.js
SubRouteWrapper.js
CourseModuleBlock.js
ModuleLessons.js
import React from 'react';

import useUser from './use-user.hook';
import AccountDropdown from './AccountDropdown';
import CourseIndexLayout from './CourseIndexLayout';

function App() {
  const user = useUser();

  return (
    <>
      <AccountDropdown user={user} />
      <CourseIndexLayout />
    </>
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

Why not use context for AccountDropdown?
(info)

A couple of students have asked: now that we've set up a UserContext, shouldn't we update that AccountDropdown component, so that it pulls the user from context as well?

We certainly could do this, but from my perspective, this would make the code a bit more complicated without offering any real benefit.

Either way, AccountDropdown will receive the exact same user object. The only difference is whether it's handed down directly, or whether it's funneled through our secret tunnel system. In situations where the data isn't being drilled through several layers of components, I prefer to pass it through props, even if that same data is already being made available through context.

Video playback rate

Context is mostly used for "global" state, things that are necessary all over the application.

One example might be the “playback rate” for videos. When a user changes the playback speed for one video, it should change for all videos, no matter where they are in the app!

Let's update the sandbox below so that playbackRate is stored in context.

Acceptance Criteria:

The VideoPlayer component should receive playbackRate through context, rather than through props.
The VideoPlayer component should also receive the setter function, setPlaybackRate, through context instead of props.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
VideoPlayer.js
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more

---

## Provider Components

Source: /joy-of-react/04-component-design/08.04-provider-component

Provider Components

Video Summary

Practice - extracting two more provider components

The sandbox below picks up where the video left off. The UserProvider component has been created, and it's up to you to create two new provider components: ThemeProvider and PlaybackRateProvider.

Acceptance Criteria:

The ThemeProvider component should manage everything related to the theme state and context.
The PlaybackRateProvider component should manage everything related to the playbackRate state and context.
App.js should import and use these two new components, matching the style/format of the UserProvider component.
Inside Homepage.js, the imports should be updated, so that we're importing the contexts from the provider components, not from App
Hint

For ThemeProvider, don't forget to move the COLORS import over!

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
UserProvider.js
ThemeProvider.js
PlaybackRateProvider.js
constants.js
Homepage.js
Result
Console
Refresh results pane

Local Storage gotchas
(warning)

This exercise uses the Local Storage API. Unfortunately, this can lead to several issues. Maybe you're getting baffling errors, even after resetting the playground. Or maybe the code isn't loading at all.

I've created a Local Storage Troubleshooting Guide
 which shows you how to solve the most common issues with Local Storage. If you're having any issues, please check this guide out.

Solution code
(success)

 Show more

---

## Performance

Source: /joy-of-react/04-component-design/08.06-context-performance

Performance

In the last module, we learned how to create “pure” components with React.memo. A pure component is one that doesn't re-render unless its props or state changes.

But what happens when a pure component consumes a context? For example:

import { FavouriteColorContext } from './App';

function Sidebar() {
  const favouriteColor = React.useContext(FavouriteColorContext);

  return (
    <div style={{ backgroundColor: favouriteColor }}>
      Sidebar
    </div>
  )
}

export default React.memo(Sidebar);

By wrapping Sidebar with React.memo, we produce a pure component, but what effect does that have? When will this component re-render?

Essentially, you can think of context as “internal props”. It follows all the same rules as props. If the value held in context changes, this component will re-render.

It's functionally equivalent to this:

function Sidebar({ favouriteColor }) {
  return (
    <div style={{ backgroundColor: favouriteColor }}>
      Sidebar
    </div>
  )
}

export default React.memo(Sidebar);

So, here's our updated definition for how pure components work:

A pure component will re-render if a prop, state variable, or context value changes.
Memoizing context values

In 90% of situations, we won't be passing a single value through context. We'll pass several things, packaged up in an object.

Here's a more realistic example:

export const FavouriteColorContext = React.createContext();

function App() {
  const [
    favouriteColor,
    setFavouriteColor
  ] = React.useState('#EBDEFB');

  return (
    <FavouriteColorContext.Provider
      value={{ favouriteColor, setFavouriteColor }}
    >
      <Home />
    </FavouriteColorContext.Provider>
  );
}

We're passing the state value, favouriteColor, as well as the state-setter function, setFavouriteColor.

When we pass multiple values like this, it tends to wreak havoc? on our pure components.

Let's solve a mystery. Below, you'll find a playground with a ColorPicker component that consumes the FavouriteColor context. There's also an unrelated piece of state, count.

ColorPicker is a pure component, and it doesn't depend at all on the count variable, but it re-renders when count changes.

Your mission is to figure out why this happens, and to fix it, so that ColorPicker only re-renders when the favouriteColor state changes.

Acceptance Criteria:

Clicking the “Count: 0” button should not cause the ColorPicker component to re-render.
A “ColorPicker rendered!” message is logged whenever ColorPicker re-renders, and so you'll know you've succeeded once clicking the “Count” button doesn't spawn a console message.
Hint

You might want to review the “Memoization” lessons from the last module.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
FavouriteColorProvider.js
Counter.js
ColorPicker.js
Preview
Refresh results pane
Console
Clear Console

Let's dig into this!

Note: In the video below, you might notice that there is no <p> showing the current count. I added this paragraph after recording the video, to make clear that the state shouldn't be moved into a child component. Sorry for any confusion!

Video Summary

Solution code
(success)

 Show more

Why are we using context here?
(warning)

In the “Context Syntax” lesson, I suggested using context when we find ourselves passing a prop “through” a component, over and over.

In this example, based on the code we have sitting in front of us, there isn't really a need for context. The favouriteColor state could be passed directly through props, and I think most folks would agree that things would be simpler that way.

But this is a contrived example. In order for us to focus on the mechanics of context, I decided to strip away all of the clutter.

Think of this as a scaled-down model, like a 1:8 scale React app. We're learning how to use context in this simplified setting, so that we can apply these skills in larger, more unwieldy codebases.

Memoizing the provider component?

One of the more common ideas, when trying to solve the mystery above, is to memoize the FavouriteColorProvider component, with React.memo.

This approach turns out to be pretty counter-intuitive. Let's discuss.

Video Summary

Here's the sandbox with our attempted solution, if you'd like to poke around:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
FavouriteColorProvider.js
Counter.js
ColorPicker.js
Preview
Refresh results pane
Console
Clear Console

---

## Modals

Source: /joy-of-react/04-component-design/09-modals

Modals

Just about every modern web application needs a good <Modal> component.

A modal is an in-window popup that displays a message. Sometimes, it has buttons to confirm an action, in which case it's often called a “dialog box”.

Click the button to open an example modal:

Toggle Modal

If you're reasonably comfortable with React and CSS, this sort of UI component might not seem too difficult. On the React side, we'll need an isOpen state variable and some conditional rendering. On the CSS side, a fixed-position parent with a centered child.

Modals are deceptively tricky, though. They have complex usability expectations and accessibility requirements.

Building a modal

In the sandbox below, you've been given an incomplete Modal component. Your job is to see how many issues you can find + fix.

This is an open-ended exercise. There's no acceptance criteria, because part of the challenge is seeing if you can spot the problems.

Some hints + tips:

Feel free to change any of the code, including the CSS — nothing is set in stone!
You're allowed to install + use NPM dependencies if you want. Click the “” icon to open this playground in CodeSandbox, where you'll be able to install whichever NPM packages you wish.
Not sure where to start? Try to use the modal without touching your mouse/trackpad, or check out the WAI-ARIA guidelines for modals/dialogs
.
If you'd prefer, you can skip straight to the video below, where we'll walk through the various issues and how to fix them.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Modal.js
Modal.module.css
use-toggle.js
VisuallyHidden.js
import React from 'react';
import { X as Close } from 'react-feather';

import styles from './Modal.module.css';

function Modal({ handleDismiss, children }) {
  return (
    <div className={styles.wrapper}>
      <div className={styles.backdrop} />
      <div className={styles.dialog}>
        <div
          className={styles.closeBtn}
          onClick={handleDismiss}
        >
          <Close />
        </div>
        {children}
      </div>
    </div>
  );
}

export default Modal;
Result
Console
Refresh results pane

Alright, let's dig into this!

Video Summary

In the video above, I reference a talk by Ryan Florence: “The Curse of React”
.

Here's our final implementation from the video:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Modal.js
Modal.module.css
use-toggle.js
VisuallyHidden.js
Result
Console
Refresh results pane

Leveraging the FocusLock component
(info)

In the video above, we saw how the <FocusLock> component from the react-focus-lock library will block the user from focusing elements outside the modal.

It turns out, this component can solve just about all of our focus-related problems for us as well!

It will automatically focus the first interactive child, when the component mounts, so we don't have to manually call .focus() on the close button.
By passing returnFocus={true}, this component will automatically restore focus, so we don't need to track document.activeElement ourselves.

Here's how our code can be simplified by leveraging this library:

function Modal({ title, handleDismiss, children }) {
- const closeBtnRef = React.useRef();
-
- React.useEffect(() => {
-   const currentlyFocusedElem = document.activeElement;
-
-   closeBtnRef.current.focus();
-
-   return () => {
-     currentlyFocusedElem?.focus();
-   };
- }, []);
-
  React.useEffect(() => {
    function handleKeyDown(event) {
      if (event.code === 'Escape') {
        handleDismiss();
      }
    }

    window.addEventListener('keydown', handleKeyDown);

    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [handleDismiss]);

  return (
-   <FocusLock>
+   <FocusLock returnFocus={true}>
      <RemoveScroll>
        <div className={styles.wrapper}>
          <div
            className={styles.backdrop}
            onClick={handleDismiss}
          />
          <div
            className={styles.dialog}
            role="dialog"
            aria-modal="true"
            aria-label={title}
          >
            <button
-             ref={closeBtnRef}
              className={styles.closeBtn}
              onClick={handleDismiss}
            >
              <Close />
              <VisuallyHidden>
                Dismiss modal
              </VisuallyHidden>
            </button>
            {children}
          </div>
        </div>
      </RemoveScroll>
    </FocusLock>
  );
}

(This view is known as a “diff”, and it shows how code changes compared to a previous version. Lines that start with  -  are removed, whereas lines that start with  +  are added.)

To be clear, I don't think it was a waste of time for us to solve this problem manually. Knowing how to manage focus is a really handy skill as a React developer! Libraries won't be able to help us in every case.

But, in cases where they can be used, it's generally a good idea to rely on them.


---

## Exercises

Source: /joy-of-react/04-component-design/09.01-modal-exercises

Exercises
Hamburger navigation

Over the past few years, a common convention has emerged: the hamburger menu.

Clicking or tapping the hamburger icon will open a navigation menu. This pattern is especially common on mobile, but can be found on some desktop sites as well.

Below, you'll find an app with an incomplete hamburger menu. Your job is to finish implementing it, taking care to consider the usability and accessibility of this feature.

Acceptance Criteria:

While the menu is open, focus should be trapped within the modal (you can use the provided FocusLock component).
When the menu is closed, focus should be restored to the last-focused element.
While the menu is open, scrolling should be disabled (you can use the provided RemoveScroll component).
Hitting "Escape" should close the menu.
Clicking the backdrop should close the menu.
The markup should be structured correctly, for screen-reader users. Here are some links to help you out:
ARIA Menu Button Pattern
Example HTML implementation

NOTE: We don't want to automatically focus the dismiss button when the menu opens, like we did in the previous “Modals” lesson. We'll discuss in the solution video below.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
ImageGallery.js
Header.js
Drawer.js
Header.module.css
Drawer.module.css
use-toggle.js
VisuallyHidden.js
import React from 'react';
import { Menu } from 'react-feather';

import useToggle from './use-toggle';
import Drawer from './Drawer';
import styles from './Header.module.css';

function Header() {
  const [isMenuOpen, toggleIsMenuOpen] = useToggle(false);

  return (
    <header>
      <a href="">Kaboom</a>

      <div>
        <button
          className={styles.hamburgerBtn}
          onClick={toggleIsMenuOpen}
        >
          <Menu />
        </button>
        {isMenuOpen && (
          <Drawer handleDismiss={toggleIsMenuOpen}>
            <ul className={styles.navigationList}>
              <li>
                <a href="">Home</a>
              </li>
              <li>
                <a href="">Gallery</a>
              </li>
              <li>
                <a href="">Photographers</a>
              </li>
              <li>
                <a href="">Submit Work</a>
              </li>
Result
Console
Refresh results pane

Solution:

Tabbing issues?
(warning)

If you're using Firefox or certain versions of Safari on macOS, you might notice that you're not able to tab through the navigation links. This is because tabbing works differently on these browsers; you need to hold Option while tabbing to cycle through links.

You can learn more in this article: No, Tabbing Is Not Broken
.

Solution code
(success)

 Show more

---

## Unstyled Component Libraries

Source: /joy-of-react/04-component-design/10-unstyled-libraries

Unstyled Component Libraries

So, earlier in this module, we talked about how component libraries like React Bootstrap and Material UI aren't often used by product companies, because they come with their own built-in design system.

As we've come to learn, however, building UI components from scratch can be surprisingly challenging. Libraries like Material UI come with robust, battle-tested components for things like modals, autocompletes?, and dropdowns.

Fortunately, we can separate the baby from the bathwater with unstyled component libraries.

Simply put, these libraries are focused purely on the mechanics and usability. Often, accessibility is a first-class concern. They have no built-in design system, and the few styles that are included can easily be overridden.

Let's talk about some of the most popular options.

Mix and match!
(info)

Because these libraries are unstyled, you don't need to pick one and stick with it. We can "mix and match" components from multiple libraries!

But won't it bloat our JavaScript bundles to depend on multiple component libraries? Fortunately not! All of the libraries we're going to talk about here support “tree-shaking”, which means our bundles only include the specific components we import. There might be some small additional cost from mixing components from multiple libraries (eg. if they depend on different lower-level packages), but this has been pretty minimal in my experience.

Why would we want to mix and match? I can think of two good reasons:

We can assemble our own bespoke? collection of our favourite components.
If the package we choose becomes unmaintained, we can gradually migrate to a newer solution, one component at a time. We don't have to drop everything else and spend weeks moving everything over!
Reach UI

Reach UI
 is one of the earliest libraries in this category, and the one I've used the most in my projects.

It was created by Ryan Florence, and it has a heavy focus on accessibility. As he was building this library, he spent an hour or two every day using a screen reader, learning how the software works in order to build robust, usable components.

Ryan Florence
@ryanflorence

"What does your dad do for work?"

My kids: "Lately, his computer just talks to him in weird fast voices and he has his eyes closed"

Sept 4, 2018

427
6 people are Tweeting about this

Unfortunately, it hasn't been actively maintained recently. It has not been updated since React 18 was released
*
, and the sole remaining maintainer has been suggesting that folks use a different option.

Radix Primitives

Radix Primitives
 is a library of unstyled, accessible components. It's an incredibly rich library, with a ton of components I've never seen anywhere else.

For example, <ContextMenu>, for building right-click context menus
:

(In their docs
, the components are shown with styles, but those styles aren't actually included with the component library, they're for demonstration purposes only.)

It's maintained by the team at WorkOS
, and I've been very impressed with the team. I opened an issue
 with an accessibility concern, and it was addressed super quickly.

This is my first choice right now, my primary recommendation. On this course platform, I plan on gradually moving over from Reach UI to Radix Primitives. I've had nothing but good experiences so far.

Headless UI

Headless UI
 is another unstyled, accessibility-focused component library.

It's maintained by the team at Tailwind Labs, and is primarily intended to be used with Tailwind (though this absolutely isn't a hard requirement!).

Interestingly, Headless UI contains bindings for both React and Vue. If you happen to work with both tools across different projects, this could come in handy!

This library includes a relatively modest collection of components; as I write this, Headless UI has 10 components, while Radix Primitives has 31. But each included component is well-thought-out, and a joy to use.

Ariakit

Ariakit
 is yet another accessible unstyled component library.

It's built by Diego Haz, creator of Reakit
. Ariakit is essentially a spiritual successor to this earlier library.

Of all the libraries in this list, I know the least about Ariakit. It offers 23 components, and from what I can tell, they seem to offer a really nice API! Interestingly, they offer custom hooks that let you access the internal state of their components.

I'm excited to see how this library develops over time!

Base UI

Base UI
 is an unstyled component library for React.

The cool thing about Base UI is that it's built by the Material UI team, and is essentially an unstyled version of Material UI, one of the most popular component libraries for React.

Material UI is (I believe) the most widely-used component library in the entire React ecosystem. Millions of internet users interact with Material UI components every day, finding and reporting edge-case bugs. Since Material UI uses Base UI internally, we get all of the benefits of that battle testing, without having to adopt any of the Material UI styles.

I haven't personally used Base UI yet myself, but I think it's likely a great choice!

React Aria

The final library I'd like to talk about is a bit different — it's not actually a component library. It's lower-level than that.

React Aria
 is a library of React custom hooks that can be used to build a component library. It's created and maintained by Adobe.

Adobe also has a separate library, React Spectrum
. React Spectrum is a styled component library, using Adobe's design system. Interestingly, React Spectrum is built using React Aria.

The idea is that we could build our own component library, using our own design system, by leveraging the suite of custom hooks provided by React Aria.

I think this is a great tool for larger teams and companies who can invest hundreds of hours into building a super-custom and fully-accessible component library. For smaller teams and solo developers, however, I'd probably opt for one of the other options in this list.


---

## Converting Our Modal

Source: /joy-of-react/04-component-design/10.01-leveraged-modal

Converting Our Modal

Video Summary

Built using Headless UI v1
(warning)

In the video above, I use Headless UI v1.7.3. Since filming this video, Headless UI has released their 2.0 version, which includes several breaking changes.

The playgrounds below are still using 1.7.3, which means you’ll notice some discrepancies if you compare the code to their current docs. You can check the older version of their docs
 if you’d like to experiment with the code below.

Here's the starting code from the video, with our original home-grown modal implementation:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Header.js
Modal.js
Modal.module.css
LoginForm.js
LoginForm.module.css
import React from 'react';
import { X as Close } from 'react-feather';
import FocusLock from 'react-focus-lock';
import { RemoveScroll } from 'react-remove-scroll';

import VisuallyHidden from './VisuallyHidden'
import styles from './Modal.module.css';

function Modal({ title, handleDismiss, children }) {
  React.useEffect(() => {
    function handleKeyDown(event) {
      if (event.code === 'Escape') {
        handleDismiss();
      }
    }

    window.addEventListener('keydown', handleKeyDown);

    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [handleDismiss]);

  return (
    <FocusLock returnFocus={true}>
      <RemoveScroll>
        <div className={styles.wrapper}>
          <div
            className={styles.backdrop}
            onClick={handleDismiss}
          />
          <div
            className={styles.dialog}
            role="dialog"
            aria-modal="true"
            aria-label={title}
Result
Console
Refresh results pane

…and here's the converted code, using the Headless UI library:

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Header.js
Modal.js
Modal.module.css
LoginForm.js
LoginForm.module.css
Result
Console
Refresh results pane

---

## Exercises

Source: /joy-of-react/04-component-design/10.02-library-exercises

Exercises
Building a FAQ

Let's suppose we're building a “Frequently Asked Questions” component:

On the surface, this sort of UI component might seem straightforward, but there are a bunch of usability/accessibility concerns here. Rather than try to tackle them all ourselves, we'll use the Radix Primitive “Accordion” component
.

Your mission is to use this component to implement the Frequently Asked Questions.

Acceptance Criteria:

Using the Accordion component
 from Radix Primitives, wire it up so that we see the 4 Kendama-related questions. Clicking the question should reveal the answer.
The component should be styled so that it matches the example above. The classes are provided in FrequentlyAskedQuestions.module.css, but you'll need to apply them to the correct elements.
No key warnings should be present in the console.
Hint

Each Accordion sub-component has its own set of props. Some of these props are required. Required props are marked with an asterisk. You can learn all about them in the “API Reference” section
.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
FrequentlyAskedQuestions.js
FrequentlyAskedQuestions.module.css
import React from 'react';
import * as Accordion from '@radix-ui/react-accordion';

import styles from './FrequentlyAskedQuestions.module.css';

function FrequentlyAskedQuestions({ data }) {
  return (
    "TODO!"
  );
}

export default FrequentlyAskedQuestions;
Result
Console
Refresh results pane

Solution:

Solution code
(success)

 Show more
Stretch goal: Add an icon

Most accordions like this have a caret or chevron that swivels when the item is expanded. It's a nice little detail that makes clear what the expected interaction is.

Update your solution to include a chevron:

For the icon, you can use the ChevronDown icon from React Feather:

import { ChevronDown } from 'react-feather';

To flip it to an upwards-pointing chevron, you can apply the following CSS:

svg {
  transform: rotate(180deg);
}

This is a tricky problem, But the docs should help. Be sure to check out the “Styling” page
 from the Radix Primitives docs!

Solution:

Solution code
(success)

 Show more
Building a Tooltip

On this course platform, I have an Asterisk component that I use to tuck additional contextual information out of the way. For example, this one:
*

Try to focus or hover over that asterisk, and you'll see a tooltip pop up with an interesting bird fact.

In this exercise, we're going to implement this component using the “Tooltip” component
 from Radix Primitives.

Acceptance Criteria:

Focusing or hovering over the asterisk should show the tooltip, containing the provided children.
When hovering, the tooltip should show after 200ms.

Code Playground

STRICT MODE
Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
Asterisk.js
Asterisk.module.css
Result
Console
Refresh results pane

Solution:

Correction: we do need the portal!
(warning)

In the video above, I get rid of the <Tooltip.Portal> element, claiming that it's not necessary in this example. Unfortunately, I was mistaken about this! When we omit the Portal, we wind up with a warning in the console:

Warning: validateDOMNesting(...): <div> cannot appear as a descendant of <p>.

The problem is that we're using this <Asterisk> component within a paragraph (<p>), and the <Tooltip.Content> component produces a <div>. Divs aren't allowed inside paragraphs, according to the HTML specification.

The solution is to keep the <Tooltip.Portal> element from the Radix example code. This element “teleports” the tooltip content so that it's not within the paragraph anymore.

The solution code below has been amended with this fix.

We'll learn all about portals in the next module.

Solution code
(success)

 Show more

A more appropriate component
(info)

I recently learned that tooltips, semantically, are meant to provide context for a button (it's a tip about a tool).

The more semantically appropriate component for the Asterisk use case would be a Popover
. A popover is a generic UI element that "pops over" something else.

Anecdotally, both components seem to work equally well, including in terms of keyboard navigation + screen reader support, but I'm not an accessibility expert. If you're implementing a similar component yourself, I'd recommend using Radix's Popover
 component instead.

