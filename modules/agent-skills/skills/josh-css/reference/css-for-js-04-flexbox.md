# CSS for JS - Module 4: Flexbox

---

## Hello Flexbox! • Josh W Comeau's Course Platform

Source: /css-for-js/04-flexbox/01-hello-world

Flexbox

To summarize:

Flexbox is one of many “layout modes” in CSS, like Flow layout or Positioned layout.
Flexbox is most handy when we have a set of things, and we want to control their distribution along a primary axis, either horizontally or vertically.
Flexbox is still relevant, even with CSS Grid reaching wide browser support. It's a different tool for a different job: CSS Grid works best for two-dimensional layouts, while Flexbox offers more flexibility for working with a single dimension.
When we apply display: flex to an element, we toggle the "Flexbox" layout algorithm for the element's children. The parent element will still use Flow layout.

Browser support
(warning)

In the video, I mention that CSS Grid isn't supported in Internet Explorer, but it turns out, I was mistaken! CSS Grid is supported in IE 10 and 11, though it relies on an incomplete, older version of the specification, and so using it can be a challenge. Flexbox works more consistently across all browsers.


---

## Directions and Alignment

Source: /css-for-js/04-flexbox/02-cardinality

Directions and Alignment

Here's a look at the CSS produced in this video:

.wrapper {
  display: flex;
  flex-direction: row; /* row, column */
  justify-content: flex-start; /* flex-end, space-between… */
  align-items: stretch; /* flex-end, baseline… */
}

The video uses an interactive demo unit to explore different property combinations. You can play with it yourself here:

Hello
to
the
World
Primary axis
Cross axis
flex-direction: row
flex-direction: column
flex-direction: row
Show axis labels
justify-content: flex-start
justify-content: flex-end
justify-content: center
justify-content: space-between
justify-content: space-around
justify-content: space-evenly
justify-content: flex-start
align-items: stretch
align-items: flex-start
align-items: flex-end
align-items: center
align-items: baseline
align-items: stretch
Exercises
Dialog actions

Update this dialog so that the buttons are spaced at either end of the dialog:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

Centered

Update this playground so that our golden marble sits in the very center of the viewport:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

Equally-spaced nav items

Let's create a responsive navigation! On mobile, the items should be stacked vertically. When the viewport exceeds 300px, the items should spread out in a row, with equal spacing.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

The final code from the video:

<style>
  ul {
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  a {
    display: block;
    padding: 8px;
  }

  @media (min-width: 300px) {
    ul {
      flex-direction: row;
      justify-content: space-evenly;
    }
  }
</style>

---

## Alignment Tricks

Source: /css-for-js/04-flexbox/03-alignment-tricks

Alignment Tricks

Flexbox gives us a couple pretty neat tricks when it comes to alignment. Let's learn a couple.

Baseline alignment

A common UI pattern involves having the site's logo right before the primary navigation:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  ul {
    display: flex;
    justify-content: space-evenly;
    align-items: center;
  }
</style>

<nav>
  <ul>
    <li>
      <div class="logo">Tom's</div>
    </li>
    <li>
      <a href="">Home</a>
    </li>
    <li>
      <a href="">Browse</a>
    </li>
  </ul>
</nav>
Result
Refresh results pane

In this example, we've vertically aligned the items to center, but it doesn't quite look right, does it?

The trouble is that align-items: center isn't what we want in this case. Instead, we want to make sure the bottoms of each character are aligned, as they would be if they were written on a page.

This can be done with align-items: baseline:

Remarkably, this “just works” even if there are multiple DOM levels. It even works with specialized HTML elements like inputs and buttons. Here's a more complex example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Watch out for Safari!
(warning)

In older versions of Safari, baseline alignment was buggy when working with empty text inputs.

For example, suppose we have the following setup:

We’re using align-items: baseline to neatly align the input’s label with the input’s content. Unfortunately, when that input is empty, the alignment shifts:

Fortunately, this bug was fixed in Safari 26, released in September 2025. That said, as I write this in early 2026, there are still tons of Apple users who haven’t updated to the very latest browser/OS, so it’s not quite something we can ignore just yet.

Until then, the easiest solution is to add placeholder text! As long as the input has a placeholder, baseline alignment will still function correctly. If you don’t want to include any visible placeholder text, you can set it to a single whitespace character:

<input
  type="text"
  placeholder=" "
