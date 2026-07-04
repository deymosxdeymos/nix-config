# CSS for JS - Module 8: Animations

---

## Introduction • Josh W Comeau's Course Platform

Source: /css-for-js/08-animations/00-introduction

Animations

The natural world we live in—the one with snowstorms and music and snakes and busses—is dynamic. Everything is constantly in motion.

Busses don't teleport from bus stop to bus stop
*
. Snakes slither around like delightfully-alien creatures. A song plays over a 3-minute interval. Snowstorms build up and pass through and fade out.

And yet, on the web, so many of the things we do are instantaneous. When you click a button or a link, elements will appear or disappear or change in a completely artificial, unconvincing way.

Our brains aren't really built for things to just happen. Companies like Apple understand this, and they account for it in their products. If you have an iPhone, watch it carefully as you do things like lock/unlock it, or switch between apps. Notice how much life there is in every interaction and transition.

This sort of subtle, natural motion helps our brains make sense of things. It makes the pixels in our screens feel more real and tangible. I think it's a big part of why mobile apps feel more premium and polished than their web-app counterparts.

Animation is a huge topic, one that deserves its own course, but in this module, we'll cover the fundamentals of animation in CSS. We'll build a sturdy foundation, one that you can build on top of.

We'll cover:

The magic of transform functions
A deep dive into how the transition property works
How to use @keyframes effectively
How to design animations, to create next-level user experiences, using principles like action-driven motion and orchestration.
Understanding animation performance, how to leverage hardware acceleration for smoother motion
Another "ecosystem world tour", this time looking at the animation landscape.

As always, we focus on mental models to help you understand how this stuff really works. Learn the principles, not the properties!


---

## Transforms

Source: /css-for-js/08-animations/01-transforms

Transforms

Over the last 8 modules, we've bumped into the transform property a couple times. As we start talking about animation, we need to become properly acquainted with this fella.

As the name implies, transform allows us to change a specified element in some way. It comes with a grab-bag of different transform functions that allow us to move and contort our elements in many different ways.

Transform functions
Translation

Translation allows us to move an item around:

transform: translate(0px, 0px);
x
0px
y
0px

We can use translate to shift an item along in either axis: x moves side to side, y moves up and down. Positive values move down and to the right. Negative values move up and to the left.

Critically, the item's in-flow position doesn't change. As far as our layout algorithms are concerned, from Flow to Flexbox to Grid, this property has no effect.

For example: in this visualization, we have 3 children aligned using Flexbox. When we apply a transform to the middle child, the Flexbox algorithm doesn't notice, and keeps the other children in the same place:

transform: translate(0px, 0px);
x
0px
y
0px

This is similar to how top / left / right / bottom work in positioned layout, with relatively-positioned elements.

When we want to move an element along a single axis, we can use translateX and translateY:

.box {
  transform: translateY(20px);

  /* It's equivalent to: */
  transform: translate(0px, 20px);
}

There's one thing that makes translate ridiculously powerful, though. Something totally unique in the CSS language.

When we use a percentage value in translate, that percentage refers to the element's own size, instead of the available space in the parent container.

For example:

transform: translate(0%, 0%);
x
0%
y
0%
Box width/height
80px

Setting transform: translateY(-100%) moves the box up by its exact height, no matter what that height is, to the pixel.

Here's another example in code, showing how percentages vary between transforms and other CSS properties like left:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Here are the two scales that are being used:

In the exercise below, we'll see why this is such a handy superpower!

With the magic of calc, we can even mix relative and absolute units:

transform: translateX(calc(0% + 0px));
Percentage
0%
Pixels
0px

This allows us to add a "buffer", so that we can translate something by its own size plus a few extra pixels.

Scale

Alright, let's look at another transform function!

scale allows us to grow or shrink an element:

transform: scale(1);
Ratio
1

Scale uses a unitless value that represents a multiple, similar to line-height. scale(2) means that the element should be 2x as big as it would normally be.

We can also pass multiple values, to scale the x and y axis independently:

transform: scale(1, 1);
x
1
y
1

At first glance, this might seem equivalent to setting width and height, but there's one big difference.

Check out what happens when our element has some text in it:

Hello World
transform: scale(1, 1);
x
1
y
1

The text scales up and down with the element. We aren't just transforming the size and shape of the box, we're transforming the entire element and all of its descendants.

Simpler calculations
(success)

This reveals an important truth about transforms: elements are flattened into a texture. All of these transforms essentially treat our element like a flat image, warping and contorting it as you might in Photoshop.

Incidentally, this is why they're so important for animations!

Think about how much work is required when we change something like width. All of the layout algorithms need to re-run, figuring out exactly where this element and all of its siblings should be. If the element has text inside, the line-wrapping algorithm needs to figure out if this new width affects the line breaks. Then, the paint algorithms run, figuring out which color every pixel needs to be, and filling it in.

It's fine to do this once when the page loads, but when we animate something, we need to do all of those calculations many many times a second. With transforms, we can skip a bunch of steps. This means that the calculations run quicker, leading to smoother motion.

We'll learn more about animation performance soon.

It may seem like a bummer that scale will stretch/squash the element's contents, but we can actually use this effect to our advantage. For example, check out this old-timey TV power animation:

transform: scale(1, 1);
filter: brightness(100%);
Power status
On
Off

For this animation, the squashing effect actually improves the effect!

And, if we really don't want our text to squash, we can apply an inverse transform to the child.

This is an advanced technique, far beyond the scope of this course, but know that it's possible to use scale to increase an element's size without distorting its children. Libraries like Motion
 take advantage of this fact to build highly-performant animations without stretching or squashing.

Rotate

You guessed it: rotate will rotate our elements:

transform: rotate(0deg);
Rotation
0deg

We typically use the deg unit for rotation, short for degrees. But there's another handy unit we can use, one which might be easier to reason about:

transform: rotate(0turn);
Rotation
0turn

The turn unit represents how many turns the element should make. 1 turn is equal to 360 degrees.

It's obscure, but well-supported; the turn unit goes all the way back to IE 9!

Skew

Finally, skew is a seldom-used but pretty-neat transformation:

Hello World
transform: skew(0deg);
Skew
0deg

As with translate, we can skew along either axis:

Hello World
transform: skewX(0deg);
Skew
0deg
Axis
X
Y

Skew can be useful for creating diagonal decorative elements (à la Stripe
). With the help of calc and some trigonometry, it can also be used on elements without distorting the text! This technique is explored in depth in Nils Binder's awesome blog post, “Create Diagonal Layouts Like It's 2020
”.

Transform origin

Every element has an origin, the anchor that the transform functions execute from.

Check out how rotation changes when we tweak the transform origin:

transform: rotate(0deg);
transform-origin: center;
Rotation
0deg
Transform Origin
center (default)
left top
25px bottom
0% 150%
center (default)

The transform origin acts as a pivot point!

It isn't exclusive to rotation, either; here's how it affects scale:

transform: scale(1);
transform-origin: center;
Scale
1
Transform Origin
center (default)
left top
25px bottom
0% 150%
center (default)

This is useful for certain kinds of effects (for example, an element "growing out of" another one).

Combining multiple operations

We can string together multiple transform functions by space-separating them:

transform: translateX(0px) rotate(0deg);
Translate X
0px
Rotation
0deg

The order is important: the transform functions will be applied sequentially. Check out what happens if we reverse the order:

transform: rotate(0deg) translateX(0px);
Translate X
0px
Rotation
0deg

The transform functions are applied from right to left, like composition in functional programming.

In the first demo, we rotate the element in its natural position, and then translate it along the X axis.

In this second demo, however, we translate the element first. When we apply the rotation, it rotates around its origin, which hasn't changed.

Here's the same demo, but with the origin shown:

transform: rotate(0deg) translateX(0px);
transform-origin: center;
Rotation
0deg
Translate X
0px
Transform Origin
center (default)
left top
25px bottom
0% 150%
center (default)

We can use this to our advantage:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In this example, we start by positioning the moon in the dead center of the planet. Our animation will shift it 80px to the right, and then cause it to rotate in a circle. Because the moon's origin is still in the center of the planet, it orbits around at a distance.

We'll learn more about keyframe animations shortly.

Inline elements

One common gotcha with transforms is that they don't work with inline elements in Flow layout.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Remember, inline elements go with the flow. Their goal is to wrap around some content with as little disruption as possible. Transforms aren't their cup of tea.

The easiest fix is to switch it to use display: inline-block, or to use a different layout mode (eg. Flexbox or Grid).

Exercises
Dialog layout

Update the code below to match this mockup:

Here's our acceptance criteria:

The dialog box should be centered within the viewport
The close button should sit just outside the dialog box, as if it was resting on top of the modal, like a bird perched on a fence.

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

---

## CSS Transitions

Source: /css-for-js/08-animations/02-transitions

CSS Transitions

The most fundamental tool in our toolbox when it comes to animations is the transition CSS property.

transition allows us to smooth out the changes that occur in our application. Instead of an element teleporting from one spot to another, it glides between the two.

In order for us to use transition, we need some CSS that changes. Here's an example of a button that moves without any animation:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .btn:hover {
    transform: translateY(-10px);
  }
</style>

<button class="btn">
  Hello World
</button>
Result
Refresh results pane

On hover, we apply a transform that shifts the element up by 10 pixels. The moment the cursor crosses our button, it gets repainted in its new position.

We can instruct the browser to interpolate from one state to another with transition:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .btn {
    transition: transform 250ms;
  }

  .btn:hover {
    transform: translateY(-10px);
  }
</style>

<button class="btn">
  Hello World
</button>
Result
Refresh results pane

As we'll discover, the transition property is highly configurable, but only two values are required:

The name of the property we wish to animate
The duration of the animation

If you plan on animating multiple properties, you can pass it a comma-separated list:

.btn {
  transition: transform 250ms, opacity 400ms;
}

.btn:hover {
  transform: scale(1.2);
  opacity: 0;
}

Selecting all properties
(warning)

transition-property takes a special value: all. When all is specified, any CSS property that changes will be transitioned.

It can be tempting to use this value, as it saves us a good chunk of typing if we're animating multiple properties, but I recommend not using it.

