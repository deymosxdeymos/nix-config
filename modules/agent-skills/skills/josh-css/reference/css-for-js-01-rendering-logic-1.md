# CSS for JS - Module 1: Rendering Logic 1

---

## Built-in Declarations and Inheritance • Josh W Comeau's Course Platform

Source: /css-for-js/01-rendering-logic-1/01-built-ins-and-inheritance

Rendering Logic I

Fundamentally, the goal of CSS is to allow you to control the appearance and layout of your app's content.

You don't quite start with a blank canvas; HTML tags do include a few minimal styles. For example, here are the built-in styles for <a> tags, in Chrome 86:

a {
  color: -webkit-link;
  cursor: pointer;
  text-decoration: underline;
}

These styles are part of the user-agent stylesheet. Each browser includes their own stylesheet full of base styles like this. There are some hard rules in the HTML specification, but for the most part, each browser comes up with its own default styles. That's why focus rings look so different across browsers!

In the past, it was common to use a CSS reset? to strip away many of these default user-agent styles. These days, though, browsers are a bit more consistent in how they render elements, and there's a growing awareness that we shouldn't expect our sites/applications to be identical across browsers and devices.

My personal Global Styles template
(success)

Whenever I start a new project, I rely on a set of baseline functional CSS rules. I share these global styles over on my blog:

A Modern CSS Reset

Chrome's source code
(info)

If you're curious to learn more about the user-agent stylesheet, you can view the full stylesheet for the Chrome browser
, from its source code.

This stylesheet includes lots of obscure CSS. It's interesting, in an academic sense, but there's not much practical benefit in studying it.

Inheritance

Let's say we have a pink paragraph with some emphasized text:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Notice that there's an <em> tag wrapping around the word you.

How come the word you is colored pink? If you think about it, we haven't applied any styles to the em element, only to paragraphs.

The answer is that certain CSS properties inherit. When I apply a color to an element, that value gets passed down to all children and grand-children.

Not all CSS properties are inheritable, though. Let's look at another example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

It's a similar situation, but instead of applying a pink text color, we apply a pink border.

Notice that the border value doesn't get passed down to the em. We still only have 1 border, and it's around the entire paragraph.

If we explicitly add the same border value to both paragraphs and emphasis tags, we see a second border within our paragraph:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

If you've worked with CSS for a while, this behaviour probably isn't surprising to you, but it's a bit weird when you think about it!

The people who wrote the CSS spec opted to make certain properties inheritable for convenience. It's a DX? thing. It would be super annoying if we had to keep re-applying the same text color styles to every child and grand-child of a container.

Most of the properties that inherit are typography-related, like color, font-size, text-shadow, and so on. You can find a more-or-less complete list of inheritable properties
 on SitePoint.

It's prototypal!

Code snippets from the above video, in case you want to play around:

class Main {
  color = 'black'
}

class Paragraph extends Main {
  backgroundColor = 'red'
}

class Span extends Paragraph {
}

const s = new Span();

console.log(s.color);
<main style="color: black;">
  <p style="color: red;">
    Hello <span>World</span>
  </p>
</main>
Forcing inheritance

Occasionally, you may wish to have a property inherit even when it wouldn't normally do so.

A good example is link colors. By default, anchor tags have built-in styles that give unvisited, inactive links a blue hue:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

As we saw earlier, these are the “built-in” styles for <a> tags:

a {
  color: -webkit-link;
  cursor: pointer;
  text-decoration: underline;
}

The trouble is that even though color is an inheritable property, it's being overwritten by the default style, color: -webkit-link?.

We can fix this by explicitly telling anchor tags to inherit their containing text color:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The Cascade

---

## The Cascade

Source: /css-for-js/01-rendering-logic-1/02-the-cascade

The Cascade

Consider the following bit of CSS and HTML:

<style>
  p {
    font-weight: bold;
    color: hsl(0deg 0% 10%);
  }

  .introduction {
    color: violet;
  }
</style>

<p class="introduction">
  Hello world
</p>

We've created two rules, one targeting a tag (p), another targeting a class (introduction). Then, we've created an HTML element that matches them both.

You may already know what happens here: we wind up with a bold, violet paragraph. It plucks the font-weight declaration from the p tag, and the color declaration from the .introduction class.

This example shows the browser's cascade algorithm at work.

When the browser needs to display our introduction paragraph on the screen, it first needs to figure out which declarations apply to it. And before it can do that, it needs to collect a set of matching rules. Once it has a list of applicable rules, it works out any conflicts. I imagine this as a sort of deathmatch: if multiple selectors each apply the same property, it pits them against each other. Two fighters enter, but only one emerges.

That's the main idea. The browser will take a set of applicable style rules, and whittle it down to a list of specific declarations that are applicable.

How does it determine which rules win each battle? It depends on the specificity of the selector.

The CSS language includes many different selectors, and each selector has a relative power. For example, classes are "more specific" than tags, so if there is a conflict between a class and a tag, the class wins. IDs, however, are more specific than classes.

Similarities with JS merging

Here's a fun thought experiment: how might we implement the cascade in JavaScript?

It turns out, JS has the perfect tool for the job: spread syntax
.

In principle, the cascade algorithm works something like this:

const appliedStyles = {
  ...inheritedStyles,
  ...tagStyles,
  ...classStyles,
  ...idStyles,
  ...inlineStyles,
  ...importantStyles
};

In our earlier example, we saw this CSS snippet:

p {
  font-weight: bold;
  color: hsl(0deg 0% 10%);
}

.introduction {
  color: violet;
}

This could be written in JavaScript as:

const tagStyles = {
  fontWeight: 'bold',
  color: 'hsl(0deg 0% 10%)',
};
const classStyles = {
  color: 'violet',
};

const appliedStyles = {
  ...tagStyles,
  ...classStyles,
};

The order that they're merged in is determined by specificity; class styles are more specific than tag styles, so they're merged in later. This way, they overwrite any conflicting styles. All non-conflicting styles are kept.

Relevance in modern application development
(info)

CSS specificity gets pretty tricky pretty quickly when you dive below the surface. For example, if both of the following selectors match a button, which one has higher specificity?

.form > button#submit
#about-page button:last-of-type?

You can calculate it by adding up the tags, classes, and IDs, but honestly, I don't think you need to know this stuff anymore.

 Show more

Block and Inline Directions

---

## Block and Inline Directions

Source: /css-for-js/01-rendering-logic-1/03-cardinality

Block and Inline Directions

The web was built for displaying inter-linked documents. A lot of CSS mechanics and terminology are inherited from the print world.

Let's take a written sheet of paper as an example:

English is a left-to-right language, meaning that the words are placed side-by-side, from left to right. Individual words are combined into blocks, like headings and paragraphs.

Pages are constructed out of blocks, placed one on top of the other. When a new paragraph is added to the page, it's inserted below the previous block element.

In other words, English documents have two "directions": the page consists of vertically-oriented blocks, made up of horizontally-oriented words:

CSS builds its sense of direction based on this system. It has a block direction (vertical), and an inline direction (horizontal).

Here's an easy way to remember the directions, for horizontal languages:

Block direction is like lego blocks: they stack together one on top of the other.
Inline direction is like people standing in-line; they stand side by side, not one on top of the other.

In this course, we're going to focus on horizontally-written languages. Vertically written languages on the web are rare; even Han-based languages that are traditionally written vertically (like Chinese, Japanese, and Korean) are often written horizontally on the web.

