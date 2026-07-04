# CSS for JS - Module 7: CSS Grid

---

## Introduction • Josh W Comeau's Course Platform

Source: /css-for-js/07-css-grid/01-introduction

CSS Grid

At this point in the course, we've become familiar with a lot of layout modes: flow layout, positioned layout, Flexbox, and even some funky ones like multi-column layout and float.

In this module, we'll take a look at the latest and greatest CSS layout mode: Grid layout.

CSS Grid builds on a lot of the ideas and patterns from Flexbox, but with the goal of distributing children across two dimensions instead of one. It's sorta like Flexbox's older cousin.

In this module, we'll learn:

How CSS Grid works at a deep, fundamental level
How to use it in a backwards-compatible, safe way for all users
How to use it to create complex layouts, using both responsive and fluid approaches for dynamic grids
Recipes for some of the most common CSS Grid challenges
Understanding and working around some of the common (and not-so-common) quirks with this layout mode

At the end of the module, we'll use all of this knowledge to build a sophisticated, dynamic layout for a fictitious online newspaper, the New Grid Times:


---

## Mental Model

Source: /css-for-js/07-css-grid/02-mental-model

Mental Model

Let's start with the mental model I use for understanding CSS Grid.

In CSS Grid, our element's content box is sliced into rows and columns. The rows/columns don't have to be the same size, but they do have to be consistent. If a column is 250px wide, each cell in that column will share that width.

Valid Grid
Valid Grid
Invalid Grid

CSS Grid doesn't support zig-zag columns like this. Every cell in the same column needs to have the same width. The same is true for rows: every cell in the same row needs to have the same height.

We also can't end a row or column prematurely; If our grid has 2 columns and 3 rows, each column will have 3 cells. This sort of thing is illegal:

Every row needs to have the same number of columns (and vice-versa). We can't have a grid where the first row has 1 column, the second row has 2 columns.

But wait just a minute: how can this be illegal? Many common grid layouts require doing this sort of thing. The popular "Holy Grail" layout has columns that don't extend to the top or bottom of the grid:

To solve this apparent paradox, we'll need to dig a bit deeper into how CSS Grid works.

Rows/columns are invisible markers

Every tangible object in the physical world can be broken down into a complex combination of atoms. A plastic bottle of water might be made up of hydrogen, oxygen, carbon, and sulfur.

Similarly, on the web, every layout can be broken down into a complex combination of divs, spans, sections, headers, buttons, etc.

The web is made up of boxes inside boxes inside boxes. If we were to add a red outline to every DOM node on the page, we expect to see a full representation of that page's structure.

For example, say we have an HTML table:

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Email</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Axel Duproprio</td>
      <td>axel@gmail.com</td>
    </tr>
    <tr>
      <td>Beatrice Bouchard</td>
      <td>beatrice@gmail.com</td>
    </tr>
  </tbody>
</table>

We haven't talked much about tables in this course, but here's how it breaks down:

Each tr element creates a new row
Each th/td element creates a new cell
All of those th/td elements will align neatly into columns

We can add an outline to every HTML element, and see the structure clearly:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

CSS Grid is fundamentally different, because the structure happens exclusively in CSS. There are no DOM nodes that represent the rows or columns in CSS Grid. Instead, the rows and columns are invisible markers, tools that our HTML elements can use to position themselves.

Rows and columns are like the lines painted on the ground in parking lots. Drivers can use these lines to align their vehicles, but really they're just symbols. It's up to the driver to decide how to use them.

This has been very abstract, so let's put it in concrete terms. Here's how we'd set up a CSS Grid to recreate a “Holy Grail” layout:

It looks almost the same as that “illegal” grid structure we saw earlier, but with 1 critical difference—the first column stretches all the way from top to bottom:

The "parking lot" analogy works in a number of ways:

Like the chaotic-evil driver who parks sideways and takes up 3 parking spots instead of 1, elements can choose to span multiple cells
An HTML element can fit snugly in its assigned cell (like a truck that barely fits in the spot), or only a tiny part of it (like a Mini Cooper in an extra-wide spot)
Cells can be totally empty! A parking lot with 50 spots might only have 1 car, in a seemingly-random spot
A single grid cell can contain multiple children, like 3 motorcycles parked in the same spot.
*

The thing that makes CSS Grid so powerful is that the grid structure can be selectively ignored. All kinds of cool layouts are made possible by this unique quirk, and we'll be exploring it throughout this module.

Inset grids
(warning)

In the examples we've seen so far, 100% of the grid's content space is taken up by rows and columns. Technically, this isn't a requirement for CSS Grid.

Let's suppose that we create a grid with 4 columns that are each 100px wide. If the container is larger than 400px, we'll wind up with some "dead space" at the end:

In practice, we rarely want to take advantage of this feature. It's usually simpler if our grids do span the entire area. I'm mentioning it here just to give you an accurate mental model, not suggesting that you should structure your grids this way.

The Grid Is Right

This game shows you a sketch of a graph. Your mission is to decide whether this grid can be implemented using CSS Grid, or whether it violates the rules of the CSS Grid algorithm.


---

## Grid Flow and Layout Modes

Source: /css-for-js/07-css-grid/04-grid-flow

Grid Flow and Layout Modes

Alright, let's create some grids!

Like Flexbox, we can enable the Grid layout mode with the display property:

.wrapper {
  display: grid;
}

Here's what happens when we dump some stuff into this element:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .wrapper {
    display: grid;
  }

  header, section, footer {
    border: 1px solid;
  }
</style>

<div class="wrapper">
  <header>Hello World</header>
  <section>Stuff here</section>
  <footer>Copyright notice</footer>
</div>
Result
Refresh results pane

This is known as an implicit grid. We haven't told the engine what the rows and columns should be, and so it's come up with its own grid, based on the number of children.

By default, it creates 1 new row for each element. Because our grid parent is given 3 children, we'll wind up with a 1x3 grid:

Grid children
Grid structure

Heads up! This is one of those interactive widgets. Hover or focus to see the transformation.

Implicit grids want to fill the available space. Notice that the elements stretch across the horizontal space like block-level elements in Flow.

If we give our grid a fixed height, we notice the same behaviour with rows:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Because our grid is 300px tall, each row winds up being 100px tall. Each element in our grid spans the entire width and height of its cell by default.

Grid children
Grid structure
Inspecting grids in the devtools

In this video, we see how to use the CSS Grid devtools to visualize the grid structure. This is especially important when our grid children don't align perfectly with the grid structure:

Grid children
Grid structure

Update: In the video, I mention that Chrome's Grid Inspector struggles with the iframes on this platform, and that you can fix it by refreshing the page. You can also fix it by closing and reopening the devtools! Still annoying, but less trouble.

Grid auto flow

So far, all of the grids we've seen have been 1 × 𝓃, where 𝓃 is the number of children. We wind up with a single column and 𝓃 rows.

What if we want to distribute the elements horizontally instead of vertically, though?

We can change the flow direction for implicit grids with the grid-auto-flow property:

1
2
3
4
grid-auto-flow
row (default)
column

At first glance, this feels quite a bit like flex-direction, but there's a critical difference.

The truly unique thing about Flexbox is that it's bi-directional. By flipping flex-direction from row to column, we're changing which axis is the primary axis, and which one is the cross axis.

In CSS Grid, there's no such thing as a "primary axis" or a "cross axis". The concept doesn't exist.

Instead, CSS Grid has rows and columns. The rows are always arranged along the "block" axis. In English and other horizontal languages, this is the vertical axis. Rows are always stacked one on top of the other. Columns are always arranged along the "inline" axis (horizontally).

CSS Grid is like Flow layout in this respect. Rows are distributed along the "block" axis, just like block-level elements in Flow.

When we change grid-auto-flow from row to column, we're not fundamentally changing the orientation of our grid; everything stays the same, except for the fact that our grid will have multiple columns instead of multiple rows.

Layout modes

Consider the following code snippet:

<style>
  .wrapper {
    display: grid;
  }

  header {
    display: inline;
  }

  .help-btn {
    position: absolute;
    bottom: 0;
    right: 0;
  }
</style>

<body>
  <main class="wrapper">
    <header>Hello World</header>
    <button class="help-btn">Help</button>
  </main>
</body>

For each of our 3 elements — main, header, and button — which layout mode is being used to render it?

Element	Your Answer
<main>
–––
Flow layout
Positioned layout
Flexbox layout
Column layout
Float layout
Grid layout
–––

<header>
–––
Flow layout
Positioned layout
Flexbox layout
Column layout
Float layout
Grid layout
–––

<button>
–––
Flow layout
Positioned layout
Flexbox layout
Column layout
Float layout
Grid layout
–––
SKIP QUIZ

Answer the quiz above to continue with this lesson.


---

## Grid Construction

Source: /css-for-js/07-css-grid/05-grid-construction

Grid Construction

So we've seen how CSS Grid can implicitly create a grid when we pass it some children. But the real magic with CSS Grid comes from being able to explicitly define our own grids.

Let's start by defining some columns. We do that with the grid-template-columns property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    display: grid;
    grid-template-columns: 25% 75%;
  }
