# CSS for JS - Module 2: Rendering Logic 2

---

## Relative Positioning • Josh W Comeau's Course Platform

Source: /css-for-js/02-rendering-logic-2/01-positioning

Rendering Logic II

In the last module, we learned about Flow layout. It's the “OG”? layout algorithm of the web. But it's not alone.

In this section, we're going to look at another layout mode: Positioned layout.

The defining feature of positioned layout is that items can overlap. The Flow Layout algorithm tries very hard to make sure that multiple elements never occupy the same pixels. With positioned layout, however, we can break out of the box.

We can opt into Positioned layout using the position property. It can be set to relative, absolute, fixed, or sticky. Each one works in a unique way, like a mini-layout-algorithm within the layout algorithm.

In the lessons ahead, we'll explore all of these different variants to Positioned layout.

Static positioning
(info)

The default value of the position property is static.

Occasionally, you'll see tutorials refer to "statically-positioned" elements. All this really means is that the elements are not using Positioned layout; they're using some other layout mode, like Flow or Flexbox or Grid.

If an element is currently using Positioned layout and you want to opt out, you can set position to either static or initial:

.box {
  /* Revert to its default value, which is ‘static’ */
  position: initial;
}
Relative positioning

Of all the Positioned layout sub-genres, relative is the most subtle.

.some-box {
  position: relative;
}

You can often slap position: relative on an element, and observe zero difference. It appears to have no effect!

In fact, it does two things:

Constrains certain children (we'll get to this shortly!)
Enables additional CSS properties to be used.

When we opt into Positioned layout, we enable a handful of new CSS properties, including:

top
left
right
bottom

We can use those directional values to shift the element around. With relative positioning, those values are relative to its natural position.

It's common to use top and left to push things along the vertical and horizontal axes respectively. Give it a shot here, to see how the element reacts:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

You can also use negative numbers to push the element in the opposite direction; for relatively-positioned nodes, left: -10px has the same effect as right: 10px.

You might be thinking: “that's cool and all, but I can already push an element around with margin! What's the difference?”

The big difference is that position doesn't impact layout. When we apply margin to an element, it can affect many other elements, potentially causing them to shift around. But when we push a relatively-positioned element around with top/left/right/bottom, that displacement occurs after all of the layout calculations. So, nothing else will move.

Compare them in this playground:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Whether we use relative-positioning and top or margin-top, the pink box winds up in the same spot (20px lower than its natural position). With margin-top, though, the black boxes below the pink ones get shuffled along too, like a row of cars forced to back up to let a truck turn.

Similarly, when block items don't have a specified width, they can dynamically resize when, say, margin-left is increased. left, on the other hand, pushes an item around without ever changing its dimensions.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Notice how the right-hand column's box "seeps out" of the container, whilst the left-hand column's box gets narrower.

Which of these is better? Well, it depends on the situation! Sometimes you want to shift an item around independently, and sometimes you'll want it to remain "context-aware". There's also a third option, using transforms, which we'll learn about later on in the course.

Finally, it's important to note that relative positioning can be applied to both block and inline elements. This allows us to nudge inline elements in a way that isn't really possible otherwise.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Relative positioning opens some interesting doors, but we're just getting started with this layout mode. Let's look at another variant.


---

## Absolute Positioning

Source: /css-for-js/02-rendering-logic-2/02-absolute

Absolute Positioning

So far, all of the elements we've seen are laid out in an orderly fashion, one on top of the other. We generally refer to this as “in flow”, a reference to Flow layout (though, these days, it can also refer to other layout modes like Flexbox).

What if we want to break the rules, though? What if we want to take an element out of this orderly flow, and stick it wherever we want?

In these cases, absolute positioning is our friend.

We generally use absolute positioning for things like:

UI elements that need to float above the UI, like tooltips or dropdowns.
Decorative elements that need to be stuck in certain positions (eg. abstract illustrations).
Stacking multiple elements in the same place, like a deck of cards.

Let's start with an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .pink.box {
    position: absolute;
    top: 0px;
    right: 0px;
    width: 75px;
    height: 75px;
    background: deeppink;
  }
</style>

<div class="pink box"></div>
<p>Hello World</p>
Result
Refresh results pane

In Flow layout, we would expect the pink box to sit on top of the paragraph, since that's their order in the DOM. Because our pink box uses absolute positioning, though, two things are different:

The pink box is nestled up in the top-right corner of the preview frame.
The "Hello world" paragraph has shifted up, to fill the space the pink box would normally fill.

Let's look at them in turn.

Placement based on the frame

This is the main thing people think about when it comes to absolute positioning. We can stick something in the corner, or otherwise position something based on the box it's being constrained by, ignoring its "natural" position.

We can do this with 4 properties: top, left, right, and bottom. Above, we stuck our box in the top-right corner by specifying that it should be 0px from the top edge and 0px from the right edge.

It doesn't have to be stuck along an edge, either. Consider:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

We've instructed the box to sit 20px below the top edge of the frame, and 25% away from the left edge. The percentage is based on the total amount of space available.

Notice how this is a totally different mechanism from relative positioning? Absolutely-positioned elements are adjusted based on their container, not based on their in-flow position.

To really drive the point home, try moving the pink box above the paragraphs in the HTML, so that it’s the first element after the <style> tag. Notice that it doesn't change anything in the rendered output!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Default placement

Here's a question: what happens if you set position: absolute, but don't give it an anchor by setting top / left / right / bottom?

Here's a playground. See if you can figure out what it's doing:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Hint: try resizing the “Result” pane!

If we don't give our absolute element an anchor, it sits in its default in-flow position. I think of it as "inheriting" its default position from Flow layout.

See this for yourself by removing position: absolute. Notice that the element sits more-or-less in the same spot!
*

It has one other effect, though. It causes the absolute element to stack on top of the surrounding text. Which takes us to the second aspect of absolute positioning…

Effect on layout

This point is a bit less obvious, but maybe even more important. When we set something to be position: absolute, we pull it out of flow.

When the browser is laying out elements, it effectively pretends that absolutely-positioned elements don't exist. They're “incorporeal”: you can stick your hand right through them, like a hologram or a ghost.

To drive the point home, here are 3 paragraphs that have been set to be absolutely positioned:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The browser starts by putting that first paragraph in its natural position, at the top of the document, but because it's absolute, it still considers that space empty.

Next, the second paragraph gets added in its natural position, which is also right at the top, since the container is effectively “empty”.

This process will continue for each provided absolute element.

Being able to take elements out-of-flow is super handy. Any time you want an element to be "floating above" the content, like a tooltip or a dropdown or a modal, absolute positioning is your friend.

Collapsing parents

While often the ability to take an element out-of-flow is useful, there are times when it can be annoying. Consider this example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In this example, we have a pink box sitting within a black-border parent. When we toggle on that position: absolute, you'll notice that the parent "collapses" down, so that it's 8px tall (4px top border, 4px bottom).

Why does this happen? Well, in terms of flow layout, the parent is empty! Remember, absolute elements are like holograms, they don't really exist. And since this parent element has no other children, it's as if it was an empty div.

The right tool for the job
(info)

You might be wondering: how do we fix this? Is there a way to stop the parent from collapsing, while still using absolute positioning on the child?

Unfortunately, I'm not aware of any way to do this (at least, not without resorting to a bunch of hacky JS), but I sorta think it's the wrong question.

In general, absolute positioning is intended to be used in situations where we don't want it to affect its surrounding layout.

If you find yourself running into this problem over and over, it's likely that you're reaching for absolute positioning in situations where another layout mode (eg. Flexbox, Grid) would be more appropriate.

Absolute sizes

Here's the playground from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

---

## Centering Trick

Source: /css-for-js/02-rendering-logic-2/03-centering-trick

Centering Trick

So we've seen how we can position an element by specifying a distance from the edge, like this:

.box {
  /* Distance from the top edge: */
  top: 0px;
  /* Distance from the left edge: */
  left: 50px;
}

Absolutely-positioned elements have another trick up their sleeve; we can use these properties to center the element!

Here's the playground from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

There are 4 important ingredients for this trick to work:

absolute positioning (position: absolute)
Equal distances from each edge (ideally 0px)
A fixed size (defined width and height properties)
Hungry margins (margin: auto)

Still relevant?
(info)

Given the rise of modern layout algorithms (Flexbox and Grid), you might wonder if this trick is still worth using.

In fact, I still use this trick a ton! It's especially useful for prominent bits of UI, things like modals or drawers or dialog boxes.

The “inset” property

As we saw, the centering trick requires setting all 4 edge properties to the same value:

.box {
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

This feels very tedious, and modern CSS has given us a more terse way to accomplish this:

.box {
  inset: 0;
}

The inset property will set all 4 edge properties (top, left, right, and bottom) to the provided value.

It's useful for this centering trick, but also when we want an element to be “inset” within its parent:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

This is equivalent to:

.box {
  position: absolute;
  top: 25px;
  left: 25px;
  right: 25px;
  bottom: 25px;
  background: deeppink;
}

This property is supported in all modern browsers — caniuse says that it's available for 92.6% of users
. If you need to support Internet Explorer, you should keep using the top/left/right/bottom combo.

In the lessons ahead, I'll keep using top/left/right/bottom instead of inset, but this is only because I hadn't gotten accustomed to using inset when I originally created these lessons. Going forward, I use inset regularly, and I suggest you do as well!


---

## Containing Blocks

Source: /css-for-js/02-rendering-logic-2/04-containing-blocks

Containing Blocks

In CSS, every HTML element has a “containing block”. A containing block is a rectangle that forms the bounds of the element's container.

In Flow layout, elements are contained by their parents. For example, this paragraph is contained by its parent <section>:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .container {
    width: 200px;
    border: 5px solid;
    padding: 16px;
  }
</style>

<section class="container">
  <p>Hello World!</p>
</section>
Result
Refresh results pane

To be precise: the paragraph is contained by a “containing block” the size and shape of the parent element's content box:

Flow layout uses containing blocks to figure out where on the screen to place the element.

When it comes to absolute positioning, however, containing blocks work a little bit differently.

When we set the position of an element using top / left / right / bottom, we're positioning the element based on the element's containing block. If our element sets top: 0; left: 0, the element will be nestled in the top-left corner of the containing block.

The million-dollar question is this: how is an absolute element's containing block calculated?

Unlike in Flow layout, absolutely-positioned elements aren't necessarily contained by their direct parent. They're a bit like rebellious teenagers in this way. They won't necessarily pay any attention to their parents.

Here's an example of an absolute element ignoring its parent:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Here's what's going on: Absolute elements can only be contained by other elements using Positioned layout. This is a really important point, and a really common source of confusion.

If we add position: relative to the .parent class, it flips the child's containing block. It will now be contained by the parent:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Here's how the algorithm works: When deciding where to place an absolutely-positioned element, it crawls up through the tree, looking for a Positioned ancestor. The first one it finds will provide the containing block.

What if it doesn't find one? In many of the examples we've seen so far, there aren't any Positioned ancestors.

In this case, the element will be positioned according to the “initial containing block”. This is a box the size of the viewport, right at the top of the document.

Here's another example. Our box is placed in a Russian-nesting-dolls-type collection of boxes. It only pays attention to the closest relative ancestor:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

It doesn't matter how many parent elements are wrapping the child, it will ignore all of them until it finds a position. It doesn't have to be relative, as seen here, but it has to use Positioned layout. absolute, fixed, and sticky will also work.

One last quick point: the pink box ignores the padding of the containing block. It sits right up against the border, even though each of these boxes has 16px of padding. The way to think about this: padding is used in Flow layout calculations, and absolute elements are taken out-of-flow. Those rules don't apply.


---

## Containing Puzzle

Source: /css-for-js/02-rendering-logic-2/05-dom-puzzle

Containing Puzzle

It takes a bit of practice to get comfortable with absolute placement and containing blocks. We'll tackle some exercises shortly, but let's prepare by playing a quick game!


---

## Exercises

Source: /css-for-js/02-rendering-logic-2/06-exercises

Exercises
Bubble Border

Absolute positioning can be very useful when it comes to creating whimsical flourishes! Let's create a “bubble border”:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .box {
    height: 150px;
    margin: 64px;
    border: 4px solid palevioletred;
  }
</style>

<div class="box">
  <div class="big circle"></div>
  <div class="medium circle"></div>
  <div class="small circle"></div>
</div>
Result
Refresh results pane

The solution:

The inherit value used in this solution is described in more detail in the “Built-in Declarations and Inheritance” lesson
.

Crosshair measuring tool?
(info)

The rectangle tool I'm using to measure in this video is the default screenshot tool built into macOS. For folks not on macOS, you can check out PowerToys
 / Greenshot
 (Windows) or screenruler
 / KRuler
 (Linux).

I've created a Treasure Trove entry about measuring sizes and distances on-screen, with tons of great tricks and recommendations.

“New and Improved!” flag

Let's suppose we're building an e-commerce app for a very fancy watch company.

We've been given the following mockup:

Below, you'll find that most of the cosmetic styles have been applied, but it's up to you to add that “New and Improved!” flag.

Acceptance Criteria:

The yellow flag should be floating above the image, using absolute positioning. There should be 8px between the top of the card and the flag. It should stick out horizontally by 8px.
The corners of the flag should be rounded: 4px on the left edges, and 1rem on the right edges.
*

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

Correction: In the video, I claim that the right-side corners will stay rounded even when the font size changes. This is true when the user changes their default font size, but not true when we change the font size of the .flag class. In order to scale with the font-size property, we need to use the em unit instead of rem. I've updated the solution code below.

Much later in the course, we'll learn about how the border-radius algorithm works.

Solution code
(success)

 Show more

---

## Stacking Contexts

Source: /css-for-js/02-rendering-logic-2/07-stacking-contexts

Stacking Contexts

Here's a question with a surprisingly-complex answer: how does the browser decide which element to render "on top" when elements overlap?

It depends on the layout mode!

In Flow layout, elements don't overlap much, but we can force it with negative margin:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .box {
    width: 50px;
    height: 50px;
    border: 3px solid;
    background: silver;
  }

  .second.box {
    margin-top: -30px;
    margin-left: 20px;
    background: hotpink;
  }
</style>

<div class="first box"></div>
<div class="second box"></div>
Result
Refresh results pane

In this case, the DOM order matters. The pink box comes after the silver box in the DOM, and so it's painted on top.

There is one catch, though: in Flow layout, content is painted separately from the background.

Check out what happens if we add some text to these boxes:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .box {
    width: 50px;
    height: 50px;
    border: 3px solid;
    background: silver;
    font-size: 2rem;
    text-align: center;
  }

  .second.box {
    margin-top: -30px;
    margin-left: 20px;
    background: hotpink;
  }
</style>

<div class="first box">
  A
</div>
<div class="second box">
  B
</div>
Result
Refresh results pane

In Flow layout, background colors and borders are truly meant to be in the background. The content will float on top. That's why the letter A shows up on top of the pink box.

The truth is that Flow layout isn't really built with layering in mind. Most of the time, when we want to layer elements, we'll want to use positioned layout.

Check out what happens if we add relative positioning to the silver box:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

As a general rule, positioned elements will always render on top of non-positioned ones. We can think of it as a two-stage process: first, all of the non-positioned elements are rendered (everything using Flow, Flexbox, Grid…). Next, all of the positioned elements are rendered on top (relative, absolute, fixed, sticky).

What if we set both elements to use relative positioning? In that case, the DOM order wins:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

To summarize:

When all siblings are rendered in Flow layout, the DOM order controls how the background elements overlap, but the content will always float to the front.
If one sibling uses positioned layout, it will appear above its non-positioned sibling, no matter what the DOM order is.
If both siblings use positioned layout, the DOM order controls which element will be on top. Unlike in Flow layout, the content does not float to the front.

That's how the stacking order is calculated by default, but CSS gives us a tool to override this default behaviour. Let's talk about the z-index property.

z-index

If we want the layered order to be different from the DOM order, we can use the z-index property to manually reorder them:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

z-index only works with positioned elements
*
. It will have no effect on an element being rendered in Flow layout.

The z in z-index refers to the z axis:

x is left/right
y is up/down
z is forward/backward

A good way to think about this is that elements with a higher z-index are placed closer to the viewer in 3D space, coming out of the screen:

3
1
2

(Hover over the iMac to view the visualization!)

The default value of the z-index property is auto, which is equivalent to the number 0. Therefore, any value greater than 0 can be used to "promote" an element to sit in front of its siblings:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Negative z-indexes

z-index values must be integers, and they're allowed to be negative. z-index: -1 is a valid declaration.

In my experience, though, negative z-indexes introduce additional complexity without offering much benefit. Every time I've tried to use negative z-index values, I've wound up regretting it.

As such, we won't cover them in this course.

Introducing stacking contexts

The playground shown in this video can be played with here:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane
Creating new contexts

In the video above, we saw how we can create a stacking context by combining a non-static position with a z-index. This isn't the only way, however!