/>
Centered AND baseline?

Here's an interesting thought experiment: What if we wanted to combine baseline and center alignment, so that the tallest item would be vertically centered, and then all siblings would be aligned to its baseline?

Spend a couple minutes giving it a shot. Treat it as an open-ended exercise (there is no "right answer").

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Once you've given it a shot, see how I did it here:

No more <h1>
(warning)

In the video above, the site name (“Tommy's”) is an <h1>. This doesn't match the playground, where the site name is inside a <div class="logo">.

Semantically, it wasn't quite right for this to be an h1. Our pages should only have a single <h1> element, and it should reflect the name of the page. The site name is the same across every page, and so it doesn't tell the user anything about what each specific page is about.

Sorry for any confusion!

Align self

So far, we've been aligning all children in a group. But what if we want specific children to have specific alignments?

Flexbox gives us the align-self property to manage this situation!

Here's an example. Notice that the first item sticks to the start of the container, while all other children are centered:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Our interactive Flex widget has been updated, so that the final item ("World") can be given align-self. Check it out:

Hello
to
the
World
Primary axis
Cross axis
flex-direction: row
flex-direction: column
flex-direction: row
justify-content: flex-start
justify-content: flex-end
justify-content: center
justify-content: space-between
justify-content: space-around
justify-content: space-evenly
justify-content: flex-start
align-items: stretch
align-items: flex-start
align-items: flex-end
align-items: center
align-items: baseline
align-items: stretch
align-self: stretch
align-self: flex-start
align-self: flex-end
align-self: center
align-self: baseline
align-self: flex-end
What about justify-self?

align-self allows us to pick specific alignment options for each individual item along the cross (secondary) axis. But what about the primary axis?

Unfortunately, justify-self doesn't exist in Flexbox. And if you think about it, it kinda makes sense that it wouldn't! In fact, it's good that it doesn't exist.

We can solve for primary-axis positioning using other properties we'll discover, like flex-grow, flex-shrink, flex-basis, and order. These properties offer much more flexibility than justify-self would!

We'll learn all about these properties in the lessons ahead.

Exercises
Conversation

Let's build an iMessage-style chat interface!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

Small correction: We shouldn't add height: 100%. The ol already has min-height: 100% in the CSS, which will allow it to expand if there are too many messages to fit.

<style>
  ol {
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
  }

  .message.sent {
    align-self: flex-end;
  }
</style>

To make this implementation production-ready, we'd also want to add some JavaScript that automatically scrolls down when the page loads / on new messages, since newer messages are appended to the end, and they might be out of the viewport if there's a larger message history. This is beyond the scope of this exercise.


---

## Growing and Shrinking

Source: /css-for-js/04-flexbox/04-grow-shrink-basis

Growing and Shrinking

Here's the demo unit from the video:

Hello World!
Each item
now contains
several words.
Primary axis
Cross axis
flex-direction: row
flex-direction: column
flex-direction: row
Show axis labels
justify-content: flex-start
justify-content: flex-end
justify-content: center
justify-content: space-between
justify-content: space-around
justify-content: space-evenly
justify-content: flex-start
align-items: stretch
align-items: flex-start
align-items: flex-end
align-items: center
align-items: baseline
align-items: stretch

To keep things straightforward, these demo units don't have controls for every possible Flex property, but you can follow my example in the video and tweak additional properties using the browser devtools!

Takeaways
There are two important sizes when dealing with Flexbox: the minimum content size, and the hypothetical size.
The minimum content size is the smallest an item can get without its contents overflowing.
Setting width in a flex row (or height in a flex column) sets the hypothetical size. It isn't a guarantee, it's a suggestion.
flex-basis has the same effect as width in a flex row (height in a column). You can use them interchangeably, but flex-basis will win if there's a conflict.
flex-grow will allow a child to consume any excess space in the container. It has no effect if there isn't any excess space.
flex-shrink will pick which item to consume space from, if the container is too small. It has no effect if there is any excess space.
flex-shrink can't shrink an item below its minimum content size.

This is a lot of takeaways, so don't feel bad if it's hard to remember them all! Feel free to revisit this video as-needed to get a refresher.

Correction: There is one more difference between width and flex-basis: flex-basis can't scale an element below its minimum content size, but width can. Consider this example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Both width and flex-basis will change the hypothetical size of an element, but width can set that value below the minimum content size. flex-basis can't.

Ratios

When we use flex-grow and flex-shrink, we use unitless values like 1 or 10. What do these numbers signify?

They represent a ratio of the available space.

Let's say we have the following markup:

<style>
  .row {
    display: flex;
  }

  nav, aside {
    flex-grow: 1;
  }

  main {
    flex-grow: 3;
  }
</style>

<div class="row">
  <nav></nav>
  <main></main>
  <aside></aside>
</div>

We want the main element to consume 3 times as much space as nav or aside. It gets 3 "units" of space, whereas nav and aside only get 1 unit.

To find out the actual percentage, add all the numbers together. In this example, there are 5 units total (1 + 3 + 1). That means that nav and aside each get 20% of the total space (1 / 5), whereas main gets 60% (3 / 5).

Similarly, flex-shrink is also based on the ratios between elements. An element with flex-shrink: 3 will shrink 3x faster than an element with flex-shrink: 1 (though flex-shrink also takes the element's size into consideration).

Exercises
Sidebar

Let's build a common web layout: A main content area with a navigation sidebar.

We want to prioritize the main content area by keeping it as large as possible once the viewport shrinks.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Solution:

Alert

Let's suppose we're building an Alert component for our component library:

Everything looks great when the element has some breathing room, but things take a turn when there isn't enough space for the heading:

Specifically, there are two issues we want to fix:

The icon gets squashed, becoming an oval.
The icon gets center-aligned instead of sticking near the top.

Update the code so that it appears like this on smaller sizes:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Solution:

An alternative solution
(success)

Instead of setting flex-shrink: 0, we can also solve this problem by changing width to min-width:

const IconWrapper = styled.div`
  min-width: 40px;
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
  background: forestgreen;
  color: white;
  border-radius: 50%;
  margin-right: 8px;
`;

This solves the problem, and for many developers it feels more intuitive / simpler, but I'd actually argue that it's a less direct way of solving the problem.

Our icon gets squashed thanks to the Flexbox shrinking algorithm, and we want to prevent that behaviour. Setting flex-shrink: 0 essentially says "Hey, I don't want this fella to shrink!".

I think there's a risk here of confusing “simple” for “familiar”. When I was first getting acquainted with flex-shrink, I had already had years of experience using min-width, and so it seemed to me like flex-shrink: 0 was an over-engineered solution. But as I've gotten more comfortable with the Flexbox algorithm, it actually feels more straightforward to me to use flex-shrink in this situation.

I'd say once you reach the point where both approaches feel intuitive, you should use whichever you prefer. They both work, after all! But if the flex-shrink approach feels more complicated, I'd encourage you to keep practicing with it, and build that muscle!


---

## The “flex” Shorthand

Source: /css-for-js/04-flexbox/05-flex-shorthand

The “flex” Shorthand
Add Note

Here's the Flex demo from the video:

Hello World!
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.
Primary axis
Cross axis
flex-direction: row
flex-direction: column
flex-direction: row
Show axis labels
justify-content: flex-start
justify-content: flex-end
justify-content: center
justify-content: space-between
justify-content: space-around
justify-content: space-evenly
justify-content: flex-start
align-items: stretch
align-items: flex-start
align-items: flex-end
align-items: center
align-items: baseline
align-items: stretch

To keep things straightforward, these demo units don't have controls for every possible Flex property (eg. flex), but you can follow my example in the video and add custom properties using the devtools!

Takeaways
flex takes 3 individual values:
flex-grow, as a unitless value (eg. 1)
flex-shrink, as a unitless value (eg. 5)
flex-basis, as a length unit (eg. 200px)
By default, flex-grow will distribute any extra space that isn't taken up by the elements.
flex: 1 will assign flex-grow: 1, but it will also set flex-basis: 0. It won't affect the default value for flex-shrink, which is 1.
Since flex-basis is a synonym for width in a flex row, we're effectively shrinking each child to have a “hypothetical width” of 0px, and then distributing all of the space between each child.

That last takeaway is summarized handily by this graphic, courtesy of the W3C:

Exercises
Cat Newspaper

Let's imagine we're building a newspaper for cats.

It should consist of 3 columns of equal width and height. As the viewport shrinks, the images should scale down:

Note: When the viewport is really small, like it is in the non-fullscreened playground, you may find that the columns overflow / become asymmetrical. You can ignore this problem for now and focus on larger viewports; we'll talk about the really-narrow-viewport issue below.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

Addendum:

On smaller screens, this solution doesn't quite work… In this addendum, we'll talk about why it doesn't work, and learn about an important Flexbox principle:


---

## Constraints

Source: /css-for-js/04-flexbox/06-constraints

Constraints

We've seen how properties like flex-grow, flex-shrink, and flex-basis can be used to control the proportions between siblings in a flex container.

What if we want to set hard limits, though, rather than ratios?

Fortunately, a familiar set of properties can help us out here: min-width/max-width and min-height/max-height.

In a flex row, flex-basis works just like width, and it also respects the constraints set by min-width and max-width.

For example: say we have three children with their own ratios, but we want to clamp each one to a minimum width of 75px. Try resizing this playground to see the effect:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper{
    display: flex;
  }
  .biggie {
    flex: 2;
    min-width: 75px;
  }
  .tiny {
    flex: 1;
    min-width: 75px;
  }
</style>

<section class="wrapper">
  <div class="biggie"></div>
  <div class="tiny"></div>
  <div class="tiny"></div>
</section>
Result
Refresh results pane

We're effectively changing the “minimum content size” to be a hardcoded value, rather than relying on the size of the element's children.

We can also use max-width to clamp an element's growth! And, in a column, min-height and max-height work the same way.

Exercises
Sidebar layout

Time for another content + sidebar layout, but this time, with different constraints!

Here are the rules:

Items should be horizontally centered
The nav should be 1/3rd of the total space, but no more than 150px
The main content should max out at 500px

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

Facebook-style layout

On their desktop application, Facebook has a 3-column layout. I've added some borders so we can see how the columns flex (as well as a blur, to protect the anonymity of my Facebook friends!):

It's a 3 column layout, and below a certain threshold, the left-hand navigation disappears. It's interesting how things scale, though!

See if you can recreate this effect in the playground below. The media query that hides the sidebar has already been applied.

For our version of it, the nav and sidebar should be the same size, and should range between 150px and 250px.

More than meets the eye
(warning)

At first glance, this might not seem like a particularly challenging problem, but the devil is in the details.

Specifically, watch what happens towards the end of the video, right after the left-hand sidebar disappears. Pay careful attention to how the two remaining columns resize as the viewport shrinks. You can scrub through the video to get a precise look.

Honestly, this is a surprisingly complex exercise, involving some out-of-the-box thinking with flex-shrink and minimum content sizes. It's intended to be a terrific challenge, and I think it's super valuable even if you can't solve it (especially if you can't solve it, actually).

In the solution video, we'll dig deep into how this works.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

The code from the solution:

.wrapper {
  display: flex;
}
nav, aside.contacts {
  min-width: 150px;
  max-width: 250px;
  flex-shrink: 9999999;
  flex-basis: 250px;
}
main {
  flex: 1;
  flex-basis: 500px;
}

@media (max-width: 700px) {
  nav {
    display: none;
  }
}

It's more common to use the flex shorthand, likely because it's what the specification recommends. Here's what that looks like:

.wrapper {
  display: flex;
}
nav, aside.contacts {
  min-width: 150px;
  max-width: 250px;
  flex: 0 999999 250px;
}
main {
  flex: 1 1 500px;
}

@media (max-width: 700px) {
  nav {
    display: none;
  }
}

Is “max-width” really necessary?
(info)

Several students have asked: Do we really need to specify max-width: 250px on the two sidebars? The solution seems to work without it!

It actually does make sense that it wouldn't be necessary in this case: we're setting its hypothetical size (via flex-basis) to 250px, and we haven't told it to grow (no flex-grow), so it doesn't have any reason to get bigger than 250px!

In other words, we're constraining it (with max-width), but it isn't trying to push past that limit anyway!

That said, in a real app, I'd probably add the max-width anyway. There may be some edge-cases where it can make a difference (eg. depending on the content within these columns), and a little redundancy never hurt!


---

## Shorthand Gotchas

Source: /css-for-js/04-flexbox/07-shorthand-gotcha

Shorthand Gotchas

There is a really common gotcha when it comes to using the flex shorthand. I've been bitten by it countless times.

Let's explore in this video:

To summarize: when we use the flex shorthand, we set flex-basis to 0, and this value will override any width you set. In other words, width has no effect in this snippet (when used inside a flex-direction: row container):

.item {
  flex: 1;
  width: 200px;
}

To prevent this unwanted surprise, we should instead use flex-basis. And if you need to set either flex-grow or flex-shrink, you should use the shorthand:

.item {
  flex: 1 1 200px;
}

---

## Wrapping

Source: /css-for-js/04-flexbox/08-wrapping

Wrapping

In Module 1, we saw how inline elements in Flow layout have a super-power: they can line-wrap. Like a sushi roll getting chopped into pieces, inline elements can be broken up to spread over multiple lines.

In Flexbox, a similar concept exists, via the flex-wrap property.

Let's learn more about how it works:

Here's the final result from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  main {
    display: flex;
    flex-wrap: wrap;
  }
  article {
    flex: 1 1 150px;
    max-width: 250px;
  }
  article img {
    width: 100%;
  }