</style>

<div class="wrapper">
  <aside>On the side</aside>
  <main>Main content</main>
</div>
Result
Refresh results pane

This property controls two things:

The number of columns we want our grid to have
The individual widths of each column

In this case, we're specifying that we want a 2-column grid, where the first column takes up 25% of the available space, and the second column takes up 75%.

Unlike in Flexbox, these values aren't “suggestions”, they're hard limits. Try resizing the “Result” pane above; the first column never stops shrinking, even when there isn't enough space for its content!

This behaviour can cause problems. If our column happens to have a large image, it'll overflow by default:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    display: grid;
    grid-template-columns: 25% 75%;
  }
</style>

<div class="wrapper">
  <aside>
    <img
      alt="Curious-looking dog"
      src="https://courses.joshwcomeau.com/cfj-mats/dog-one-300px.jpg"
    />
  </aside>
  <main>Main content</main>
</div>
Result
Refresh results pane
Flexible columns

What if we want our columns to grow if their contents won't otherwise fit?

For that, we have a new fr unit:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The fr unit brings Flexbox-style flexibility to CSS Grid. You can think of it kinda like flex-grow, except that it's operating on the columns, and not on the actual child elements.

fr stands for “fraction”. In this example, we're saying that the first column should take up 1 "unit" of space, and the second column should take up 3 "units". There are 4 units total, so the first column is 1/4th, the second column is 3/4ths.

Like flex-grow, the fr unit is flexible. In this example, our first column wants to take up 1/4th of the available space, but its child is too wide, so it grows to accommodate it.

This behaviour only happens with the fr unit (as well as auto). Pixels, rems, and percentages are all hard limits.

The other thing to note about fr is that it distributes available space. Consider this situation:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

First, the grid reserves 200px for the first column. Then, it distributes whatever space remains to the other 2. This is how flex-grow works when we don't set flex-basis to 0.

Implicit rows

CSS Grid is a two-dimensional layout mode. Let's start working in two dimensions!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In this example, we've created a 2-column grid, and then we've given it 7 children. The default behaviour in CSS Grid is that every child gets its own cell. Our grid will implicitly create as many rows as it needs to.

How tall will these rows be? By default, they grow and shrink as-needed, based on the children. Consider this example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Our grid has 2 rows, with 2 children per row. In the first row, our tallest child is the first one, at 50px, so the grid is given a height of 50px. In the second row, the second column holds the taller child at 80px, and so it gets a height of 80px.

Here's how that looks:

Grid children
Grid structure

You can also verify this using the CSS Grid devtools:

Implicit rows are handy when we're rendering based on some data, like a search results page. We can toss a bunch of items into our grid and trust that each row will be the right size for the content.

But what if we want to control the heights of each row?

Explicit rows

When creating whole layouts in CSS Grid, it's common to give each row an explicit height. We can do this with the grid-template-rows property.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

We've created three rows: a 64px-tall header, a 100px-tall footer, and a main content area that fills the remaining space.

Note that in order for the grid to fill the page, we've had to use the min-height percentage trick from Module 1. We could also set min-height: 100vh, but it's not quite as mobile-friendly.

Out-of-bounds items

Let's imagine we create an explicit CSS Grid with 1 column and 3 rows. By default, each child will be assigned to its own cell.

What happens if we include more than 3 children?

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In this example, we've only declared 3 rows, but added 4 children, so the browser creates a 4th row and squeezes it in. It doesn't cause an overflow, it just means that there's less available space for the other elements.

It's a bit misleading to think about “implicit grids” and “explicit grids”. It's more accurate to say that individual rows / columns can be implicit or explicit. An “explicit grid” can still generate implicit columns or rows if we add additional children.

Gaps

As with Flexbox, we can build gutters into our grid with the gap property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

What if we only want there to be a gap between rows, and not between columns? We can specify two values, one for each direction:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

gap is a relatively modern feature, though it's grown to be quite well-supported
 in modern browsers. If you need to support Internet Explorer, you should use the grid-gap property instead. The two properties can be used interchangeably.

The “repeat” function

Let's suppose we're building a weekly planner / agenda application.

We need 6 columns: 1 wide column for the "metadata", and then 5 equal-width columns for each day of the week.
*

We could write out each column verbatim:

.calendar {
  grid-template-columns:
    250px 1fr 1fr 1fr 1fr 1fr;
}

This is fine, but it's an annoying bit of friction. It's also harder to tell at a glance exactly how many columns there are.

Fortunately, CSS Grid introduces a function that makes life a little bit easier:

.calendar {
  grid-template-columns: 250px repeat(5, 1fr);
}

We're saying that we should repeat the 1fr value 5 times. The end result is the same, but it's easier to read.

This is most commonly used with the fr unit, but it doesn't have to be! We can use any unit, like repeat(4, 200px).

Exercises
Mondrifans

Piet Mondrian was a Dutch painter, famous for his paintings of colorful squares.

Let's suppose we're building a Mondrian fan club site, and we want the layout to match his aesthetic:

Give it a shot in the playground below. Some helpful design guidelines have been added in the comments.

Note: This playground starts with an all-black background color, and this can give the impression that it's bugged / hasn't loaded. Sorry for any confusion!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Solution:

Solution code
(success)

 Show more
Calendar

Let's create a mini calendar:

Some notes:

The dark outer border is part of the challenge! It should wrap neatly around the calendar.
To keep things simple, we're assuming that the 1st day of the month is a Sunday.
Each day on the calendar should be a square, sized at 2rem x 2rem.
*
We're using React for this one, to make it easier to generate the 30 child elements we need. But you shouldn't need to tweak any of the JSX, only the CSS.

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

Solution code
(success)

 Show more

---

## Alignment

Source: /css-for-js/07-css-grid/06-alignment

Alignment

When it comes to alignment in Flexbox, we can control the distribution along the primary axis with justify-content, and along the secondary axis with align-items.

Things are kinda similar in CSS Grid. We use some of the same properties, but they don't quite work exactly the same way.

Aligning columns

We'll start by looking at how to align columns. For that, we use justify-content:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    display: grid;
    justify-content: center;
  }
</style>

<div class="wrapper">
  <header>Hello World</header>
  <section>Stuff here</section>
  <footer>Copyright notice</footer>
</div>
Result
Refresh results pane

The default behaviour in CSS Grid is to stretch the columns to take up all available space. justify-content: center overrules this behaviour.

In order to center our column within the grid, it has to figure out how wide that column should be. This is no small task! It has to look at the contents of each row, and figure out which child is widest.

We can see this result in the devtools:

In the first image, we see that the width of our column is 123.72px. In the second image, we inspect the last child, and see that it also has a width of 123.72px.

Because that third child has the widest natural width, the entire column shrinks to fit that width, and that width is used for the other elements (which would otherwise be shorter).

We can skip this whole process by giving the column an explicit width:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In addition to center, we also have start and end. This is similar to flex-start and flex-end, but since we aren't in Flexbox, we can omit the flex- prefix.

We also have the "distributed" options we saw in the Flexbox module: space-between, space-around, and space-evenly. They make more sense when our grid has multiple columns:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

So, justify-content allows us to change how our columns are distributed. But there's another property we need to familiarize ourselves with: justify-items.

Poke around with this example, and see if you can make sense of what it's doing:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

At first glance, this seems to violate one of our core principles: columns aren't supposed to change their width across different rows! A column should be a consistent width, for the entire length of the grid.

Upon closer inspection, though, we notice something interesting:

The columns are actually full-width! But the items within the column have been shrunk down and centered.

Normally, a grid child will stretch across the entire width of its column. If we place an element in a 100px-wide column, we'll get a 100px-wide element.

But that's just the default, it isn't set in stone. justify-items changes this behaviour so that the child element moves around within its cell.

In other words:

justify-content applies to the grid structure, changing the columns.
justify-items applies to the child elements, without affecting the shape of the grid.

Different values for content and items
(info)

The values for justify-items are slightly different than the values for justify-content: we have center, start, and end, but we don't have any of the "space" variants like space-between.

Take a minute and think about it: Can you figure out why space-between doesn't make sense for justify-items?

 Show more
Aligning rows

In CSS Grid, align-content is how we align the rows in our grid:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Here's a visualization showing what's happening here:

Grid children
Grid structure

Because align-content is set to space-between, the grid has shifted the rows to be as far apart from each other as possible, like magnets that are repelling each other. And because we haven't given our rows an explicit height, they stick with their intrinsic size, 26px.

Note that this only works because we've given our grid a fixed height of 300px. Without that declaration, align-content has no effect: the rows will be packed in like sardines! We need some free space in the grid, otherwise there really isn't any difference between the options.

How about align-items? You guessed it: it controls the element's vertical position within the row:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Grid children
Grid structure

With align-items, we control the placement of individual elements within each cell.

Self-alignment

In Flexbox, align-items is used on the parent to control the cross-axis position for all of the elements. But we also have align-self, which allows a specific child to overrule it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In CSS Grid, align-self works pretty much the same way. We apply it to specific grid children, and it changes their vertical position within the grid cell.