Here are some other declarations that create a new stacking context:

Setting opacity to a value less than 1
Setting position to fixed or sticky (No z-index needed for these values!)
Applying a mix-blend-mode other than normal
Adding a z-index to a child inside a display: flex or display: grid container
Using transform, filter, clip-path, or perspective
Explicitly creating a context with isolation: isolate (More on this soon!)

If you're curious, you can see the full list of how stacking contexts are created
 on MDN.

Debugging stacking contexts

Stacking contexts are the source of a lot of trouble.

When I worked at Khan Academy, we kept having regressions around our modal and our site header; no matter how aggressively-high we set the modal's z-index, the blasted header kept poking out on top.

On this very course platform, early beta users spotted a similar problem:

No matter how much experience you have, you'll occasionally run into these issues. The good news is that with the right combination of knowledge, experience, and tooling, we can solve these issues without breaking a sweat.

We're going to learn more about stacking contexts in the lessons ahead, but I want to introduce a super nifty tool first: CSS Stacking Context Inspector
.

This is a free Chrome/Firefox extension which answers a few critical questions about any individual element:

Which stacking context does this element belong to?
Does it create a stacking context of its own?
If it uses the z-index property, is it having any effect? If not, why not?
Where does it sit relative to other elements in the same stacking context?

Install CSS Stacking Context Inspector:

For Chrome
For Firefox

---

## Managing z-index

Source: /css-for-js/02-rendering-logic-2/08-reducing-z-index

Managing z-index

One of the most common frustrations when it comes to CSS is getting stuck fighting the "z-index wars".

Here's how this happens: you have an element which is rendering behind another element, but you want it to be in front. So you pick a bigger value for its z-index, maybe 100, and it solves your problem. Later, you have another element that needs to be even higher, so you pick an even higher arbitrary value. This process repeats over and over. As the application matures, the numbers get bigger and bigger. It's like z-index inflation.

Here's the good news: we don't have to play these reindeer games!

In some cases, we can avoid setting z-index, relying on DOM order instead. And in other cases, we can bundle up our layers into an isolated stacking context.

Let's look at some strategies for reducing z-index pain.

Swapping DOM order

Let's suppose we have a card, and we want to sprinkle some decorative blobs behind the card:

We'll use absolute positioning to place those shapes around the card. The code might look something like this:

<style>
  .wrapper {
    /* Create a containing block */
    position: relative;
  }
  .card {
    position: relative;
    z-index: 2;
  }
  .decoration {
    position: absolute;
    z-index: 1;
  }
</style>

<div class="wrapper">
  <div class="card">
    Hello World
  </div>
  <img
    alt=""
    src="/decorative-blob-1.svg"
    class="decoration"
    style="top: -20px; left: -70px;"
  />
  <img
    alt=""
    src="/decorative-blob-2.svg"
    class="decoration"
    style="top: -50px; left: -10px;"
  />
  <!-- Other blobs omitted for brevity -->
</div>

We want the card to sit in front of the blobs, so we give it a higher z-index.

But! If we were to switch the order of these DOM nodes, we wouldn't need to use z-index at all:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

If we don't specify a z-index, the browser will paint positioned elements based on their DOM order. So as long as our card uses positioned layout (with position: relative) and comes after the blobs, it'll be painted on top. This is true across browsers and devices.

(We can put the CSS rules in whichever order we'd like; the only thing that matters is the order of the HTML elements.)

Be careful with this strategy!
(warning)

Swapping the DOM order to control rendering can be a very useful trick, but it isn't always appropriate.

When we swap the order of two DOM nodes, we also swap their order in the tab index. For folks who navigate with a keyboard, they encounter elements based on the DOM order.

In the example above, this isn't a problem, since the decorative images aren't interactive. Keyboard users will skip right past them no matter where in the DOM they are.

But if we were to swap the order of an element containing interactive elements — links, buttons, form inputs — it can have a jarring effect on the user experience for keyboard navigators.

Isolated stacking contexts

Let's suppose we're building a "pricing" page.

We implement the design we receive, and wind up with the following UI:

We're all set to ship it, when our PM swings by our desk and says “Hi deymos — the marketing team wants us to make a change…”

The new design emphasizes the "pro" plan by floating it so that it sits above the other two cards:

We can render this sort of UI using something like Flexbox, but we'll hit a problem: by default, elements stack according to their DOM order. We'll wind up emphasizing the wrong card:

Unfortunately, we can't use the DOM-order-swap trick we learned earlier—it would mess up the keyboard tab order. So instead, we'll use z-index, giving the middle card a higher z-index value so that it shows up on top:

<style>
  .card {
    position: relative;
    z-index: 1;
  }
  .primary.card {
    z-index: 2;
  }
</style>

<section class="pricing">
  <article class="card">
    <!-- Stuff omitted -->
  </article>
  <article class="primary card">
    <!-- Stuff omitted -->
  </article>
  <article class="card">
    <!-- Stuff omitted -->
  </article>
</section>

We test this code, and it works great! The middle card sits on top. So we ship it to production, feeling satisfied with ourselves. But then, an hour later, we receive a Slack message from the customer success team:

“deymos, I think your recent deploy broke something…”

We check it out, and sure enough, something very funky is going on:

We forgot about the site's sticky header! And, weirdly, it's slipping between the cards.

Here's why this is happening: the cards and that header are all in the same stacking context. Their z-index values are being compared and applied. And it just so happens that the header shares the same z-index value as our primary card.

Here's a wider view of the HTML/CSS responsible for this bug:

<style>
  header {
    position: fixed;
    z-index: 2;
  }

  .card {
    position: relative;
    z-index: 1;
  }
  .primary.card {
    z-index: 2;
  }
</style>

<header>Synergistic Inc.</header>
<main>
  <section class="pricing">
    <article class="card">
      <!-- Stuff omitted -->
    </article>
    <article class="primary card">
      <!-- Stuff omitted -->
    </article>
    <article class="card">
      <!-- Stuff omitted -->
    </article>
  </section>
</main>

The two side cards have a z-index of 1, so they slip behind the header. But the primary card matches the header's z-index of 2. And since the primary card comes later in the DOM order, it shows up on top.

In order to fix this, we need to create an isolated stacking context. If we can bundle those 3 cards into their own context, we can guarantee that they all slip behind the header.

One way to do this is to give the .pricing wrapper a position and z-index:

.pricing {
  position: relative;
  z-index: 1;
}

These two properties create a stacking context, flattening all of the elements inside. This means that the elements as a group will either sit above or below our header, but there's no way for them to become interlaced with other elements.

It doesn't matter how high the z-index inflation gets within that group, either: even if we had 10 cards with 10 different z-index values, none of those values will matter outside of that context.

This is a key strategy when it comes to fighting the z-index wars. By intentionally bundling layered elements into stacking contexts, we reduce the number of "top-level" elements with z-index values.

But there's one more thing that makes this strategy even better.

The isolation property

Instead of adding position: relative; z-index: 1; to our .pricing selector, we can do this:

.pricing {
  isolation: isolate;
}

The isolation property does precisely 1 thing: creates a stacking context.

It has the same effect of flattening all of the child elements, but it does so without requiring that we also set a z-index on the parent. It's the lightest-touch way to create a stacking context.

This is especially valuable in the era of component-driven frameworks. Our application might have a Pricing component that renders our group of cards, and we might use that component in multiple places. This way, we aren't prescribing a z-index value to be used everywhere.

Ever since discovering the isolation property, I've been using it a ton. Whenever a child within a component applies a z-index value, I add isolation: isolate to the component's parent element. This guarantees that we won't see weird "slip-in-between" bugs, like the one we saw with the sticky header. But it doesn't contribute at all to z-index inflation, or force me to pick a value.

Adam Wathan, creator of Tailwind, has similarly discovered its value
, and has added an isolate utility to the library.

Here's a live-editable version of the code we've been talking about. Play with it yourself to see how it works!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Flexbox?
(warning)

This snippet uses some CSS we haven't seen yet, like Flexbox and fixed positioning. We'll learn much more about this stuff soon enough.

There's one interesting interaction here, though: The .card elements can use z-index even if they don't set position: relative!

This happens because the Flexbox algorithm uses the z-index property in the same way that the Positioned layout algorithm does. z-index doesn't work in Flow layout, but it does in Flexbox (as well as Grid).

We'll learn more about how Flexbox interacts with other layout modes in Module 4.

Browser support
(info)

isolation is supported by all modern browsers, but not by Internet Explorer. If you need to support IE, you'll need to find another way to create a stacking context. Check out the full list on MDN
*
.


---

## Portals

Source: /css-for-js/02-rendering-logic-2/10-portals

Portals
(Optional lesson)

The video references portals, which are an advanced React feature. Alternatives exist for most component-driven frameworks:

React Portals
Angular Portals
Vue Teleport
 (same idea, just a different name)
Svelte Portal
 (third-party)

Also, you probably don't need to fuss with portals directly. Portals are a low-level tool intended primarily for library authors.

They're often used for tricky UI elements like modals, tooltips, and dropdowns. These sorts of elements are notoriously tricky to build properly, especially when considering touch devices and accessibility!

Instead, I recommend using a style-agnostic accessibility-first component library like Radix Primitives
.

Radix Primitives can be thought of as "the missing standard library of the web". It includes components for things like modals/dialogs and comboboxes. Critically, it's unopinionated when it comes to styling. You can think of them almost like primitives, like <input> or <button>. Like these elements, you're supposed to bring your own styles.

I share my favourite component libraries over in the Treasure Trove:

Recommended Component Libraries

Finally, you can play with the code from this video
 to get a feel for how it works! The key files are CustomLoginModal and ReachLoginModal, and you can toggle between them in Header.js.

<dialog> element?
(warning)

A few students have asked: what about the native <dialog> element? Could it be used in this situation, to solve the problem without needing to use portals or any JS libraries?

The <dialog> element has been around for a few years, but it's really picked up steam recently. They've addressed a bunch of accessibility concerns, and I believe it's generally seen as a solid way to create modals and dialogs. And so, yeah! It could provide a much more straightforward way to solve this problem.

That said, I still think it's worth knowing about portals, at least at a high level, because we still need to rely on libraries for other forms of global UI, like popovers.

And when I tinkered with <dialog> myself, I remember having a few issues getting it to play nicely with React. Regrettably I don't remember most of the issues; the one that I do remember is that if my <dialog> contained a tooltip, the tooltip wound up getting stuck behind the <dialog>.

But yeah, you should definitely experiment with <dialog> for yourself! You can learn more on MDN
.


---

## Fixed Positioning

Source: /css-for-js/02-rendering-logic-2/13-fixed

Fixed Positioning

Fixed position is a close cousin to absolute positioning. The main difference is that it's even more rebellious: it can only be contained by the viewport. It doesn't care about containing blocks.

The main advantage of fixed-position elements is that they're immune to scrolling.

For example, here's a help button that sticks in the bottom-right corner regardless of scroll position:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .help-btn {
    position: fixed;
    right: 32px;
    bottom: 32px;
  }