</style>

<main>
  <article>
    <img src="https://courses.joshwcomeau.com/cfj-mats/dog-one-300px.jpg" />
    <section>
      <h2>The One Weird Trick to get tasty dinner scraps</h2>
      <p>Step one: Find the friendliest human at the dinner table. Step two: Give them sad pupper eyes. Step 3: Get slid human food on the sly.</p>
    </section>
  </article>
  <article>
    <img src="https://courses.joshwcomeau.com/cfj-mats/dog-two-300px.jpg"
    />
    <section>
      <h2>How to show them you mean business</h2>
      <p>Every dog park has their own scene. Different cliques. If you want to make a name for yourself, you'll need to make a good first impression…</p>
    </section>
  </article>
  <article>
    <img src="https://courses.joshwcomeau.com/cfj-mats/dog-three-300px.jpg" />
    <section>
      <h2>Life in the outdoors</h2>
      <p>We purchased and tested the 10 best outdoors accessories so you don't have to. Here's what we found…</p>
    </section>
Result
Refresh results pane
Content vs. items

Here's the demo unit from this video:

Primary axis
Cross axis
flex-direction: row
flex-direction: column
flex-direction: row
justify-content: flex-start
justify-content: flex-end
justify-content: center
justify-content: space-between
justify-content: space-around
justify-content: space-evenly
justify-content: flex-start
align-items: stretch
align-items: flex-start
align-items: flex-end
align-items: center
align-items: baseline
align-items: flex-start
align-content: stretch
align-content: flex-start
align-content: flex-end
align-content: center
align-content: baseline
align-content: flex-start