We also have justify-self, which changes a particular element's horizontal position, within the grid cell:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Here's how this is structured:

Grid children
Grid structure
When to use items vs content

So far, we've been spending our time in the realm of the theoretical, learning about the rules of the algorithm.

Let's talk a bit about when these different tools come in handy.

The playground from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Exercises
Diagonals

Using grid alignment, update the code below to create a "diagonal" set of boxes:

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

Solution code
(success)

 Show more
Broken rectangles

Let's make something rather neat-looking!

A variable, --rect-width, holds the width of the entire rectangle. Here's how that width is divided, on each row:

The starter code might be a bit hard to make sense of, so feel free to use the Grid devtools to take a peek at the initial setup!

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

Solution code
(success)

 Show more

---

## Grid Areas

Source: /css-for-js/07-css-grid/07-grid-areas

Grid Areas

The killer feature of CSS Grid, in my opinion, is the ability to name regions of the grid, and assign elements to them.

In this video, we learn about grid-template-areas and grid-area:

Correction
(warning)

In the video above, we see the following declaration:

.wrapper {
  grid-template-rows: 80px 2fr;
}

There's nothing explicitly wrong here, but there is something a bit strange: why am I setting 2fr here?

The answer is: it was a mistake 😅. An earlier version of this playground used fractional units for both rows. When I updated the first row to use pixels, I forgot to change the second.

As we saw in the Grid Construction lesson, the fr unit allows us to specify how rows/columns share extra space, similar to the flex-grow property in Flexbox. When we only have one child using the fr unit, it'll consume all of the extra space, regardless of whether it's set to 2fr, 1fr, or 10000fr.

And so, the most conventional thing is to use 1fr, like this:

.wrapper {
  grid-template-rows: 80px 1fr;
}                       /* ↑↑↑ */

Here's the code from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Exercises
Holy Grail

One of the main use cases for CSS Grid is to create full-page layouts.

Let's create the most famous full-page layout, “Holy Grail”:

The constraints are given in the form of a code comment below:

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

Solution code
(success)

 Show more

---

## Tracks and Lines

Source: /css-for-js/07-css-grid/08-tracks-and-lines

Tracks and Lines

In the last lesson, we saw how grid-template-areas lets us group subsections of the grid into areas. We can then assign children to those areas with grid-area.

This API, however, is syntactic sugar?. If we want to truly understand how CSS Grid works, we need to understand how the algorithm sees the grid structure.

Grids are composed of tracks and lines:

In this video, we'll cover how to use grid lines to assign children:

Spanning multiple lines

In the examples above, we used grid-column and grid-row to select a specific location for our grid child. This is useful when we know exactly where our child should sit, but in other cases, we’ll want things to be a bit more dynamic.

For example, maybe we want our grid children to fill the grid naturally, but we want certain grid children to span multiple columns:

1
2
3
4
1
2
3
4
5

In this example, most of the grid children (represented with gray boxes) sit in a single grid cell, but we want featured children (represented with yellow boxes) to be double-wide, spanning across two columns.

We could solve this by giving each child a specific column/row assignment, but this sounds very tedious, especially if the grid is generated from dynamic data! Instead, we can use the special span keyword for featured children:

.grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: repeat(3, 1fr);
}
.featured.child {
  grid-column: span 2;
}

Here’s a live-editable playground showcasing this functionality:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Awkwardly-placed featured children?
(warning)

In the example above, the two featured children are conveniently not assigned to the fourth and final column. What happens if we put a two-column-wide grid child in the last column?

Well, let’s try it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The featured child can’t fit in that final column. As a result, it’s pushed to the next row, and a blank spot is left in the first row’s final cell.

CSS Grid has a neat trick for this sort of situation. If the order of the children isn’t important, we can instruct the browser to cram the children in wherever they’ll fit. Check this out:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

We learned about grid-auto-flow in the “Grid Flow” lesson, though we didn’t cover the dense variant. When we add dense, we tell the grid layout algorithm to prioritize filling any gaps, even if that means displaying the items out-of-order. In this case, it discovered that the fifth grid child would fit in that fourth grid cell, and so it gets plucked up and moved ahead of the featured child.

Truthfully, I don’t find myself using this variant that often, but it can be very handy in certain situations!


---

## Reading Flow

Source: /css-for-js/07-css-grid/08.01-reading-flow

Reading Flow

In the past couple of lessons, we’ve seen a few different ways that children can be laid out within a grid:

Using a named area (eg. grid-area: header)
Using row/column assignments (eg. grid-column: 2 / 4)
Using automatic placement (eg. grid-auto-flow: row dense)

All of these options have the potential to cause the grid children to be arranged in an order that doesn’t match their order in the DOM. There’s no guarantee that the element’s order in the HTML markup will match the visual order on-screen.

This isn’t a problem for most users, but let’s consider how this can affect folks who navigate using the keyboard. Try tabbing between the buttons below:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    display: grid;
  }

  .btn.one {
    grid-column: 5;
    grid-row: 3;
  }
  .btn.two {
    grid-column: 2;
    grid-row: 5;
  }
  .btn.three {
    grid-column: 3;
    grid-row: 1;
  }
  .btn.four {
    grid-column: 1;
    grid-row: 1;
  }
</style>

<div class="wrapper">
  <button class="btn one">A</button>
  <button class="btn two">B</button>
  <button class="btn three">C</button>
  <button class="btn four">D</button>
</div>
Result
Refresh results pane

Here’s what you should see:

Keyboard users expect tab navigation to follow a logical sequence, from left to right and from top to bottom. In this case, I think the tab order should be D → C → A → B, but instead, it follows the order specified in the markup:

<button class="btn one">A</button>
<button class="btn two">B</button>
<button class="btn three">C</button>
<button class="btn four">D</button>

Having the focus hop all over the place like this is super confusing and disorientating. A rough analogy for mouse users would be if scrolling went in the opposite direction for part of the page.

In this particular case, the solution is pretty straightforward: we can re-arrange the DOM nodes so that they match the visual order. Here’s what that looks like:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

But what if we can’t solve this problem by re-arranging the DOM nodes?

For example, suppose we have a responsive design that changes layout based on the viewport size:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

On larger screens, the <aside> comes first in the visual order, but on smaller screens, <header> comes first. We can’t match the DOM order to the visual order because the visual order changes based on the window width.

Here’s another example: what if we set grid-auto-flow: row dense? As we saw at the end of the previous lesson, this declaration will cause the grid algorithm to rearrange the grid children to avoid gaps, changing the visual order dynamically.

There are plenty of situations in CSS Grid where it’s just not practical to ensure that the DOM order matches the visual order of the grid children. Fortunately, a modern CSS feature offers a solution to this long-standing problem.

The reading-flow CSS property allows us to override the default tab order, to use a visual order instead. Check this out:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

If you’re using a supported browser, you should now see that focus goes in the right order: D → C → A → B.

In this example, I’m setting reading-flow to grid-rows, which will go from left to right through each row, from the top row to the bottom row. This property respects writing-mode, so the horizontal order would be flipped in a right-to-left language.

We can also use this property in Flexbox by setting it to flex-visual. We can even establish our own order by setting it to source-order and applying a reading-order integer to each child.
*

In other words, reading-flow lets us choose how elements should be ordered when traversing through them. This applies to the tab order, but it also affects things like the order in which content will be announced for screen readers. Until now, assistive technologies relied exclusively on the DOM order, based on the HTML markup, when really this concern should be handled by the presentation layer, CSS.

You can learn more about reading-flow and the related reading-order property in this wonderful article from Di Zhang and Rachel Andrew:

Use CSS reading-flow for logical sequential focus navigation

Browser support
(warning)

As of December 2025, reading-flow is only supported in Chrome, Edge, and Opera. It’s sitting around 71%
 of tracked browsers on caniuse.

This feels like the sort of feature that Safari and Firefox are likely to prioritize soon, so I’m hopeful that browser support will improve quite a bit over the next year or so.

In the meantime, it’s still a good idea to try and match the DOM order to the visual order, whenever possible. In cases where we can’t keep the DOM order in sync with the visual order, reading-flow is a great progressive enhancement.


---

## Fluid Grids

Source: /css-for-js/07-css-grid/09-fluid-grids

Fluid Grids

Perhaps the most famous CSS Grid snippet looks like this:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .grid {
    display: grid;
    gap: 16px;
    grid-template-columns:
      repeat(auto-fill, minmax(150px, 1fr));
  }
</style>

<main class="grid">
  <div class="item"></div>
  <div class="item"></div>
  <div class="item"></div>
  <div class="item"></div>
  <div class="item"></div>
  <div class="item"></div>
</main>
Result
Refresh results pane

Try resizing the “Result” pane in full-screen mode to see how it works.

Essentially, this handy-dandy “World Famous” grid snippet creates a grid with a dynamic number of columns. Each column will be the same width, and it'll try and pack as many in as it can while staying above a specified minimum (in this case, 150px).