We'll also mainly focus on left-to-right languages like English. We'll pick up a few tidbits about right-to-left languages like Arabic, but for the most part, it's beyond the scope of this course.

You can learn more about different writing modes in this wonderful article by Jen Simmons
.

Logical properties

Earlier, we learned about "built-in" styles — these are the rules that each browser comes with out-of-the-box, defined in the user-agent stylesheet.

Here are the built-in styles for p tags, in Chrome:

p {
  display: block;
  margin-block-start: 1em;
  margin-block-end: 1em;
  margin-inline-start: 0px;
  margin-inline-end: 0px;
}

You may not have seen margin-block-start before, but can you figure out what it means from context? Can you figure out why Chrome chose to use these properties, instead of a standard margin property?

Give it some thought, and then click the button to continue:

REVEAL

Note that we're speaking purely in terms of directions at this point. It's no coincidence that the display property can be set to block and inline, but we're not actually talking about those values yet; for now, the important takeaway is that content is structured along a block axis and an inline axis, just like a real-world document.

When should we use logical properties?

Logical properties are intended to entirely replace their conventional alternatives. In the future, we might all write margin-inline-start instead of margin-left!

That said, it's hard to overcome inertia. I'll be honest, I still reach for margin-left out of habit. 😅

The main selling point for logical properties is internationalization. If you want your product to be available in a left-to-right language like English and a right-to-left language like Arabic, you can save yourself a lot of trouble by using logical properties.

The main argument against using logical properties is browser support. Now, to be clear, browser support for logical properties is very good
—at the time of writing, 98% of devices support them. But there are some noticeable gaps, including Internet Explorer 10 and 11, Opera Mini, and relatively-recent versions of Safari.

In this course, we'll primary use conventional properties like margin-left, but if you're starting a new project, I'd encourage you to give logical properties a shot!


The Box Model

---

## The Box Model

Source: /css-for-js/01-rendering-logic-1/04-the-box-model

The Box Model

The most common CSS-related job-interview question is probably this:

Can you explain the box model?

It's the CSS version of "what is a closure?", or "what's the difference between classical and prototypal inheritance?".

Because it's such a common question, you may have read about it when prepping for job interviews, or maybe it was taught to you at a bootcamp. Typically, though, the answer given is quite shallow, and glosses over a lot of details. This is unfortunate, since the Box Model is a critical part of CSS' rendering model!

Over the next few lessons, we'll go a bit deeper, and learn about how the browser uses the box model to dictate layout.

Winter Layers

The four aspects that make up the box model are:

Content
Padding
Border
Margin

A helpful analogy is to imagine a person out for a winter walk, wearing a big poofy coat:

The content is the person themselves, the human being inside the coat.
The padding is the polyester stuffing in the coat. The more stuffing there is, the more poofed-up the coat will be, and the more space the person will take up.
The border is the material of the coat. It has a thickness and a color, and it affects the person's appearance.
The margin is the person's “personal space”. As we've learned in recent years, it's good to have 2 meters (6 feet) of space around us.

We'll learn more about each of these properties; beyond just the conceptual model, there's a surprising amount of nuance when it comes to using them effectively!

Debugging in the browser
Box Sizing

When we say that an element should have a width of 100%, what does that actually mean?

It turns out, the browser might have a slightly different interpretation than you do. Let's explore.

These aspects affect the size of the element. The code snippet below will draw a black rectangle on the screen (due to the border). What are the dimensions of that rectangle?
<style>
  section {
    width: 500px;
  }
  .box {
    width: 100%;
    padding: 20px;
    border: 4px solid;
  }
</style>

<section>
  <div class="box"></div>
</section>
1
500px × 0px
2
524px × 24px
3
540px × 40px
4
548px × 48px
5
None of the above

After answering, show the answer:

REVEAL

This behaviour is surprising, and generally not what we want as developers! Thankfully, browsers provide an escape hatch.

The box-sizing CSS property allows us to change the rules for size calculations. The default value (content-box) only takes the inner content into account, but it offers an alternative value: border-box.

With box-sizing: border-box, things behave much more intuitively.

Play with the snippet from this video here:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
A new default

Instead of having to remember to swap box-sizing on every layout element, we can set it as the default value for all elements with this handy CSS snippet:

*,
*::before,
*::after {
  box-sizing: border-box;
}

This is the very first rule in my custom CSS reset
, and arguably the most important. Everything is just so much more intuitive with this box-sizing model!

Why the pseudo-elements?
(info)

You might be wondering: why do we need to add *::before and *::after? Shouldn't the wildcard selector (*) select everything?

Well, yes and no. The * selector will select all elements, but ::before and ::after aren't considered elements. They're pseudo-elements. And so we need to select them explicitly.


Padding

---

## Padding

Source: /css-for-js/01-rendering-logic-1/05-padding

Padding

A helpful way to think about padding is that it's "inner space".

Imagine that you add a background color to an element with some padding:

.some-fella {
  padding: 48px;
  background-color: tomato;
}

Because padding is on the inside, the padded area also receives the background color:

48px
48px
48px
48px

Padding can be set for all directions at once, or it can be specified for individual directions:

.even-padding {
  padding: 20px;
}

.asymmetric-padding {
  padding-top: 20px;
  padding-bottom: 40px;
  padding-left: 60px;
  padding-right: 80px;
}

/* The same thing, but using ✨ logical properties ✨ */
.asymmetric-logical-padding {
  padding-block-start: 20px;
  padding-block-end: 40px;
  padding-inline-start: 60px;
  padding-inline-end: 80px;
}
Units

When applying padding, we can pick from a pretty wide range of units. The most common ones are:

px
em
rem

Many developers believe that pixels are bad for accessibility. This is true when it comes to font size, but I actually think pixels are the best unit to use for padding.

Here's the snippet from the video:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Padding percentages
(warning)

Can we use percentages for padding, like this?

.box {
  padding-top: 25%;
}

We can, but the result is surprising and counter-intuitive; percentages are always calculated based on the element's available width. This is true for left/right padding, and even for top/bottom padding!

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Try resizing the “Result” tab, and notice how the box grows and shrinks. This is because the top padding is equal to 25% of the available horizontal space, based on how wide the parent element is.

For a while, this quirky behavior was actually useful in certain situations, when we wanted to preserve a specific aspect ratio. We'll learn more about this in Module 6.

Shorthand properties

The padding property has a couple tricks up its sleeve. It can be used to set asymmetric padding, in a few different ways.

.two-way-padding {
  padding: 15px 30px;
}

.asymmetric-padding {
  padding: 10px 20px 30px 40px;
}

If two values are passed, the first value is used for both vertical directions (top/bottom), and the second value is used for horizontal directions (left/right).

If all 4 values are passed, it applies them in a specific order: top, right, bottom, left.

The easiest way to remember this order is to picture a clock. We start at the top (12:00), and go clockwise for the remaining values:

When fewer than 4 values are passed, it "fills in the gaps". If you pass it two values, it mirrors the top to the bottom, and the right to the left. With only 3 values, we set top/right/bottom explicitly, and mirror the right value to the left.

Beyond padding
(info)

This pattern is shared amongst other CSS properties that have shorthand values. For example:

margin (margin: 10px 20px 30px 40px)
border-style (border-style: dotted solid dashed solid)

A similar pattern is used for properties that affect corners, like border-radius; the pattern is top-left, top-right, bottom-right, bottom-left. It follows a clockwise pattern starting from the top-left.