</style>

<button class="help-btn">
  Help
</button>
Result
Refresh results pane

When you scroll in the “Result” pane, the button doesn't budge. It's cemented in place.

In many ways, “fixed” can be thought of as spicy absolute. It's very similar in principle — it's taken out-of-flow and positioned according to some sort of parent boundary — but the boundary it uses is different. Instead of the closest non-static ancestor, it listens to the “initial containing block”, a box the size and position of the viewport?.

Many of the tips and tricks we learned for absolute positioning will work here as well: for example, a fixed element can be centered on the screen using the same party trick. This is perfect for overlays like modals:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .modal {
    /*
      For this party trick, we need:
      - Position absolute or fixed
      - All sides set to '0'
      - explicit dimensions
      - auto margins
    */
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    width: 85%;
    height: 200px;
    margin: auto;
  }
</style>

<div>
  <div class="modal-backdrop"></div>
  <div class="modal">Hello World</div>
</div>
<p>Background text</p>
Result
Refresh results pane

Try switching .modal from position: fixed to position: absolute, and then scroll the page to see the difference!

Fixed without anchor points?
(info)

Here's a question for you: what do you suppose happens if we remove the "anchor points" (top, left, right, and bottom) for a fixed-position element?

Well, let's give it a shot! Below, you'll find a playground anchored to the bottom right corner. Try removing the right and bottom properties:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Here's what you should see:

If we don't set an anchor point, they sit in their in-flow position. If this element wasn't position: fixed, it would sit in the top-left corner of its parent element, .wrapper. This behavior is consistent with absolute positioning.

Amazingly, though, fixed positioning still works! When we scroll the “Result” pane, the box stays locked in place!

This is mostly a curiosity, but it can be useful in certain situations, when we want to "inherit" an in-flow position while still remaining fixed in place.

Incompatibility with certain CSS properties

Certain CSS properties, when applied to an ancestor, will mess with fixed positioning.

For example, if an ancestor (parent, grandparent, …) uses the transform property, it stops being locked to the viewport:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Here's what's happening here: By applying a transform to .container, it becomes the containing block for this fixed-position child. As a result, it functions like an absolutely-positioned child.

The same thing happens when we use the filter CSS property, as well as the will-change property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

(I realize we haven't seen transform, filter, or will-change yet, but rest assured, we'll cover them in depth in Module 8 and Module 9!)

You can read more about this curious behaviour on Eric Meyer's blog
.

Diagnosing the problem

Frustratingly, this issue often pops up in large and complex applications. There might be 15-20 ancestors above our fixed-position element; do we have to check all of them??

I've created a short snippet that can help us automatically find the culprit:

// Replace “.the-fixed-child” for a CSS selector
// that matches the fixed-position element:
const selector = '.the-fixed-child';

function findCulprits(elem) {
  if (!elem) {
    throw new Error(
      'Could not find element with that selector'
    );
  }

  let parent = elem.parentElement;

  while (parent) {
    const {
      transform,
      willChange,
      filter,
    } = getComputedStyle(parent);

    if (
      transform !== 'none' ||
      willChange === 'transform' ||
      filter !== 'none'
    ) {
      console.warn(
        '🚨 Found a culprit! 🚨\n',
        parent,
        { transform, willChange, filter }
      );
    }
    parent = parent.parentElement;
  }
}

findCulprits(document.querySelector(selector));

To use this snippet, copy/paste it into the browser console. It will log out any ancestors that set one of the troublesome CSS properties. You'll have an opportunity to practice in the exercise below.

In Chrome, you can right-click the returned element and select "Open in Elements pane" to view that element in context. To fix the issue, there are a couple of options:

You can try to remove or replace the troublesome CSS property (eg. for filter: drop-shadow, you can use box-shadow instead).
If you can't change the CSS, you can use a portal, like we saw in the previous lesson, or otherwise find a way to move the fixed element to a different container.

Beware of iframes!
(info)

If you try to use this snippet for an exercise in this course platform, or on a tool like Codepen, you may hit that “Could not find element with that selector” error.

This happens because the element in question is rendered within an iframe. The playground embeds an entirely separate HTML document within it, and it has its own DOM and JavaScript environment.

To solve for this, we need to select the correct environment before running the snippet. Here's how we can do this in Chrome:

In Firefox, it can be toggled by clicking this icon:

Exercises
Reuniting the boxes

I've created a little codepen that includes a broken fixed element. Your mission is to fix it, using the browser devtools and the snippet above.

The element in question is a solid purple box. Your goal is to reunite it with a hollow purple box:

Solve this problem using the snippet provided above, rather than looking through the CSS code (it would be like trying to find a needle in a haystack in a larger, more-realistic scenario!).

Access the Codepen

This exercise is considered "solved" when you find and disable the culprit from the “Elements” pane, reuniting the boxes.

Solution:


---

## Overflow

Source: /css-for-js/02-rendering-logic-2/14-overflow

Overflow

When designers work on mockups, they tend to make assumptions about the kinds of data we'll be working with; they might, for example, assume that all names are fewer than 20 characters long.

As JS developers, we know that these assumptions never survive first contact with real data. 😅

As a fun example: you've probably heard of Pablo Picasso, the world-famous Spanish artist, with the weird geometrical faces. But do you know his full name? Here it is:

Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso

Good luck fitting that into a table cell!

This section deals with overflow, a condition that happens when content doesn't fit into its parent's content box.

Here's a quick example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .info {
    max-height: 100px;
    border: 3px solid;
  }
</style>

<div class="info">
  <strong>Name:</strong> Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso
</div>
Result
Refresh results pane

Typically, block elements have variable height, so they can grow as-needed to contain their children. But when we constrain the height by setting a specific value, we create an impossible condition.

The browser solves for this by letting the content spill outside the bounds, but without accounting for it in flow computations. If we add some additional content below that name box, you'll see that the overflow has no effect on layout, and we get a big mess of overlapping text:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

To help us manage these kinds of situations, the browser makes a property available: overflow.

Accepted values

overflow defaults to visible, which allows an element's content to extend beyond its bounds. Let's see what our other options are.

Scroll