At some point in the future, you (or someone on your team) will change this CSS. You might add a new declaration that you don't want to transition. It's better to be specific, and avoid any unintended animations.

Animation is like salt: too much of it spoils the dish.

Timing functions

When we talk about “motion” on the web, we're really talking about simulated motion. The pixels themselves aren't moving across the display!

What we're really doing is more like a flipbook. Each frame draws the element at a slightly different position. If we do this fast enough, it appears like fluid motion, but it's an optical illusion.

Let's look at an example. Click the "Play" button to animate the circle from left to right:

TIMELINE
Run animation

(the first time you run this animation, it might be a bit janky, but it should run smoother on subsequent plays!)

To understand this visualization: each faded circle is a "ghost", like in oldschool racing games. It shows a single frame that was previously painted. Normally, your monitor only shows each frame for a small fraction of a second, but I've added these "ghosts" to help us understand what's actually happening when we animate an element.

In this animation, we're using a linear timing function. This means that the element moves at a constant pace; our circle moves by the same amount each frame.

Progression
Time

There are several timing functions available to us in CSS. We can specify which one we want to use with the transition-timing-function property:

.btn {
  transition: transform 250ms;
  transition-timing-function: linear;
}

Or, we can pass it directly to the transition shorthand property:

.btn {
  transition: transform 250ms linear;
}

linear is rarely the best choice — after all, pretty much nothing in the real world moves this way
*
. Good animations mimic the natural world, so we should pick something more organic!

Let's run through our options.

ease-out

ease-out comes charging in like a wild bull, but it runs out of energy. By the end, it's pootering along like a sleepy turtle.

TIMELINE
Run animation

Try scrubbing with the timeline; notice how drastic the movement is in the first few frames, and how subtle it becomes towards the end.

If we were to graph the displacement of the element over time, it'd look something like this:

Progression
Time

When would you use ease-out? It's most commonly used when something is entering from off-screen (eg. a modal appearing). It produces the effect that something came hustling in from far away, and settles in front of the user.

ease-in

ease-in is the opposite of ease-out. It starts slow and speeds up:

TIMELINE
Run animation

Here's what it looks like on a graph:

Progression
Time

Note that ease-in is pretty much exclusively useful for animations that end with the element offscreen or invisible; otherwise, the sudden stop can be jarring.

It can be worthwhile to combine ease-in and ease-out when something enters and exits the viewport, like a modal.

ease-in-out

Next up, ease-in-out. It's the combination of the previous two timing functions:

TIMELINE
Run animation

This timing function is symmetrical. It has an equal amount of acceleration and deceleration.

Progression
Time

I find this curve most useful for anything that happens in a loop (eg. an element fading in and out, over and over).

It's a big improvement over linear, but before you go slapping it on everything, let's look at one more option.

ease

ease is very similar to ease-in-out, with one key difference: it isn't symmetrical. It features a brief ramp-up, and lots of deceleration:

TIMELINE
Run animation

ease is the default value — if you don't specify a timing function, ease gets used. This tends to be a good thing: ease is a great option in most cases. Unless you're specifically going for a different effect, ease makes a lot of sense.

Progression
Time

Time is constant
(info)

An important note about all of these demos: time is constant. Timing functions describe how a value should get from 0 to 1 over a fixed time interval, not how quickly the animation should complete. Some timing functions may feel faster or slower, but in these examples, they all take exactly 1 second to complete.

Custom curves

If the provided built-in options don't suit your needs, you can define your own custom easing curve, using the cubic bézier timing function!

.btn {
  transition:
    transform 250ms cubic-bezier(0.1, 0.2, 0.3, 0.4);
}

All of the values we've seen so far are really just presets for this cubic-bezier function. The linear value can also be represented as cubic-bezier(0, 0, 1, 1).

Coming up with custom curves can be difficult, but it's extremely worthwhile. I share my tool of choice, and how I use it, over in the Treasure Trove:

cubic-bezier

You can also pick from this extended set of timing functions
. Though beware: a few of the more outlandish options won't work in CSS.

Time for me to come clean
(warning)

I have a confession to make: the demonstrations above, showing the different timing functions, were exaggerated.

In truth, timing functions like ease-in are more subtle than depicted, but I wanted to emphasize the effect to make it easier to understand. The cubic-bezier timing function makes that possible!

 Show more
Delays

Have you ever tried to mouse over a nested navigation menu, only to have it close before you get there?

Image courtesy of Ben Kamens

As a JS developer, you can probably work out why this happens: the dropdown only stays open while being hovered! As we move the mouse diagonally to select a child, our cursor dips out of bounds, and the menu closes.

This problem can be solved in a rather elegant way without needing to reach for JS. We can use transition-delay!

.dropdown {
  opacity: 0;
  transition: opacity 400ms;
  transition-delay: 300ms;
}

.dropdown-wrapper:hover .dropdown {
  opacity: 1;
  transition: opacity 100ms;
  transition-delay: 0ms;
}

transition-delay allows us to keep things status-quo for a brief interval. In this case, when the user moves their mouse outside .dropdown-wrapper, nothing happens for 300ms. If their mouse re-enters the element within that 300ms window, the transition never takes place.

After 300ms elapses, the transition kicks in normally, and the dropdown fades out over 400ms.

Why no shorthand?
(info)

So far, we've been using the transition shorthand to bundle all our transition-related values together. transition-delay can also be used with the shorthand:

.dropdown {
  opacity: 0;
  transition: opacity 250ms 300ms;
}

Personally, I prefer not to use the shorthand for transition-delay.

 Show more
Doom flicker

This video describes a "doom flicker", a common animation bug where an element jumps up and down quickly in an unintentional, unpleasant way:

Warning: This GIF includes flickering motion that may potentially trigger seizures for people with photosensitive epilepsy.

REVEAL

Here's the "before" code:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

And here's the "after" solution code:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

To solve this problem, we separate the trigger from the effect. We listen for hovers on the parent <button>, but apply the transformation to a child element. This ensures that the hover target won't move out from under the cursor.

This works because hover states bubble up, just like mouseEnter events in JavaScript. When we hover over .btn-contents, we're also hovering over all of its ancestors (.btn, body, etc).

Exercises
Translated cards

Update the set of cards below so that hovering causes them to slide upwards:

No "doom flicker" should occur.

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
Photo zoom

Update the photo gallery below so that hovering a photo zooms in slightly:

This is a tricky problem! You'll need to use a property we've seen in past modules to complete the effect.

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

At the end of the video, I mention that the weird “snapping into place” effect will be covered in a future lesson. If you're keen to figure that out, you'll want to learn about the will-change property, discussed in the Animation Performance lesson.


---

## Keyframe Animations

Source: /css-for-js/08-animations/03-keyframe-animations

Keyframe Animations

CSS keyframe animations are declared using the @keyframes at-rule. We can specify a transition from one set of CSS declarations to another:

@keyframes slide-in {
  from {
    transform: translateX(-100%);
  }
  to {
    transform: translateX(0%);
  }
}

Each @keyframes statement needs a name! In this case, we've chosen to name it slide-in. You can think of this like a global variable.
*

Keyframe animations are meant to be general and reusable. We can apply them to specific selectors with the animation property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  @keyframes slide-in {
    from {
      transform: translateX(-100%);
    }
    to {
      transform: translateX(0%);
    }
  }

  .box {
    animation: slide-in 1000ms;
  }
</style>

<div class="box">
  Hello World
</div>
Result
Refresh results pane

(To re-run the animation, refresh the “Result” pane by clicking the
"Refresh"
 icon.)

As with the transition property, animation requires a duration. Here we've said that the animation should last 1 second (1000ms).

The browser will interpolate the declarations within our from and to blocks, over the duration specified. This happens immediately, as soon as the property is set.

We can animate multiple properties in the same animation declaration. Here's a fancier example that changes multiple properties:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Timing functions

As with transition, keyframe animations default to an ease timing curve, but can be overridden.

We can do this with the animation-timing-function property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Looped animations

By default, keyframe animations will only run once, but we can control this with the animation-iteration-count property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

It's somewhat rare to specify an integer like this, but there is one special value that comes in handy: infinite.

For example, we can use it to create a loading spinner:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Note that for spinners, we generally want to use a linear timing function so that the motion is constant (though this is somewhat subjective—try changing it and see what you think!).

Multi-step animations

In addition to the from and to keywords, we can also use percentages. This allows us to add more than 2 steps:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The percentages refer to the progress through the animation. from is really just syntactic sugar? for 0%. to is sugar for 100%.

Importantly, the timing function applies to each step. We don't get a single ease for the entire animation:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In this playground, both spinners complete 1 full rotation in 2 seconds. But multi-step-spin breaks it into 4 distinct steps, and each step has the timing function applied.

There's no way around it using CSS keyframe animations, though it is possible to configure this behaviour in the Web Animations API. We take a brief look at this at the end of the module

Alternating animations

Let's suppose that we want an element to "breathe", inflating and deflating.

We could set it up as a 3-step animation:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

It spends the first half of the duration growing to be 1.5x its default size. Once it reaches that peak, it spends the second half shrinking back down to 1x.

This works, but there's a more-elegant way to accomplish the same effect. We can use the animation-direction property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

animation-direction controls the order of the keyframes. The default value is normal, going from 0% to 100% over the course of the specified duration.

We can also set it to reverse. This will play the animation backwards, going from 100% to 0%.

The interesting part, though, is that we can set it to alternate, which ping-pongs between normal and reverse on subsequent iterations.

Instead of having 1 big animation that grows and shrinks, we set our animation to grow, and then reverse it on the next iteration, causing it to shrink.

Half the duration
(info)

Originally, our "breathe" animation lasted 4 seconds. When we switched to the alternate strategy, however, we cut the duration in half, down to 2 seconds.

This is because each iteration only performs half the work. It always took 2 seconds to grow, and 2 seconds to shrink. Before, we had a single 4-second-long animation. Now, we have a 2-second-long animation that requires 2 iterations to complete a full cycle.

Shorthand values

We've picked up a lot of animation properties in this lesson, and it's been a lot of typing!

Fortunately, as with transition, we can use the animation shorthand to combine all of these properties.

The above animation can be rewritten:

.box {
  /*
  From this:
    animation: grow-and-shrink 2000ms;
    animation-timing-function: ease-in-out;
    animation-iteration-count: infinite;
    animation-direction: alternate;

  ...to this:
  */
  animation: grow-and-shrink 2000ms ease-in-out infinite alternate;
}

Here's a piece of good news, as well: the order doesn't matter. For the most part, you can toss these properties in any order you want.

This works because different properties accept different values; alternate, for example, isn't a valid timing-function or iteration-count, so the browser can deduce that you mean to assign it to animation-direction.

.box {
  /* This works: */
  animation: grow-and-shrink 2000ms ease-in-out infinite alternate;

  /* This also works! */
  animation: grow-and-shrink alternate infinite 2000ms ease-in-out;
}

There is an exception: animation-delay, a property we'll talk more about shortly, needs to come after the duration, since both properties take the same value type (milliseconds/seconds).

For that reason, I prefer to exclude delay from the shorthand:

.box {
  animation: grow-and-shrink 2000ms ease-in-out infinite alternate;
  animation-delay: 500ms;
}

---

## Fill Modes

Source: /css-for-js/08-animations/04-fill-modes

Fill Modes

Probably the most confusing aspect of keyframe animations is fill modes. They're the biggest obstacle on our path towards confidence.

First, let's start with a problem.

We want our element to fade out. The animation itself works fine, but when it's over, the element pops back into existence:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  @keyframes fade-out {
    from {
      opacity: 1;
    }
    to {
      opacity: 0;
    }
  }

  .box {
    animation: fade-out 1000ms;
  }
</style>

<div class="box">
  Hello World
</div>
Result
Refresh results pane

If we were to graph the element's opacity over time, it would look something like this:

Why does the element jump back to full visibility? Well, the declarations in the from and to blocks only apply while the animation is running.

After that first 1000ms, the animation packs itself up and hits the road. The declarations in the to block dissipate, leaving our element with whatever CSS declarations have been defined elsewhere. Since we haven't set opacity for this element anywhere else, it snaps back to its default value (1).

One way to solve this is to add an opacity declaration to the .box selector directly:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

While the animation is running, the declarations in the @keyframes statement overrule the opacity declaration in the .box selector. Once the animation wraps up, though, that declaration kicks in and keeps the box hidden.

Specificity?
(info)

You might be wondering: how "specific" are the declarations in a @keyframes statement? Will they always overrule other selectors while the animation is running?

But what about keyframe animations? What is their specificity?

It turns out that specificity isn't really the right way to think about this; instead, we need to think about cascade origins.

 Show more

So, we can update our CSS so that the element's properties match the to block, but is that really the best way?

Filling forwards

Instead of relying on default declarations, let's consider another approach, using animation-fill-mode:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

animation-fill-mode lets us persist the final value from the animation, forwards in time.

"forwards" is a very confusing name, but hopefully seeing it on the graph makes it a bit clearer.

Imagine if we recorded the first 10 seconds the user spent on our page. We can now scrub forwards and backwards in time through this recording.

As we scrub through the first second, the box slowly disappears. For the next 9 seconds, the box remains invisible, because animation-fill-mode: forwards effectively copying the declarations from the to block, and persisting them as we scrub forwards in time.

Filling backwards

By default, animations will run immediately, as soon as the animation property is set.

Like with transition, though, we can specify a delay if we'd like the animation to start a bit later.

Unfortunately, we run into a similar issue:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

For that first half-second, the element is fully visible:

This issue is caused by the same culprit. For that first 500ms, no CSS from the animation is applied.

animation-fill-mode has another value, backwards, which allows us to apply the animation's initial state backwards in time.

Essentially what we've said here is to copy all of the declarations in the from block and apply them to the element ASAP, before the animation has started.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

What if we want to persist the animation forwards and backwards? We can use a third value, both, which persists in both directions:

In general, I want the initial value in my keyframe to be applied during the delay. And I want the final value to keep applying after the animation has ended. I apply animation-fill-mode: both as a matter of habit to my keyframe animations. I wish it was the default value.

Like all of the animation properties we're discussing, it can be tossed into the animation shorthand:

.box {
  animation: slide-in 1000ms ease-out both;
  animation-delay: 500ms;
}

---

## Dynamic Updates

Source: /css-for-js/08-animations/05-dynamic-updates

Dynamic Updates

So far, all of the examples we've seen involve an animation running right on page load (or after a prescribed delay).

That's not quite the right way to think about it though. There's no rule that says that animations need to happen immediately!

It's more accurate to say that the animation will start as soon as a valid animation is wired up, using the animation property. Using JavaScript, we can add that property dynamically, at any point in time:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
App.js
styles.css
import React from 'react';
import styled from 'styled-components';

function App() {
  const [
    animated,
    setAnimated
  ] = React.useState(false);

  return (
    <Wrapper>
      <Box
        style={{
          animation: animated
            ? 'jump 1000ms infinite'
            : undefined,
        }}
      />
      <button
        onClick={() => {
          setAnimated(!animated);
        }}
      >
        {animated
          ? 'Disable animation'
          : 'Enable animation'
        }
      </button>
    </Wrapper>
  );
}

const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  justify-content: center;
Result
Console
Refresh results pane

When the page loads, the animation property is set to undefined, and so nothing happens. When the user clicks the "Enable animation" button, though, that property is updated to jump 1000ms infinite. The moment the animation property is set to a valid value, the animation begins.

If the button is clicked again, animation is reverted back to undefined, and the animation is disabled.

Playing and pausing

You may have noticed in the example above: disabling the animation can lead to some pretty jarring transitions:

When we remove the animation property, all of the CSS in the from and to blocks evaporates immediately. The element will revert back to its default CSS.

This is known as an “interruption”. @keyframes animations don't handle interruptions well.

There is a tool that can help in certain situations, though: play states.

Here's an updated example:

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

(Quick reminder: styles are "camelCased" when setting them in JavaScript. animationPlayState sets the CSS property animation-play-state.)

Before, we were dynamically applying and removing the animation altogether. In this updated example, the animation is always applied (inside the Box styled-component), but we dynamically toggle it between running and paused.

paused works like the pause button on a remote control. Everything freezes in place. Toggling it back to running will pick up from where it left off.

animation-play-state has excellent browser support
, going all the way back to IE10.

Not many animations require "pause" functionality, but it's a neat property to have in your back pocket!

Animations vs. transitions

You might be wondering: when should I use @keyframes, and when should I use transition?

There are some things that only @keyframes can do:

Looped animations
Multi-step animations
pauseable animations

We can do some of this stuff from JS, if we really wanted to. But usually, it's simpler to use @keyframes.

If an animation needs to run immediately when the page loads or the component mounts, it's easiest to use @keyframes.

On the other hand, I reach for transition when my CSS will change as a result of some application state or user action. I use it when I want to smooth out an otherwise harsh transition between values.

Both tools serve slightly different purposes, and it takes some practice to build an intuition for which to use when.


---

## With styled-components

Source: /css-for-js/08-animations/06-with-styled-components

With styled-components
(Optional lesson)

When we write CSS with styled-components, all of our styles are coupled with a specific component. The @keyframes at-rule is meant to be declared globally, though. How do we use @keyframes with styled-components?

Happily, the library comes with a utility for this!

We can import keyframes from the styled-components package, and use it like so:

import styled, { keyframes } from 'styled-components';

function App() {
  return <FloatingCircle />;
}

const float = keyframes`
  from {
    transform: translateY(10px);
  }
  to {
    transform: translateY(-10px);
  }
`;

const FloatingCircle = styled.div`
  animation: ${float} 1000ms infinite alternate ease-in-out;
`;

The keyframes function is called using tagged template literals, just like the styled helper functions.

To apply our animation, we interpolate it within the styles for a specific component.

This is a good thing! While it might seem like this is a pointless bit of added friction, it comes with a terrific advantage: it removes the possibility for naming conflicts.

In vanilla CSS, @keyframes definitions are global. If we create a keyframe animation called fadeIn, any component anywhere in our application can use this animation. If another developer on our team also decides to name their animation fadeIn, one of the animations will overwrite the other.

In styled-components, each animation is given a unique, random name, just like the component classes! Under the hood, this float animation might actually be named exvRVV or BozTiK.

Beyond this one difference, keyframe animations created in styled-components function exactly like @keyframes statements written in vanilla CSS.

Learn more in the styled-components documentation
.


---

## Exercises

Source: /css-for-js/08-animations/07-exercises

Exercises
Pop-up Help Circle

Update the code below so that the help circle slides in from the bottom, after a short delay:

Specific requirements are mentioned in the code comments:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<!--
Acceptance criteria:

• Should have a 1000ms delay
• Should animate over 500ms
• Should have 32px of spacing from the
  bottom-right corner
-->

<style>

</style>

<button class="help-circle">
  <img
    alt=""
    src="https://courses.joshwcomeau.com/cfj-mats/help-white.svg"
  />
  <span class="visually-hidden">
    Access help center
  </span>
</button>
Result
Refresh results pane

Solution:

Solution code
(success)

 Show more
Waving hand

Update the "waving hand" emoji below so that it actually waves at the user:

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

## Animation Performance

Source: /css-for-js/08-animations/08-animation-performance

Animation Performance

As JS developers, we focus quite a bit on performance. Which is good! Performance is important.

It's also really important when it comes to our animations. Sluggish animations can ruin an otherwise good user experience.

The tolerances are also really tight. In order for our brain to perceive motion as fluid and believable, it needs to run at 60 frames per second: this leaves us with only ~16 milliseconds to update each frame!

If our animation is too computationally expensive, it'll appear janky and choppy. The device just can't keep up, and the framerate drops.

Experience this for yourself by tweaking the "Frames per second" control:

TIMELINE
FPS
Run animation

In practice, poor performance will often take the form of variable framerates, so this isn't a perfect simulation.

Animation performance is a surprisingly deep and interesting area, well beyond the scope of this course. But let's cover the absolutely-critical, need-to-know bits.

The pixel pipeline

If we want to update the colors of the pixels on our screen, there's a pipeline of possible steps:

Recalculating style — first, we need to figure out which CSS declarations apply to which elements.
Layout — next, we need to figure out where each element sits on the page.
Paint — once we know where everything is, we can start painting them. This is the process of figuring out which color every pixel should be (“rasterization”), and filling it in.
Compositing — Finally, we can transform previously-painted elements.