It's useful when we have a list of items that we want to render, like a group of cards. We want them to be uniform, and to tile nicely no matter what the screen size is, or how many items we have.

It's also a very complicated snippet, one which leverages many advanced aspects of the Grid layout mode. In this lesson, we're going to break it down, and learn how each piece works. This is really useful, as it gives us a whole set of tools we can use in other situations!

Clamping with minmax

Earlier, we saw how the “min”, “max”, and “clamp” functions can be used to constrain a specific value between a lower and/or upper bound.

CSS Grid has a similar function: minmax.

Here's an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Here's my mental model for what's going on here: we want to have two equal-width columns (both 1fr), but our first column should never shrink below 50px, while the second one shouldn't shrink below 250px.

It's essentially a way to set a min-width on our grid columns.

Similarly, minmax allows us to set a min-height when used with grid-template-rows.

One quick gotcha: the flexible unit has to come last. minmax(1fr, 250px) is invalid, because 1fr isn't a valid "minimum" value.

Generating columns with auto-fill

Earlier, we saw how the repeat function can save us a bit of typing:

.grid {
  grid-template-columns: repeat(7, 1fr);
  /*
    ...is equivalent to:
    grid-template-columns: 1fr 1fr 1fr 1fr 1fr 1fr 1fr;
  */
}

repeat has another trick up its sleeve, though: it accepts special keywords in addition to straight-up numbers.

Let's say we have some cards that are exactly 150px wide. We want to fill the grid with as many 150px-wide columns as possible.

We can do that with auto-fill:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Inspect this grid in your browser's devtools, and resize the “Result” pane. Notice that as the available space increases, so too does the number of columns.

When the available space isn't a perfect multiple of 150px, we have some leftover space. We can control how the columns are aligned with justify-content:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

auto-fill allows us to implement fluid principles in CSS Grid. As we saw in a previous module, fluid design uses constraints that shift automatically based on the container size, rather than specifying explicit behaviour at particular viewport sizes.

Putting them together

Alright, so we know that minmax lets us clamp a value to a specific range, and we know that repeat takes a special value, auto-fill, which generates a dynamic number of columns.

When we put them together, we recreate the World Famous Grid Snippet:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Here's how this algorithm works:

Figure out how many columns we can fit at the minimum acceptable size, 150px.
Scale up each column so that the entire horizontal space is filled

If the container is 450px wide, we can fit exactly 3 columns at 150px, and there's no leftover space.

If the container is 480px wide, we can still only fit 3 columns, but there's 30px of leftover space. Each column gets 10px wider, so that we have 3 columns that are 160px wide, perfectly filling the 480px-wide container.

Note: This is a slight oversimplification. The real algorithm subtracts additional space like gap or padding from the calculations, and supports having different columns of different proportions. But this is the basic idea!

auto-fill vs. auto-fit

In addition to the auto-fill keyword, there's also an auto-fit keyword.

Most of the time, these two properties work exactly the same way, and can be used interchangeably. There is one significant difference, though.

Let's suppose that we're rendering a dynamic list of data. We might have 20 items, or 40 items, or 2 items.

What should happen when we have extra space? Let's suppose that we have space for 6 items, but we're only given 2 items. Should we create 4 extra empty columns, or should we stretch our two columns to be super wide, filling the available space?

This is the fundamental difference between auto-fill (lots of empty columns) and auto-fit (stretched ultra-wide columns).

Try it for yourself in this snippet:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Personally, I almost always use auto-fill, since it ensures consistency in my grid no matter how many items I have. But if you want to make sure the elements span 100% of the available space, auto-fit has you covered.

For more information on this distinction, check out this fantastic article
 on the topic by Sara Soueidan.

Responsive tweaks

So far, we've been working with cards that have a very small minimum width, 150px.

Notice what happens if we choose a larger minimum width:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

We've declared that our columns should never shrink below 400px wide, which causes a horizontal overflow on smaller screens!

How can we solve for this? Well, there are two options.

The responsive approach

We can always use a media query that changes the grid structure when we get below the minimum threshold:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

When our viewport is smaller, we'll stick with a much-more-simple grid layout: a single column. We'll only use our World Famous Grid Snippet on larger screens, when we have enough space for it.

Note that the media query has a 50px buffer. I flip the switch at 450px, even though our minimum card width is 400px. This adds enough space for padding (32px total, 16px on each side), and a scrollbar (10-15px depending on operating system).

The fluid approach

Alternatively, we can add yet another constraint to our snippet:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Yikes, what a snippet 😬. Let's talk through what's happening here.

The first part to get evaluated is this:

min(400px, 100%)

100% refers to the .grid element's width. If we're viewing this on a large monitor, .grid might be 800px wide, so 100% resolves to 800px.

min() picks the smaller of the two values, so on a large monitor, 400px is returned from this expression.

On a smaller screen, however, 100% might only be 250px. In this case, 100% is returned, since it's smaller than the alternative 400px option.

Once we've figured out which value is smaller, the resulting value is plugged into the “World Famous” snippet:

/* On large screens: */
.grid {
  grid-template-columns: repeat(
    auto-fill,
    minmax(400px, 1fr)
  );
}

/* On small screens: */
.grid {
  grid-template-columns: repeat(
    auto-fill,
    minmax(100%, 1fr)
  );
}

So which of these two approaches is better?

The unpopular-but-true answer is that it depends!

When I work on solo projects, I tend to favor fluid approaches, because I've been using these techniques for a while, and I'm comfortable with them.

When working on a team with a bunch of other devs, though, I might reach for the responsive approach instead. Most JS devs aren't super comfortable with these advanced CSS techniques (which is in part why I built this course!), and I don't want to write code that is inscrutable to my coworkers.

It's similar to advanced JS techniques, like recursion. Recursion is a powerful tool, but in certain situations, it might be wiser to use a more-straightforward iterative approach, so that junior teammates can understand and contribute to the code.

Exercises
World-Famous with no copy/paste

For this first exercise, let's implement the World-Famous Grid Snippet from scratch, without copy/pasting.

I know it's tempting, but by writing it out manually, you'll be reinforcing the ideas. We want to think of this not as a magical incantation, but as a combination of well-understood tools that combine to create the desired layout.

Update the playground below to use the World-Famous Grid Snippet with the criteria listed in the comments:

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

Solution code
(success)

 Show more

---

## Grid Dividers

Source: /css-for-js/07-css-grid/11-grid-dividers

Grid Dividers

Let's imagine that you're using CSS Grid to create a magazine layout, with 1 large featured story and two smaller stories below:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .wrapper {
    display: grid;
    grid-template-columns: 1fr 1fr;
    padding: 24px;
    gap: 24px;
    max-width: 550px;
    margin: 0 auto;
  }

  .story img {
    width: 100%;
    height: 200px;
    object-fit: cover;
    border-radius: 4px;
  }

  .featured.story {
    grid-column: 1 / -1;
  }
</style>

<div class="wrapper">
  <article class="featured story">
    <img src="https://courses.joshwcomeau.com/cfj-mats/meerkat.jpg" alt="A curious meerkat pops up" />
    <h2>
      Study: Meerkats unseat dolphins as nature's smartest animal
    </h2>
    <p>
      Meanwhile, humans come in 4th, right after the surprisingly-wiley platypus.
    </p>
  </article>
  <article class="story">
    <img src="https://courses.joshwcomeau.com/cfj-mats/night-sky.jpg" alt="A vibrant shot of the night sky" />
    <h2>
      The Search for Extra-Terrestrial Life
Result
Refresh results pane

Right as you're ready to ship it, the lead designer pings you on Slack: “Hi deymos — Hate to do this to you, but the design just got updated”.

Here's the new design:

Specifically, design wants us to add hot pink borders in-between each article, to add a bit of cosmetic panache.

If you'd like, you can spend a few minutes tinkering with this challenge. The hot-pink color has been provided in a CSS variable, --hot-pink.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

It's a tricky problem because there isn't any way to make the grid lines visible — even if we could, it wouldn't be exactly what we want, since some children span multiple rows/columns.

We can solve this using background colors though!

Here's the approach we'll take:

Grid background
Grid children

The grid children are given a background color that matches the page's background. The grid container is given a hot-pink background, but it only shows in the small spaces between and around the grid children.

Here's the code:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Inset borders

The approach above was suggested by Discord user RebeccaB, and in general it's a way better approach than the one I originally used!

The only issue with this approach is that it's a little bit less flexible. For example, it won't work if we want our inner borders to be "inset", not reaching the edge of the container:

RebeccaB's background-color approach won't work here, since the borders aren't contiguous!

Here's how we can solve this new problem:

We'll add a large amount of padding to the overall container, since no border reaches the edge
We'll selectively add borders to specific grid children. For example, that first featured story will have a border along its bottom edge.
We'll use padding to increase the distance between borders, making sure that we apply padding "proportionally".

Here's what that looks like in code:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

story:nth-of-type(2n) selects the "extra-terrestrial" story, and any other stories that would fall into the first column (after the featured story). We give it 24px of right padding, and a border.