If we know that our content is going to overlap, we can slap an overflow: scroll declaration on it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

A warning for macOS developers!
(warning)

Beware: depending on your operating system and peripherals, overflow: scroll can look quite different!

On my computer — an iMac with a trackpad — I only see scrollbars when I try and scroll within the target area:

If I switch to a wired mouse, however, things look quite a bit different:

 Show more

Technically speaking, overflow is a shorthand for 2 distinct properties:

overflow-x
overflow-y

When we pass a single value, it uses that value for both horizontal and vertical axes. If we only want to allow scrolling in 1 direction, though, we can be a bit more precise:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

This works alright, but there's another option!

Auto

overflow: auto will add scrollbars, like overflow: scroll, but only when the content overflows. It’s a "have your cake and eat it too" kind of situation.

When the content overflows, it looks just like overflow-y: scroll:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The content is overflowing because the .info wrapper has a constrained height. If we remove the max-height declaration, the container will grow, and the scrollbar will disappear:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In practice, we often don’t know whether an element should have a scrollbar or not: browser windows come in lots of shapes and sizes (not to mention, the content itself might be dynamic!). overflow: auto is the ideal behaviour when we know an element might overflow.

Now, we don't want to use this property too often. Sometimes, we want content to spill beyond the bounds of the container, like when using negative margins, or absolute positioning. We should use overflow: auto specifically when we want an element to have its own scrollbar if the content doesn't fit.

Why use overflow: scroll?
(info)

In most cases, overflow: auto is a better choice than overflow: scroll, but as with everything, there are tradeoffs involved.

 Show more
Hidden

overflow: hidden is an extreme option; any content that overflows the container is erased, totally hidden from the user:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Why would you ever want to do this? I can think of two main reasons:

Hidden overflow is a necessary ingredient for truncating text with an ellipsis (…). We'll learn all about that in Module 6.
We can hide overflow for artistic purposes, on decorative elements:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Try removing overflow: hidden, and you'll notice two things:

The decorative blobs are no longer being constrained by the box.
We've introduced an undesirable horizontal scrollbar!

Accidental horizontal scrollbars are awful. We'll learn how to identify and prevent them in Module 5.

Do future-you a favor
(info)

So here's the thing about overflow: hidden. It's often deployed strategically, to solve specific problems.

In this course platform, for example, I shift content over to show the menu on mobile:

 Show more
Clip

There’s one more overflow value that was recently added to browsers: overflow: clip.

For the most part, overflow: clip works just like overflow: hidden:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In order to understand the difference between clip and hidden, we need to dig into one of the hidden mechanisms in CSS, scroll containers. We’ll learn about them in the next lesson.

---

## Scroll Containers

Source: /css-for-js/02-rendering-logic-2/14.1-scroll-containers

Scroll Containers

In CSS, there are certain “hidden mechanisms”, devices and concepts that exist within the language, but are totally invisible to most developers. If we want to truly understand how CSS works, we have to learn about these mechanisms.

One such mechanism is the scroll container.

Let's suppose we're trying to do something like this:

Notice that the circles are cropped horizontally, but allowed to spill out vertically.

How should we solve this? Well, maybe we can take advantage of overflow-x, to hide overflow along the X axis? Maybe something like this?

.wrapper {
  /* Hide overflow in the X axis: */
  overflow-x: hidden;
  /* ...but allow it in the Y axis: */
  overflow-y: visible;
}

Unfortunately, this doesn't work:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    overflow-x: hidden;
    overflow-y: visible;
    background: pink;
  }
</style>

<div class="wrapper">
  <div class="flourish one"></div>
  <div class="flourish two"></div>
</div>
Result
Refresh results pane

Hm, it's as if we set overflow-y: scroll. What's going on here?

To understand what's going on here, we need to learn about scroll containers

I like to think of scroll containers like the TARDIS from the British sci-fi show Dr. Who: It's a regular-sized telephone box from the outside, but a large spaceship inside, somehow defying physics.

When we set the overflow property to scroll, hidden, or auto, we create one of these magical "bigger inside than outside" spaceships.

For example, this .wrapper element is a 150px-tall box, and yet it somehow contains a much larger image, as if it was a portal to some alternative dimension:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

And here's the problem: when a container becomes a scroll container, it manages overflow in both directions. The moment we set overflow-x or overflow-y, it becomes a portal to an alternative dimension, and all children/descendants will be affected.

When a child is placed in a scroll container, it guarantees that the child will never spill outside of it. It's on the other side of the portal! Either a child is or isn't in a scroll container. We can't mix and match for vertical/horizontal.

Critically, this is true regardless of whether we set scroll, auto, or hidden. All 3 values have the same effect: it creates a scroll container.

But wait… Why would hidden create a scroll container? It makes sense that scroll and auto would create a scroll container, but we can't scroll within an overflow: hidden element!

Here's the trick: overflow: hidden is identical to overflow: scroll, but with the scrollbars removed.

I'm not sure why it was implemented this way, but an element with overflow: hidden is literally a scroll container with the default scroll mechanisms disabled.

I can prove it. Try to tab through the links within this scroll container:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

As you tab through the links, the container should automatically scroll:

There may not be any visible scrollbars, but it's definitely still a scroll container. We can force it to scroll by tabbing through interactive elements. A crafty user might even write some JS that can programmatically scroll this container!

So, to summarize:

When we use overflow: scroll, overflow: auto, or overflow: hidden, we create a scroll container. This is true whether we set the property on the X axis, the Y axis, or both.
A scroll container is like a portal to a pocket dimension. When an element is contained by a scroll container, it's guaranteed to be stuck inside. It will never overflow beyond the 4 corners of the scroll container.
Setting overflow: hidden creates a scroll container and then hides the scrollbars. It follows all the same rules as overflow: scroll.

But, don't give up hope! Modern CSS has provided a shiny new way to solve this problem.

Overflow: clip

Over the past few months, a new overflow value has been landing in browsers:

.box {
  overflow: clip;
}

overflow: clip works quite a bit like overflow: hidden, but it doesn't create a scroll container. Essentially, it acts the way most developers think overflow: hidden should work. It trims off any overflow, in one or both directions.

We can solve our problem using this property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

If you're using a supported browser, you should see this:

Pretty cool, right??

With overflow: clip, no scroll container is created. Any content that spills outside the bounds of this containing block is made invisible.

In terms of browser support, overflow: clip is supported in all major browsers
, and has been since late 2022. As I write this in November 2024, support has reached 93.4%. For cosmetic effects like this, I think that’s a perfectly acceptable level of support, but in other situations, you may wish to wait a bit longer before switching to overflow: clip.

Can we solve this problem without overflow: clip? We can indeed! In the next section, I'll share the workaround I've been using for years.

A blessing and a curse
(warning)

overflow: clip is a wonderful addition to the CSS language, but there are some significant tradeoffs worth considering.

For example, let's update our list of links to use clip:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Because no scroll container is created, the final couple of links won't be made visible upon focus. As we tab through the list, the focus indicator becomes invisible, and we have no idea what we're selecting.

overflow: hidden has built-in guardrails: interactive elements like links, buttons, and form inputs will be made visible if they're focused, but we lose these guardrails with overflow: clip. The onus is on us to test across different devices and screen sizes, to make sure we aren't accidentally building something unusable!

Going forward in the course
(info)

When I originally created this course, overflow: clip didn’t yet have very good browser support. As a result, there may be situations in future lessons where I use overflow: hidden instead of overflow: clip.

This shouldn’t be interpreted as an intentional choice, but rather a choice made before overflow: clip was an option.

Workaround

So, let's suppose we don't want to use overflow: clip, because we want something that will work for 100% of users.

Here's how I'd solve it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Here's how this works: I've created a new parent, .outer-wrapper, indicated by the dashed silver border. This element is going to be the one that hides overflow. And it's going to wrap over everything else on the page as well.

Our pink box, .wrapper, is no longer trying to hide the overflow. It no longer creates a scroll container.

Now, you might be thinking: won't this still add a vertical scrollbar when the container fills up? What if I have a bunch of stuff inside?

Well, let's try it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The trick here is that scroll containers only scroll when there's overflow. Because .outer-wrapper doesn't have a constrained height, the container is free to grow and shrink as much as it wants. As long as I don't explicitly set something like height: 400px, we won't get an awkward scrollbar.

In Module 1, we talked about how width and height are different; height looks down the tree to calculate its height. And so our .outer-wrapper will keep growing as we put more stuff on it.

To put it another way: scroll containers only start to scroll when the inner size exceeds the outer size. As long as the outer size can keep on growing, that doesn't happen.


---