What the heck is “compositing”?
(info)

The 4th step in our pixel pipeline is the most confusing. What the heck is it?! And how is it different from painting?

Compositing lets the browser re-use the work done in previous frames.

It was invented to help with scroll performance. In the early days of the web, the entire page had to be repainted on every frame when the user scrolled. This was slow and miserable, so the smart folks who work on browsers found a way to skip the paint process, and instead slide the page's content up or down when the user scrolls.

Compositing is lightning-quick because it doesn't have to do many calculations. It's all about transforming the stuff it has already calculated (sliding it around, rotating it, etc).

Different CSS properties will trigger different steps in the pixel pipeline. If we animate an element's height, we'll need to recalculate the layout, since an item shrinking might mean that its siblings scoot up to fill the space.

For this reason, it's best to try and avoid animating any properties that affect layout: this is things like width, height, padding, margin.

Properties like background-color will never affect layout, because there aren't any colors that change an element's position on the page. So it'll be faster than animating a property that does affect layout.

The transform property, however, is special: it can animate a property without even triggering a paint step! Like with scrolling, it can reuse the work done on previous steps.

There are only two properties that can be animated with compositing alone: transform and opacity. In Chrome, filter can also be composited, and they're working on supporting more properties
, like clip-path and background-color.

Does that mean that you can only ever animate transform and opacity? Personally, I think we can be a little bit more flexible than that. Not all repaints / layout-recalculations are created equal! For example, tweaking the height of an absolutely-positioned element tends to be quicker, since there's no chance that it will cause siblings to be shifted.

The best thing you can do is to test your animations on a very low-end device, like the low-end smartphones discussed in Module 5. If you're satisfied with the performance on a low-end device, ship it!

Hardware Acceleration

Depending on your browser and OS, you may occasionally notice a curious flicker on certain animations:

Pay close attention to the letters. Notice how they appear to glitch slightly at the start and end of the transition, as if everything was locking into place?

This happens because of a hand-off between the computer's CPU and GPU. Let me explain.

When we animate an element using transform and opacity, the browser will sometimes try to optimize this animation. Instead of rasterizing the pixels on every frame, it transfers everything to the GPU as a texture. GPUs are very good at doing these kinds of texture-based transformations, and as a result, we get a very slick, very performant animation. This is known as “hardware acceleration”.

Here's the problem: GPUs and CPUs render things slightly differently. When the CPU hands it to the GPU, and vice versa, you get a snap of things shifting slightly.

We can fix this problem by adding the following CSS property:

.btn {
  will-change: transform;
}

will-change is a property that allows us to hint to the browser that we're going to animate the selected element, and that it should optimize for this case.

In practice, what this means is that the browser will let the GPU handle this element all the time. No more handing-off between CPU and GPU, no more telltale “snapping into place”.

will-change lets us be intentional about which elements should be hardware-accelerated. Browsers have their own inscrutable logic around this stuff, and I'd rather not leave it up to chance.

Alternative properties
(info)

Hardware acceleration has been around for a long time—longer than the will-change property, in fact!

For a long time, it was accomplished by using a 3D transform, like transform: translateZ(0px). Even with a 0px value, the browser still hands it off to the GPU, since moving in 3D space is definitely a GPU strength. There's also backface-visibility: hidden.

When will-change came out, it was intended to give developers a proper, semantically-meaningful way to hint to the browser that an element should be optimized. It’s intended to be a bit of a black box; browsers are free to decide how to implement this property, to make whatever optimizations they see fit.

Happily, it seems as though all of these issues have been resolved. I've done some testing, and have found that most of the time, I get the best results across modern browsers with will-change. That said, every now and then I run into a situation where transform: translateZ(0px) still works a bit better, so if you’re running into performance problems or any weird visual artifacts, it’s worth having this other method in your back pocket.

There's another benefit to hardware acceleration: we can take advantage of sub-pixel rendering.

Check out these two boxes. They shift down when you hover/focus them. One of them is hardware-accelerated, and the other one isn't.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

It's maybe a bit subtle, depending on your device and your display, but one box moves much more smoothly than the other.

Properties like margin-top can't sub-pixel-render, which means they need to round to the nearest pixel, creating a stepped, janky effect. transform, meanwhile, can smoothly shift between pixels.

It isn't clear to me if this legitimately uses subpixels (the R/G/B pixel fragments we discussed in Module 6), or if it uses anti-alias trickery. Either way, though, the effect is consistently smoother, on both retina and non-retina displays.

Tradeoffs
(warning)

Nothing in life comes free, and hardware acceleration is no exception.

By delegating an element's rendering to the GPU, it'll consume more video memory, a resource that can be limited, especially on lower-end mobile devices.

This isn't as big a deal as it used to be — I've done some testing on a Xiaomi Redmi 7A, a popular budget smartphone in India, and it seems to hold up just fine. Just don't broadly apply will-change to elements that won't move. Be intentional about where you use it.

If you're interested in learning more about animation performance, I gave a talk on this subject at React Rally. It goes deep into this topic:


---

## Designing Animations

Source: /css-for-js/08-animations/09-animation-design

Designing Animations

As developers, our job is generally focused on implementation; a product/design team gives us designs, and we bring them to life.

In my experience, however, most teams don't have a motion designer on them. And the standard design tools—things like Figma, Sketch, Illustrator—don't really support animations.
*

This is really unfortunate, because animation is a critical part of the user experience, and it's hard to get right. We've all had the experience of being annoyed by an aggressive or out-of-place animation.

This course isn't about motion design, so we won't go too deep, but I wanted to provide some high-level tips to make it easier to design animations.

Types of animation

In her amazing book “Animation At Work”
, author Rachel Nabors describes 5 common categories of animation:

Transitions change the content on the page in a significant way, like moving from one page to another, a modal opening or closing, or a multi-step wizard moving to the next step.
Supplements add or remove information from the page, without changing their "location" or task. For example, a notification might pop up in the corner.
Feedback helps the user understand how the application has responded to user input. For example, an error message appearing when submitting a form, or a button sliding down on click to indicate that it's being depressed.
Demonstrations are used for education, a way of showing the user how something works. Many of the animations on this platform, like the visualizations in the “Rules of Margin Collapse” lesson, fit into this category.
Decorations are aesthetic and don't affect the information on the page. For example, confetti to celebrate a piece of good news being delivered to the user.

Of these categories, decorations are often dismissed as frivolous. And they certainly can be! But I'm of the view that each of these categories is valid and valuable. The important thing is that you understand why you're adding animation: which of these categories does it fit into? How does it help the user?

Every animation we add should have a purpose behind it. We shouldn't add animation just to be fancy. Animation can make a product feel more polished, but only when it's thoughtful, and it's clear to the user why it exists.

Realism
(info)

Earlier, we talked about how things in the natural world don't teleport, and how animation can make our products feel more "real" by simulating how things move in reality. How does this fit in with the categories?

I'd say that "realism" animations are a subset of #3, feedback. They show the user how the application responds to input, whether that's clicking, hovering, scrolling…

Animation duration

When creating animations in CSS, we need to specify a duration in milliseconds. So how long should they be?

Let's do some experimentation to figure that out. Play with different durations for the following animation:

OPEN MODAL
Dismiss Modal
Hello World

This is a modal!

Transition Duration
100ms

If we pick a very-quick value (say, around 200ms), the motion is disorienting. Too much is happening too fast.

If we pick a very-slow value, though, it feels like it takes too long. Imagine if this is something the user has to do 10 times a day; how long do you think it'll take for this animation to become annoying?

In this example, I think 500ms is a decent compromise.

Let's try another example:

I'm a button!
Transition Speed
100ms

In this example, the motion is much more subtle. We can get away with much quicker values; I'd probably pick a value around 200ms.

The generally-acceptable range of durations is from 200ms to 500ms. There are definitely exceptions, but I'd say that 80%+ of my animations fit within that range.

Adaptive animations
(info)

Sometimes, I'll have a wonderful idea for a whimsical animation, something that delights the user the first time they see it.

For example, years ago I created a generative art machine. Here's the loading animation:

I want users to see this animation, so I break a cardinal rule: this spinner will show for at least 4 seconds, even if the content loads quicker! 😱

But here's the thing: after they've seen it a couple times, the behaviour changes. I disable the 4-second minimum, and the content loads the instant it's ready.

This trick is done all the time in video games! The first time you fight the boss, you're treated to a dazzling 10-second cutscene. On subsequent attempts, it skips right to the action.

How do we update our animations to change depending on how often they've been seen? We'll need to use some JavaScript and localStorage. Here's an example, using React:

 Show more
Additional reading

We've only scratched the surface of animation and motion design!

Here are some resources to keep going, if you're interested in this subject:

Animation At Work
 by Rachel Nabors. It's an incredibly helpful resource for understanding the "why" around animation.
Improving the Payment Experience With Animations
, a fantastic article written by Stripe designer Michaël Villar about the Stripe Checkout animations.

---

## Action-Driven Animation

Source: /css-for-js/08-animations/10-action-driven-animation

Action-Driven Animation

When most of us think about animations, we think in terms of states: The modal is either open (opacity: 1) or closed (opacity: 0). We use CSS transitions to animate the changes in state.

The trouble with this way of thinking is that it doesn't distinguish between actions. The transition for opening the modal is the same as it would be when closing the modal, since both actions are transitioning between the same 2 states. But is that really ideal?

Here's the modal demo we saw earlier, but with some new controls. Try playing with different settings for enter and exit transitions:

OPEN MODAL
Dismiss Modal
Hello World

This is a modal!

Enter Duration
500ms
Enter Timing Function
linear
ease
ease-in
ease-out
ease-in-out
ease
Exit Duration
500ms
Exit Timing Function
linear
ease
ease-in
ease-out
ease-in-out
ease

My preferred settings
(info)

There are no right/wrong answers for which values to pick, but I do have a personal preference.

After you've experimented with the options, expand to show which values I picked and why:

 Show more

How do we create transitions based on actions? Unfortunately, it's not always so straightforward.

If the animation is based on a pseudo-selector like :hover, we can do it by using different transition values:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