The stories in the second column are selected with story:nth-of-type(2n + 3), and they're given a symmetrical amount of left padding, so that both columns are equidistant from the border.

This approach feels a bit like solving a puzzle; we need to find a strategy for placing borders/padding around individual children that creates the illusion of an inner grid border.

In most cases, it's better to go with the simpler background-color approach, described earlier in this lesson. But when we need an extra amount of precision, this approach can provide much more flexibility.

Weird math
(info)

The nth-of-type math can be a bit hard to understand.

If we had written nth-of-type(2n), we would have selected every other child. Because we only have 3 children in this case, 2n would have selected the middle child (“Extra-Terrestrial Life”).

When we add a number (2n + 3), we specify an offset. Instead of counting every other child from the very beginning, we start counting every other child from the 3rd item onwards.

In a vanilla HTML/CSS context, these selectors are very powerful. Honestly, though, they don't feel as relevant to me when working in the context of a component-driven framework like React.

Here's how I might solve this problem instead:

function Story({ data, index }) {
  const needsLeftPadding = index >= 2 && index % 2 === 0;

  return (
    <article
      style={{
        paddingLeft: needsLeftPadding ? 24 : 0,
      }}
    >
      {data.children}
    </article>
  );
}

In JavaScript, indexes start at 0 instead of 1, so index >= 2 matches the 3rd item and above. Then we check for even numbers with index % 2 === 0.

Both approaches are equally valid, so it really comes down to personal taste. There aren't any substantive differences between the two approaches in terms of performance or usability.


---

## Grid Recipes

Source: /css-for-js/07-css-grid/12-grid-recipes

Grid Recipes

Now that we've worked through the bulk of the CSS Grid API, it's time to see what we can do with the stuff we've learned!

The lessons that follow each contain a cool thing we can do with CSS Grid.


---

## Two-Line Center

Source: /css-for-js/07-css-grid/13-two-line-centering

Two-Line Center

Let's say that we want to center one element within its parent, both horizontally and vertically:

For a long time, this was a notoriously tricky challenge, especially if we wanted to keep the element in-flow.

When Flexbox launched, this challenge became a lot less daunting; we could do it in 3 lines of CSS:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>

<section class="wrapper">
  <div class="box"></div>
</section>
Result
Refresh results pane

In CSS Grid, we can use the same trick. For consistency, we'll use align-content instead of align-items (though both should produce a similar result in this circumstance).

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    display: grid;
    justify-content: center;
    align-content: center;
  }
</style>

<section class="wrapper">
  <div class="box"></div>
</section>
Result
Refresh results pane

Because we're setting justify-content and align-content to the same value, we can take advantage of a nifty shorthand:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The place-content property will set both justify-content and align-content at the same time. This means that we now have a CSS centering trick that's just 2 declarations long!

Modern CSS is pretty friggin cool.


---

## Sticky Grids

Source: /css-for-js/07-css-grid/14-sticky-grids

Sticky Grids

One of the neat things about CSS Grid is that's highly interoperable with other layout methods in CSS.

For example, let's say we wanted to create a “Holy Grail” type layout, but with a header and sidebar that follows the user as they scroll:

Fortunately, we can combine sticky positioning and CSS Grid children! Unfortunately, though, there are some surprising and unintuitive wrinkles that make it a bit challenging to use in practice.

This isn't an exercise, but I recommend spending a few minutes seeing if you can implement a sticky header and sidebar in the playground below. Even if you successfully complete it, I recommend watching the full lesson below; we delve deep into the mechanics of how these two layout modes interoperate!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<div class="grid">
  <header>
    <h1>My Website</h1>
  </header>
  <aside>
    <h2>Chicken Cacciatore</h2>
    <nav>
      <ol>
        <li>Introduction</li>
        <li>Prep</li>
        <li>Cooking</li>
        <li>Reviews</li>
      </ol>
    </nav>
  </aside>
  <main>
    Main Content
  </main>
  <footer>
    Copyright notice
  </footer>
</div>
Result
Refresh results pane
Adding sticky grid children

This video is dense. If you had trouble following it at certain parts, that's ok! It might take a bit of practice before this stuff "clicks".

Here's the code from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Be sure to view this in "Fullscreen" mode, or remove some of the list items, in order to observe the sticky behaviour.


---

## Full Bleed Layouts

Source: /css-for-js/07-css-grid/15-full-bleed

Full Bleed Layouts

A common blog layout involves a single, centered column of text:

In Module 1, we learned about a max-width wrapper utility that can help us with this. We can even combine it with the “ch” unit from Module 6, for a pretty solid approach:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .max-width-wrapper {
    max-width: 30ch;
    padding: 32px;
    margin-left: auto;
    margin-right: auto;
  }
</style>

<div class="max-width-wrapper">
  <h1>Some Heading</h1>
  <p>
    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.
  </p>
  <img
    alt="a satisfied-looking cute meerkat"
    src="https://courses.joshwcomeau.com/cfj-mats/meerkat.jpg"
    class="meerkat"
  />
  <p>
    It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
  </p>
</div>
Result
Refresh results pane

(In a real setting, we'd want to use 50-75ch, but I've chosen a smaller value in this case because the “Result” tab is so narrow!)

Using a max-width wrapper is a solid approach, but it does lock us in; every in-flow child will be constrained by that container.

But what if we wanted to allow certain children to "break free", and fill the entire window width?

Having an element stretch from edge to edge is known as a "full-bleed" element, a term borrowed from the publishing world when magazine ads would be printed right to the edge of the page.

At first blush, this seems like an impossible problem. If our child is in-flow, it will be bound by its containing block (in this case, .max-width-wrapper). And if we take it out of flow, it will break our layout / cause overlaps.

Fortunately, CSS Grid offers a very clever solution to this problem.

Here's an MVP of the solution. Take a moment and see if you can figure out how it works:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

There's a lot going on here, so let's unpack it!

Grid construction

We've created a grid with 3 explicit columns.

Our left column takes up 1fr
Our center column, where our content will go, takes up min(30ch, 100%)
Our right column takes up 1fr

As we saw in an earlier lesson, the ch unit is equal to the width of the 0 character, in the current font. Let's assume that in the current situation, our 0 character is 15px wide. This means that our 30ch value translates to 450px.

450px is too wide to fit on many mobile displays. That's why we have that min() function. It clamps this value so that it never grows above 100% of the available space. On a 375px-wide phone, our center column will be 375px wide, not 450px.

Our two side columns will share whatever space remains. Like auto margins, this is a clever way to make sure the middle column is centered.

Let's imagine that our window is 650px wide. Our center column eats up 450px of space, so there's 200px left over. Because both side columns consume 1fr, they each take 100px, pushing the middle column into the center of the screen.

Here's a visualization showing how this works:

1fr
30ch
1fr
Column assignments

As we start adding children to this grid, they'll be assigned into the first available cell. This doesn't work for us: we want all of our content to be assigned to that middle column by default!

That's where this CSS comes in:

.wrapper > * {
  grid-column: 2;
}

The asterisk (*) is a wildcard: it matches everything. This means that every child we pop into this grid will be lined up inside the 2nd column.

Every new child will create its own implicit row, and occupy the center column:

<h1>
<p>
<p>
<p>

Wildcard performance
(info)

You may have heard that using the wildcard selector (*) is bad practice. Some will tell you that it is slow, and can affect the overall performance of your page.

20 years ago, this was something to think about. Today, browsers are so optimized that we don't really need to worry so much about selector performance; a 2011 article from Nicole Sullivan
 talks about some of the optimizations that browsers make to optimize selector lookups, and it's only gotten more sophisticated since then.

There probably are synthetic benchmarks that show a perceptible difference between different selector patterns, but in my own work, I've never noticed any issues using the wildcard selector.

Full-bleed children

Finally, we need a way to "opt in" to the full-bleed behaviour!

That's where this fella comes in:

.full-bleed {
  grid-column: 1 / -1;
}

Any child that applies the .full-bleed class will stretch from the first column line to the last column line.

Here's how this works by default:

<h1>
<p>
<img class="full-bleed">
<p>

This can lead to some very tall images, on very wide screens, so I like to combine it with a fixed height and object-fit:

.meerkat {
  display: block;
  width: 100%;
  height: 300px;
  object-fit: cover;
}

For more information on object-fit, check out the lesson on Fit and Position.

Negative numbers?
(info)

Our .full-bleed class sets its column to 1 / -1. Why are we mixing positive and negative numbers??

Every grid line has a positive number (counting from the left) and a negative number (counting from the right). We're saying in this snippet that we want our element to start on the first column from the left, and end on the first column from the right, spanning the entire grid.

It's functionally equivalent to this:

.full-bleed {
  grid-column: 1 / 4;
}

The benefit to using 1 / -1 is that it future-proofs our code. If we ever decide to add another column to this grid, 1 / 4 will need to be updated to 1 / 5, but 1 / -1 will always stretch across the whole grid, no matter how many columns it has.

Adding gutters

You may have noticed that when the window is smaller, things feel very cramped:

We haven't added any gap or padding to this grid, and so it makes sense that the contents would run right up to the edge.