Two dimensions
(info)

Before this lesson, all of the examples we've seen have existed in a single dimension. flex-wrap allows us to dip our toes into two-dimensional layouts.

Ultimately, however, we aren't going to go too deep into this. The reason is that CSS Grid offers a more compelling story for two-dimensional layouts.

CSS Grid is well-supported in all major browsers, but not in Internet Explorer. If you still need to support IE, I'd suggest having a reasonable fallback for that browser (eg. instead of placing things in a grid, stack elements in a large column). Supporting a browser does not mean that the experience has to be 100% identical.

Exercise
Deconstructed Pancake

Here's a layout I bet you've seen on marketing pages before:

Now we could solve this with media queries, but I'd rather solve it using Flexbox. We should be able to use flex-wrap to reconstruct this effect!

Give it a shot:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

This layout is known as the “Deconstructed pancake”
.


---

## Groups and Gaps

Source: /css-for-js/04-flexbox/09-gaps

Groups and Gaps

Update: The gap property has landed in Safari
, and is now safe to use across all modern browsers!

Sandbox from this video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import styled from 'styled-components';

function Header() {
  return (
    <Wrapper>
      <Logo>My Thing</Logo>
      <AuthButton>Log in</AuthButton>
      <AuthButton>Sign up</AuthButton>
    </Wrapper>
  );
}