Overwriting values

Let's say we want to produce an element with only 3 padded sides:

48px
48px
48px

We could do this with our shorthand property:

.box {
  padding: 48px 48px 0;
}

There is another way to represent the same intent, which is arguably clearer:

.box {
  padding: 48px;
  padding-bottom: 0;
}

"Long-form" properties can overwrite the relevant value in shorthand properties. The effect is the same, but it's a bit more semantic; instead of a random string of numbers, we're declaring that we want 48px of padding, hold the bottom.

Please note: the order matters! The overwrite has to come after the shorthand, otherwise it won't have any effect.

.box {
  /*
    🙅‍♀️ because `padding-bottom` comes first,
    it will be overwritten by the shorthand.
  */
  padding-bottom: 0;
  padding: 48px;
}
Shortyhand

Border

---

## Border

Source: /css-for-js/01-rendering-logic-1/06-border

Border

Border is a bit of an odd duck in the trinity of padding/border/margin—unlike the other two, it has a visual/cosmetic component.

There are three styles specific to border:

Border width (eg. 3px, 1em)
Border style (eg. solid, dotted)
Border color (eg. hotpink, black)

They can be combined into a shorthand:

.box {
  border: 3px solid hotpink;
}

The only required field is border-style. Without it, no border will be shown!

.not-good {
  /* 🙅‍♀️ Won't work – needs a style! */
  border: 2px pink;
}

.good {
  /* 🙆‍♀️ Will produce a black, 3px-thick border */
  border: solid;
}

As with padding, you can overwrite broad properties with specific ones. This is useful for creating several "variants" of an element.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .box {
    width: 50px;
    height: 50px;
    border: 10px ridge black;
  }

  .box.one {
    border-color: deeppink;
  }
  .box.two {
    border-color: gold;
  }
  .box.three {
    border-color: turquoise;
  }
</style>

<div class="box one"></div>
<div class="box two"></div>
<div class="box three"></div>
Result
Refresh results pane

We've specified a black border on the .box class, but each box variant overwrites it with a custom color.