## Horizontal Overflow

Source: /css-for-js/02-rendering-logic-2/14.2-horizontal-overflow

Horizontal Overflow

So far, all of the examples we've seen involve vertical overflow. But what if we want data to overflow in the alternative direction?

For example: let's say we have a collection of images, and we want the user to be able to scroll horizontally:

Images are inline by default. Like words in a paragraph, they line-wrap when they can't all fit. The overflow property on its own won't help us:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .wrapper {
    overflow: auto;
    border: 3px solid;
  }

  .wrapper img {
    width: 32%;
  }
</style>

<div class="wrapper">
  <img
    alt="Cat licking itself"
    src="https://courses.joshwcomeau.com/cfj-mats/cat-300px.jpg"
  />
  <img
    alt="Curious cat with bright blue background"
    src="https://courses.joshwcomeau.com/cfj-mats/cat-two-300px.jpg"
  />
  <img
    alt="Majestic white cat with piercing blue eyes"
    src="https://courses.joshwcomeau.com/cfj-mats/cat-three-300px.jpg"
  />
  <img
    alt="The grumpiest cat you've ever seen"
    src="https://courses.joshwcomeau.com/cfj-mats/cat-four-300px.jpg"
  />
</div>
Result
Refresh results pane

How can we instruct the container to not linewrap, and instead to leave the content in a single line? The white-space property has got our back:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .wrapper {
    overflow: auto;
    border: 3px solid;
    /* The secret ingredient: */
    white-space: nowrap;
  }

  .wrapper img {
    width: 32%;
  }
</style>

<div class="wrapper">
  <img
    alt="Cat licking itself"
    src="https://courses.joshwcomeau.com/cfj-mats/cat-300px.jpg"
  />
  <img
    alt="Curious cat with bright blue background"
    src="https://courses.joshwcomeau.com/cfj-mats/cat-two-300px.jpg"
  />
  <img
    alt="Majestic white cat with piercing blue eyes"
    src="https://courses.joshwcomeau.com/cfj-mats/cat-three-300px.jpg"
  />
  <img
    alt="The grumpiest cat you've ever seen"
    src="https://courses.joshwcomeau.com/cfj-mats/cat-four-300px.jpg"
  />
</div>
Result
Refresh results pane

white-space is a property that lets us tweak how words and other inline/inline-block elements wrap. By setting it to nowrap, we instruct the container to never break lines. That, in tandem with overflow: auto, allows us to achieve a horizontally-scrollable element.

We'll learn more about the white-space property in Module 6, when we talk about text wrapping.

white-space: nonsense
(info)

You might be wondering: why is nowrap smushed together? Why isn't it no-wrap, like all other multi-word CSS keywords?

There isn't a good reason. The CSSWG? has labeled it a mistake in the language
.

Here's an easy way to remember this peculiarity: it's like the word “nonsense”. It's not “non-sense”, after all.


---

## Positioned Layout

Source: /css-for-js/02-rendering-logic-2/14.3-positioned-layout

Positioned Layout

When we talk about managing overflow, we're generally thinking about "in-flow" children, either in Flow layout, or something like Flexbox / Grid.

How does overflow work with positioned layout, though? Will an absolutely-positioned child trigger a scrollbar if the parent has overflow: auto? What about fixed positioning?

In this lesson, we'll put these ideas under the microscope.

Overflow and containing blocks

Earlier in this module, we learned about containing blocks. Every element is contained by a block. Most of the time, it's the parent, but absolutely-positioned elements ignore their parents unless they, too, use positioned layout.

This dynamic plays a role when it comes to overflow!

Take a look at the following playground, and see if you can figure out why the pink box is peeking outside its parent, despite the overflow: hidden:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .wrapper {
    overflow: hidden;
    width: 150px;
    height: 150px;
    border: 3px solid;
  }
  .box {
    position: absolute;
    top: 24px;
    left: 24px;
    background: deeppink;
    width: 150px;
    height: 200px;
  }
</style>

<div class="wrapper">
  <div class="box" />
</div>
Result
Refresh results pane

.box is not being contained by wrapper. As a result, it ignores the overflow: hidden set on that parent.

We can fix this by adding position: relative to the parent:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Absolutely-positioned elements act just like static-positioned elements when it comes to overflow. If the parent sets overflow: auto, as long as that parent is the containing block, it will allow that child to be scrolled into view:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

This is pretty surprising! In general, absolute positioning is ignored by standard layout algorithms, and yet overflow: auto treats it just like any other element!

It's important to realize this so that you don't get caught off guard by this peculiar behaviour.

Using this knowledge to our advantage
(success)

Here's a common frustration: you have an element that creates a scroll container (eg. through overflow: hidden), but you want to let some items escape the scroll container. For example, maybe you want to add a tooltip to a scrollable list:

In general, I recommend solving this problem using portals, as we saw a few lessons back. But we can also solve this problem by exploiting the way containing blocks work with scroll containers.

 Show more
Fixed positioning

So, here's a question for you.

If we changed the pink box above from absolute to fixed, what would happen? Would the parent element remain scrollable?

Take a minute and think about it. Then, try it out, and see if it does what you expect:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This result surprised me at first. Did it surprise you?

When we switch to position: fixed, the parent's scrollbars disappear, and the element pops into view, as if overflow was set to its default value, visible. Why is that?

In order for a child to "trigger" the overflow, it needs to be contained by it. Setting position: relative is enough to contain an absolute child, but fixed children are only ever contained by the “initial containing block”, a box that exists outside the DOM structure.

In other words: .wrapper will only add a scrollbar when one of its contained children spills out of its bounds. But regular ol' HTML elements can't contain fixed children.

Similarly, this also means that fixed-position elements are immune from being hidden with overflow: hidden:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

---

## Sticky Positioning

Source: /css-for-js/02-rendering-logic-2/15-sticky

Sticky Positioning

position: sticky is the newest addition to the crew. The idea is that as you scroll, an element can "stick" to the edge. At that moment, it transitions from being relatively-positioned to being fixed-positioned.