const Wrapper = styled.header`
  display: flex;
  gap: 8px;
`;

const Logo = styled.a`
  font-size: 1.5rem;
  margin-right: auto;
`;

const AuthButton = styled.button``

export default Header;
Result
Console
Refresh results pane
Exercises
Superheader

A lot of e-commerce sites feature a "superheader" — a header that sits above the main site header, advertising deals or providing secondary navigation.

In this exercise, we'll create our own version of that:

The search input and language toggle should be right-aligned, with the "Free shipping" text staying on the left. This should be done entirely through CSS, no markup changes.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

Photo viewer

Alright, let's build something more complex.

In this exercise, we'll build a "photo viewer". A vertical strip of photos shows the available options, and a larger photo displays the current selection.

It should scale with the viewport size, as shown:

NOTE: We're focusing exclusively on the styles. The functionality of selecting photos is not included.

Hint

You might notice that the main image doesn't quite align with the buttons. If you run into this issue, you may wish to revisit the “Flow Layout” lesson from Module 1.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:


---

## Ordering

Source: /css-for-js/04-flexbox/10-ordering

Ordering

By default, Flexbox arranges its items based on their DOM order, the same way things work in Flow layout. But in Flexbox, we are given overrides to tweak that order.

There are several ways to accomplish this, but we'll focus primarily on flex-direction.