(Oh, and if you're wondering why the selector is .box.one instead of .one, it's because I like the way it reads, semantically! The .box prefix isn't necessary, but it makes the intent a bit clearer.)

Here's a fun fact: If we don't specify a border color, it'll default to using the element's text color! Check it out:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

If you want to specify this behaviour explicitly, it can be done with the special currentColor keyword.

currentColor is always a reference to the element's derived text color (whether set explicitly or inherited), and it can be used anywhere a color might be used:

.box {
  color: hotpink;
  border: 1px solid currentColor;
  box-shadow: 2px 2px 2px currentColor;
}
Border radius

The CSSWG? has published a list of mistakes
 they've made with the CSS language. One of these mistakes is listed:

border-radius should have been corner-radius.

It's not hard to understand the rationale; the border-radius property rounds an element even if it has no border!

Like padding, border-radius accepts discrete values for each direction. Unlike padding, it's focused on specific corners, not specific sides. Here are some examples:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

You can also use percentages; 50% will turn your shape into a circle or oval, since each corner's radius is 50% of the total width/height:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

border-radius can do some funky and wild stuff, and we'll learn more about it in later in this course.

Border Playground

There are a surprising number of border styles! Here's a little interactive widget to help get you familiar with them:

BORDER COLOR
Red
Orange
Yellow
Green
Blue
Indigo
Violet
Gray
BORDER WIDTH
BORDER RADIUS
Solid
Dotted
Dashed
Double
Groove
Ridge
Inset
Outset
Mixed
(Dashed Solid)
Border vs. Outline

A common stumbling block for devs is the distinction between outline and border. In some respects, they're quite similar! They both add a visual edge to a given element.

The core difference is that outline doesn't affect layout. Outline is kinda more like box-shadow; it's a cosmetic effect draped over an element, without nudging it around, or changing its size.

Outlines share many of the same properties:

border-width becomes outline-width
border-color becomes outline-color
border-style becomes outline-style

Outlines are stacked outside border, and can sometimes be used as a "second border", for effect:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

A couple more quick tidbits about outlines:

Outlines will follow the curve set with border-radius in all modern browsers. This wasn’t always the case, but it has been this way across all major browsers since 2023.
Outlines have a special outline-offset property. It allows you to add a bit of a gap between the element and its outline.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

One more thing: Outlines are sometimes used as focus indicators, for folks who use the keyboard (or other non-pointer devices) to navigate.

We'll learn all about focus outlines later in the course. In the meantime, you should avoid tweaking outlines on interactive elements like buttons or links.


Margin

---

## Margin

Source: /css-for-js/01-rendering-logic-1/07-margin

Margin

Finally, the third in our trinity: margin. Margin increases the space around an element, giving it some breathing room. As we saw earlier, margin is "personal space".

In some ways, margin is the most amorphous and mysterious. It can do wacky things, like pull an element outside a parent, or center itself within its container.

Let's see if we can shed some light on this wily property!

Syntax

The syntax for margin looks an awful lot like padding:

.spaced-box {
  margin: 20px;
}

.asymmetrically-spaced-box {
  margin: 20px 10px;
}

.individually-specified-box {
  margin-top: 10px;
  margin-left: 20px;
  margin-right: 30px;
  margin-bottom: 40px;
}
.logical-box {
  margin-block-start: 20px;
  margin-block-end: 40px;
  margin-inline-start: 60px;
  margin-inline-end: 80px;
}

We learned about shorthand properties a couple lessons back, so we won't revisit them here. Pop back if you need a refresher!

Negative margin

With padding and border, only positive numbers (including 0) are supported. With margin, however, we can drop into the negatives.

A negative margin can pull an element outside its parent:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Negative margins can also pull an element's sibling closer:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Interesting, right? The top .pink.box has a negative bottom margin, and the result is that its sibling is pulled up, and overlaps the pink box.

It's easy to fall into the trap of thinking that margin is exclusively about changing the selected element's position. Really, though, it's about changing the gap between elements. Negative margin shrinks the gap below an element, causing the next element to scoot up closer.

Finally, negative margin can affect the position of all siblings. Check out what happens when we apply negative margin to the first box in a series:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The interesting thing is those two black boxes: they "follow" the deep pink box up.

When we use margin to tweak an element's position, we might also be tweaking every subsequent element as well. This is different from other methods of shifting an element's position, like using transform: translate (which we'll cover later on).

If you're keen to learn more about the intricacies of negative margin, check out this in-depth article
 by Peter-Paul Koch.

Auto margins

Margins have one other trick up their sleeve: they can be used to center a child in a container.

Watch what happens when we set an element's left and right margin to auto:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

If we inspect this element in our devtools, we see that the browser has applied an equal amount of margin on either side of the element:

The auto value seeks to fill the maximum available space. It works the same way for the width property, as we'll discover shortly.

When we set both margin-left and margin-right to auto, we're telling them each to take up as much space as possible. Like a game of Hungry Hungry Hippos, both sides try to gobble up all of the free space around the element. They're evenly-matched, though, so neither side wins; they always end in a draw.

If you take the free space around an element and distribute it evenly on both sides, you wind up centering that element. This is a happy byproduct of this mechanism!

Two caveats:

This only works for horizontal margin. Setting top/bottom margin to auto is equivalent to setting it to 0px
*
.
This only works on elements with an explicit width. Block elements will naturally grow to fill the available horizontal space, so we need to give our element a width in order to center it.

Outdated?
(info)

You may be wondering if this technique for centering is outdated, now that we have modern layout rendering modes like Flexbox and Grid.

The answer is “no”, but it's a bit nuanced.

 Show more
Exercises
Thinking outside the box

In Flow layout, elements are stacked neatly into boxes. Things don't overlap by default.

Sometimes, though, we want to pull something a little outside its parent container, for aesthetic effect.

Your mission in this exercise is to reproduce the following effect:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The solution:

A different playground?
(warning)

In the video above, I solve the exercise in a very different looking playground! This is because my “Playground” component has evolved over the years, and this video was filmed using an earlier version. It looks different cosmetically, but the content remains the same.

Sorry for any confusion!

Stretched content

Our .card element has served us well so far, but now we have a bit of a problem.

Let's say we want to include a picture of an otter, and we want it to stretch out, to fill the available container width:

The container's padding is getting in our way. Update the code to allow for full-width children.

Feel free to modify the HTML in this one! This isn't one of those challenges where you mustn't touch the markup.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The solution:

Wait, why do we need a wrapping element here? I glossed over the explanation pretty quickly in the video, so let me elaborate here!

The default value for the width property is auto. By default, for most elements, this means “automatically grow to fill as much space as possible”.

Images, as well as other “replaced elements” like <video> and <canvas>, are special. They don't automatically expand to fill the available space. Instead, they rely on their intrinsic size.

For example, suppose I take a photo on an old webcam. That photo has a native size of 640 × 480. When I embed this image on the page, using an <img> tag, it'll have a default width of 640px.

This is the problem. width: auto has a different meaning for replaced elements. It doesn't mean “stretch out and fill all of the space”, it means “use your natural width”!

If you're still a bit confused, don't worry; we'll cover all of this stuff in greater depth shortly! There's an entire lesson dedicated to the “width” property coming up soon.


Flow Layout

---

## Flow Layout

Source: /css-for-js/01-rendering-logic-1/09-flow-layout

Flow Layout

When it comes to layout, CSS is more like a collection of mini-languages than a single cohesive language.

Every HTML element will have its layout calculated by a layout algorithm. These are known as “layout modes”, and there are 7 distinct ones.

We'll cover several layout modes in this course, including Positioned layout, “Flexible Box” layout (AKA Flexbox), and Grid layout (AKA CSS Grid). For now, though, let's focus on Flow layout.

Flow layout is the default layout mode. Everything we've seen so far has used Flow layout. A plain HTML document, with no CSS applied, uses Flow layout exclusively.

I like to think of Flow layout as the “Microsoft Word” layout algorithm. It's intended to be used for document type layouts.

There are two main element types in Flow layout:

Block elements: things like headings, paragraphs, footers, asides. The chunks of content that make up a page.
Inline elements: things like links, or a string of bold text. Generally, inline elements are meant to highlight bits of text, or elements within a block container.

Each HTML tag has a default type. <div> and <header> are block elements, span and <a> are inline elements.

We can toggle any particular element with the display property:

/* Transform a particular <a> tag from `inline` to `block`: */
a.nav-link {
  display: block;
}

(There's also a third value, inline-block, which is a sort of fusion between the two types. We'll learn about it towards the end of this lesson.)

It's no coincidence that block and inline align with the directions we were speaking about earlier. In flow layout, block elements stack in the block direction, and inline elements stack in the inline direction.

It's more than just direction, though. Each display value comes with its own behaviour, its own rules. Let's look at them in turn:

Inline elements don't want to make a fuss

If you've ever tried to adjust the positioning or size of an inline element, you've likely been confounded by the fact that a bunch of CSS properties just don't work.

For example, this snippet will have no effect:

strong {
  height: 2em;
}

You can picture inline elements as go-with-the-flow-type folks. They don't want to inconvenience anyone by pushing any boundaries. They're like polite dinner-party guests who sit exactly where they're assigned.

You can shift things in the inline direction with margin-left and margin-right, since that pushes it around in the inline direction, but you can't give it a width or height. When it comes to layout, an inline element is where it is, and there's not much we can do about it.

Replaced elements
(info)

There's an exception to this rule: replaced elements.

A replaced element is one that embeds a "foreign" object. This includes:

<img />
<video />
<canvas />

These elements are all technically inline, but they're special: they can affect block layout. You can give them explicit dimensions, or add some margin-top.

How do we reconcile this? I have a trick. I like to pretend that it's a foreign object within an inline wrapper. When you pass it a width or height, you're applying those properties to the foreign object. The inline wrapper still goes with the flow.

Block elements don't share

When you place a block level element on the page, its content box greedily expands to fill the entire available horizontal space.

A heading might only need 150px to contain its letters, but if you put it in an 800px container, it will expand to fill 800px of width.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

What if we force it to shrink down to the minimum size required for the letters? We can do this with the special width keyword fit-content
*
:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Even though there's plenty of space left on that first row, the red box sits underneath our heading. The h2 does not want to share any inline space.

In other words, elements that are display: block will stack in the block direction, regardless of their size.

Inline elements have “magic space”

In the box model lesson, we learned about the different ways we can increase space around an element: we can change its content size, we can add padding, we can thicken the border, or increase the margin.

Inline elements are a bit sneaky, though.

Here's an example of an image with a fixed size of 300×300 pixels, sitting in a plain ol' div. Using your browser's devtools, take a look at the image and its div:

You'll notice something peculiar… The image is taking up the correct size, 300×300, but the parent has a slightly larger height:

The image is 300px tall, but its parent <div> is 306px tall. Where are those extra few pixels coming from?? It's not padding, it's not border, it's not margin…

The reason for this extra “magic space” is that the browser treats inline elements as if they're typography. It makes sense that with text, you'd want a bit of extra space, so that the lines in a paragraph aren't crammed in too tightly.

There are two ways we can fix this problem:

Set images to display: block — if you're noticing this problem, there's a good chance your images aren't interspersed with text, so setting them to display as blocks makes sense.
Set the line-height on the wrapping div to 0:

This space is proportional to the height of each line, so if we reduce the line height to 0, this “magic space” goes away. Because our container doesn't contain any text, this property has no other effect.

Space between inline elements

There's another unrelated way that inline elements have a bit of extra spacing. Take a look at this example; notice that there are gaps between the 3 images:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

This space is caused by the whitespace between elements. If we squish our HTML so that there are no newlines or whitespace characters between images, this problem goes away:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

This happens because HTML is space-sensitive, at least to an extent. The browser can't tell the difference between whitespace added to separate words in a paragraph, and whitespace added to indent our HTML and keep it readable.

How do we solve this problem? Well, it turns out that this issue is specific to Flow layout. Other layout modes, like Flexbox, ignore whitespace altogether. So, the simplest thing is to switch the container to use Flexbox. We'll learn all about Flexbox in Module 4.

Inline elements can line-wrap

Inline elements have one pretty big trick up their sleeves; they can line-wrap.

This paragraph features a multi-line <strong> tag:

This is a paragraph with some very bolded words in it.

Unlike block elements, an inline element can produce shapes other than boxes
*
. Firefox accurately reports on the situation:

This helps explain why certain CSS properties aren't available for inline elements. What would it even mean to increase the vertical margin on a shape like this?

It's worth noting that it's still considered "one shape". If we add a border, we can see that we don't get 2 discrete rectangles, but rather a single rectangle cut in half and repositioned:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

I like to think of it like a sushi roll. We have one long strip of text, and it's chopped up into individual bite-sized lines before being presented.

The deal with inline-block

One of the most confusing things about Flow layout is the Frankenstein display: inline-block value. Honestly, it took a few tries before I truly understood what it was / how it worked.

Here's how I've grown to think about it: An inline-block element is a block-level element that can be placed in an inline context. You know the expression “a wolf in sheep's clothing”? We can think of inline-block as “a block in inline's clothing”.

In terms of layout, it's treated as an inline element. We can drop it in the middle of a paragraph, without totally borking the layout. But internally, it acts much more like a block element.

Let's look at an example:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Try removing the display: inline-block declaration to see the difference.

In this example, we've set our <strong> to be inline-block. Because this tag is now secretly a block-level element, it has access to the full universe of CSS. Usually, properties like width and margin-top have no effect on an inline element, but they do work on inline-block elements.

We've effectively turned our strong element into a block element, as far as its own CSS declarations are concerned. But from the paragraph's perspective, it's an inline element. It lays it out as an inline element, in the inline direction beside the text.

In many ways, inline-block allows us to have our cake and eat it too. It's the best of both worlds! It's too good to be true!

Predictably, however, there's a catch.

Inline-block doesn't line-wrap

It's said that all architects will at some point design a chair. Similarly, many front-end developers will at some point build a flashy link component. On my blog, I used to have this nifty hover effect:

Hello World
Hello World

(Hover over the “Hello World” text to see the effect.)

This effect is only shown on large screens, and only on hover (not focus). Here's a recording, for folks who can't trigger it:

This is a neat effect, but it relies on CSS properties like clip-path, properties that don't work with inline elements. In order for this to work, we need to switch to display: inline-block.

Here's the big downside with inline-block: It disables line-wrapping.

This might not seem like a big tradeoff, but consider what happens when we try to use this on longer-length links:

Because the link can't line-wrap, it forces the entire link onto the next line, adding an awkward gap.

You may be tempted to pick really-short link text, to avoid this problem, but that would be a mistake; descriptive link text is important for accessibility
. Therefore, we should only use effects like this when the links aren't part of a paragraph (eg. navigation links).

Building this link effect
(info)

If you're curious about how this effect was created, we'll learn how to build a similar effect towards the end of this course (It's an exercise in Module 9, using the clip-path property).

---

## Width Algorithms

Source: /css-for-js/01-rendering-logic-1/10-widths

Width Algorithms

In the previous lesson, we learned how block-level elements like h1 and p will expand to fill the available space.

It's easy to assume that this means that they have a default width of 100%, but that wouldn't quite be right.

In the following playground, try toggling the width: 100% declaration in the devtools, to see how it affects the size of the heading:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  h1 {
    /* width: 100%; */
    margin-left: 16px;
    background-color: chartreuse;
  }
</style>

<h1>
  Hello World
</h1>
Result
Refresh results pane

When we enable width: 100%, we cause the heading to pop outside of our frame. This happens because of the left margin.

When we use percentage-based widths, those percentages are based on the parent element's content space. If the body tag makes 400px of space available, any child with 100% width will become 400px wide, regardless of any other circumstances. This calculation happens first, before the margin is applied.

Block elements have a default width value of auto, not 100%. width: auto works very similar to margin: auto; it's a hungry value that will grow as much as it's able to, but no more. In the case above, our h1 will grow to fill the container minus the 16px of left margin.

It's a subtle but important distinction: by default, block elements have dynamic sizing. They're context-aware.

Keyword values

Broadly speaking, there are two kinds of values we can specify for width:

Measurements (100%, 200px, 5rem)
Keywords (auto, fit-content)

Measurement-based values are either completely explicit (eg. 200px), or relative to the parent's available space (eg. 50%). Keywords, on the other hand, let us specify different sorts of behaviours depending on the context.

We've already seen how auto will let our element greedily consume the available space while respecting any constraints. Let's look at some of our other options!

min-content

When we set width: min-content, we're specifying that we want our element to become as narrow as it can, based on the child contents. This is a totally different perspective: we aren't sizing based on the space made available by the parent, we're sizing based on the element's children!

This value is known as an intrinsic value, while measurements and the auto keyword are extrinsic. The distinction is based on whether we're focusing on the element itself, or the space made available by the element's parent.

Here's an example:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In this case, we wind up with a very narrow heading, because it chooses the smallest possible value for width that still contains each word. Whenever it encounters whitespace or a hyphenated word, it'll break it onto a new line.

This value can be useful for certain kinds of effects.

max-content

This value is similar in principle, but it takes an opposite strategy: it never adds any line-breaks. The element's width will be the smallest value that contains the content, without breaking it up:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

As you can see, an element with width: max-content pays no attention to the constraints set by the parent. It will size the element based purely on the length of its unbroken children.

Why would this be useful? Well, it produces a nice effect when the content is short enough to fit within the parent:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Unlike with auto, max-content doesn't fill the available space. If we want to add a background color only around the letters, this would be a neat way to do it!

Of course, our work needs to render correctly across screens of all sizes. We can't assume that the container will always be big enough to contain the heading! Thankfully, one more value is provided by the browser…

fit-content

If these keywords were bowls of porridge, fit-content would be the one that Goldilocks declares "just right".

Here's how it works: like min-content and max-content, the width is based on the size of the children. If that width can fit within the parent container, it behaves just like max-content, not adding any line-breaks.

If the content is too wide to fit in the parent, however, it adds line-breaks as-needed to ensure it never exceeds the available space. It behaves just like width: auto.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane
Min and max widths

We can add constraints to an element's size using min-width and max-width.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Try resizing this result to see how the box changes size!

The particularly exciting thing about min-width and max-width is that they let us mix units. We can specify constraints in pixels, but set a percentage width.

We'll explore these ideas much more in Module 5.

A thought experiment

fit-content is a really cool new value, but does it offer truly unique functionality? Can it be replicated using other less-shiny CSS properties?

Take a few minutes and think about it. Play around and see if you can replicate the effect without using fit-content:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

We'll discuss in this video:

Solutions have been discovered!
(success)

So far, two solutions have been found 😄 Expand below to see them:

 Show more
Exercises
Max Width Wrapper

Frequently, I'll find myself in situations where I want to constrain an element to sit in a centered column, like this:

In this exercise, we'll build a generic utility class that we can drop in to solve this problem wherever we encounter it.

Specifically, our goal with a max-width wrapper is to fulfill these constraints:

It fills the available space on smaller viewports.
It sets a maximum width, and will horizontally center itself within the parent if there is leftover space.
It includes a bit of horizontal “breathing room”, so that its children aren't pressed right up against the edges of the viewport.

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The solution:

Solution code
(info)

 Show more

A bit too small?
(info)

In the solution code above, our .max-width-wrapper class has a max-width of 350px, and then we're applying 16px of padding on each side. This means that the card itself can only ever be 318px wide:

This is because of the “border-box” box sizing. The 350px width we've set includes the border + padding.

This might seem like a problem, but honestly, I'm not worried about it 😄. In a realistic scenario, we'd probably want to adjust this max-width value based on the content anyway. I chose 350px because it displays nicely in this course platform.

Some students have thought to switch the box-sizing to content-box, so that the 350px width is applied to the inner content size. This does indeed ensure that our card will be able to expand to 350px, but in my opinion, that's not a trade worth making. Switching box-sizing values between elements is a recipe for confusion.

Figures and captions

The <figure> HTML element is fairly niche, but super useful. It allows us to display any sort of “non-typical” content: images, videos, code snippets, widgets, etc. It also lets us caption that content with <figcaption>.

Here's how it's used:

<figure>
  <img
    src="/graph.jpg"
    alt="A bar graph showing the number of cats per capita"
  />
  <figcaption>
    Source: Cat Scientists Ltd.
  </figcaption>
</figure>

<figure> elements are block-level elements, which means they fill the available horizontal space. But what if we wanted them to shrink to wrap around the image inside?

Different figures will need to be different sizes, based on the widths of the images inside. Therefore, your solution shouldn't "hardcode" any pixel values.

Give it a shot:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Solution:

---

## Height Algorithms

Source: /css-for-js/01-rendering-logic-1/11-height

Height Algorithms

We've seen how widths are calculated in Flow layout, but how about height?

In some ways, it works the same way. Setting an element to have a height of 50% will force that item to take up half of the parent element's content area: no more, no less.

In other ways, they're quite different. The default "width" behaviour of a block-level element is to fill all the available width, whereas the default "height" behaviour is to be as small as possible while fitting all of the element's content; it's closer to width: min-content than width: auto!

Also, we tend to treat height as "more dynamic" than width. We might feel comfortable setting our main content wrapper to have a max width of 750px, but we wouldn't usually do this with height; We want our design to work whether the content is 200 words, or 20,000 words. And even for pages with the exact same content, we expect that our containers will grow taller on phone screens, and shorter on desktop monitors.

We generally want to avoid setting fixed heights, otherwise we might wind up in a situation like this:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  section {
    height: 100px;
    max-width: 300px;
    border: solid;
  }
</style>

<section>
  <p>
    Constraining height is generally a bad idea, because we usually don't know how much space the element's content will take up! This paragraph is breaking out of its box, because we've constrained its height to just 100 pixels.
  </p>
</section>
Result
Refresh results pane

When it comes to layout wrappers like this, setting a fixed height is usually a bad idea. But what about when we want to set a minimum height?

For example, let's say that we have an element that wraps around our entire app. If a specific page doesn't have much content, the entire app might be less than 100% of our window height. What if we want it to take up at least 100% of the available space?

Our goal is to have a .wrapper element that will be no smaller than 100% of the available height. But min-height: 100% doesn't work:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Have you ever tried to use a percentage-based height, only to discover that it seems to have no effect? In this lesson, we're going to look at why this happens.

As we saw earlier, the default behaviour of an element in terms of height is to be as small as possible, to contain its children.

Our section sits inside the <body> tag, and so when we set a percentage-based height or min-height, the percentage is based on that parent height. <body> doesn't have a specific height set, which means it uses the default behaviour: stay as short as possible, while still containing all the children.

In other words, we have an impossible condition: we're telling the <section> to be a percentage of the <body>, and the <body> wants to base its size off of the <section>. They're both looking to each other for guidance.

This is a really common source of confusion. It isn't fixed by Flexbox or Grid, either; those tools help us control the contents of a container, but that container still needs to get its height from somewhere!

Here's how to fix it:

Put height: 100% on every element before your main one (including html and body)
Put min-height: 100% on that wrapper
Don't try and use percentage-based heights within that wrapper

When html is given height: 100%, it takes up the height of the viewport. That serves as our base. The body tag's 100% is based on that base size.

When we get to our wrapper, we want to use min-height. This way, the minimum size is equal to the viewport height, but it can overflow and take up more space if required by the content.

Here it is in code:

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

App wrapper gotcha
(warning)

JavaScript frameworks like React will render our applications into a container element. In order for percentage-based heights to work, we need to add height: 100% to this wrapper!

If you use create-react-app, the wrapper has an ID of root. In Next.js, it's __next.

Here's an example of how you can solve this problem for these two frameworks:

html,
body,
#root, /* for create-react-app */
#__next /* for Next.js */ {
  height: 100%;
}

Note that this isn't specific to React. We need to include selectors for every element that sits between the root html tag, and the element we want to stretch to 100% of the screen size.

But yeah, I don't want to distract from the fundamental takeaway here, because it's a really important one: by default, width looks up the tree, while height looks down the tree. An element's width is calculated based on its parent's size, but an element's height is calculated based on its children.

When it comes to height, a parent element will “shrinkwrap” itself around its children, like a pouch of vacuum-sealed food.

We can override this default behaviour by specifying an explicit value. For example, width: 300px and height: 500px don't look up or down the tree; they don't have to calculate anything, since we're giving it a specific value! So, I'm specifically talking about when we don't set width/height.

What about the vh unit?
(info)

You may be familiar with the vh unit, a unit designed exactly for this purpose. If you set height: 100vh, your element will inherit its height from the viewport size.

Unfortunately, this unit doesn't quite work the way we'd often like, because of mobile devices.

 Show more
But what about that footer?

Earlier, we talked about the common UI challenge of having a footer that stays at the bottom:

Having a full-height container is an important pre-requisite, but we haven't seen the tools needed to finish solving this problem. Ultimately, the goal with this module is to get comfortable with the height algorithm in Flow layout, to understand why height and min-height sometimes don't do what we expect.

Specifically, in order to solve this problem, we'd need to use Flexbox. Flexbox is the subject of an upcoming module, and we'll see how to solve this and many other problems with it.

I know cliffhangers aren't any fun, though, so here's the solution. If it doesn't make sense to you yet, don't worry: before too long, you'll become a Flexbox champion 😄

Code Playground
(Restored)

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

It is also possible to solve this problem with absolute positioning, something we'll see in Module 2. I do not recommend this approach though: the footer can "overlap" other content, unless you're very careful and use a hacky workaround.


Margin Collapse

---

## Margin Collapse

Source: /css-for-js/01-rendering-logic-1/11-margin-collapse-intro

Margin Collapse

Earlier, we talked about how margin is akin to "personal space". Let's suppose that we want to keep 6 feet
*
 of personal space.

When we think about it, though, that 6 feet can be "shared". If each person has a 6-foot bubble, we don't actually need to be 12 feet away!

Drag this fella
(Or focus him and press Left/Right)

Margins work in a similar fashion—adjacent margins will sometimes "collapse", and overlap.

This can lead to some surprising behaviour. Let's explore an example.

If you'd like, you can poke around with the same example
.


The Rules

---

## The Rules

Source: /css-for-js/01-rendering-logic-1/12-rules-of-margin-collapse

The Rules

To really understand margin collapse, we need to consider a lot of different circumstances. Let's go through them one by one, looking at how different situations lead to different results.

This can be a lot to take in. The very next lesson is a game testing you on these concepts; you may wish to bounce between the two. Go over a couple rules, try the game, rinse and repeat.

Only vertical margins collapse

Here's the "canonical" margin-collapse example — multiple paragraphs in a row:

<style>
  p {
    margin-top: 24px;
    margin-bottom: 24px;
  }
</style>

<p>Paragraph One</p>
<p>Paragraph Two</p>

Each paragraph has 24px of vertical margin (margin-top and margin-bottom), and that margin collapses. The paragraphs will be 24px apart, not 48px apart.

Hover over (or focus) this visualization. This page is full of these interactive illustrations that show how margins do (or don't) overlap.

Paragraph One
margin-bottom: 24px
Paragraph Two
margin-top: 24px

When margin-collapse was added to the CSS specification, the language designers made a curious choice: horizontal margins (margin-left and margin-right) shouldn't collapse.

In the early days, CSS wasn't intended to be used for layouts. The people writing the spec were imagining headings and paragraphs, not columns and sidebars.

So that's our first rule: only vertical margins collapse.

First
Second

Here's a live-editable example. Pop open the developer tools and inspect the margins for yourself:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Writing modes
(info)

CSS gives us the power to switch our writing modes, so that block-level elements stack horizontally instead of vertically. What effect do you think this would have on margin collapse?

 Show more
Margins only collapse in Flow layout

The web has multiple layout modes, like positioned layout, flexbox layout, and grid layout.

Margin collapse is unique to Flow layout. If you have children inside a display: flex parent, those children's margins will never collapse.

Only adjacent elements collapse

It is somewhat common to use the <br /> tag (a line-break) to increase space between block elements.

<style>
  p {
    margin-top: 32px;
    margin-bottom: 32px;
  }
</style>

<p>Paragraph One</p>
<br />
<p>Paragraph Two</p>

Regrettably, this has an adverse effect on our margins:

Paragraph One
<br>
Paragraph Two

The <br /> tag is invisible and empty, but any element between two others will block margins from collapsing. Elements generally need to be adjacent in the DOM for their margins to collapse.

The bigger margin wins

What about when the margins are asymmetrical? Say, the top element wants 72px of space below, while the bottom element only needs 24px?

Paragraph One
margin-bottom: 72px
Paragraph Two
margin-top: 24px

The bigger number wins.

This one feels intuitive if you think of margin as "personal space". If one person needs 6 feet of personal space, and another requires 8 feet of personal space, the two people will keep 8 feet apart.

Nesting doesn't prevent collapsing

Alright, here's where it starts to get weird. Consider the following code:

<style>
  p {
    margin-top: 48px;
    margin-bottom: 48px;
  }
</style>

<div>
  <p>Paragraph One</p>
</div>
<p>Paragraph Two</p>

We're dropping our first paragraph into a containing <div>, but the margins will still collapse!

Paragraph One
<div>
Paragraph Two

It turns out that many of us have a misconception about how margins work.

Margin is meant to increase the distance between siblings. It is not meant to add some space between the top of an element and its parent; that's what padding is for.

Margin will always try and increase distance between siblings, even if it means transferring margin to the parent element! In this case, the effect is the same as if we had applied the margin to the parent <div>, not the child <p>.

“But that can't be!”, I can hear you saying. “I've used margin before to increase the distance between the parent and the first child!”

Margins only collapse when they're touching. Here are some examples of nested margins that don't collapse.

Blocked by padding or border

You can think of padding/border as a sort of wall; if it sits between two margins, they can't collapse, because there's an obstruction in the way.

Paragraph One
padding-bottom: 24px
Paragraph Two

This visualization shows padding, but the same thing happens with border.

Even 1px of padding or border will cause margins not to collapse.

Blocked by a gap

As we saw in Height Algorithms, a parent will "vacuum-seal" around a child. A 150px-tall single child will have a 150px-tall parent, with no pixels to spare on either side.

But what if we explicitly give our parent element a height? Well, that would create a gap underneath the child:

height: 300px

The empty space between the two margins stops them from collapsing, like a moat filled with hungry piranhas.

Note that this is on a per-side basis. In this example, the child's top margin could still collapse. But because there's some empty space below the child, its bottom margin will never collapse.

Blocked by a scroll container

Later in this course, we'll learn how the overflow property can create a scroll container. If the parent element creates a scroll container, with a declaration like overflow: auto or overflow: hidden, it will disable margin collapse if the margins are on either side of the scroll container.

Here's the takeaway from these three scenarios: Margins must be touching in order for them to collapse.

Margins can collapse in the same direction

So far, all the examples we've seen involve adjacent opposite margins: the bottom of one element overlaps with the top of the next element.

Surprisingly, margins can collapse even in the same direction.

Parent
margin-top: 72px
Child
margin-top: 24px

Here's what this looks like in code:

<style>
  .parent {
    margin-top: 72px;
  }

  .child {
    margin-top: 24px;
  }
</style>

<div class="parent">
  <p class="child">Paragraph One</p>
</div>

This is an extension of the previous rule. The child margin is getting “absorbed” into the parent margin. The two are combining, and are subject to the same rules of margin-collapse we've seen so far (eg. the biggest one wins).

This can lead to big surprises. For example, check out this common frustration:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In this scenario, you might expect the two sections to be touching, with the margin applied inside each container:

Paragraph One
Paragraph Two

This seems like a reasonable assumption, since the <section>s have no margin at all! The intention seems to be to increase the space within the top of each box, to give the paragraphs a bit of breathing room.

The trouble is that 0px margin is still a collapsible margin. Each section has 0px top margin, and it gets combined with the 32px top margin on the paragraph. Since 32px is the larger of the two, it wins.

More than two margins can collapse

Margin collapse isn't limited to just two margins! In this example, 4 separate margins occupy the same space:

It's hard to see what's going on, but this is essentially a combination of the previous rules:

Siblings can combine adjacent margins (if the first element has margin-bottom, and the second one has margin-top)
A parent and child can combine margins in the same direction

Each sibling has a child that contributes a same-direction margin.

Here it is, in code. Use the devtools to view each margin in isolation:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The space between our <header> and <section> has 4 separate margins competing to occupy that space!

The header wants space below itself
The h1 in the header has bottom margin, which collapses with its parent
The section below the header wants space above itself
The p in the section has top margin, which collapses with its parent

Ultimately, the paragraph has the largest cumulative margin, so it wins, and 40px separates the header and section.

Negative margins

Finally, we have one more factor to consider: negative margins.

As we saw when we looked at Margins, a negative margin will pull an element in the opposite direction. A sibling with a negative margin-top might overlap its neighbor:

margin-top: -40px

How do negative margins collapse? Well, it's actually quite similar to positive ones! The negative margins will share a space, and the size of that space is determined by the most significant negative margin. In this example, the elements overlap by 75px, since the more-negative margin (-75px) was more significant than the other (-25px).

margin-bottom: -75px
margin-top: -25px

What about when negative and positive margins are mixed? In this case, the numbers are added together. In this example, the -25px negative margin and the 25px positive margin cancel each other out and have no effect, since -25px + 25px is 0.

margin-bottom: -25px
margin-top: 25px
No Margins
Margins

Why would we want to apply margins that have no effect?! Well, sometimes you don't control one of the two margins. Maybe it comes from a legacy style, or it's tightly ensconced in a component. By applying an inverse negative margin to the parent, you can "cancel out" a margin.

Of course, this is not ideal. Better to remove unwanted margins than to add even more margins! But this hacky fix can be a lifesaver in certain situations.

Multiple positive and negative margins

We've gotten pretty deep into the weeds here, and we have one more thing to look at. It's the "final boss" of this topic, the culmination of all the rules we've seen so far.

What if we have multiple margins competing for the same space, and some are negative?

If there are more than 2 margins involved, the algorithm looks like this:

All of the positive margins collapse together (eg. 10px and 50px collapse into a single 50px margin).
All of the negative margins collapse together (eg. -20px and -30px collapse into a single -30px margin).
Add those two numbers together (50px + -30px = 20px).

Here's an example in code. Poke around in the devtools to see how it all works out:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In this example, our most significant positive margin is 30px. Our most significant negative margin is -20px. Therefore, we wind up with 10px of realized margin, since we add the positive and negative values together.

(No 3D illustration for this one — honestly, it was too busy and chaotic-looking to offer much clarity 😅)

You can probably understand now why margin collapse has such a dastardly reputation! This stuff is tricky, and that's no joke.

As mentioned, the next lesson features a game that will let you test your collapse knowledge. Don't be afraid to pop back to this lesson for a refresher after you play; it might take a few tries before everything clicks.


Will It Collapse?

---

## Will It Collapse?

Source: /css-for-js/01-rendering-logic-1/13-will-it-collapse

Will It Collapse?

The rules of margin collapse can be confusing, especially when considering how they interact with each other.

Rather than try to memorize them all, a better way to develop an intuition about it is to experiment and test your knowledge.

Let's get some practice with a game.

Will It Collapse?

Using Margin Effectively

---

## Using Margin Effectively

Source: /css-for-js/01-rendering-logic-1/14-best-practices

Using Margin Effectively

Now that you've seen how hairy margin collapse can get, you may wonder: why use margin at all, if it has so many footguns??

In fact, a growing trend amongst JavaScript developers is to forego margin altogether, and use a combination of padding and layout components instead. Max Stoiber, co-creator of styled-components, has written about how margin is harmful
.

I personally really like this idea, but I also want to acknowledge that it isn't possible for most folks. Unless you're starting a brand-new project, and the entire team is onboard, you'll be stuck with margin. You need to learn how to use it effectively because most of the front-end world relies on it.

Margin is like glue

I really like this quote by Heydon Pickering:

Margin is like putting glue on something before you’ve decided what to stick it to, or if it should be stuck to anything.

I try and avoid putting margin on something at the component boundary. For example, let's say we have a VideoClip component:

function VideoClip({ src }) {
  return (
    <video
      src={src}
      style={{ margin: 32 }}
    />
  );
}

You might be imagining embedding this video in a blog post, and you know you'll want some space around it... but applying margin in this way is gluing the component without knowing where you'll stick it.

You might be saying “But no, I know where I want to stick it! In the blog post!”. And that's fine for bespoke, one-off components… but VideoClip sounds generic and reusable. I might want to use it in lots of different places, and those places might have different spacing requirements.

For reusable components, we want them to be as unopinionated as possible. Because next week, you may want to create a VideoStrip component that lines up several video clips without any gap, and now you have a problem, because the same component needs different amounts of margin in different situations.

There are a couple of solutions to this. One option is to allow components like VideoClip to accept a className prop, so that we can supply the correct amount of margin whenever we use this component. We’ll talk more about this strategy in Module 3.

Another option is to use layout components. These are components that are intended to wrap around a group of elements to provide some sort of shared layout. For example, the Braid design system
 has a Stack component that applies vertical spacing between its children:

function BlogPost() {
  return (
    <Stack>
      <p>Hello world!</p>
      <VideoClip />
      <p>Yadda yadda yadda</p>
      <SomeEmbeddedThing />
    </Stack>
  )
}

Workshop: Agency page

---

## Workshop: Agency page

Source: /css-for-js/01-rendering-logic-1/15-flow-workshop

Workshop: Agency page

Alright, time to build something! In this workshop, we'll build a landing page for a fictional consultancy.

About workshops

Because this is the first workshop in the course, let's talk about how they work!

Workshops are real-world-inspired problems. The project and its goals are described in depth in the project's README.md file, though you'll be given the gist of the project here on the course platform.

Workshops are intended to be challenging. Especially when we get deeper into the course, you may not be able to complete the challenge, and that’s OK. It’s about the journey, not the destination.

If you get stuck on a problem, you can review earlier lessons in the module to look for hints. Feel free to google things, or ask ChatGPT to see if it has any ideas. If you’re still stuck after that, you can check out the solution video (in the next lesson) to see how I solve the problem.

Once you're finished with the workshop, you can submit the link to your solution. This is mainly to serve as an accountability tool. On occasion, I'll go through the submissions to see broadly where people are struggling, but I don't offer individual reviews.

Also, it’s worth noting that there are many valid solutions for the workshops; your solution might look quite different than mine, but that doesn't mean you did it wrong!

Alright, let's get to the specifics of this workshop!

Your mission

In this workshop, you're asked to build a landing page for an agency:

Here's what it looks like on tablet and mobile:

This mockup is built entirely using flow layout: no Flexbox, no grid, no absolute positioning. It relies heavily on padding, margin, and border. No media queries are required.

Getting started

The quickest way to get started is to work on this project through CodeSandbox, a web-based IDE:

Work on CodeSandbox

Save to refresh!
(warning)

On CodeSandbox, you're shown the editor on the left, the preview output on the right.

Because this is a static file (no JS bundler involved), there is no hot reloader. This means you need to manually save the file to view updates. You can do this with the standard save shortcut (Ctrl + S).

If you'd like to work on this on your local machine, or if you run into problems with the CodeSandbox, you can fork the Github repository here:

Download from Github

Once you have the files on your machine, you can run a local development server by running the following terminal commands:

$ npm install
$ npm run dev

If you're not familiar with Node/NPM, I've prepared a short guide that covers how to install and manage Node projects.

Downloading from Github
(info)

The intended way to access these files is to fork the repository and then clone it onto your machine using the Git CLI tool, but if you're not familiar with Git, you can download all the files into a .zip file:

The README file is your home base. It includes specific instructions for how to proceed, as well as a bunch of other helpful contextual information. I recommend keeping the README open at all times, and referring back to it whenever you're not sure how to proceed / what you should be doing.

Protip: viewing Markdown previews
(success)

If you use VS Code as your code editor, you can preview the README.md file using its built-in markdown previewer:

This is way more convenient: we can actually see the embedded images, click the links, etc.

To enter this command, you'll need to open the command palette. This can be done with Ctrl + shift + P.

Unfortunately, this doesn't work in CodeSandbox.

Accessing the design

In addition to the screenshots included here, you can access the full design on Figma:

figma.com/file/6hGqKA5scrZJScb9KW3Hj2/Huckleberry

Never used Figma before?
(warning)

If you're unfamiliar, Figma is software used by UI designers to create mockups. I've used it to prepare the designs for several workshops in this course.

As developers, Figma can help us implement designs by giving us insights into things like spacings and typography styles. We can save a ton of time by getting our data from Figma.

I've created a short bonus lesson that teaches you how to use it. It includes a bunch of tips and tricks I've learned after using Figma for years.

Check it out:

Intro to Figma
 Workshop Submitted

You marked this lesson as completed without submitting a URL. Add one now?

I review a small percentage of submitted workshops, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


Workshop Solution

---

## Workshop Solution

Source: /css-for-js/01-rendering-logic-1/16-flow-workshop-solution

Workshop Solution

In this video, we'll walk through my solution to the “Huckleberry” agency page workshop.

The code created in this video can be viewed in the solution branch of the repo

In the video above, the HTML has <em> tags around the “Huckleberry” company name. These tags have been removed from the workshop. Sorry for any confusion!

Crosshair measuring tool?
(success)

The rectangle tool I'm using to measure in this video is the default screenshot tool built into macOS. For folks not on macOS, you can check out PowerToys
 / Greenshot
 (Windows) or screenruler
 / KRuler
 (Linux).

I've created a Treasure Trove entry about measuring sizes and distances on-screen, with tons of great tricks and recommendations.