If we add padding to the grid itself, it will give us some breathing room, but it also stops the full-bleed elements from truly being full-bleed:

.wrapper {
  display: grid;
  grid-template-columns:
    1fr
    min(30ch, 100%)
    1fr;
  padding-left: 16px;
  padding-right: 16px;
}

Notice that our meerkat photo isn't actually full-bleed anymore. This is actually kind of a tricky problem: how do we give standard children a bit of breathing room without affecting .full-bleed ones?

We can have our cake and eat it too by using negative margin on the full-bleed children:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Our container has 16px of padding, but our full-bleed children will undo that, using the negative margin trick we saw way back in Module 1!

The only problem with this approach is that there's an implicit dependency between the parent's padding and the child's margin. Later, we may wish to tweak the parent's padding, and forget to update the margin, breaking the layout.

We can address this with CSS variables:

.wrapper {
  --breathing-room: 16px;

  display: grid;
  grid-template-columns:
    1fr
    min(30ch, 100%)
    1fr;
  padding-left: var(--breathing-room);
  padding-right: var(--breathing-room);
}
.wrapper > * {
  grid-column: 2;
}
.full-bleed {
  grid-column: 1 / -1;
  margin-left: calc(
    var(--breathing-room) * -1
  );
  margin-right: calc(
    var(--breathing-room) * -1
  );
}

With this variable, there's no way to tweak the padding without also updating the margin.

Getting fancy with calc
(info)

The approach shown above was suggested by Discord user TheKayser. I've amended this lesson because I much prefer their approach to my original one!

If you're curious, though, here's how I solved it initially:

 Show more

---

## Managing Overflow

Source: /css-for-js/07-css-grid/16-managing-overflow

Managing Overflow

Let's suppose that we have a grid child that will hold a list of images. On smaller screens, we want to add a horizontal scrollbar:

When we implement it, however, our overflow: auto appears not to work:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .grid {
    display: grid;
    grid-template-columns: 175px 1fr;
    gap: 16px;
  }

  .image-list {
    display: flex;
    gap: 16px;
    max-width: 100%;
    overflow: auto;
  }
</style>

<div class="grid">
  <div class="intro">
    <h2>My Photos</h2>
    <p>Here are some animals I saw on holiday:</p>
  </div>
  <div class="image-container">
    <ul class="image-list">
       <li>
        <img src="https://courses.joshwcomeau.com/cfj-mats/cat-four-300px.jpg" />
      </li>
      <li>
        <img src="https://courses.joshwcomeau.com/cfj-mats/otter.jpg" />
      </li>
       <li>
        <img src="https://courses.joshwcomeau.com/cfj-mats/dog-three-300px.jpg" />
      </li>
       <li>
        <img src="https://courses.joshwcomeau.com/cfj-mats/meerkat.jpg" />
      </li>
    </ul>
  </div>
Result
Refresh results pane

We've given our image-list a max-width of 100%, and set overflow: auto, so why isn't it truncating the size??

We tend to think of the fr unit as a way to divvy up leftover space, but there's another crucial aspect of this unit: it reacts based on its contents.

If we put a really-large child in this column, the fr unit will grow to contain it.

Here's an example showing this behaviour more clearly:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .grid {
    display: grid;
    grid-template-columns: 175px 1fr;
    gap: 16px;
  }

  .box {
    width: 1000px;
    height: 200px;
    background-color: peachpuff;
  }
</style>

<div class="grid">
  <div class="intro">
    <h2>My Photos</h2>
    <p>Here are some animals I saw on holiday:</p>
  </div>
  <div class="box-container">
    <div class="box"></div>
  </div>
</div>
Result
Refresh results pane

If you inspect this in the grid devtools, you'll notice that the second column has grown to be 1000px wide. It has to do this, since the column wants to contain the child, and the child is quite large.

There are two ways to solve this problem.

Solution 1: Moving the overflow

We can solve this problem by moving our overflow: auto to the grid child directly:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Coming back to our original problem, we can solve the issue by moving the overflow: auto up to the direct grid child:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Why does this work? My hunch is that the fr has an exception built-in: if the grid child has overflow: auto, it gives the column permission to shrink below the natural width of that element. But this doesn't work recursively: it has to be on the direct grid child, not a descendant.

Solution 2: Setting a minimum width

We've specified that our second column should have a width of 1fr. With a clever use of minmax, we can specify that we're OK with the column shrinking below the child's width:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

By changing 1fr to minmax(0, 1fr), we're telling the column that it can be as small as it wants. It shouldn't worry about trying to stretch around the children.

CSS Tricks has a wonderful article on this approach: “Preventing a Grid Blowout”
.


---

## Grid Quirks

Source: /css-for-js/07-css-grid/17-grid-quirks

Grid Quirks

This lesson collects a handful of curious / counterintuitive things I've stumbled across with CSS Grid

Row limit

In Chrome, grids are limited to 1000 rows. If an implicit grid is given 1002 children, the final 3 children will occupy the same cell. You can see an example of this behaviour
.

Update: the limit has been increased!
(success)

Starting in Chrome 96, released in November 2021, the grid row limit has been bumped to 100,000 rows!

That said, we shouldn't actually try and render that many items; Google recommends not exceeding 1500 DOM nodes, on the entire page! If you have a massive dataset that you want to render, you can use virtualization.

Virtualization is an advanced technique that uses JS to remove DOM nodes not currently on-screen. It's beyond the scope of this course. For React devs, I recommend react-window
 by Brian Vaughn.

Margin collapse

As in Flexbox, the margin on grid children won't collapse, in either direction:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .wrapper {
    display: grid;
  }

  p {
    margin: 30px;
  }
</style>

<div class="wrapper">
  <p>Hello World!</p>
  <p>The margins on these paragraphs won't collapse.</p>
  <p>Check it out in the devtools.</p>
</div>
Result
Refresh results pane

Margin collapse is a feature of Flow layout, and these paragraphs are being arranged according to Grid layout.

Z-index works with grid children

In Module 2, we learned about how z-index can be used to control the stacking order of elements in the same stacking context.

Normally, z-index only works in positioned layout: the element needs to set position to relative/absolute/fixed/sticky. But an exception has been carved out for CSS Grid: A grid child can use z-index even if it doesn't change the position property.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

By setting z-index on a grid child, it will create a stacking context.

Weirdness with “fr” on rows

The fr unit allows us to divvy up extra space in a grid container.

This makes sense when we use it in our columns, and it makes sense when we use it on rows within a specified-height container… but things get a little strange in other situations:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

We've given a grid child a specific height… and for some reason, that affects the height of all the rows??

This quirk is more academic than practical, since I can't remember ever wishing to use the fr unit in this way… but it can teach us a lot about how the grid algorithm works!

This topic is explored in depth in a Video Archive video, “Grid Row ‘fr’ Weirdness”.


---

## Subgrid

Source: /css-for-js/07-css-grid/18-subgrid

Subgrid

Like Flexbox, CSS Grid has traditionally been a parent/child type of deal; the parent defines the layout, and the children participate in it.

This works fine for Flexbox, which is all about aligning children along a primary axis, but it’s a more significant limitation for CSS Grid. There are situations where it would be really convenient if we could pass a grid structure down through the DOM tree, so that deeply-nested elements like grand-children could use the same grid layout.

This is the big idea behind subgrid. It’s a recent addition to CSS Grid which makes it way more powerful. I hadn’t realized it at first, but subgrid opens up whole new possibilities for layout, things that just weren’t practical until now. ✨

I’ll show you some of the very cool things we can do with subgrid over the next couple of lessons, but for now, let’s focus on the basics.

The fundamentals

Suppose we want to implement the following mockup:

We can create this layout using a flat grid, no subgrid required. Here’s a quick implementation:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
<style>
  .grid {
    display: grid;
    grid-template-columns: 35% 1fr 1fr 1fr;

    header {
      grid-row: 1 / 3;
    }
  }
</style>

<div class="grid">
  <header>
    <h1>My Portfolio</h1>
    <p>
      A small selection of the works created using Blender. No robots or AI involved.
    </p>
    <p>
      In a real artist portfolio, there would be more text here.
    </p>
  </header>
  <img alt="…" src="/img/thumb-sneakers.jpg" />
  <img alt="…" src="/img/thumb-rocket.jpg" />
  <img alt="…" src="/img/thumb-fish.jpg" />
  <img alt="…" src="/img/thumb-guitar-pedals.jpg" />
  <img alt="…" src="/img/thumb-machine.jpg" />
  <img alt="…" src="/img/thumb-particles.jpg" />
</div>
Result
Console
Refresh results pane

If we check the “Grid” devtools, we see that this is a 4x2 grid, with the header spanning the first two rows:

In order for this to work without subgrid, every grid participant has to be a direct child of the .grid container. Sure enough, if we inspect the HTML, we see the following structure:

<div class="grid">
  <header>
    <h1>…</h1>
    <p>…</p>
  </header>
  <img alt="…" src="/img/thumb-sneakers.jpg" />
  <img alt="…" src="/img/thumb-rocket.jpg" />
  <img alt="…" src="/img/thumb-fish.jpg" />
  <img alt="…" src="/img/thumb-guitar-pedals.jpg" />
  <img alt="…" src="/img/thumb-machine.jpg" />
  <img alt="…" src="/img/thumb-particles.jpg" />
</div>

Semantically, this feels a bit funky to me. I feel like these images should be grouped in a list, since we’re displaying a collection of portfolio pieces. Proper semantic markup will provide more context to folks using assistive technologies like screen readers, and to search engines that are trying to make sense of our page.

Unfortunately, adding this extra markup throws a wrench into the grid:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

Instead of having each image occupy its own grid cell, we instead cram the entire list of images into a single cell in the second column, leaving the final two columns totally empty. 😬

CSS subgrid allows us to extend the parent grid through that <ul> tag, so that each list item (containing an image) can participate in the grid layout. Here’s what that looks like:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

There’s a lot going on here, so let’s unpack it.

Using grid-column and grid-row, we assign the <ul> to span three columns and two rows. This is how we specify which portion of the grid we want to share with the <ul>’s descendants.
Next, we apply display: grid to the <ul>, to create a new child grid.
Finally, we pass along the row/column definitions using grid-template-rows and grid-template-columns. The subgrid keyword is the key bit of magic that ties the two grids together, allowing each <li> to occupy its own cell in the parent grid.

A common misconception
(info)

It might seem strange that we need to set display: grid on the child <ul>; we’re not trying to create a brand-new grid, we’re trying to extend the existing grid, right?

Well, kinda. Technically, we are creating a new grid when we use subgrid, but that grid will inherit the template from the parent grid. There’s only one grid structure, but it can be shared by multiple grids.

Why did they set it up this way? I think it makes sense when we remember that CSS is a collection of different layout modes. When we apply display: grid to an element, we opt into Grid layout for that element’s children. Without that declaration, the children would use regular ol’ Flow layout, which means they wouldn’t have any awareness of the grid template.

It actually winds up being a good thing that subgrids create their own grids. It means that, for example, we can apply a different gap to the subgrid, if we want there to be more or less space between the rows/columns within the subgrid.

When I first learned about subgrid, this is the sort of scenario I was imagining: cases where nested HTML elements like <ul> + <li> or <figure> + <figcaption> block us from assigning the actual UI elements to the grid. CSS subgrid is a nifty lil’ escape hatch for these types of situations!

That said, it's not like we haven’t had other ways to solve these kinds of problems. Instead of sharing a single CSS grid template with subgrid, we could instead combine a Flexbox row with a nested grid:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

Instead of trying to rig everything up to use a single grid structure, we can often create the same layout with nested combinations of Flexbox/Grid. And honestly, I think I prefer this approach in this case! It feels simpler to me.

But like I said earlier, this isn’t the most exciting use case for subgrid. Now that we’ve covered the basic syntax, we can explore some of the more interesting possibilities. 😄


---

## Dynamic Layouts

Source: /css-for-js/07-css-grid/18.01-new-layout-possibilities

Dynamic Layouts

Sticking with the artist portfolio example from the previous lesson, let’s suppose we have this card design:

Bret’s Dead Fish

I created this render for the Animation Design module in my upcoming course, Whimsical Animations. The fish is a nod to Bret Victor’s talk, “Stop Drawing Dead Fish”, which is referenced in the course.

This looks alright on its own, but something funky happens when we put it in a grid:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
<style>
  .grid {
    display: grid;
    grid-template-columns: 1fr 1fr;

    @media (max-width: 32rem) {
      grid-template-columns: 1fr;
    }
  }
  .grid article {
    display: grid;
    grid-template-columns: 2fr 1fr;
  }
</style>

<div class="grid">
  <article>
    <img
      alt="A big yellow pufferfish"
      src="/img/thumb-fish.jpg"
    />
    <div class="content">
      <h2>Bret’s Dead Fish</h2>
      <p>
        I created this render for the Animation Design module in my upcoming course, Whimsical Animations. The fish is a nod to Bret Victor’s talk, “Stop Drawing Dead Fish”, which is referenced in the course.
      </p>
    </div>
  </article>
  <article>
    <img
      alt="two white sneakers with pink details and a shiny sparkly rainbow"
      src="/img/thumb-sneakers.jpg"
    />
    <div class="content">
      <h2>Big Shoes To Fill</h2>
      <p>
Result
Console
Refresh results pane

Notice that the images are different widths? The fish image, for example, is much wider than the final supercomputer image. What’s going on here? 🤔

Well, let’s take a look at the CSS. The four cards are arranged in a two-column grid (which shrinks to a one-column grid on smaller screens):

.grid {
  display: grid;
  grid-template-columns: 1fr 1fr;

  @media (max-width: 32rem) {
    grid-template-columns: 1fr;
  }
}

We’re populating this top-level grid with four <article> cards. Each card declares its own two-column grid:

.grid article {
  display: grid;
  grid-template-columns: 2fr 1fr;
}

The goal here is for the image to take up the lion’s share of the space within each card, since that’s the important part (the point of an artist’s portfolio, after all, is to showcase the art!). But the fr unit is designed to be flexible; it will try to match the requested ratio, but it’ll adapt based on the content.

This is actually a very good thing. We could force the image column to be a fixed size, but we wouldn’t like the results:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

On certain viewport sizes, the cards simply aren’t large enough to devote ⅔rds of the available space to the image and still contain the text content. If we force that column to have a fixed size, the text could wind up overflowing:

So, the flexibility we get from the fr unit is a good thing. The problem is that each card is doing its own internal calculation. The heading in the first card (“Bret’s Dead Fish”) is made up of small words, so it can fit comfortably in a narrow column. But the final card’s heading (“Infinite Supercomputer”) requires quite a bit more room.

If you’ve worked with CSS for a while, you’ve probably gotten stuck in cul-de-sacs like this. One of the hardest problems in CSS is when siblings need to be aware of each other inside nested / complex layouts.

Miraculously, subgrid offers a solution to these sorts of problems. Check this out:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

How cool is this?? 🤯

In the original version, the parent grid was a two-column layout, with each card assigned to a grid cell. In this new version, the parent grid grows to four columns:

Each <article> will span two of these columns (grid-column: span 2), and inherits the column definitions from the parent (grid-template-column: subgrid).

As a result, the grid can dynamically react to content changes. Try erasing the word “Supercomputer” in the playground above and notice how the columns readjust!

Honestly, I’m not really used to thinking about layouts like this. Before subgrid, I might’ve solved this problem by picking a very narrow fixed width for the image column, so that there was always enough space for the text column. This would ensure that the layout never breaks, but remember, the goal of a portfolio is to display as much of the images as possible! Subgrid allows us to adapt to the content dynamically, so that we can produce the best possible UI in various contexts.

This is where subgrid truly shines, in my opinion. By extending the grid downwards, it means that we can allow siblings to become responsive to each other, in a way that hasn’t been possible until now. ✨

Supporting older browsers

Subgrid has been supported across all major browsers since 2023. Surprisingly, though, subgrid support still hasn’t hit 90% yet (according to caniuse
, as of December 2025).

This presents a bit of a challenge. As we’ve seen in this blog post, subgrid enables us to solve problems that were previously unsolvable. What should we do for folks who visit using older browsers?

Well, we can’t produce an identical experience, but I think with a bit of creative problem-solving, we can come up with alternative layouts that are good enough. Using the artist portfolio example from earlier, we could reconfigure the card layout so that the image is stacked vertically, rather than horizontally:

We can accomplish this using feature queries. Here’s what the code looks like:

.grid article {
  /* Fallback layout for older browsers: */

  @supports (grid-template-columns: subgrid) {
    /* Fancy new layout for modern browsers: */
  }
}

Here’s a live playground showing the full implementation. Comment out everything inside the @supports block to see what the fallback experience looks like:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

Alternatively, I could have kept the two-column layout but restricted the image column’s width (eg. grid-template-columns: 50px 1fr). This would’ve preserved the original design for everyone. But I think when it comes to fallbacks, the goal isn't to be as similar to the original as possible, the goal is to produce the best experience possible. In this particular case, I think a single-column fallback experience works better.


---

## Subgrid Gotchas

Source: /css-for-js/07-css-grid/18.02-subgrid-gotchas

Subgrid Gotchas

As I’ve been experimenting with subgrid, there have been a couple of things that have caught me off guard. Let’s go over them, so that you’ll be well-prepared!

Reserving space for the subgrid

Sharing columns with subgrid tends to be pretty intuitive, but things get a bit more quirky when sharing rows.

To help me explain, let’s look at a different example. Suppose our design team wants us to build the following pricing UI, to show the features included at different price tiers:

This seems like a pretty straightforward task, but the devil is in the details. If we use a typical Grid or Flexbox strategy, we’ll wind up with asymmetrical rows:

This might look right at a quick glance, but notice how the features don’t line up. In the original mockup, the first line of every feature is perfectly aligned with the same feature in the opposite card!