Flipping flex-direction

We've seen how Flexbox has a flex-direction property: we use it to control whether our container's primary axis is vertical or horizontal.

There are two other values we can use as well:

row-reverse
column-reverse

As you might expect, this property flips the order so that they stack from last to first:

1
2
3
4
Primary axis
Cross axis
flex-direction: row
flex-direction: column
flex-direction: row-reverse
flex-direction: column-reverse
flex-direction: row-reverse
Show axis labels

This works by swapping flex-start and flex-end; when working in English, a Flex row typically starts on the left and ends on the right. flex-direction: row-reverse flips this on its head.

This does have a surprising side-effect: things will appear right-aligned instead of left-aligned. This is because we aren't just changing the order of the elements, we're changing the direction of the axis. A reversed row starts on the right, and ends on the left (in a left-to-right language like English).

If we want to flip the order of children without changing their alignment, we can do so with justify-content:

.row {
  flex-direction: row-reverse;
  justify-content: flex-end;
}

Visual order only!
(warning)

When we flip the order of flex children, it's important to know that we're only changing things cosmetically.

For users who navigate with the keyboard and/or use a screen reader, they'll still be going through items in the order laid out in the DOM / written in your HTML. row-reverse and column-reverse don't change anything for them.

This can actually be a boon, as we'll see shortly. But it's worth keeping in mind, to make sure we don't accidentally make things worse for them.

Other mechanisms

There are two other mechanisms we can use to control order:

The order property, on individual children
flex-wrap: wrap-reverse

order works similar to z-index — a child with order: 2 will show up after a child with order: 1, but before a child with order: 5.

flex-wrap: wrap-reverse causes elements to wrap upwards rather than downwards.

In a world without CSS Grid, these methods would be worth exploring. Honestly, though, CSS Grid is a better tool for the job when we have complex ordering requirements. For that reason, we won't be looking at order or flex-wrap: wrap-reverse in this course.

Exercises
Table of contents

It's common for blog posts and online magazine articles to feature an index of the contents, with convenient links to hop to specific sections:

With this kind of layout, by default, users will have to tab through the entire article before reaching the table of contents:

This seems backwards to me. The table of contents is there to help you skip quickly to a specific section. In books, for example, the table of contents is on the first page, not the last! It doesn't help anyone if they can only access it once they've navigated through the whole article.

Update the code below so that the table of contents comes first in the tab order.

NOTE: You can modify both the HTML and CSS in this one, don't feel like you need to stick exclusively to the styles!

How to test?
(info)

The easiest way to test the tab order is to double-click the “Result” heading just above the preview pane, and hit tab twice. Focus will move into the iframe, and you can progress through the interactive elements in order:

Not working for you? If you're using macOS Safari, you'll either need to hold “Option” while you hit tab, or configure your OS to use standard tab behaviour
. Older versions of macOS Firefox also needed this tweak, though I believe it's been fixed in recent versions.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:


---

## Interactive Review

Source: /css-for-js/04-flexbox/10-review

Interactive Review

I recently published a blog post: “An Interactive Guide to Flexbox”
.

This blog post covers a lot of the same ground that we've seen so far in this course, with some additional interactives. If you're still feeling a bit shaky about some of the concepts we've gone over so far, I think it could serve as an excellent review!

Read the blog post

---

## Flexbox Interactions

Source: /css-for-js/04-flexbox/11-flex-interactions

Flexbox Interactions

So far, we've been discussing Flexbox on its own. Let's take a look at how Flexbox interacts with other properties and layout modes.

Positioned flex children

What do you suppose happens when a flex child is given absolute or fixed positioning?