In addition to setting position: sticky, you also need to pick at least one edge to stick to (top, left, right, bottom). Most commonly, this is done with top: 0px (or top: 0; the unit is optional when it's zero).

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .sticky-ball {
    position: sticky;
    top: 0;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: deeppink;
  }
  /*
    Artificially boost the size of the
    "body", so that the frame can be
    scrolled.
  */
  html, body {
    height: 150%;
    padding: 48px;
  }
</style>

<div class="sticky-ball"></div>
<p>Scroll within this white box!</p>
Result
Refresh results pane

There's a lot of subtlety with position: sticky. Let's go through some of the details.

Stays in their box

An often-overlooked aspect of position: sticky is that the element will never follow the scroll outside of its parent container. Sticky elements only stick while their container is in view.

In the following example, scroll all the way to the bottom, and note that the pink circle never leaves the black rectangle:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .sticky-ball {
    position: sticky;
    top: 0;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: deeppink;
  }

  .wrapper {
    height: 50%;
    margin-top: 25%;
    margin-bottom: 100%;
    border: 4px solid;
  }
  html, body {
    height: 165%;
  }
</style>

<div class="wrapper">
  <div class="sticky-ball"></div>
</div>
Result
Refresh results pane

I used this effect years ago in a portfolio I created for myself. Notice how each section's header stays adjacent to its content:

Here's an example of how this effect could be built. Note that it uses a bit of Flexbox to structure the layout. We'll cover Flexbox in depth in Module 4.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This effect is so cool because it convinces the eye that each heading "knows" to stop before the next one. In reality, each heading is inside a box, and can't leave that box.

Add a border to each section to reveal the truth.

Offset

As we've seen, every position value changes the way top/left/right/bottom work:

With relative positioning, the element is shifted from its natural, in-flow position
With absolute positioning, the element is distanced from its containing block's edge
With fixed positioning, the element is adjusted based on the viewport

With sticky positioning, these values control the “stick point”, the minimum gap.

We can set it to 0px if we want it to stick right against the edge, or we can pick a bigger number to give it a bit of breathing room. We can even use negative numbers if we want!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This does feel sorta weird to me. Typically, we imagine directions like top pushing an element around, affecting its position on the page. With sticky positioning, however, it's all about the “stick point”. top sets the minimum distance that the element will sit from the top of the viewport.

In many cases, we'll want to use top: 0px so that the element sticks right at the top of the viewport, but we can choose different values depending on the effect we're going for.

Not incorporeal

Earlier, we saw how absolute and fixed elements are “incorporeal”—they don't block out any space, like holograms. If they have any static or relative siblings, those siblings will be positioned as if the absolute/fixed elements don't exist.

Sticky elements are like relative or static elements in this regard; they're laid out in-flow. They take up real space, and that space remains taken even when the element is stuck to an edge during scrolling.

Toggle the .main.box element below between fixed and sticky, and notice how its siblings and parent container change:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

When we change our pink box to be position: fixed, the other boxes move up to fill the space, and the parent shrinks to half of its original height.

Sticky elements are considered "in-flow", while fixed elements aren’t.

Horizontal stickiness

Sticky positioning is almost always used with vertical scrolling, but it doesn't have to be! Here's an example with both vertical and horizontal stickiness:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Sticky positioning and browser support

Happily, position: sticky is supported across all major browsers
.

You may have heard that sticky (or even fixed!) positioning is buggy on mobile. It is true that for a while, iOS Safari in particular had trouble with it… but those days are long over. You can safely use sticky positioning on iOS and Android.

For a very long time, position: sticky didn't play nicely with HTML tables in Chrome: specifically, you couldn't set a <thead> or <tbody> to be sticky, you had to set individual cells (and it was kinda wonky). Fortunately, this has been addressed in Chrome 91; sticky tables work across all major browsers now!


---

## Exercises

Source: /css-for-js/02-rendering-logic-2/16-sticky-exercises

Exercises
1. Sticky header

Probably the most common use case for position: sticky is to create a sticky header!

Unlike fixed positioning, we can even be a little bit fancy—let's add a slight bit of “cushion”, so that the header doesn't stick immediately:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  header {
    height: 50px;
    background: slateblue;
    color: white;
    opacity: 0.96;
  }
</style>

<header>
  <ul>
    <li>Home</li>
    <li>About</li>
    <li>Contact</li>
  </ul>
</header>

<main>
  <p>Hello world!</p>
</main>
Result
Refresh results pane

The Solution:

(The CSS is structured slightly differently in the video; I rearranged things after receiving some feedback that it was confusing!)

2. Fix the bug

In the following playground, I expect the pink square to stick to the top edge on scroll, but it isn't working!

Can you figure out why?

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The Solution:

Note: An even better solution might be to move the position: sticky to the header! Make the entire header stick, rather than the pink box within. The best solution will depend on the particular circumstances in any given situation.


---

## Troubleshooting

Source: /css-for-js/02-rendering-logic-2/17-troubleshooting

Troubleshooting

Unfortunately, it's very common to apply position: sticky to an element, only for nothing to happen; the element won't stick!

Let's look at some common reasons for this.

A parent is hiding/managing overflow

This is probably the most common reason in a large, real-world application.

When we set overflow to hidden/scroll/auto, we create a scroll container. And when it comes to sticky positioning, elements stick to the closest scroll container.

Here's a concrete example of the problem:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  main {
    /*
      Comment out this line to enable
      sticky positioning!
    */
    overflow: auto;
  }
  header {
    position: sticky;
    top: 0;
  }
</style>

<main>
  <header>
    Sticky Header
  </header>
</main>
Result
Refresh results pane

Because <main> sets overflow: auto, it creates a scroll container. The header will only stick when scrolling within this scroll container.

If we reduce the height and add a bunch of content, the scroll container has enough stuff to warrant a scrollbar. Try scrolling within the black box:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  main {
    overflow: auto;
    max-height: 200px;
  }

  header {
    position: sticky;
    top: 0;
  }
</style>

<main>
  <header>
    Sticky Header
  </header>
  <p>
    Because the main tag has a max-height, the content inside that element won't fit. The 'overflow: auto' means that this container will have its own scrollbar, and the header will stick *within this context*.
  </p>
  <p>
    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.
  </p>
  <p>
    It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
  </p>
</main>
Result
Refresh results pane

Here's how to think about it: position: sticky can only stick in one "context". If it's within a scroll container, it can only stick within that container.

Frustratingly, it doesn't have to be a direct parent, either — it might be a great-great-great-great-grandparent that sets overflow: hidden, maybe to remove an unwanted horizontal scrollbar!

How do we figure out which element is the culprit? Here's a snippet you can run in the browser devtools to figure it out:

// Replace “.the-sticky-child” for a CSS selector
// that matches the sticky-position element:
const selector = '.the-sticky-child';

function findCulprits(elem) {
  if (!elem) {
    throw new Error(
      'Could not find element with that selector'
    );
  }

  let parent = elem.parentElement;

  while (parent) {
    const { overflow } = getComputedStyle(parent);

    if (['auto', 'scroll', 'hidden'].includes(overflow)) {
      console.log(overflow, parent);
    }

    parent = parent.parentElement;
  }
}

findCulprits(document.querySelector(selector));

You can copy/paste this snippet into the browser console, replacing selector with a CSS selector that matches your sticky element. It will crawl up the DOM tree looking for an ancestor with overflow set to either auto, scroll, or hidden.

So how do we fix it, once we've found the culprit?

If the culprit uses overflow: hidden, we can switch to overflow: clip. Because overflow: clip doesn't create a scroll container, it doesn't have this problem!
If the culprit uses auto or scroll, you might be able to remove this property, or push it lower in the DOM. This is a tricky problem, often without a quick solution. We saw an example of this sort of restructuring in the solution to the last exercise.

Later, in Module 5, we'll discuss some strategies for removing horizontal scrollbars. For now, just know that if sticky positioning isn't working, there's a good chance that an ancestor is managing overflow.

The container isn't big enough

We saw an example of this in Exercise 2 of the previous lesson. A sticky element will only follow the viewport as long as it remains inside its parent container.

Make sure that your sticky element has room to move within its parent container.

The sticky element is stretched

When using Flexbox or Grid, it's possible for a sticky element to be stretched along the cross-axis. This, in effect, makes it so that the element has no space to move in its parent container.

We haven't covered Flexbox yet, but if you're already familiar, you can see the problem and its solution in this Module 4 lesson, under “Sticky Sidebar”.

There's a thin gap above my sticky header!

If you intend for an element to sit right against the edge of the viewport, you might discover a thin 1px gap between the element and the edge in Chrome.

This is a rounding issue with fractional pixels. I've solved this issue by insetting the sticky element by a single pixel:

header {
  position: sticky;
  top: -1px; /* -1px instead of 0px */
}

---

## Hidden Content

Source: /css-for-js/02-rendering-logic-2/18-hidden-content

Hidden Content

We have one last thing to get to before we wrap this module up: invisible stuff.

There's a surprising amount of subtlety when it comes to hidden content — there are a variety of ways to hide elements in CSS, and they all come with different tradeoffs. If you're not careful, you can introduce accessibility problems, or hurt your search engine rankings!

Let's look at some of the most common methods.

display: none

This method is probably the most well-known way to hide content in CSS, and it’s very effective. Elements hidden with display: none won’t be painted, and they won’t participate in the layout at all, as though they don’t even exist.

It's unfortunate that this behaviour is triggered using the display property — it already has so many hats to wear! That same property is used to control whether an element is block or inline, as well as used to enable Flexbox and CSS Grid.

A button which is set to display: none cannot be clicked or focused. Notice that you can't select the "Two" button by tabbing through the existing buttons:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .hidden {
    display: none;
  }
</style>

<button>One</button>
<button class="hidden">Two</button>
<button>Three</button>
<button>Four</button>
Result
Refresh results pane

This property can be very useful when combined with media queries to toggle between mobile and desktop variants of an element:

.desktop-header {
  display: none;
}

@media (min-width: 1024px) {
  .desktop-header {
    display: block;
  }

  .mobile-header {
    display: none;
  }
}

In this snippet, we can see that by default, our .desktop-header is hidden. If the user's viewport is at least 1024px wide, however, we show the header by setting display: block, and hide the mobile header, flipping from one to the other. There will always be exactly 1 visible: never zero, and never both.

Comparison with rendering
(info)

If you use a framework like React, you may be wondering whether it makes sense to use display: none in CSS, or manage this entirely in React:

function Widget({ showButton }) {
  return (
    <div>
      {showButton && <Button>Hello</Button>}
    </div>
  )
}

In many situations, either option is fine; the user experience won't be impacted by your choice. But there are some subtle things to be aware of.

 Show more
Visibility: hidden

The visibility property allows you to hide an element, but in a slightly different way. It's like a cloak of invisibility; the item can't be seen, but it's still there, taking up space.

This property isn't as commonly used, because generally you don't want a big hole in your UI! But sometimes, it's helpful to be able to "hold space open" for an element that will soon become visible.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In this example, you can mouse over the answer area to reveal the answer. This works by toggling visibility from hidden to visible (the default value).

