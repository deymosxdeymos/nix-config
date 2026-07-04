# CSS for JS - Bonus

---

## Intro to Figma

Source: /css-for-js/bonus/01-intro-to-figma

Intro to Figma

Figma is a vector graphics tool, similar to Sketch or Adobe Illustrator. Over the past few years, Figma has taken the design community by storm; It's the “React” of the design world.

Historically, it hasn't made a ton of sense for developers to learn to use design tools, but Figma has changed that — even if we have no interest in UI/UX design, learning to use Figma can make us better developers!

Learn why and how in this quick video:

Figma updates
(warning)

In late 2024, Figma refreshed its UI:

The biggest change is that the toolbar is now centered along the bottom, rather than being in the top left. For our purposes — using Figma to extract information about the design — things are relatively stable, and you shouldn’t have too much trouble.


---

## Intro to React

Source: /css-for-js/bonus/02-intro-to-react

Intro to React

Play with the final code from this video on CodeSandbox:
codesandbox.io/s/intro-to-react-pqdof

This video covers:

Why it's important to learn a little bit of React, even if you're not interested in becoming a React developer.
How JSX differs from HTML
How to set inline styles in JSX
Why components are so great
Creating custom components
Adapting components to data with props
The children prop

I forgot to mention something pretty significant in the video: the children prop.

Let's say we're building an IconButton component. It renders a button with an icon in it:

GO HOME

Here's one way we could structure this component:

function IconButton({ icon, contents }) {
  return (
    <button className="IconButton">
      <Icon icon={icon} />
      {contents}
    </button>
  );
}

// We would render it like this:
<IconButton
  icon="home"
  contents="Go home"
/>

Our component takes two props, icon and contents. These are the two things that are variable, from one instance to the next.

But when we think about HTML, though, that's not actually how we would do it! The "content" is usually placed between the open tag and the close tag.

Here's another way we can write it:

function IconButton({ icon, children }) {
  return (
    <button className="IconButton">
      <Icon icon={icon} />
      {children}
    </button>
  );
}

// We would render it like this:
<IconButton icon="home">
  Go home
</IconButton>

This is syntactic sugar?: React is forwarding anything we pass between the tags to the children prop, to mimic HTML.

Additional resources
I have another course, The Joy of React
! It's intended to be a beginner-friendly way to learn React, and to become comfortable building web applications with it.
the official documentation
 was updated in 2023, and is an incredibly useful resource.
Ali Spittel's “The Beginner's Guide to React” (2020 version)
 is a much more thorough introduction to React, and the best free resource I've found!
FreeCodeCamp has a free React Beginner's Handbook
, written by Flavio Copes.

Making sense of JSX
(info)

Let's face it: Having fake-HTML inside our JS is a weird thing, and it feels absolutely mystical at first.

You don't need to understand how this works in order to work through the materials in this course (or even to become a proficient React developer!). That said, I know that it can be a puzzling enigma, and some developers will want to understand how it works in order to feel comfortable using it.

 Show more