<style>
  .row {
    display: flex;
  }

  .help-btn {
    flex: 1;
    position: fixed;
    right: 0;
    bottom: 0;
  }
</style>

<section class="row">
  <main>
    <!-- Stuff here -->
  </main>
  <div class="help-btn"></div>
</section>

We've put our .help-btn element in a bit of a bind, by asking it to participate in the flex layout (with flex: 1), but also giving it positioned layout (with position: fixed).

When there is a conflict between layout modes, positioned layout always wins. Our help button will become fixed to the bottom-right corner of the viewport, and the .row Flex container will ignore it, and act as though it only has one child (<main>).

As a general rule, elements can't participate in multiple layout modes at once. Either it's using flexbox, or it's using positioned layout. This is ultimately a very good thing, because CSS would be much more complicated if this wasn't true!

See for yourself — try adding various flex properties to .row (eg. justify-content, flex-direction…), and try deleting the <div class="help-btn"> element. It shouldn't affect anything:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

What about relative positioning?
(info)

An exception to this rule is relative positioning, but it's kind of a special case.

When you give something relative positioning, you're instructing it to move based on its normal position. That normal position is "inherited" from whichever layout mode it happens to be rendered by.

If you give a flex child relative positioning, that element is technically being rendered in two different layout modes, but they're compatible; the element is first laid out inside the flex container, and then transposed using top/left/right/bottom by positioned layout.

Similarly, sticky positioning can also work in a flex container, though there is a bit of a "gotcha" there. We'll see it in the next lesson!

Margin collapse

In Module 1, we learned about margin collapse. When two block-level elements are adjacent or nested, their margins can overlap, or be absorbed.

Margin collapse is exclusive to Flow layout. It doesn't happen when elements are laid out inside a flexbox parent.

As the "original" layout mode of the web, Flow is built around documents, and margin collapse makes a lot of sense when documents are concerned. But when we're building layouts for dynamic web applications, collapsing margins don't make as much sense.

Here's a demo. Try changing .column's "display" property to "block", and watch what happens with the margins!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane
Flexbox and z-index

Here's a bit of a riddle for you: can you tell why z-index appears to work in this example?

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

It's curious, right? Both .first and .second are statically positioned. If we rely purely on render order, the pink box should sit above the blue one. And yet, because .first has z-index: 2, it floats above!

Earlier, we learned that the z-index property is used by the Positioned layout algorithm. It has no effect in Flow layout, which is why we need to add position: relative in order to set a z-index.

It turns out, however, that the Flexbox algorithm also supports z-index. If our element is being laid out with Flexbox, it uses z-index as if it was rendered with Positioned layout.

The same thing is true for CSS Grid; a child in Grid layout can use z-index without setting position: relative.

Remember, CSS is comprised of layout modes, and each layout mode decides what each property should do. Positioned, Flexbox, and Grid all implement support for z-index. Flow layout does not.

Exercises
Combining layout modes

While Flexbox is super powerful, there are certain things it can't do on its own.

Let's say we're trying to build this kind of UI:

Specifically, it has these constraints:

Two equal width columns
The container should be the height of the first column.
The second column should scroll vertically, since it won't fit in the shorter container.

This is a tricky exercise!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Solution:

A common alternative solution is to use absolute positioning (Check out an example from Poissoj
 and another from Guglielmo
).

These solutions work pretty well, but there is one small difference: the cursor has to be positioned over the list for scrolling to work. In the sticky solution, scrolling works anywhere within the pink box.


---

## Recipes

Source: /css-for-js/04-flexbox/12-recipes

Recipes

Now that we've covered all of the theory when it comes to Flexbox, let's see how we can use it in some practical every-day examples!

If you prefer, you can treat these as exercises, and try to complete them before watching the videos. Totally up to you!

Holy Grail layout

For a long time, the "Holy Grail" layout was simultaneously extremely common, and extremely difficult to implement correctly with the tools of the time (tables and floats).

Fortunately, Flexbox can handle it without any weird hacks!

Here's what we're going for:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>

</style>

<div class="wrapper">
  <header class="box">Header</header>
  <section class="middle">
    <nav class="box">Nav</nav>
    <main class="box">Main Content</main>
    <aside class="box">Ad unit</aside>
  </section>
  <footer class="box">Footer</footer>
</div>
Result
Refresh results pane

Let's take a look at it!

Sticky sidebar