When the mouse is resting atop the element, the :hover declarations apply, and so the enter animation will be given transition: transform 150ms. The moment the mouse leaves the element, though, it falls back to the default transition: transform 500ms, and uses that transition for the exit animation.

Quick vs. slow values
(info)

In the modal example earlier, the enter animation was a typical speed, and the exit animation was much quicker.

In this button example, though, it's switched: the enter animation is quick, and the exit animation is slow.

Why is that?

 Show more

So we've seen how to set custom transitions based on CSS pseudo-selectors like :hover. But how do we do this in other situations? Like the modal example?

We'll need to use JavaScript to change the duration dynamically. Here's an example using React:

const ENTER_DURATION = '500ms';
const EXIT_DURATION = '250ms';
const ENTER_EASE = 'ease-out';
const EXIT_EASE = 'ease-in';

function Modal({ isOpen, children }) {
  return (
    <Wrapper
      style={{
        '--transition-duration': isOpen
          ? ENTER_DURATION
          : EXIT_DURATION,
        '--timing-function': isOpen
          ? ENTER_EASE
          : EXIT_EASE,
      }}
    >
      <DialogContent>
        {children}
      </DialogContent>
    </Wrapper>
  )
}

const Wrapper = styled(DialogOverlay)`
  transition:
    transform var(--transition-duration) var(--timing-function);
`;

This is a quick sketch that leaves out lots of detail — you can also check out a full, live example.

To learn more about action-driven animation, I highly recommend checking out Tobias Ahlin's blog post on the subject, Meaningful Motion with Action-Driven Animation
. It includes a ton of examples of action-driven animation.

Exercises
Pushable button

Let's suppose we want to build a 3D "pushable" button:

Click Me

When I see this effect implemented online, I typically see people use borders or box-shadows. These implementations are fine for static buttons, but if we want to animate it, we'll have a much smoother effect if we stick with transforms.

Instead, we'll separate the button into 2 layers: a light-colored front, and a dark-colored back. The front layer will move up and down.

Here's how this works:

Push Me
Reveal
0

Below, we've implemented the broad strokes of this effect, but with no transitions! Update the code so that there are distinct, action-based animations for the following 3 actions:

Hovering
Clicking
Leaving (moving the mouse away from the button)

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

If you're interested in going deeper with this 3D button concept, check out my blog post, “Building a Magical 3D Button”
. In addition to what we've already covered, we see how to add a shadow, how to simulate a springy effect with custom Bézier curves, and more!


---

## Orchestration

Source: /css-for-js/08-animations/11-orchestration

Orchestration

In the last lesson, we saw how we can improve a modal animation by differentiating between enter and exit actions.

We can improve that animation even more by sequencing it.

Take another look at this animation:

OPEN MODAL
Dismiss Modal
Hello World

This is a modal!

Enter Duration
500ms
Enter Timing Function
linear
ease
ease-in
ease-out
ease-in-out
ease-out
Exit Duration
250ms
Exit Timing Function
linear
ease
ease-in
ease-out
ease-in-out
ease-in

It looks OK, but it feels a bit mechanical, a bit stilted. We can vastly improve this animation by orchestrating the different elements:

Instead of everything happening all at once, the individual elements are staggered:

The backdrop starts fading in right away, and lasts a long time (1000ms).
The modal waits for 250ms, and then slides in over 400ms
The close button is now hidden by default, and is given its own unique transition. It starts animating after 600ms, and lasts 250ms.

We can visualize this on a timeline, showing when each element starts and finishes. Here's the enter animation:

And here's the sequence for the exit animation:

It may seem like overkill, but this level of attention-to-detail is key for creating next-level animations. This is the secret sauce.

Companies like Apple understand this. Their animations have so many little orchestrated details. As an example, here's what happens when you focus the search bar on apple.com
:

Here's a list of the details I've spotted:

A backdrop fades in
The header navigation fades out, staggering outwards from the icon that was clicked
A dropdown fades in
The dropdown items slide in, separately, once the dropdown is visible
The search input and close button slide in, above the dropdown
Implementing orchestration

So, how do we take advantage of orchestration? With a lot of ternaries. 😬

Here's a high-level sketch of our sequenced modal animation, using React:

function Modal({ isOpen, handleDismiss, children }) {
  return (
    <Wrapper>
      <Backdrop
        style={{
          opacity: isOpen ? 0.75 : 0,
          transition: 'opacity',
          transitionDuration: isOpen
            ? '1000ms'
            : '500ms',
          transitionDelay: isOpen
            ? '0ms'
            : '100ms',
          transitionTimingFunction: isOpen
            ? 'ease-out'
            : 'ease-in',
        }}
        onClick={handleDismiss}
      />
      <DialogContent
        style={{
          transform: isOpen
            ? 'translateY(0vh)'
            : 'translateY(100vh)',
          transition: 'transform',
          transitionDuration: isOpen
            ? '400ms'
            : '250ms',
          transitionDelay: isOpen
            ? '250ms'
            : '0ms',
          transitionTimingFunction: isOpen
            ? 'ease-out'
            : 'ease-in',
        }}
      >
        <ButtonWrapper>
          <CloseButton
            onClick={handleDismiss}
            style={{
              opacity: isOpen ? 1 : 0,
              transform: isOpen
                ? 'translateY(0)'
                : 'translateY(25%)',
              transition: 'opacity, transform',
              transitionDuration: '250ms',
              transitionDelay: isOpen ? '600ms' : '0ms',
            }}
          />
        </ButtonWrapper>
        {children}
      </DialogContent>
    </Wrapper>
  )
}

Because we want separate enter/exit animations, we need to set different values for a bunch of stuff based on whether isOpen is set to true.

There's no denying it: this stuff can get messy. When I have this many properties, I like to tuck them into a helper function, so that the animation settings don't get in the way of understanding the overall structure / business logic:

function Modal({ isOpen, handleDismiss, children }) {
  const {
    backdropStyles,
    modalStyles,
    closeButtonStyles
  } = getTransitionStyles(isOpen);

  return (
    <Wrapper>
      <Backdrop
        style={{
          opacity: isOpen ? 0.75 : 0,
          ...backdropStyles,
        }}
        onClick={handleDismiss}
      />
      <DialogContent
        style={{
          transform: isOpen
            ? 'translateY(0vh)'
            : 'translateY(100vh)',
          ...modalStyles,
        }}
      >
        <ButtonWrapper>
          <CloseButton
            onClick={handleDismiss}
            style={{
              opacity: isOpen ? 1 : 0,
              transform: isOpen
                ? 'translateY(0)'
                : 'translateY(25%)',
              ...closeButtonStyles,
            }}
          />
        </ButtonWrapper>
        {children}
      </DialogContent>
    </Wrapper>
  );
}

function getTransitionStyles(isOpen) {
  /* Return 3 objects, one for each animated element */
}

I've omitted the contents of that getTransitionStyles function for brevity. View the complete, live demo.

It's beyond the scope of this course, but animation libraries like React Spring
 and GSAP
 can also make it easier to coordinate multiple moving elements.

The transitionEnd event
(info)

Another way to manage orchestration is to use the transitionEnd event.

We can bind event listeners to it like any other event:

element.addEventListener('onTransitionEnd', () => {
  // Whenever a transition completes on the target element,
  // this function will be called.
});

Instead of fiddling with delays, we instruct one animation to start the moment another one ends. This can clean up our code, and make it easier to reason about the relationship between elements.

The drawback is that it's less flexible. I don't always want to wait for one element to stop moving before another one starts! In the example above, our modal starts sliding up while the backdrop is still fading in. There's no way to do this with transitionEnd.

If you're interested in developing your animation skillset, it's worth having this tool in your toolbelt, but it certainly can't replace transition delays.


---

## Accessibility

Source: /css-for-js/08-animations/12-accessibility

Accessibility

Animations are an important part of the user experience, but not everyone experiences them the same way. For some folks, certain kinds of motion can trigger physical symptoms like nausea, dizziness, and malaise.

Modern operating systems offer a remedy for this: users can opt out of animations. The setting is meant primarily for the OS, but websites and web applications can now access that value and use it in our CSS and JS.

It's our job to check and respect that value. In this lesson, we'll learn how.

Vestibular disorders

The human body is comprised of many different systems responsible for regulating and managing this whole being-alive thing. One of those systems is called the vestibular system. It includes the inner ear and parts of the brain, and it manages our sense of balance.

You know when you spin really fast and it makes you dizzy? By spinning, you're sloshing fluid around in your inner ear, and the brain uses that fluid to help it figure out which direction is “up”.

When you spin around in circles, your brain receives incompatible information from different sources: your ear-fluid is claiming one thing, while your eyes are claiming another. This dissonance is super disorienting and unpleasant.

For most people, unless you're intentionally trying to confuse this system, it works properly, and you can move through your life trusting that it will keep you upright. But for others, this system is not always trustworthy—a vestibular disorder causes the vestibular system to feed the brain bad information.

The most commonly-known symptom of this is vertigo; all of a sudden, someone will feel like gravity is pulling them in the wrong direction. This is just one way that vestibular disorders can manifest.

Troublingly, animations can be a trigger for some folks, leading to a whole range of unpleasant side-effects: vertigo, dizziness, nausea, headaches, malaise. It can feel as if our website is reaching out and spinning the person in their office chair. 😬

It is estimated that up to 35% of adults 40+ in the US have experienced some form of vestibular dysfunction, with 5% reporting chronic problems (source
).

We shouldn't forget about these people when developing animations.

Opting out of animations

For a few years now, operating systems have been letting users request a motion-free experience, typically within the Accessibility settings:

Happily, this setting now exists in all mainstream operating systems, including desktop (macOS 10.12+, Windows 7+, Linux) and mobile (iOS, Android 9+). You can google "reduce animations [operating system]" to find the specific instructions for your device.

Originally, this setting was used exclusively by the operating system; when the box was ticked, macOS would disable motion-heavy animations, like the "genie" animation when minimizing/maximizing windows.

Apple added a media query that Safari could use to hook into this setting: prefers-reduced-motion. In the years since, other browsers and operating systems have followed suit. Today, browser support is very good
.

What about for folks using Internet Explorer, or a really old version of their operating system? We'll structure things in a way so that if the feature is unsupported, animations will be disabled by default.