Historically, the only way to achieve this sort of thing in CSS has been with Table layout (using <table> tags, or display: table). It’s not really practical to use a table here, though, since we’d need each card to be its own column in the same table, and we can’t easily style table columns.

Subgrid to the rescue! At least in theory, we should be able to let both cards share a single grid, like this:

Unfortunately, there’s a very easy mistake to make. See if you can spot the problem with this code:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

All of the text is clumped up in the same spot! If we inspect this using the Grid devtools, we discover that we’ve wound up with a 2×1 grid. All of the content within each card is smushed into a single row. 😬

Typically, with CSS Grid, we don’t need to explicitly define any rows. I usually define the number of columns, and trust the grid algorithm to add new rows as-needed, so that each child gets its own grid cell.

With subgrid, we need to change our approach, since by default, our child grid will only span a single grid column/row. If we want it to occupy multiple rows, we need to reserve them explicitly.

Here’s what the fix looks like:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

The extra-complicated thing about this setup is that we’re extending the grid down two layers:

First, we extend it to <div class="card">, which includes an <h2> and a <ul>.
Next, we extend it to that child <ul>, so that the individual list items each get their own row.

There are 5 list items in this case, which means we need 6 rows total (one for the heading, five for the list). If we don’t “reserve” all of these rows explicitly, then the browser will shove everything into a single row and make a big mess, like we saw above.

This is mind-bending stuff, but it becomes intuitive with a bit of practice. The thing to keep in mind is that subgrids, by default, will only occupy a single grid cell. In order to spread a group of items across multiple grid rows, the subgrid must first stretch across that area itself.

Dynamic data?
(info)

In the example above, I knew exactly how many rows I needed, because the content was static. But what if we’re using dynamic data, and we don’t actually know how many rows we’ll need? And what if each column has a different number of rows??

In cases like this, there is a hacky workaround we can use:

.card,
.card ul {
  grid-row: span 99;
  display: grid;
  grid-template-rows: subgrid;
}

Instead of specifying the exact number of rows needed, we can instead pick a big number like 99, one that will definitely exceed the actual number of rows. We’ll wind up with a 99-row grid, and all of the unused rows will stack up together at the bottom.

As hacky as this feels, it’s fairly harmless; as far as I can tell, there isn’t a significant performance cost to having a bunch of empty rows, and by default, they’ll all take up 0px of height, so they won’t affect the layout at all.

The big downside to this approach is that we lose the ability to use the gap property. gap will add space between all rows, even empty ones, so if we wind up with dozens of empty rows at the bottom of our grid, we’ll also wind up with a ton of empty space.

Why doesn’t the auto-assignment algorithm work with subgrid?
(warning)

You might be wondering why we need our child grid to span across multiple rows. Why do we need to write grid-row: span 6? Couldn’t the algorithm figure it out, based on how many children are within the subgrid?

This confused me at first too, but there is actually a valid reason for this limitation.

To understand what’s going on here, let’s forget about subgrid for a sec. When working with a typical CSS grid, we can set it up in one of two ways:

Define an explicit number of rows using grid-template-rows on the parent (a top-down approach).
Leave grid-template-rows set to the default value of auto, which will allow the grid structure to be dynamically derived from the children (a bottom-up approach).

In our “pricing cards” example, we’d like to use the bottom-up approach, having the number of grid rows computed based on the number of children, but when we set grid-template-rows: subgrid, we’re specifically instructing the inner grids to inherit the grid structure from the parent.

In CSS, data can only be sent in one direction; either it’s set on the parent and passed down through the children, or it’s calculated by the children and bubbles up to the parent. We can’t combine approaches. Conceptually, this is the same issue we run into with percentage-based heights and with container queries. It’s yet another impossible recursive situation, where we’re asking the parent to depend on the child, and the child to depend on the parent.

Special thanks to Max Duval
 for helping me sort this out!

Nested grid numbers

We got the gnarliest gotcha out of the way first! I promise the next two won’t be as intellectually taxing. 😅

As we saw in the “Tracks and Lines” lesson, we can assign our grid children using line numbers:

.child {
  /* Sit in the 2nd row, from row line 2 to row line 3: */
  grid-row: 2;

  /* Span the entire width of the grid: */
  grid-column: 1 / -1;

}

When we inherit a portion of the grid using grid-template-rows: subgrid or grid-template-columns: subgrid, the line numbers get reset.

Here’s an example of what I’m talking about:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

Our yellow .child is assigned to grid-column: 2 and grid-row: 2, but it winds up sitting in the third of the grid’s four rows and columns. 🤔

It turns out that while the grid template is inherited with subgrid, the line indexes don’t. Our .subgrid grid inherits columns/rows 2 through 4, but internally, they get re-indexed as 1 through 3.

We can see this using the grid devtools in the Elements inspector:

In my mind, I had been thinking of line numbers as unique IDs, and so I figured that if the subgrid is inheriting the grid template, those IDs would come along for the ride too. But if we think of these line numbers as indices rather than IDs, this behaviour makes a lot more sense. In every grid, the first line has index 1, even if that row/column is inherited from a parent grid.

Accessing grid areas from a subgrid?
(info)

As we learned in the “Grid Areas” lesson, we can also assign our grid children to specific areas using the grid-area property.

This got me wondering: can the elements within a subgrid still access the named areas defined by the parent grid?

Fortunately, the answer is yes. Here’s a quick example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane
Incompatibility with fluid grids

As we learned in the “Fluid Grids” lesson, we can create grids with a dynamic number of columns using this world-famous grid snippet:

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
}

The idea here is to create a grid with as many columns as possible, as long as those columns are at least 100px wide. This means that as the container grows, new columns will be added:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Download project files
Toggle fullscreen
index.html
styles.css
Result
Console
Refresh results pane

This is a very cool approach, but unfortunately, it doesn’t quite work with some of the new UI possibilities introduced by subgrid. For example, the “portfolio card” grid we explored earlier requires that we list the specific number of columns. We can’t use auto-fill or auto-fit.

So many possibilities

So, hopefully now that you’ve gone through these lessons, you’ll agree with me: subgrid is a surprisingly versatile and powerful feature!

Honestly, I’m still adapting to this new way of thinking about layouts. I plan on continuing to experiment with subgrid, and I would encourage you to do the same!

One caveat about this course: I added these lessons on subgrid in December 2025. Unfortunately, I haven’t had the chance to go through the rest of the course and update it accordingly. As a result, this is the last you’ll see of subgrid in this course. If I don’t use subgrid in a future lesson, it’s because it wasn’t an option when I produced that part of the course, not because I intentionally decided against it.


---

## Workshop: New Grid Times

Source: /css-for-js/07-css-grid/19-workshop

Workshop: New Grid Times

In this workshop, we're going to tackle our most ambitious layout yet!

We'll build an online newspaper, New Grid Times:

Project introduction
Access starter files

As always, you can choose to fork and clone the Git repository, or else fork the CodeSandbox and work in-browser:

Download from Github
Work on CodeSandbox

You'll find step-by-step instructions in the workshop's README.md.

You can also access the design on Figma:

Figma design

Have fun!

Submit Workshop

I review a small percentage of submitted workshops, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## Workshop Solution

Source: /css-for-js/07-css-grid/19.01-workshop-solution

Workshop Solution

Outdated code in solution videos
(warning)

Since filming these solution videos, I have migrated this workshop from create-react-app to Vite, and updated React to 19. This required a few small changes in terms of file structure. For example, file extensions have been changed from .js to .jsx, since Vite doesn’t allow JSX in plain JS files.

The solution code
 has been updated, so please use that as your source of truth, rather than what’s in the videos.

Exercise 1: Header
View the code on Github
Exercise 2: Prep and Polish

This exercise has 3 sub-tasks, so they've each been given their own video:

Text truncation

Discord user Pawan discovered a more elegant solution to this problem: instead of using AbstractWrapper to prevent the paragraph from showing below the ellipsis, we can set align-self: start on the paragraph tag. This prevents it from stretching.

Story borders
Opinion avatars
View the code on Github

I also recorded a quick video that addresses the use of white-space: pre-wrap in this project:

Exercise 3: Main story grid
View the code on Github
Exercise 4: Specialty story grid

Correction: The min-width: 220px declaration causes problems on windows around 500px wide. We can fix it by pushing it inside the tabletAndUp media query:

const SportsStoryWrapper = styled.div`
  @media ${QUERIES.tabletAndUp} {
    min-width: 220px;
  }
`;
View the code on Github

A simpler approach?
(success)

This solution includes the following CSS:

const Wrapper = styled.div`
  @media ${QUERIES.tabletAndUp} {
    grid-template-columns: minmax(0px, auto);
  }
`;

I think I chose this declaration because I was in “minmax” thinking mode, but a student pointed out that the following snippet works just as well, and is a bit more straightforward:

const Wrapper = styled.div`
  @media ${QUERIES.tabletAndUp} {
    grid-template-columns: 100%;
  }
`;

Our goal is to wind up with a single column with a defined width (that the child grids can use), and so we don't need to involve minmax.

Exercise 5: Footer
View the code on Github