It's common for a sidebar to use position: sticky, to follow the user as they scroll through an article.

Does this work within a Flex container?

At first glance, it appears not to:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

There is a way to make this work, however! Let's explore:

An alternative approach
(info)

We can also solve this problem by constraining the height of the <nav> element:

nav {
  position: sticky;
  top: 0;
  height: fit-content;
}

This works because height overrides the default “stretch” alignment in Flexbox. The Flexbox can't stretch the <nav> to fill the parent container's height anymore. As a result, the <nav> element has a bunch of empty space below, and it can stick to the edge of the viewport as the user scrolls.

This is a 100% acceptable solution, though it does feel a bit more complicated to me. Instead of tweaking the Flexbox algorithm to do what we want, we're forcing a conflict between size and alignment.

It reminds me a bit of what I mentioned a couple of lessons ago: it's easy to mistake familiarity for simplicity.

Most CSS developers are more comfortable with height than with Flexbox cross-axis alignment, and so it feels simpler to tweak height and not have to fuss with Flexbox. I would have felt this way, a few years ago.

Ultimately, this is a personal-preference thing, and I'm not suggesting that one approach is better than the other. Some developers might be very comfortable with Flexbox, and yet still prefer the height approach. But I want to make sure you're not leaning on familiar CSS properties as a crutch, to avoid developing your Flexbox muscles. ❤️

Overstuffed and centered

There are many ways to center an item in a container, like this cat image:

What if we want it to stay centered even if it exceeds its container?

Give it a shot:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Here's how I solved it:


---

## Workshop: Sole&Ankle

Source: /css-for-js/04-flexbox/13-workshop

Workshop: Sole&Ankle

In this workshop, we'll build a sneaker store!

It should flex to handle different desktop sizes (no mobile or tablet… yet):

Project introduction
Resources

Grab the starter code from Github, or work on CodeSandbox:

Download from Github
Work on CodeSandbox

Please note: This project requires Node 18+. If you try to run this workshop using an older version of Node, you’ll get an error about structuredClone not being defined. I recommend using NVM
 to easily hop between Node versions.

You'll find step-by-step instructions in the workshop's README.md.

You can also access the design on Figma:

Figma design

Have fun!

Submit Workshop

I review a small percentage of submitted workshops, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## Workshop Solution

Source: /css-for-js/04-flexbox/14-workshop-solution

Workshop Solution

Outdated code in solution videos
(warning)

Since filming these solution videos, I have migrated this workshop from create-react-app to Vite, and updated React to 19. This required a few small changes in terms of file structure. For example, file extensions have been changed from .js to .jsx, since Vite doesn’t allow JSX in plain JS files.

The solution code
 has been updated, so please use that as your source of truth, rather than what’s in the videos.

There are a lot of different moving pieces in this one! Let's explore them in turn.

Exercise 1: Superheader
View the code on Github

Height fix
(warning)

In the solution, we set the height of the superheader explicitly:

const Wrapper = styled.div`
  height: 40px;
`;

This can cause problems if the user bumps up their default font size. Instead, we should either set min-height: 40px (so that it can grow as necessary), or height: 2.5rem (so that it scales smoothly with font size).

Exercise 2: Header
View the code on Github

As mentioned in Exercise 1, we shouldn't set height in pixels. I've updated this solution to use rems.

Exercise 3: Shell
View the code on Github
Exercise 4: Sneaker Grid

This exercise has two distinct parts, so it's split into two distinct videos!

Part A: Grid layout with Flexbox
View the code on Github

Correction: At around the 6-minute mark, I mention that the elements sit on one line because of flex-shrink. In fact, the reason they compress so much is because flex: 1 also sets flex-basis to 0.

Part B: Price and Flag touches
View the code on Github

Correction: The font size in the flag should be ${14 / 16}rem;, not ${14 / 18}rem;.

Forgotten: border radius!
(info)

So, one thing I totally missed: the design has rounded corners on the shoe images! Sorry about that. 😅

We can fix this by applying the following border-radius declaration:

// ShoeCard.js
const Image = styled.img`
  width: 100%;
  border-radius: 16px 16px 4px 4px;
`;

I got these values from the Figma design:

By applying the border-radius directly to the image, we sidestep potential complications (the alternative is to apply it to the <Wrapper> and then clip the corners with overflow: hidden, but this will also clip our nifty flags!).