Accessing in CSS

To tell if they've requested reduced motion, we can use a media query:

.fancy-box {
  width: 100px;
  height: 100px;
  transform: scale(1);
  transition: transform 300ms;
}

.fancy-box:hover {
  transform: scale(1.2);
}

@media (prefers-reduced-motion: reduce) {
  .fancy-box {
    transition: none;
  }
}

If they've ticked the "reduce animations" checkbox, prefers-reduced-motion will be set to reduce. The CSS rules in that media query will apply, disabling the transition on our .fancy-box selector.

In this case, we're starting from a place of animations being enabled, and explicitly disabling them based on a media query. A better mental model is to think in terms of the reverse: start without animations, and enable them if the user wishes:

.fancy-box {
  width: 100px;
  height: 100px;
  transform: scale(1);
  /* No more `transition` here! */
}

.fancy-box:hover {
  transform: scale(1.2);
}

@media (prefers-reduced-motion: no-preference) {
  .fancy-box {
    transition: transform 300ms;
  }
}

To be clear, no-preference is the default value. If a user has never fiddled with their accessibility settings, prefers-reduced-motion will be set to no-preference.

By switching it up so that the transition is set from within a media query, we ensure that the animation is disabled by default for users on browsers/devices that don't support this property. Browsers ignore CSS inside unrecognized media queries, so it's as if this transition doesn't exist for them.

Globally unsetting animations
(warning)

You might be wondering: why do this on a case-by-case basis? Can't we disable all animations globally for folks who opt out of animations?

I have seen some folks sharing a snippet that aims to do this:

@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

This works by reducing all animations to be essentially instantaneous, and using !important to ensure that this value overwrites everything else. 0.01ms is chosen instead of 0ms because some older browsers consider 0 milliseconds a falsy/null value.

I don't recommend this approach, for a few reasons:

It won't help folks using older browsers/operating systems, since animations will be enabled by default if the prefers-reduced-motion media query isn't supported.
This approach can actually backfire and cause rapid, dizzying motion if certain JS animation libraries (eg. React Spring) are used.
We don't necessarily want to disable all animations. More on this below.

The best thing to do is to periodically test our products with the "prefers-reduced-motion" setting enabled, to make sure that everything is working as intended.

Accessing in JavaScript

The media query shown above works great for animations that take place entirely from within CSS (eg. transitions, keyframe animations). However, there are many types of animations that cannot be done entirely through CSS:

Animations using spring physics.
Animations involving the cursor coordinates, scroll position, or other “environment” factors.
*
HTML5 Canvas animations.
Certain kinds of SVG animations.

Fortunately, we can access the value of the media query from within JS. Here's a snippet:

function getPrefersReducedMotion() {
  const mediaQueryList = window.matchMedia(
    '(prefers-reduced-motion: no-preference)'
  );

  const prefersReducedMotion = !mediaQueryList.matches;

  return prefersReducedMotion;
}

This function will return true if the user prefers reduced motion (has ticked the "reduce motion" checkbox), or they're using an older browser and we don't know what their true preference is. If it returns false, it means the user has no preference, and we should enable our animations.

We can also use event listeners to update this value when it changes:

const mediaQueryList =
  window.matchMedia('(prefers-reduced-motion: no-preference)');

let prefersReducedMotion = getPrefersReducedMotion();

// Update the variable whenever the value changes:
mediaQueryList.addEventListener('change', () => {
  prefersReducedMotion = getPrefersReducedMotion();
});

This listener will fire when the user toggles the "Reduce motion" checkbox in their operating system.

We want to listen for this event, because we want to immediately terminate animations if the user toggles the box, even if the page has already loaded / the animation is in progress.

Accessing in React

If you want to use this value in your React applications, you can create a custom hook based on this JS logic.

There are some caveats, especially around server-side rendering. I wrote a blog post on this topic, “Accessible Animations in React”
. Check it out if you're a React developer!

Motion vs. Animation

Not all animations involve motion. For example, we might fade something in, or change an element's text color. Nothing "moves" in those animations.

I've read through interviews with folks with vestibular disorders, and the most common triggers tend to be pretty elaborate movement: for example, a multi-layered parallax animation, or a page-wide transition. Big sweeping movements.

Should we disable all animations? Or only the ones with significant motion?

I am not enough of an expert to be able to provide a definitive answer, but I can share how I think about it.

If an element moves more than a few pixels, I'll disable it using the techniques discussed in this lesson. And if an element's opacity changes in a way that can suggest motion (eg. a staggered fade between multiple elements), I'll disable that as well. But I don't disable color changes, or small bits of fading-in-and-out. And if an element only moves a few pixels (eg. a button on hover), I might keep that in as well.

Intuit has an interesting approach to this problem: they switch animations to "light-weight" alternatives. Here's an example:

How much motion is acceptable? It's a difficult question to answer, because everyone's different. From the research I've done, small bits of motion like this don't seem to bother most people with vestibular issues. But I personally prefer to err on the side of caution; I'd rather disable too many animations than too few.

In-app settings?
(info)

Some applications, like Duolingo and Discord, have a specific user setting to disable animation.

While this might feel redundant in a world with widely-supported "prefers reduced motion", there is a good argument for keeping a user setting.

This allows us to create 3 different groups:

The standard experience: full animations.
Folks who have ticked "reduce motion" in the OS: the most problematic animations are removed, or switched to lighter alternatives.
Folks who disable animations in the in-app settings: no animations at all.

This is a significant maintenance overhead, and probably not worth it for most applications. But if you want to build a world-class user experience, this is the sort of small detail that can go a long way.

Exercises
Help Circle

Update the “Help Circle” animation from earlier so that it doesn't animate for users who have enabled the "reduced motion" setting.

Be sure to test this by toggling the setting in your own OS!

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

## 3D Transforms

Source: /css-for-js/08-animations/13-3d-transforms

3D Transforms

So far, we've been thinking primarily in two dimensions: we've been moving stuff left-to-right and top-to-bottom.

CSS comes with a surprisingly robust 3D engine, one that we can leverage to do all kinds of fancy stuff.

For example, here's how we can rotate an element in 3D space:

transform: rotateX(0deg);
Angle
0deg
Axis
x
y
z

Let's explore how this 3D environment works.

Isometric vs. perspective

Remember “Where's Waldo?”, the puzzle game where you had to find a red-striped thrill-seeker on a mission to find the world's most chaotic environments?

There's something a bit curious about these puzzles: there's no perspective.
*

In real life, things that are further away appear smaller to us. A smartphone held a few inches from our face will appear larger than a TV across the room.

If this “Where's Waldo?” puzzle was a photograph, the people near the top should appear much smaller than the people at the bottom. But they're all drawn to the same scale.

This is known as isometric projection. Artists use this to achieve a certain effect. Another example is popular pixel artist Eboy
:

By contrast, perspective projection mimics how things appear in real life, where things vanish into the distance:

Source

By default, the 3D engine in CSS will assume that we want to use isometric projection. Everything will be the same size, no matter how far away it is. We can switch to a perspective projection using the perspective CSS property:

Enable Perspective
true
false

When we switch to perspective projection, things suddenly appear "3D". When an element moves away from the user, it gets smaller. When it rotates along the X or Y axis, we can tell which edge is closer to us, and which edge is further away.

In order to switch to perspective projection, we also need to pass it a length value:

perspective: 250px;

The value we pass to perspective can be thought of as a measure of how close the user is to the screen.

If the user is right next to the screen, small changes in position will appear huge. Imagine spinning a card that's only a few inches from your face.

If the user is further away, though, that same motion will appear smaller and more subtle.

We can choose a perspective value based on how attention-grabbing we want our animation to be:

perspective: 250px;
Perspective
250px

Pixels?
(info)

It's a bit weird to use pixels for perspective, isn't it? What does it mean for the user to be 500 pixels away from the screen, exactly?

Interestingly, CSS does have units for both inches and centimeters. This is totally valid CSS:

.box-wrapper {
  perspective: 20cm;
}

The trouble is that the browser doesn't actually have enough information for this to be trustworthy / accurate. 1cm is equivalent to 38px, on all devices, no matter the pixel density or screen size.
*

As weird as it is, pixels is the right choice. Experiment with different values until you find one that feels right, based on the effect you're going for!

Applying perspective

There are two different ways to apply perspective. The first is with the perspective CSS property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Note that the perspective property needs to be set on the parent element. It's kind of like display: grid; we set perspective to control how the children will be presented.

The cool thing about the perspective property is that it groups the children into the same environment. Our 3 cards above are each rendered a little differently, based on their position within the box.

Essentially, the box's position within the perspective-parent will control what angle we see it at. We can see this by moving a rotated box — try moving your mouse around in the “Result” pane:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

(You can also view a keyboard-friendly version of this demo!)

The perspective function

In addition to the perspective property, there is also a perspective() transform function:

.box {
  transform: perspective(250px) rotateX(45deg);
}

Unlike the perspective property, the perspective() function will give each transformed element its own little environment.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

I tend to prefer using the perspective property, since I generally want my siblings to share an environment, for a more realistic effect.


---

## Rendering Contexts

Source: /css-for-js/08-animations/14-3d-rendering-contexts

Rendering Contexts

So far, we've seen how to make something appear 3D, with the perspective property.

Here's an example of how this property can be used, alongside 3D transforms, to build “tilting” cards. Hover/focus the cards to see them tilt:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    perspective: 500px;
  }
  .card-link {
    display: block;
    transform-origin: top center;
    will-change: transform;
    transform: rotateX(0deg);
    transition: transform 750ms;
  }
  .card-link:hover,
  .card-link:focus {
    transform: rotateX(-35deg);
    transition: transform 250ms;
  }
</style>

<div class="wrapper">
  <a href="/" class="card-link">
    <article class="card">
      <img
        src="https://courses.joshwcomeau.com/images/logos/chrome.svg"
      />
    </article>
  </a>
  <a href="/" class="card-link">
    <article class="card">
      <img
        src="https://courses.joshwcomeau.com/images/logos/firefox.svg"
      />
    </article>
  </a>
  <a href="/" class="card-link">
    <article class="card">
      <img
Result
Refresh results pane

This demo combines a bunch of stuff we've been learning through this module:

On hover/focus, each card is rotating by -35 degrees along the X axis. We're animating the effect using the “transition” property.
We want the cards to pivot along their top edge, and so we've set the “transform-origin” to change the element's origin.
We want all cards to share the same perspective projection, and so we set perspective: 500px on the shared .wrapper parent. Cards on the left and right sides will tilt towards the center.

There are a number of problems with this demo, however.

You might've noticed the biggest issue: cards on the right tilt in front of their siblings:

Why does this happen? Well, we're rotating the cards in 3D space, but they're still being stacked according to the stacking context stuff we learned in Module 2. Specifically, because we haven't used z-index, the stacking order is determined by DOM order; the 5th card sits in front of the 4th, the 4th in front of the 3rd, etc.

So, hm. We could solve this by manually tweaking the z-index on each card, so that the middle card is in front… Maybe something like this?

This could work, but there's a better option.

Introducing the transform-style property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Glitchy on Firefox
(info)

If you're using Firefox, you might notice that the hover event triggers inconsistently. It's not very pleasant!

We'll address this issue in the next lesson, Gotchas

Much better!

When we set transform-style: preserve-3d, we opt into a different stacking algorithm. Instead of being based purely on stacking contexts and z-index layers, we position the elements in 3D space!

With transform-style: preserve-3d, the z-index property can still be used to set the default position, but the moment we start tilting or moving an item in 3D space, that takes precedence.

This is a big deal. It essentially gives us a legit 3D engine to work with in CSS! We can do things that aren't otherwise possible with z-index:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In this example, a yellow circle is moving forwards and backwards in 3D space. A red rectangle has been tilted backwards, so that the circle will intersect it at an angle.

Here's the same animation, but rotated so that we can see what's going on more clearly:

Pretty cool, right?

3D rendering contexts

When we apply transform-style: preserve-3d, we create a 3D rendering context.

It's a bit like how certain CSS properties like position: fixed create a stacking context. With transform-style: preserve-3d, we allow the element's children to be repositioned in 3D space. When one element moves closer, it'll be painted above its siblings in the 3D rendering context.

I feel like it's really easy to get perspective and transform-style mixed up, but they accomplish different goals:

perspective is all about the visuals of how items are presented. By default, CSS uses orthographic projection, like that “Where's Waldo?” drawing, but we can flip to perspective projection with the perspective attribute.
transform-style creates a 3D rendering context, which allows items to be moved around in 3D space, changing which elements show up “in front”, and allowing elements to intersect.

We've already seen what happens when we set perspective without setting transform-style: elements will appear to rotate and move in 3D space, but it's a purely visual effect. The layering / paint order is still determined by things like z-index and DOM order.

And if we set transform-style without setting perspective, elements can move in 3D space, but they still appear flat:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Unfortunately, there are quite a few gotchas with 3D rendering contexts, and 3D transforms in general. We'll discuss them in the next lesson.


---

## Gotchas

Source: /css-for-js/08-animations/15-gotchas

Gotchas

When working with 3D transforms, there are lots of speed bumps we have to watch out for. This lesson will dig into some of the problems I've run into. We'll also learn more about how 3D rendering contexts work!

Applying perspective to descendants

In the “flip cards” demo, you might've noticed that we can trigger a “doom flicker” depending on where we hover:

Why does this happen? Well, when we hover over the card, we cause it to rotate. If our cursor is near the bottom of the card, this means that it'll rotate away from the cursor, which means that it'll no longer be hovered. And so the element keeps flickering between the hover and non-hover states.

This is the same problem we saw when we talked about doom flickers with 2D transitions. And we can solve it using the same strategy: we should apply the transform to a child, so that the element listening for :hover doesn't move.

For whatever reason, this effect is even worse in Firefox, causing the hover event to trigger sporadically and inconsistently.

Essentially, then, we need:

A shared parent that sets perspective
A wrapper over each individual card that listens for hover/focus
A child that applies the transition when its wrapper is hovered/focus

Here's my first shot at setting this up:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  /* 1. Shared parent */
  .wrapper {
    perspective: 500px;
    transform-style: preserve-3d;
  }

  /* 2. Individual card wrapper */
  .card-link {
    display: block;
  }

  /* 3. Child to be transformed: */
  .card {
    transform-origin: top center;
    will-change: transform;
    transform: rotateX(0deg);
    transition: transform 750ms;
  }

  /*
    Apply the transforms to the child
    when we hover/focus the wrapper:
  */
  .card-link:hover .card,
  .card-link:focus .card {
    transform: rotateX(-35deg);
    transition: transform 250ms;
  }
</style>

<div class="wrapper">
  <a href="/" class="card-link">
    <article class="card">
      <img
        src="https://courses.joshwcomeau.com/images/logos/chrome.svg"
Result
Refresh results pane

With these changes, you should see something like this:

So, the good news is that there's no more doom flicker… the bad news is that we seem to have broken the perspective projection! It doesn't appear to be rotating in 3D anymore.

Here's the problem: the transform-style property is not inheritable. It creates a 3D rendering context, but only direct children can participate in this context by default.

In the previous demo, this wasn't a problem, since there was a direct parent-child relationship:

<div class="wrapper"> <!-- Creates a 3D rendering context -->
  <a class="card-link"></a> <!-- Applies a 3D transform -->
</div>

Now, though, the transformed element is a grandchild of the .wrapper that creates the 3D rendering context:

<div class="wrapper"> <!-- Creates a 3D rendering context -->
  <a class="card-link"> <!-- Listens for hover/focus -->
    <article class="card"></article> <!-- Applies a 3D transform -->
  </a>
</div>

The really frustrating thing about this is that it recently changed. Until 2021, this demo would have worked fine in all browsers except Firefox. It turns out that Firefox was the only one actually following the spec, however, and so even though it's way less convenient, this is actually the correct behaviour.

So how do we fix it? We need to apply transform-style: preserve-3d to the middle layer, .card-link:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This was bewildering to me at first, but I've figured out what's going on here. Let's unpack it.

By default, transform-style: preserve-3d creates a brand-new 3D rendering context. This is what's happening on .wrapper.

But! If a direct child also sets transform-style: preserve-3d, it doesn't create a new context, it forwards the context downwards, extending the 3D rendering context so that grandchildren can participate.

In other words, transform-style: preserve-3d acts as a sort of bridge, allowing descendants to participate in an ancestor's 3D rendering context. We can repeat this trick as many times as we wish; as long as each layer sets transform-style: preserve-3d, the 3D rendering context will be chained along.

What about perspective? This property isn't inheritable either, but fortunately, we don't have to worry about it. The perspective applies directly to the 3D rendering context. As long as our descendants have access to the 3D rendering context, the perspective will apply automatically.

If you find yourself running into this bug, and you're not sure how to fix it, I have a quick set of steps you can follow:

Locate the ancestor that creates the 3D rendering context (this will be the element that sets perspective).
Locate the descendant that applies a 3D transform (eg. transform: rotateX()).
Apply the following CSS declaration to each element between the two: transform-style: preserve-3d;. This will ensure that the 3D rendering context is passed through all the layers, and can be used by the transformed descendant.

The “inherit” keyword
(success)

Instead of setting transform-style: preserve-3d on the child, we can also use the special inherit keyword:

.wrapper {
  perspective: 500px;
  transform-style: preserve-3d;
}
.card-link {
  transform-style: inherit;
}

As we learned way back in Module 1, inherit copies the value for this property from its parent.

I like this approach, because it feels like it communicates my intent, semantically. The children aren't creating a brand-new 3D rendering context, they're inheriting the one created by their parent/ancestor!

To be clear, though, both approaches work exactly the same way. The inherit keyword copy/pastes the preserve-3d value.

Scrollburglars and broken rendering contexts

Alright, let's look at another issue from our original demo.

As we mouse over the final card, you may have noticed a scrollburglar sneak in:

Curiously, this only seems to happen on Chrome, and only on our original demo (moving the transforms to the grandchild appears to fix it?). I believe that this is likely a browser bug, but unfortunately, these sorts of bugs aren't so rare. I imagine it's tough to correctly identify when a 3D transform overflows!

Let's suppose we want to fix it. Maybe we can do this by clamping the overflow with overflow: hidden?

Well, let's see:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This fixes the scrollburglar, but it breaks the 3D rendering context:

It turns out that the element that creates the 3D rendering context (.wrapper, in this case) is a bit temperamental?. There are a whole bunch of CSS properties that, when applied to the same element, will disable the 3D rendering context.

The list includes:

overflow
clip-path
opacity
filter
mix-blend-mode

How do we fix it? We need to move these properties to a different element.

For example, to fix our scrollburglar, maybe we can add overflow: hidden to a new parent element:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Ana Tudor has an incredible blog post that documents all of these concerns, and includes workarounds:

Things to Watch Out for When Working with CSS 3D

Ultimately, it can take a bit of time to get comfortable with some of the limitations and edge-cases with 3D transforms in CSS, but once you get the hang of it, it unlocks a ton of incredible possibilities.

For example, a few years ago I recreated Windows 98's "file transfer" animation:

The "moon" that rotates around the earth slips neatly behind the planet because it's using transform-style: preserve-3d. No z-indexes needed to be juggled for this effect.

The code for this demo is beyond the scope of the course, but you can view its source on Github
.


---

## Ecosystem World Tour

Source: /css-for-js/08-animations/16-ecosystem-world-tour

Ecosystem World Tour

As we did in Module 3, this lesson takes a look at the modern landscape, this time with a focus on animation. We'll look at different libraries and APIs, with the goal of helping you understand what your options are, and how to get started with them.

Unfortunately, this list is a bit React-heavy, for the simple reason that it's what I know best. I'm not as familiar with other UI frameworks, and sadly many of the animation packages are often framework-specific.

As before, this is based on my personal experience and opinions. Plenty of very-smart people will likely disagree with me on certain aspects. This isn't meant to be either objective or definitive. My hope is that this can point you in the right direction, and you can do your own research and experimentation.

Also: this lesson is at the very end of this module for a reason: it's important to get comfortable with the basics of CSS animation first!

The Web Animations API

The Web Animations API is a low-level animation API built into the browser. We can build animation sequences and control them from within JavaScript.