How does this compare to display: none? Try switching it out and see what changes.

Also, what happens when you change the answer? Try switching it to just "Snow White".

Sometimes, having an element control its parent's layout without being visible can be useful!

There's one other really cool thing about visibility: hidden. It can be selectively undone by children.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In this example, we've hidden the parent section, but chosen to reveal a specific child, the second button. This is unusual; the same can't be done with any of the other methods on this page. Usually, when a parent is hidden, all of its children will also be hidden, and there's no way around it.

Opacity

Finally, there's opacity!

Unlike the other options, opacity is not binary. We can flip it from 1 to 0 to fully hide an element, but we can use fractional values to make it semi-transparent.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Unsurprisingly, hiding an element with opacity does not remove it from flow. In fact, items hidden with opacity aren't really hidden:

Buttons can still be clicked
Text is still selectable
Form elements can still be focused

If we're not careful, we can introduce accessibility issues: imagine we hide a set of buttons, but keyboard users will still be able to tab through them, without knowing where their focus is! Opacity on its own is not a great way to hide something from view.

Opacity is helpful when:

An item needs to be semi-visible
An item's visibility needs to be animated, fading in and out

We'll learn more about animations in Module 8.

Accessibility

We've seen how to hide elements visually, using a few different methods. But not everyone who uses the web views it on a screen. We also need to consider how to make the best possible experience for folks using screen readers.

Hiding from screens

Let's look at how to hide an element from screens, but keep it discoverable for folks using a screen reader.

Here's the playground from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Here's the snippet in pure CSS:

.visually-hidden {
  position: absolute;
  overflow: hidden;
  clip: rect(0 0 0 0);
  height: 1px;
  width: 1px;
  margin: -1px;
  padding: 0;
  border: 0;
}

The clip property is a legacy alias for clip-path. clip-path allows us to cut shapes out of our elements; we'll explore it more in Module 9.

And finally, check out my custom VisuallyHidden component
.

aria-label?
(info)

There's another common way to add annotations for screen readers: through the aria-label HTML attribute:

<button aria-label="Contact support">
  <HelpCircle />
</button>

This solution works, but not quite as well as the Visually Hidden approach.

I'm not an accessibility expert, so I don’t know all of the potential issues, but one example is that automatic translation services
 will ignore aria-label, but will catch and translate visually-hidden children.

There are times where ARIA attributes are necessary, but as a general rule, if we can use the visually hidden approach, we should. The experience will be more accessible.

Hiding from screen readers

The .visually-hidden snippet lets us hide content from sighted users while keeping it around for folks using screen readers. But what if we want to do the opposite?

Sometimes, a DOM node serves some sort of cosmetic purpose, but we don't want its content to be accessible for folks using screen readers. We occasionally need to tell screen readers to ignore some markup.

For example: later in the course, we'll learn how to create this rising link effect:

In order for this effect to work, we need to duplicate the text content, something like this:

<a href="/">
  Go Home
  <span class="revealed">
    Go Home
  </span>
</a>

A screen reader will read this as "Go home go home", which isn't ideal!

We can tell screen readers to ignore an element using the aria-hidden attribute:

<a href="/">
  Go Home
  <span class="revealed" aria-hidden="true">
    Go Home
  </span>
</a>

This property has no effect on the layout / visual presentation. It's used exclusively by screen reader software.

Be careful when focusable elements are concerned!
(warning)

The aria-hidden directive will keep the text within from being read aloud, but it won't remove any descendants from the tab order.

For example:

<p aria-hidden="true">
  This paragraph contains <a href="/">a link</a>.
</p>

As a screen reader user tabs through the elements on the page, they'll still be able to access the link inside that paragraph.

Fortunately, a new "inert" attribute allows us to indicate to screen-readers to ignore interactive content:

<p inert aria-hidden="true">
  This paragraph contains <a href="/">a link</a>.
</p>

This property has broad browser support, supported in all modern browsers since early 2023
. There's also a WICG polyfill
 you can use, if you need 100% browser support.


---

## Workshop: Character Creator

Source: /css-for-js/02-rendering-logic-2/19-character-workshop

Workshop: Character Creator

Alright — we've covered a lot of stuff in this module. Let's build something with all of our newfound knowledge!

Your mission

In this workshop, you're asked to build a character creator for a Sims-style video game:

All of the functionality and initial styling has been provided; it's your job to apply the lessons learned in this module to bring it all together.

Let's go over the project in more detail:

Intro to React and JSX

If you've never used React before, I've created a short mini-lesson that teaches the fundamentals of React and JSX:

Bonus: Intro to React
Access starter files

As always, you can choose to fork and clone the Git repository, or else fork the CodeSandbox and work in-browser:

Download from Github
Work on CodeSandbox

Please note: This project requires Node 18+. If you try to run this workshop using an older version of Node, you’ll get an error about structuredClone not being defined. I recommend using NVM
 to easily hop between Node versions.

Local development troubleshooting
(warning)

If you try to run this codebase on your local machine, it's possible you might run into some issues. I've created a Troubleshooting guide that covers the most common issue that developers run into with this workshop.

If you're still having problems after going through this guide, you can share what's going on in Discord, and we'll be happy to help you figure it out!

Once you've finished with the workshop, click "Submit entry" below. Friendly reminder that submissions are not graded, though I may review them periodically!

Submit Workshop

I review a small percentage of submitted workshops, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## Workshop Solution

Source: /css-for-js/02-rendering-logic-2/20-character-workshop-solution

Workshop Solution

Modernizing the workshops
(warning)

In December 2024, I updated many of the workshops to use Vite, a modern build tool for React applications. Previously, they used create-react-app, a tool which is no longer actively maintained. The solution videos on this page were filmed using the older version of this workshop.

The solution code itself hasn’t changed, but you may notice some discrepancies between your local repository and the one shown in the videos. For example, some file extensions have been changed from .js to .jsx, because Vite doesn’t support using JSX inside .js files.

Below each solution video, you’ll find a link to the solution code on Github. This code has been updated to use Vite, so please use this as the “source of truth” for all exercise solutions, rather than what you see in the videos.

Apologies in advance for any confusion! If you spot any mistakes or have any questions, please let me know in our community Discord.

Exercise 1: Footer link color
View the code on Github
Exercise 2: Layout

Collapsed SVGs?
(warning)

If you try and code along with this video, you'll notice something interesting. About halfway through, your SVG will have a height of 0px, and will be completely invisible.

By the end of the video, everything is correct. But, if you're halfway through the video and wondering why you're not getting the result you see in the video, read on for an explanation:

 Show more
View the code on Github
Exercise 3: Overflow
View the code on Github

Improved accessibility
(info)

To make this application accessible for folks who rely on a keyboard or screen reader, I chose to make each option a <button>, and to indicate the selected option with aria-pressed:

<button
  {...delegated}
  aria-pressed={isSelected}
  className={styles.toggleButton}
  style={{ backgroundColor: color }}
>
  <span className="visually-hidden">{label}</span>
  {children}
</button>

A side-effect of this implementation is that it’s a bit tedious for keyboard users. Each option is its own <button>, which means users have to tab through each and every option. With more than 50 combined options, that’s a lot of tabbing to make it through the page!

A better solution would be to use radio buttons. When a radio button is focused, the left/right arrow keys can be used to move between options, while the tab key skips between sets of radio buttons.

Here’s a quick sketch of this alternative approach:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Using your keyboard, try to select various options. You should notice that the Tab key moves you between groups, and the left/right arrow keys allow you select specific options.

(If you use Safari on macOS, you may need to tweak a global setting
 to allow you to tab through radio buttons.)

Exercise 4: Perspective
View the code on Github

You can also see all of the changes
 for the solution on Github, for all exercises.

Stretch goal quirk

Unfortunately, I don't have a solution for the stretch goal, but I did want to touch on something a bit funky that Discord member bjrmatos discovered: on mobile, a mysterious horizontal scrollbar appears!

We'll discuss weird horizontal scrollbars more in Module 5, but I think if you attempted the stretch goal and were stymied by this strange quirk, it's worth taking a quick detour.

I explain what's going on in this Video Archive video:

Video Archive video: Mysterious Workshop Scrollburglar
Onto a new module!

Congratulations on making it through Module 2! This module deals with some of the most complex mechanics in the language.

If you're still feeling a bit shaky when it comes to stacking contexts and the new layout modes, it's OK! We'll have plenty more opportunities in this course to practice these ideas 😄

If there are any concepts that still seem foggy to you, bring it up on Discord! Our community exists to help students like you push through the complex bits and develop a deeper understanding of CSS.