It mirrors the @keyframes API. Here's a quick example:

const elem = document.querySelector('.box');

const frames = [
  { opacity: 0, transform: 'translateY(100%)' },
  { opacity: 1, transform: 'translateY(0%)' },
];

elem.animate(
  frames,
  {
    duration: 1000,
    iterations: Infinity,
  }
);

This is equivalent to the following CSS animation:

@keyframes pop-in {
  from {
    opacity: 0;
    transform: translateY(100%);
  }

  to {
    opacity: 1;
    transform: translateY(0%);
  }
}

.box {
  animation: pop-in 1000ms infinite;
}

For the most part, the Web Animations API can be thought of as "CSS keyframe animations in JavaScript". Under the hood, the Web Animations API even uses the same low-level implementation as keyframe animations, so their performance characteristics are identical.

But there are some things that are different between the two.

The most significant, IMO, is that the Web Animations API will let us apply a single timing function for the whole animation. Each step isn't given its own easing, by default.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The box on the left uses the Web Animations API, and so the entire animation uses a single easing curve. The box on the right uses keyframe animations, and so each step in the sequence is given its own ease.

We can also apply custom timing functions to each step in the Web Animations API:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Pros:

It's built into the browser, so no hefty package needs to be included in your bundle.
It has good performance, and won't be affected by any work happening in the JS main thread.
It has solid browser support
.
It allows a bit more customization compared to CSS keyframe animations.

Cons:

It's not fundamentally different from CSS keyframe animations. It doesn't really let you do anything "new".
Frustratingly, there are lots of subtle differences between keyframe animations and the Web Animations API for you to get tripped up by. For example, the default timing function is "linear" instead of "ease". And in order to change the timing function, you set easing instead of animationTimingFunction.

Resources:

Using the Web Animations API
, on MDN
CSS Animations vs. Web Animations API
, on CSS Tricks
Motion

Motion (formerly known as “Framer Motion”) is an incredible piece of technology.

Motion is a production-ready library for React. It does a lot of things, but the most impressive and noteworthy thing is that it can animate CSS properties that aren't normally able to be animated.

For example: earlier in this course, we saw these Flexbox visualizers:

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

In "real life", when we change Flexbox properties, that transition can't be animated. transition: justify-content 300ms has no effect. But I've done it here, using Motion.

Motion works by calculating a complex sequence of transforms required to interpolate between the start and end positions. This is known as the FLIP technique. As someone who built a FLIP-based library myself, let me tell you: this stuff is ridiculously hard.

Because it uses transforms, the animations are highly performant. Even if we could animate Flexbox properties, they wouldn't be this smooth.

It's not limited to Flexbox, either. Motion can animate just about any CSS change. If your element goes from being a child in a Grid container to setting position: absolute; top: 50px, Motion can animate that transition.

It can even animate transitions between components.

Here's an example from their docs:

Here's the wild thing: we aren't actually "moving" the smaller cards to the center of the screen. The center card is a completely different component, with completely different HTML elements. Motion is magic.

Pros:

Can animate all kinds of things that would normally not be animatable, leading to next-level user experiences. We can build stuff that would have been unimaginably complex, just a year or two ago.
Uses hardware-accelerated transforms for performant transitions.
Supports using spring physics instead of Bézier curves (discussed below).
Ties in beautifully with React. Can add sophisticated animations in a remarkably small amount of code.

Cons:

All of that magic comes at a cost: according to Bundle Phobia
, the package weighs ~42kB gzip.
Like all JS-based animation libraries, the animation might run choppy if the main thread becomes occupied.
Only works with React.

Resources:

More on Motion in the Treasure Trove
Official site / docs
Github
React Spring

React Spring allows us to model our animations based on spring physics, rather than Bézier curves.

Spring physics are an entirely different model for running animations. When we work with spring physics, we don't pick a duration for our animations; instead, we configure the characteristics of a spring.

Why would we want to do this? Because the resulting motion is incredible. It feels fluid and realistic. Spring physics are modeled on the natural world, and it convinces our brain in a way that Bézier curves can't fully imitate.

React Spring is the most common way to animate using spring physics in React. They've done a ton of work to make an incredibly powerful, highly-configurable library. You can do lots of wild stuff with React Spring, and it's been my go-to library for years.

Pros:

Fluid, organic motion compared with CSS transitions / keyframe animations.
Highly optimized performance.
Relatively small: 19kb gzip, according to Bundle Phobia
.
A rich API with lots of advanced options, including wonderful orchestration tools.
Ties in with an ecosystem created by the same folks. For example, we can use it with react-use-gesture to create the card-grabbing animation above, or this one:
At its core, React Spring is a number generator. This means it can be used for all kinds of animations, not just transitioning CSS properties. For example:

Cons:

It can't do "magic" animations in the way that Motion can. And given that Motion does support spring physics, it may be the better choice for your application.
The learning curve is pretty steep, both with spring physics in general, and this library in particular.
Like all JS-based animation libraries, the animation might be janky if the main thread becomes occupied.

Resources:

Official site / docs
Github
A Friendly Introduction to Spring Physics
, by me!
GreenSock GSAP

GSAP is one of the oldest and most well-known animation libraries out there.

I personally haven't used it much, but folks like Sarah Drasner swear by it
. It offers advanced Bézier-based easing (much more flexible than the cubic-bezier CSS function), and a timeline to manage orchestration (animating multiple elements at specific moments).

In terms of bundle size, it sits right between the two other libraries we've seen (27kb gzip, according to BundlePhobia
), though that number might be artificially low: GSAP has a rich plugin ecosystem, and those plugins may inflate your bundle.

Pros:

Large, active community.
Can be used with any framework, not just React.
Highly optimized performance.
Rich plugin ecosystem for things like adding scroll-based triggers.
Probably lots of other things! I'm not familiar enough with it to say.

Cons:

It doesn't support true spring physics.
Because it's framework-agnostic, it won't tie in as neatly as framework-specific solutions.
Probably lots of other things! I'm not familiar enough with it to say.

Resources:

Official site / docs
How to Animate on the Web With GreenSock
, by Sarah Drasner
Other libraries

There's a huge ecosystem out there, and we're just scratching the surface.

That said, there are relatively few tools out there doing truly remarkable things. Most of the libraries I've seen are all about ergonomics. They offer a different way to accomplish the same stuff you could do with CSS transitions or keyframe animations.

Once you become comfortable with CSS transitions and keyframe animations, these sorts of tools don't seem to offer as much value. But they come with a cost: you need to spend time learning how to use them, and they increase the size of your JS bundles!

I prefer to focus on tools that let us do things not otherwise possible. CSS doesn't come with a built-in way to use spring physics, so a spring-physics-based library is worthwhile to me.

If you don't use React, I'd encourage you to look for libraries with similar game-changing potential!

(Svelte comes with a bunch of advanced animation stuff built-in. If you're a Svelte dev, you may not need a library!)

The fundamentals always matter
(info)

With amazing tools like Motion, React Spring, and GSAP, you might be wondering: is there any point to using the fundamental animation tools in CSS?

Yes it is! I still rely on the CSS transition property and CSS keyframe animations a ton.

CSS animations run off the main thread, which means they have an inherent performance advantage over these fancy JS animation libraries. For small, straightforward animations, nothing works better than CSS transitions and animations!

I reach for modern tools in two cases:

The animation is too complex or sophisticated to be done with CSS (eg. 'crossfading' between DOM elements).
The animation is very prominent, and I want to squeeze a bit of extra lush-ness out of it with spring physics.

---

## Workshop

Source: /css-for-js/08-animations/17-workshop

Workshop

For the third and final time, we'll be working on Sole&Ankle, the sneaker store!

Our goal is to add a handful of interactions to the project:

Resources

Grab the starter code from Github, or work on CodeSandbox:

Download from Github
Work on CodeSandbox

As always, you'll find step-by-step instructions in the workshop's README.md.

There's one thing which is a bit different about this workshop: each exercise includes an open-ended stretch goal. Once you've finished the prescribed animation, it's your turn to get creative and add your own twist. Some ideas are given as inspiration, but you can interpret them however you wish.

Very few developers are lucky enough to work with a professional motion designer, so it often falls to us. This workshop will challenge you to design your own animations, in addition to implementation.

Please feel encouraged to share recordings of your custom animations in Discord!!

Submit Workshop

I review a small percentage of submitted workshops, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## Workshop Solution

Source: /css-for-js/08-animations/18-workshop-solution

Workshop Solution

Outdated code in solution videos
(warning)

Since filming these solution videos, I have migrated this workshop from create-react-app to Vite, and updated React to 19. This required a few small changes in terms of file structure. For example, file extensions have been changed from .js to .jsx, since Vite doesn’t allow JSX in plain JS files.

The solution code
 has been updated, so please use that as your source of truth, rather than what’s in the videos.

Exercise 1: Sneaker Zoom
View the code on Github

Each exercise in this workshop encourages you to extend or replace the given animation. Here's an example of how I'd tackle the “Stretch Goal” part of this, by using CSS filters and rotation to enhance the effect:

Exercise 2: Navigation link flip-up
View the code on Github

Fixing an accessibility issue
(warning)

In the video above, we wind up with the following markup:

<Wrapper {...delegated}>
  <MainText>{children}</MainText>
  <HoverText>{children}</HoverText>
</Wrapper>

There's an accessibility issue here; because {children} is repeated twice, folks who use screen readers will hear the link text twice (eg. "Sale Sale" instead of "Sale").

We can fix this by adding aria-hidden to one of the wrappers:

<Wrapper {...delegated}>
  <MainText>{children}</MainText>
  <HoverText aria-hidden={true}>{children}</HoverText>
</Wrapper>

This change has been added to the solution on Github. Thanks to Discord user Penguin for reporting it!

Exercise 3: Modal enter animation

Different dialog library used
(warning)

In the Module 5 workshop solution, I explained that this workshop was updated from Reach UI to Radix Primitives
. This means that the code you’ll see in this solution video will differ a bit from what you have in your own repository.

The good news is that the final code is actually a bit simpler, due to how overlays work in Radix Primitives. The bad news is that the solution video does some no-longer-necessary work (creating a separate <Backdrop> element, around the 4 minute mark).

View the code on Github

