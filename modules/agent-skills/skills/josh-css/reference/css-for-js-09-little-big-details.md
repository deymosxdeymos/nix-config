# CSS for JS - Module 9: Little Big Details

---

## Introduction • Josh W Comeau's Course Platform

Source: /css-for-js/09-little-big-details/00-introduction

Little Big Details

For the past 9 modules, we've been focused on building a solid foundation in CSS. We've seen how to use a bunch of different layout modes, how to build interfaces for all sorts of devices and screen sizes, and how to integrate it all into a JavaScript framework.

In this final module, we're adding frosting and sprinkles to our cake. 😄

We'll learn about cosmetic properties like gradients and shadows, and how to wield these weapons to produce beautiful, eye-catching interfaces. But it's not just about aesthetics. We'll also see how to use CSS to add "functional polish" to our applications, to make sure users have the best possible experience.

We'll go deeper into properties and functions we've already seen, and learn how to truly get the most out of them.

This is probably the most straight-up fun module in the course, and I'm so excited you've made it here!


---

## CSS Filters

Source: /css-for-js/09-little-big-details/01-filters

CSS Filters

CSS filters allow us to leverage the ridiculous power of SVG filters from within CSS, wrapped up in a declarative, straightforward bow.

If you're not familiar with SVGs, it's an image file format that allows us to create vector graphics using an HTML-like syntax:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<svg
  xmlns="http://www.w3.org/2000/svg"
  width="200"
  height="200"
  style="outline: 3px solid"
>
  <rect
    x="0"
    y="0"
    width="150"
    height="200"
    fill="deeppink"
  />
  <circle
    r="50"
    cx="150"
    cy="100"
    fill="gold"
  />
</svg>
Result
Refresh results pane

One of the things that make SVGs so powerful is that they have a rich filter API.

SVG filters tend to be wildly complex and inscrutable. Here's an example SVG filter used to create a drop-shadow effect:

<svg xmlns="http://www.w3.org/2000/svg">
  <filter id="drop-shadow">
    <feGaussianBlur in="SourceAlpha" stdDeviation="5" />
    <feOffset dx="4" dy="8" result="offsetblur" />
    <feFlood flood-color="hsl(0deg 0% 0% / 0.2)" />
    <feComposite in2="offsetblur" operator="in" />
    <feMerge>
      <feMergeNode />
      <feMergeNode in="SourceGraphic" />
    </feMerge>
  </filter>
</svg>

How does this work? I have no idea. 😅

Here's the cool thing, though: we can access this SVG filter from within CSS, using a much easier-to-understand interface:

.box {
  filter: drop-shadow(4px 8px 5px hsl(0deg 0% 0% / 0.2));
}

CSS has access to about a dozen common SVG filters, through the use of filter functions like drop-shadow().

In the lessons that follow, we'll explore some of them!


---

## Color Manipulation

Source: /css-for-js/09-little-big-details/01.01-color-manipulation

Color Manipulation

A good chunk of CSS filters manipulate color in some way.

If you've used image-editing software like Photoshop before, many of these filters will seem familiar.

Here are some examples:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .brightness {
    filter: brightness(150%);
  }
  .contrast {
    filter: contrast(60%);
  }
  .sepia {
    filter: sepia(100%);
  }
  .mixed {
    filter: contrast(200%) grayscale(90%);
  }
</style>

<section>
  <div>
    <h2>Default (no filter)</h2>
    <img
      alt="A colourful busy street in Tokyo, Japan"
      src="https://courses.joshwcomeau.com/cfj-mats/akihabara.jpg"
    />
  </div>

  <div>
    <h2>Boosted Brightness</h2>
    <img
      class="brightness"
      alt="A colourful busy street in Tokyo, Japan"
      src="https://courses.joshwcomeau.com/cfj-mats/akihabara.jpg"
    />
  </div>

  <div>
    <h2>Lowered Contrast</h2>
    <img
Result
Refresh results pane

These color-manipulating filters take a percentage. For example, brightness has a default value of 100%, and we can either make it less bright or more bright:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .less-bright {
    filter: brightness(25%);
  }
  .default {
    filter: brightness(100%);
  }
  .more-bright {
    filter: brightness(200%);
  }
</style>

<section>
  <div>
    <h2>Less bright</h2>
    <img
      class="less-bright"
      alt="A colourful busy street in Tokyo, Japan"
      src="https://courses.joshwcomeau.com/cfj-mats/akihabara.jpg"
    />
  </div>

  <div>
    <h2>Default</h2>
    <img
      class="default"
      alt="A colourful busy street in Tokyo, Japan"
      src="https://courses.joshwcomeau.com/cfj-mats/akihabara.jpg"
    />
  </div>

  <div>
    <h2>More bright</h2>
    <img
      class="more-bright"
      alt="A colourful busy street in Tokyo, Japan"
Result
Refresh results pane

We can apply multiple filters to the same element by space-separating them:

.image {
  filter:
    brightness(120%)
    contrast(110%)
    grayscale(50%);
}

These color-manipulation filters are often used on images, but they work with any DOM nodes!

In this example, we crank up the brightness on hover, using transition to animate the effect:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The effect is similar to animating background-color, but more flexible, since it works with gradients and background images as well.

It can also be more performant, because filter is hardware-accelerated in some browsers
*
.

Hue rotation

The hue-rotate filter function is interesting: it shifts the color of every pixel in the element.

When we hover over the button, let's mix in some more red:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Our background gradient has a hue of 260deg. Applying hue-rotate(60deg) increases the hue of all colours by 60deg, leading to a background gradient with a hue of 320deg.

Color-rotated emoji
(info)

Google engineer Surma recently shared a neat discovery
 — The hue-rotate filter can be used to change the colors of emoji!

For example:

 Show more

---

## Blur Filter

Source: /css-for-js/09-little-big-details/01.02-blur-filter

Blur Filter

One of the most useful CSS filters is blur. It applies a Gaussian blur to the selected element.

Here's an example. Try hovering or focusing the link to unblur the image:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  img {
    filter:
      blur(6px)
      brightness(50%);
    transition: filter 800ms ease-in-out;
  }

  a:hover img,
  a:focus img {
    filter:
      blur(0px)
      brightness(100%);
    transition: filter 300ms;
  }
</style>

<a href="/">
  <img
    alt="A colourful busy street in Tokyo, Japan"
    src="https://courses.joshwcomeau.com/cfj-mats/akihabara.jpg"
  />
</a>
Result
Refresh results pane

Blurring can be a very expensive operation, even with hardware acceleration. Be sure to test your effect on low-end devices before trying this sort of thing!

Blurring is cosmetic
(warning)

When we apply a blur to an image, we obfuscate it visually, but this is a purely cosmetic effect. If someone is using a screen reader, they'll be able to access the element, and won't have any idea that the content is meant to be concealed.

This can be a problem if the blurring serves a functional purpose. For example, if you're building a quiz game, and the answer is heavily blurred until the user submits their response.

In these cases, you'll need to use the aria-hidden attribute to hide the content from screen readers. You can remove the blur filter and the aria-hidden attribute at the same time for a consistent, parallel experience.

The blur filter will lead to a soft, blurred edge. If you'd prefer a sharper edge, you can add overflow: hidden to the parent container:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Blurred glow

There are lots of cool things you can do with the blur filter, but I'm about to share one of my personal favourites. A design secret, if you will.

Here's the final result from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

---

## Backdrop Filters

Source: /css-for-js/09-little-big-details/01.03-backdrop-filters

Backdrop Filters

The filter property will apply an SVG filter to the selected element, but what if we want to blur everything behind the element?

For example, maybe we want to add a card in front of a photo, blurring the background:

Seattle

We can accomplish this task using the backdrop-filter property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .blur-circle {
    backdrop-filter: blur(10px);
    /* Vendor prefix for Safari: */
    -webkit-backdrop-filter: blur(10px);
  }
</style>

<img
  alt="A colourful busy street in Tokyo, Japan"
  src="https://courses.joshwcomeau.com/cfj-mats/akihabara.jpg"
/>
<div class="blur-circle"></div>
Result
Refresh results pane

On this very course platform (though not on this page), I use backdrop-filter to obfuscate the content behind the sticky header.

In order to ensure that the text in the header remains visible, I also add a semi-opaque background color:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
The tip of the iceberg

backdrop-filter unlocks a lot of interesting, creative possibilities. It's most commonly used with the blur filter, but backdrop-filter supports the full range of filters we saw with filter! You can likewise combine multiple backdrop filters:

.header {
  backdrop-filter:
    brightness(150%)
    hue-rotate(30deg)
    blur(5px);
}

It's worth experimenting with this property — it can do a lot of neat things!

Even more realistic frosted glass
(success)

backdrop-filter: blur() can produce a frosted glass effect, but there are some subtle issues with this property. With a bit of clever outside-the-box thinking, we can make the effect much more realistic and pleasant.

I explore this concept in my new blog post, Next-level frosted glass with backdrop-filter
.


---

## Border Radius

Source: /css-for-js/09-little-big-details/02-radius

Border Radius

As we've seen, the border-radius property lets us round the corners of our boxes:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .card {
    width: 200px;
    height: 200px;
    background: white;
    border-radius: 16px;
  }
</style>

<article class="card"></article>
Result
Refresh results pane

Like so much in CSS, this property appears simple, but we've only seen the tip of the iceberg. We can do some pretty cool things with border-radius!

Percentages

Have you ever tried to use a percentage border-radius on a non-square element?

The result is a bit funky:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .card {
    width: 300px;
    height: 150px;
    background: white;
    border-radius: 10%;
  }
</style>

<article class="card"></article>
Result
Refresh results pane

To understand what's going on here, we need to dig a bit deeper into how this property works.

The border-radius property is actually a shorthand for 4 distinct CSS properties:

border-top-left-radius
border-top-right-radius
border-bottom-right-radius
border-bottom-left-radius

Each of these properties accepts two values: the horizontal radius, and the vertical radius.

Check out what happens if I pass two distinct values for the top-left corner:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The first value is used as the horizontal radius for an ellipse. The second value is used as the vertical radius:

This is how border-radius works under-the-hood. When we pass a value like 32px, that single value is used 8 times:

Here's where it gets weird: when we use a percentage, the horizontal radius will be based on the width, and the vertical radius will be based on the height.

For example, here's the corner resulting from border-radius: 25%:

Here's how to think about it: the ellipse will be proportional to the element itself. If our element has a width of 300px and a height of 150px, it will have an aspect ratio of 2:1. When we use a single percentage value for border-radius, it produces an ellipse with the same aspect ratio.

If we set border-radius to 50%, something special happens.

If the radius is 50%, that means the diameter is 100%. So we wind up with an ellipse that is the same width and height as the element itself. As a result, our shape becomes an ellipse:

Full shorthand syntax

So we've seen how border-radius actually takes 8 separate values: there are 4 corners, and each corner can specify a horizontal and vertical radius.

We can pass all 8 values to the border-radius shorthand with our friend, the / delimiter:

.box {
  border-radius: 10% 20% 30% 40% / 50% 60% 70% 80%;
}

The first 4 numbers are all horizontal radiuses. We specify them in clockwise order, starting from the top-left corner.

The last 4 numbers are the vertical radiuses, also specified in clockwise order from the top-left.

If only the first 4 numbers are provided, they're copied over to the last 4:

.box {
  /* These two declarations are equivalent: */
  border-radius: 10% 20% 30% 40%;
  border-radius: 10% 20% 30% 40% / 10% 20% 30% 40%;
}

And if only a single value is provided, it's copied over to all 8 values:

.box {
  /* These two declarations are equivalent: */
  border-radius: 100px;
  border-radius: 100px 100px 100px 100px / 100px 100px 100px 100px;
}
Blobby shapes

By using all 8 border-radius values, we can create some pretty nifty blobby shapes!

Check out this neat tool by 9Elements
:

By dragging the handles along the perimeter, we can customize the specific shape for our element. Once we have a value we're satisfied with, we can copy/paste the CSS into our application!

Visit “Fancy Border Radius”

(Unfortunately, this tool doesn't support keyboard interactions, and requires a pointer device to use.)


---

## Nested Radiuses

Source: /css-for-js/09-little-big-details/02.01-nested-radius

Nested Radiuses

Let's look at a super common mistake people make.

Suppose we have a rounded element in a rounded container. We use the same border-radius for both parent and child:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .card {
    border-radius: 16px;
    padding: 8px;
  }
  .avatar {
    border-radius: 16px;
  }
</style>

<article class="card">
  <img
    class="avatar"
    alt="Dog avatar"
    src="https://courses.joshwcomeau.com/cfj-mats/article-image-spot.jpg"
  />
  <h2>Spot</h2>
  <p>Perennial Good Boy. Parlimentary candidate, district 22. Dog park YIMBY.</p>
</article>
Result
Refresh results pane

The corners don't quite look right, do they? Look at how chunky they are in the middle:

By using the same border-radius, both corners are being rounded according to their own circles:

Our corner would look more consistent if the two corners shared the same center point, like tree rings:

This way, the corners are the same thickness all the way through:

How do we calculate this? Well, our goal is to figure out the radius of the larger circle. To do that, we'll need to sum up the inner circle's radius as well as any padding or other spacing:

In this case, the correct outer radius is 24px (16px inner radius + 8px padding).

We can use calc and CSS variables to do this calculation for us:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

What if the outer radius is known, and we want to calculate the inner radius? We can do the same calculation, except we'd subtract the padding instead of adding it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

A lot of developers come up with nested radius values by guessing / trial-and-error. And it's surprisingly hard to come up with the perfect value that way!

Hopefully, this explanation has made the process a bit more intuitive, so you can apply this logic the next time you run into this situation!


---

## Circular Radius

Source: /css-for-js/09-little-big-details/02.02-circular-radius

Circular Radius

Let's say that we want to produce this sort of rounded corner:

Try resizing this element to see how the corners behave as the shape changes. You should be able to resize by dragging the bottom-right corner (on desktop).

The cool thing about this element is that its corners are always symmetrical and circular. They never stretch into ovals.

By contrast, check out this example, which produces an oval unless the element is a perfect square:

If we know the exact width and height of the element, we can set the border-radius to half of that amount. But what if the container size is dynamic, as it is here?

There's a hacky-yet-simple fix for this—pick a very very large number:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .card {
    /* Yowza! */
    border-radius: 5000px;
  }
</style>

<article class="card"></article>
Result
Refresh results pane

Here's why this works: the border-radius algorithm has a built-in limit: it won't allow the corners to grow so large that they run into each other.

If our element is 200×100, each corner will have a maximum radius of 50px. It's mathematically impossible for them to grow larger:

border-radius
25px

It doesn't matter how high we set the number; if the number is bigger than 50, it won't make a difference, because the corners just can't grow anymore. They run into each other.

Why not just set it to 50px, then? Well, 50px is only the magic number if our container is 100px tall. If the container is 1000px by 800px, the magic number would be 400px.

That's why I chose 5000px; it's unrealistically huge. It'll produce the result I want even when applied to a relatively large element.

Asymmetric circles

Alright, one more puzzle: what if we wanted to create this sort of shape?

Like before, our corners are circular, and they scale with the element as it changes size and shape. Except this time, they aren't symmetrical; the top corners are 5x larger than the bottom ones.

We can do this by picking large, asymmetrical values:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

When given way-too-large values, the browser will clamp them, and do its best to preserve the ratio between them. In effect, it's treated like flex-grow numbers, rather than absolute pixel values
*
.

We can see how this algorithm works out here:

Top radius
100px
Bottom radius
100px

The moment the two corners touch, when the combined radiuses exceed the element's height, the pixel value becomes hypothetical.

This behavior is described in the specification
, and faithfully implemented by all browsers! So you can use this trick without worrying that you're relying on an unspecified hack.

Using vmax instead

Discord user Micha shared a pretty cool modern way to accomplish this. Instead of picking an arbitrary enormous number, we can use 100vmax:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

As we learned earlier in the course, the vmax unit will switch between vw (Viewport Width) and vh (Viewport Height), depending on which one is bigger. Essentially, each vmax unit is equal to 1% of the window width when in landscape orientation, and 1% of the window height when in portrait orientation.

By setting the corner radius to 100% of the viewport’s largest size, we guarantee that it'll be bigger than the element could be, as long as the element is smaller than the viewport itself.

Ultimately, it's the same thing as setting border-radius: 10000px, but it feels a bit less hacky to me.


---

## Shadows

Source: /css-for-js/09-little-big-details/03-shadows

Shadows

In the real world, shadows are everywhere. They give our environment a sense of lighting and depth.

We want our web applications to feel tangible and real, and shadows are an important piece of the puzzle!
*

Like so much in CSS, the shadow rabbit hole goes surprisingly deep. In this lesson, we'll learn how to use shadows effectively, and pick up some neat tricks along the way!

Tools of the trade

There are three main ways to apply shadows in CSS: box-shadow, text-shadow, and filter: drop-shadow.

box-shadow

box-shadow is the most common way to apply shadows in CSS.

It's based on the box model. When you apply box-shadow to an element, that element's box will cast a simulated shadow behind it.

Here's a quick demonstration:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .card {
    box-shadow:
      2px 4px 8px hsl(0deg 0% 0% / 0.25);
  }
</style>

<article class="card">
  <h2>Hello World</h2>
</article>
Result
Refresh results pane

box-shadow is most commonly called with 4 arguments:

Horizontal offset
Vertical offset
Blur radius
Color

The blur radius is the strength of the blurring effect.

The color can be any valid color value, but I strongly recommend using hsl/hsla. Using a solid color like black produces a very aggressive shadow. We want to be more subtle than that.

filter: drop-shadow

As we've seen, the filter property allows us to access SVG filter mechanics from within the CSS language. drop-shadow is one of those filters!

At first blush, it looks quite a bit like box-shadow:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The API looks quite similar: it also accepts 4 values, of the same types, in the same order. They aren't quite the same thing, though.

Under the hood, the drop-shadow filter function uses Gaussian blurring. This is a different mathematical way of calculating blur, and it produces slightly different results. Instead of a simple blur radius, the third argument specifies a “standard deviation”:

Hi!
Shadow
filter
box-shadow
none

Notice that filter produces a softer, more-blended shadow.

Both shadow techniques come with their own trade-offs, and both can do things that the other can't. We'll explore them in this lesson.

text-shadow

text-shadow is a shadow that applies only to the typography within the selected element.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

One of the most common use cases for text-shadow is to increase the contrast between light-coloured text and a light background. We'll see examples of this a bit later on. For the next couple lessons, we'll focus primarily on box-shadow and filter: drop-shadow.


---

## Contoured Shadows

Source: /css-for-js/09-little-big-details/03.01-contoured-shadows

Contoured Shadows

As we saw earlier, many CSS filters are designed to work well with images. It seems like they're plucked straight from Photoshop!

filter: drop-shadow continues this trend.

In Photoshop, when you add a drop shadow to a layer, it applies that shadow to the opaque pixels in the layer. It doesn't form a rectangle around the layer itself!

This means that if we use filter: drop-shadow on an image that supports transparency (eg. png, gif, svg), the shadow will apply to the non-transparent parts of the image:

Shadow
filter
box-shadow
none

This effect isn't limited to images, either—it works for any DOM node!

Check out this example, with child elements spilling over the edge:

Hi!
Shadow
filter
box-shadow
none

When we apply filter: drop-shadow to an element, it contours that element and all of its descendants (even non-contiguous ones, like the smaller circle!), and applies the shadow to that shape.

Here it is in code:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This is pretty remarkable, isn't it?

We can even apply filter: drop-shadow to a group of elements, to make sure we don't have any "shadow overlap":

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This can prevent the unsightly overlap that happens when box-shadow is used on tightly-grouped siblings:

box-shadow
filter: drop-shadow
Toggle
Expand

With this sort of superpower, you might be wondering: what's the point of box-shadow? Shouldn't we just use filter: drop-shadow all the time?

Not so fast — box-shadow has a few unique tricks up its sleeves as well. We'll explore them over the next couple of lessons.

Safari quirks
(warning)

Sometimes, filter: drop-shadow produces some really funky effects in Safari.

For example, I had been using a drop-shadow on the “notes” feature in this course platform. Aravind, a student, pointed out that when annotating certain types of content, some pretty glitchy behaviour could occur:

Over the past year, I've occasionally noticed quirks with Safari and drop-shadow. It's fine 95% of the time, but you should definitely test your drop shadows on Safari to make sure they aren't glitchy!

This quirk is specifically with filter: drop-shadow. box-shadow works consistently.


---

## Single-Sided Shadows

Source: /css-for-js/09-little-big-details/03.02-single-sided-shadows

Single-Sided Shadows

Sometimes, we want our shadows to be cast in a single direction. We want the shadow to be underneath the element, not spilling out in all directions!

box-shadow is uniquely qualified to solve this problem, because it alone takes an optional fourth argument: spread radius.

.box {
  box-shadow: 0px 2px 4px 10px red;
  /*                       ^-- Spread! */
}

The spread radius allows us to increase or decrease the size of the shadow.

By default, spread is 0, meaning that the shadow is the same size as the element. A spread of 2px means that the shadow grows in every direction by 2px, becoming 4px wider and 4px taller.

box-shadow: 8px 8px 2px 0px hsl(0deg 0% 0% / 0.2);
Spread
0px

How does this help us create single-sided shadows?

The reason shadows tend to spill out in all directions is because of the blur radius. We can use the spread radius to offset this growth, so that the shadow stays small. Then, we can use offsets to choose which side it should show under:

box-shadow: 0px 0px 0px 0px hsl(0deg 0% 0% / 0.2)
Blur / Spread
0px
Offset
0px

It can take some experimentation to find the right combination, depending on the effect you're after.

We can clean the code up a bit using a CSS variable, to link the blur and spread radii:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

These examples show the shadow on the bottom edge, as that's most common. You can change which side the shadow appears by tweaking the horizontal/vertical offsets:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The drop-shadow filter function does not take a spread argument, so this feature is unique to box-shadow.


---

## Inset Shadows

Source: /css-for-js/09-little-big-details/03.03-inset-shadows

Inset Shadows

There's one more nifty trick exclusive to box-shadow: we can use it to create inner shadows!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    box-shadow:
      inset
      2px 2px 8px
      hsl(0deg 0% 0% / 0.33);
  }
</style>

<div class="wrapper">
  Hello World
</div>
Result
Refresh results pane

Inset shadows allow us to create the illusion that an element is lower than its surrounding environment. This can be a very useful tool!

One of my favourite tricks with inset shadows is to create a "moat", a thin canal around a child element:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    box-shadow:
      inset
      2px 2px 8px
      hsl(0deg 0% 0% / 0.33);
    /*
     The '.box' has a non-inset shadow.
     We don't want it to bleed beyond
     its wrapper.
    */
    overflow: hidden;
  }
  .box {
    box-shadow:
      2px 2px 8px
      hsl(0deg 0% 0% / 0.33);
  }
</style>

<div class="wrapper">
  <div class="box">
    Moat!
  </div>
</div>
Result
Refresh results pane

In addition to the inset shadow on .wrapper, we also apply a shadow on the .box child. Aside from the fact that this second shadow isn't inset, the two shadows are identical. This completes the illusion.

Why “overflow: hidden”?
(info)

In the code sample above, we add overflow: hidden to the parent .wrapper. How come?

 Show more

---

## Exercises

Source: /css-for-js/09-little-big-details/03.04-shadow-exercises

Exercises
Tooltip with shadow

We're building a little tooltip, and we want the whole thing to have a shadow, including its tip!

Update the code below to match this design:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .tooltip {
    box-shadow: 0px 0px 16px hsl(0deg 0% 0% / 0.5);
  }
</style>

<div class="tooltip">
  Lorem ipsum dolor hello
</div>
Result
Refresh results pane

Solution:

Solution code
(success)

 Show more
Scrapbooking

Let's create a scrapbooking-inspired UI:

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

## Designing Shadows

Source: /css-for-js/09-little-big-details/03.05-shadow-design

Designing Shadows

It's one thing to know how to use the shadow CSS properties, and another to create realistic, lush-looking shadows!

In this lesson, we'll look at some strategies for creating beautiful, life-like shadows. We'll also learn how to implement some advanced shadow tricks.

Why even use shadows?

Shadows imply elevation, and bigger shadows imply more elevation. If we use shadows strategically, we can create the illusion of depth, as if different elements on the page are floating above the background at different levels.

Here's a simulation that shows what the shadows imply:

Log in
Sign up
Are you sure?

This action cannot be undone.

Cancel
Confirm
Reveal
0%
Include Elevation
Yes
No

The best websites and web applications feel tactile and genuine, as if the browser is a window into a different world. Shadows help sell that illusion.

There's also a tactical benefit here as well. By using different shadows on the header and dialog box, we create the impression that the dialog box is closer to us than the header is. Our attention tends to be drawn to the elements closest to us, and so by elevating the dialog box, we make it more likely that the user focuses on it first. We can use elevation as a tool to direct attention.

When I use shadows, I do it with one of these purposes in mind. Either I want to increase the prominence of a specific element, or I want to make my application feel more tactile and life-like.

In order to achieve these goals, though, we need to take a holistic view of the shadows in our application.

Creating a consistent environment

For a long time, I didn't really use shadows correctly 😬.

When I wanted an element to have a shadow, I'd add the box-shadow property and tinker with the numbers until I liked the look of the result.

Here's the problem: by creating each shadow in isolation like this, you'll wind up with a mess of incongruous shadows. If our goal is to create the illusion of depth, we need each and every shadow to match. Otherwise, it just looks like a bunch of blurry borders:

In the natural world, shadows are cast from a light source. The direction of the shadows depends on the position of the light.

Move your cursor around the box (or, focus and use the arrow keys) to see what I mean:

Hover, focus, or tap to interact

In general, we should decide on a single light source for all elements on the page. It's common for that light source to be above and slightly to the left:

If CSS had a real lighting system, we would specify a position for one or more lights. Sadly, CSS has no such thing.

Instead, we shift the shadow around by specifying a horizontal offset and a vertical offset. In the image above, for example, the resulting shadow has a 4px vertical offset and a 2px horizontal offset.

Here's the first trick for cohesive shadows: every shadow on the page should share the same ratio. This will make it seem like every element is lit from the same very-far-away light source, like the sun.

Next, let's talk more about elevation. How can we create the illusion that an element is lifting up towards the user?

We'll need to tweak all 4 variables in tandem to create a cohesive experience.

Experiment with this demo, and notice how the values change:

box-shadow: 4.0px 8.0px 8.0px hsl(0deg 0% 0% / 0.38);
Elevation
0.5

With this strategy, the first two numbers—horizontal and vertical offset—scale together in tandem. In this particular case, the vertical offset is always 2x the horizontal one.

Two other things happen as the card rises higher:

The blur radius gets larger.
The shadow becomes less opaque.

(I'm also increasing the size of the card, for even more realism. In practice, it can be easier to skip this step.)

There are probably complex mathematical reasons for why these things happen, but we can leverage our intuition as humans that exist in a lit world.

If you're in a well-lit room, press your hand against your desk (or any nearby surface) and slowly lift up. Notice how the shadow changes: it moves further away from your hand (larger offset), it becomes fuzzier (larger blur radius), and it starts to fade away (lower opacity). If you're not able to move your hands, you can use reference objects in the room instead. Compare the different shadows around you.

Because we have so much experience existing in environments with shadows, we don't really have to memorize a bunch of new rules. We just need to apply our intuition when it comes to designing shadows. Though this does require a mindset shift; we need to start thinking of our HTML elements as physical objects.

So, to summarize:

Each element on the page should be lit from the same global light source.
The box-shadow property represents the light source's position using horizontal and vertical offsets. To ensure consistency, each shadow should use the same ratio between these two numbers.
As an element gets closer to the user, the offset should increase, the blur radius should increase, and the shadow's opacity should decrease.
You can skip some of these calculations by using our intuition.
Layering

Modern 3D illustration tools like Blender can produce realistic shadows and lighting by using a technique known as raytracing.

In raytracing, hundreds of beams of lights are shot out from the camera, bouncing off of the surfaces in the scene hundreds of times. This is a computationally-expensive technique; it can take minutes to hours to produce a single image!

Web users don't have that kind of patience, and so the box-shadow algorithm is much more rudimentary. It creates a box in the shape of our element, and applies a basic blurring algorithm to it.

As a result, our shadows will never look photo-realistic, but we can improve things quite a bit with a nifty technique: layering.

Instead of using a single box-shadow, we'll stack a handful on top of each other, with slightly-different offsets and radiuses:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

By layering multiple shadows, we create a bit of the subtlety present in real-life shadows.

This technique is described in detail in Tobias Ahlin's wonderful blog post, “Smoother and Sharper Shadows with Layered box-shadow
”.

How do we figure out the settings for each shadow layer? I've created a tool to help. You can check it out here: joshwcomeau.com/shadow-palette

You can learn how to get the most out of this tool in the associated blog post
.

You can also check out my write-up for how I use another tool over in the Treasure Trove.

Performance tradeoff
(info)

Layered shadows are undeniably beautiful, but they do come with a cost. If we layer 5 shadows, our device has to do 5x more work!

This isn't as much of an issue on modern hardware, but it can slow rendering down on older inexpensive mobile devices.

As always, be sure to do your own testing! In my experience, layered shadows don't affect performance in a significant way, but I've also never tried to use dozens or hundreds at the same time.

Also, it's probably a bad idea to try animating a layered shadow.

Color-matched shadows

So far, all of our shadows have used a semi-transparent black color, like hsl(0deg 0% 0% / 0.4). This isn't actually ideal.

When we layer black over our background color, it doesn't just make it darker; it also desaturates it quite a bit.

Compare these two boxes:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The box on the left uses a transparent black. The box on the right matches the color's hue and saturation, but lowers the lightness. We wind up with a much more vibrant box!

A similar effect happens when we use a darker color for our shadows:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

To my eye, neither of these shadows is quite right. The one on the left is too desaturated, but the one on the right is not desaturated enough; it feels more like a glow than a shadow!

It can take some experimentation to find the Goldilocks color:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

By matching the hue and lowering the saturation/lightness, we can create an authentic shadow that doesn't have that “washed out” grey quality.

The relationship between saturation and lightness
(info)

When we tweak an HSL color's lightness, it appears to affect its saturation as well. Check out this example: both boxes are fully saturated, but the right-side box is so much more vivid:

 Show more
Putting it all together

We've covered 3 distinct ideas in this tutorial:

Creating a cohesive environment by coordinating our shadows.
Using layering to create more-realistic shadows.
Tweaking the colors to prevent “washed-out” gray shadows.

Here's an example that applies all of these ideas:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Shadows on dark
(info)

If your application has a dark-colored background (either by default or as part of a dark-mode theme), you might be wondering: can you still use shadows to create a sense of elevation?

It's definitely a bit trickier, and it isn't possible if your app uses a very dark, near-black background color. But in some cases, we can still make use of shadows to an extent.

The trick is to go much heavier on the opacity.

 Show more
Fitting into a design system

As we discussed in Module 3, the design world has been moving towards a "design system" mentality. Rather than picking one-off color values, we should have a standardized palette, and all colors should come from that collection.

The shadows we've seen need to be customized depending on their elevation and environment. This might seem counter-productive, in a world with design systems and finite design tokens. Can we really “tokenize” these sorts of shadows?

We definitely can! Though it will require the assistance of some modern tooling.

For example, here's how I'd solve this problem using React, styled-components, and CSS variables:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

I have a static ELEVATIONS object, which defines 3 elevations. The color data for each shadow uses a CSS variable, --shadow-color.

Every time I change the background color (in Wrapper and BlueWrapper), I also change the --shadow-color. That way, any child that uses a shadow will automatically have this property inherited.

I do fully recognize that many of us work on codebases with established design systems, and squeezing this in isn't so simple. It's up to you to decide whether it's worth the trouble or not!


---

## Colors

Source: /css-for-js/09-little-big-details/04-colors

Colors

In an earlier lesson, we covered the fundamentals of color on the web. In this set of lessons, we're going to look at color from a few different angles.

Color perception varies quite a lot from person to person. We'll consider how we can use color more responsibly in our web products. It's not just about contrast ratios, either; we also need to make sure we aren't relying on colors that can't be distinguished by everybody.

We're also going to look at how to apply color to things not often thought of as colorable. For example, text selection colors! We'll also explore a bleeding-edge feature that lets us adjust the "accent colors" for certain native form elements.

Coming up with nice color palettes
(success)

When you're starting a new project, how do you come up with a nice, aesthetic, accessible color palette?

I share my best tricks and techniques over in the Treasure Trove:

Color Palettes

---

## Accessibility

Source: /css-for-js/09-little-big-details/04.01-color-accessibility

Accessibility

When using color in our user interfaces, there are two questions we need to ask ourselves:

Is there enough contrast between the text/UI and background?
Can folks who are color-blind understand this UI?

Let's look at each in turn.

Color contrast

In order for text to be legible, it needs to have a significant amount of contrast between it and its background.

For example, very few of us will be able to read this text comfortably:

Secret text!

That's an obvious example of text with not enough contrast, but how about this one?

Not-so-secret text?

Depending on your eyesight and color perception, you may or may not be able to read it clearly. But enough people struggle with it that this is considered an accessibility violation.

There is a standardized way of checking contrast levels: the WCAG contrast ratios.

This is a mathematical formula that accepts two colors, and spits out a number. The bigger the number, the greater the contrast:

Aa
1.21
Aa
2.21
Aa
2.99
Aa
5.89
Aa
14.87
Aa
21.00

The scale ranges from 1 (zero contrast) to 21 (maximum contrast).

What's the minimum acceptable number? Well, there are two factors to consider:

How big is the text? Large text (eg. headings) is allowed to have lower contrast ratios than normal text (eg. paragraphs).
What level of support are you aiming for? There are AA and AAA guidelines. AAA is more strict. Companies generally settle on AA, though this should be thought of as a bare minimum.

Here are the minimum acceptable contrast ratios:

	Normal text	Large text
AA	4.5	3
AAA	7	4.5

You can check the color contrast for any two colors using this handy tool: Color Review
:

If your selected color has insufficient contrast, this tool shows you visually where the thresholds are by drawing lines over the color picker, so you can pick a new value with higher contrast.

Chrome also expose this number while hovering using the element selector:

In my experience, this tooltip works about 75% of the time. Sometimes, it isn't able to decipher what the background color is. When it fails, you can use the Contrast Checker
 tool instead.

Color-picking

Once you have the text and background color, you can plug it into a calculator. But what if it isn't clear what the colors are?

For example, if text is in front of an image:

Fresh Strawberries Now Available!

What hex code represents the photo of strawberries??

We'll need to sample some colors to see what the contrast is like. You can find color picker browser extensions
 that will let you infer the color of any pixel on the page:

Try and find "low-contrast" parts of the photo to check. In this case, my biggest concern is the light glare on the strawberries, like this:

Plugging it into the calculator, I see that #78717C has a 4.71 contrast ratio with the white text. That's pretty close to the 4.5 limit, and given how "busy" the background is, I'd probably try and shoot for at least a 6 or 7. Something like this:

Fresh Strawberries Now Available!

An imperfect formula
(info)

The WCAG contrast-ratio formula is pretty sophisticated; it doesn't just look at raw mathematical data, but also considers human vision.

Every color is a combination of red, green, and blue. Each of these channels is given a relative “luminance”. For example, we tend to perceive pure green as brighter than pure blue, and so this distinction is worked into the calculation.

Unfortunately, there's another curious aspect to human vision that the formula doesn't take into account: color perception is non-linear.

We have a tendency to perceive higher contrast between brighter colours than between darker colours. According to the WCAG formula, these two examples each have the same color contrast ratio:

Aa
4.5
Aa
4.5

We perceive the one on the right as higher-contrast because both colors are brighter.

The good news is that the WCAG org is aware of this, and are working on an updated formula. The new standard is called APCA (Advanced Perceptual Contrast Algorithm).

You can learn more about this new standard in this fantastic Twitter thread
 from Dan Hollick.

Color blindness

Color blindness is the inability to see certain colors. It's estimated that between 5-10% of people have some amount of color blindness.

There are several categories of color-blindness

Red/green colorblindness (protanopia, deuteranopia)
Blue/yellow colorblindness (tritanopia)
Complete colorblindness (monochromacy)

The most common form of colorblindness is red/green. My partner has red/green colorblindness. To him, red and green both appear brownish.

It's impossible to truly know what this experience is like unless you're colorblind, but we can get a hint by digitally altering images to simulate it:

Simulate
Typical vision
Red/green colorblindness
Blue/yellow colorblindness
Monochromacy
Typical vision

In our work, we need to be careful not to rely on color to communicate meaning. This is a surprisingly easy mistake to make, given how culturally-embedded some color associations are. For example, most people associate green with success and red with failure, but these two colors are identical for most colorblind folks!

(We can still use color as a sort of progressive enhancement! But it needs to be a secondary indicator, not the only one.)

Browser devtools allow us to simulate colorblindness. Here's a quick preview in Chrome:

We explore this feature in depth in the solution video for the exercise below. You can also learn more in the Chrome documentation
, and learn how to emulate vision deficiencies in Firefox instead
.

Protanopia vs. Deuteranopia
(info)

Earlier, I mentioned that red-green colorblindness comes in two flavors: protanopia and deuteranopia. What's the difference?

 Show more
Exercises
Fix this UI

This UI has several contrast and color issues. Your mission is to find + fix them:

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

## Selection Colors

Source: /css-for-js/09-little-big-details/04.02-selection-colors

Selection Colors

Throughout this course, we've been using color and background-color to change the colors for the DOM nodes on our page.

What if we want to change the styles of things not clearly identifiable within the DOM, though?

In this lesson, we'll learn how to tweak the colors for text selection, scrollbars, and native form controls.

Selection colors

By default, when we select text, a blue background is applied
*
:

We can tweak both the background and text color for the selection box using the ::selection pseudo-element:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  ::selection {
    color: hsl(25deg 100% 20%);
    background-color: hsl(55deg 100% 60%);
  }
</style>

<p>
  Try selecting some of the text in these paragraphs!
</p>
<p>
  Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.
</p>
Result
Refresh results pane

This is a small detail, but it can be surprisingly charming.

Tweaking selection styles by element

Sometimes, you may wish to use different selection styles for different elements on the page, rather than a single "global" selection style.

For example, on this course platform, I have different selection styles depending on whether you're "on paper" (white background) or "in space" (black background).

Setting this up, however, is surprisingly tricky.

For example, try selecting the text in the paragraph:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In certain browsers, the child <em> will continue to use the default selection styles, like this:

According to the spec
, ::selection styles should be inheritable, but as I write this in September 2025, both Firefox and Safari continue to violate the spec. Fortunately, Chrome has fixed this issue, and hopefully in the future, other browsers will follow suit!

In the meantime, we can use CSS variables to work around the issue:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Essentially, every element on the page has the exact same ::selection styles, but they rely on CSS variables rather than hardcoded values. When we change the value of a CSS variable, the selection styles change, for that element and all of its descendants.

Accessibility concerns
(warning)

There are valid accessibility concerns when it comes to overriding default selection styles.

Changing the default selection styles can cause confusion, especially amongst people who are still developing technological literacy, as well as those with cognitive disabilities.

Personally, because I build products that are aimed at software developers, I'm comfortable tweaking the default selection colors. But you'll need to consider your own product's audience, and see if the benefits outweigh the risks.

It's also important to check that the color and background color are sufficiently high-contrast, as discussed in the Color Accessibility lesson.

Browser support
(info)

This property is universally supported
 across desktop browsers. On mobile, it's supported by Android but not iOS.


---

## Accent Colors

Source: /css-for-js/09-little-big-details/04.03-accent-colors

Accent Colors
(Optional lesson)

When styling certain types of UI (eg. checkboxes, radio buttons, sliders), we've typically had two choices:

Use the browser defaults pretty much as-is
Rebuilt the element from scratch, using more-flexible tags like <button>.

Often, designers will push for custom elements, because the browser defaults clash with the designs.

Fortunately, an upcoming addition to the CSS language is going to give us a third choice: accent colors.

With the accent-color property, we'll be able to change the colors used in a handful of HTML elements:

In the image above, courtesy of Adam Argyle and Joey Arhar
, we see how setting accent-color: hotpink changes a handful of form controls.

The specific appearance of form controls will vary by browser and operating system. The specification shows how accent-color affects radio buttons across platforms

In terms of browser support, this property has been supported in all major browsers
 since March 2022!


---

## Gradients

Source: /css-for-js/09-little-big-details/05-gradients

Gradients

The CSS language has a surprisingly deep and sophisticated set of gradient functions:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .linear {
    background-image:
      linear-gradient(deeppink, red, coral, gold, white);
  }
  .radial {
    background-image: radial-gradient(
      circle at 0% 100%,
      deeppink, red, coral, gold, white
    );
  }
  .conic {
    background-image:
      conic-gradient(deeppink, red, coral, gold, white);
  }
</style>

<section class="wrapper">
  <div class="box linear"></div>
  <div class="box radial"></div>
  <div class="box conic"></div>
</section>
Result
Refresh results pane

In this set of lessons, we'll go deep, exploring how all of these different gradients work, and learning how to do some really cool things with them!


---

## Linear Gradients

Source: /css-for-js/09-little-big-details/05.01-linear-gradients

Linear Gradients

If we provide two colors to linear-gradient, it will interpolate between them, starting from the top and going down:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .box {
    width: 200px;
    height: 200px;
    border: 3px solid;
    background-image: linear-gradient(deeppink, gold);
  }
</style>

<div class="box"></div>
Result
Refresh results pane

If we want the gradient to run at a different angle, we can pass that as an optional first argument:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .box {
    width: 200px;
    height: 200px;
    border: 3px solid;
    background-image: linear-gradient(45deg, deeppink, gold);
  }
</style>

<div class="box"></div>
Result
Refresh results pane

Somewhat confusingly, the default angle for gradients is 180deg. If we set it to 0deg, the gradient would run from the bottom to the top.

As a neat bit of sugar, we can also specify cardinal directions with the to keyword:

.box {
  background-image: linear-gradient(to right, color1, color2);
  /* Is equivalent to: */
  background-image: linear-gradient(90deg, color1, color2);
}

We can pass more than two colors, to create richer gradients:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Gradients have "color stops", points along the spectrum where the color is fully applied. By default, these colors will be equidistant:

We can change their placement, though, using percentages:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

We can use color stops to do something pretty neat and unexpected: we can create sharp lines by positioning the stops very close together:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

I believe you can use the same color-stop value (eg. gold 40%, white 40%), but I prefer to separate them by a fraction of a percentage, to make it clear what's going on here. The visual result is the same, so this is purely a semantics concern.

Gradient hints

In addition to color stops, we also have color hints. A color hint allows us to move the midpoint between two colors:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Both boxes are transitioning between the same two colors, but the effect is quite different!

Normally, the midpoint between two colors is halfway through the space between color stops. Hints allow us to shift that midpoint:

Browser support
(info)

In general, linear gradients have been around for a very long time, and they work in every conceivable browser.

Gradient hints are relatively new; they're supported in all major browsers, but not Internet Explorer.


---

## Radial Gradients

Source: /css-for-js/09-little-big-details/05.02-radial-gradients

Radial Gradients

A radial gradient emanates outwards in a circle from a single point

Gradient Function
linear-gradient
radial-gradient

Here it is in code:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .box {
    width: 200px;
    height: 200px;
    border: 3px solid;
    background-image: radial-gradient(
      deeppink,
      red,
      coral,
      gold,
      white
    );
  }
</style>

<div class="box"></div>
Result
Refresh results pane

In some ways, the different gradient functions in CSS are quite similar. They all work on the principle of accepting multiple color stops and hints, and interpolating color between them.

They do have some differences, though!

The optional first argument for radial gradients is a bit funky. It's sort-of a position, sort-of a size.

Here's an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

We're saying that the gradient's "core" should span half of the available width, and the full height. This creates a tall, skinny ellipse.

Gradient ellipses get really complicated really fast, and honestly, I've never found I needed to go down that rabbit hole. Instead, let's focus on circular radial gradients.

We can "lock in" the shape using the circle at prefix. We'll use it here to create a sunset effect:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Here's how this works: we're creating a circular gradient centered at (50%, 100%) — the midpoint along the bottom edge. The colors radiate outwards from this point, and I use color stop percentages to define the shape I want.

Gradient sunset
(success)

Codepen user Marty
 has created a ridiculously beautiful interactive sunset using linear and radial gradients:

Check it out for yourself on Codepen
!

If you're interested in going deeper and learning the ins and outs of radial gradients, MDN has a fantastic in-depth article on the subject
.


---

## Conic Gradients

Source: /css-for-js/09-little-big-details/05.03-conic-gradients

Conic Gradients

Conic gradients are the newest member of the gradient family, and they're nifty.

Gradient Function
linear-gradient
radial-gradient
conic-gradient

Conic gradients are what would happen if you took a straight line with a linear gradient, and formed it into a circle:

Like our other gradient functions, this one looks pretty similar:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .box {
    width: 200px;
    height: 200px;
    border: 3px solid;
    background-image: conic-gradient(
      deeppink,
      red,
      coral,
      gold,
      white
    );
  }
</style>

<div class="box"></div>
Result
Refresh results pane

Browser support
(info)

Conic gradients are supported by all major browsers
, but not supported in Internet Explorer.

Smoothing it out

By default, we wind up with a pretty harsh line running vertically through the top half. This is because our start and end colors are so different! Unlike the other gradient functions, we don't get a seamless blended result automatically with conic gradients.

If our gradient ends with the same color it started with, we can create a smoother effect:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Alternatively, we can make all of the lines harsh, by shifting the color stops to be adjacent.

This can be useful for creating pie charts!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane
Gradient angle and position

Linear gradients are given an angle (eg. 45deg), and radial gradients are given a position (circle at 50% 100%). Conic gradients take both.

The format is as follows:

from <angle> at <position>

This format is pretty weird, but it becomes intuitive with a bit of experimentation. Try it out here:

from 0deg at 50% 50%
Angle
0deg
Horizontal Offset
50%
Vertical Offset
50%

Let's get some practice. Using this tool, can you recreate these two images?

Solutions
(info)

Here are the settings to recreate the two gradients shown above:

 Show more
Recipes

Let's look at some things we can use conic gradients for!

Edge glow

One of the most practical, useful use cases for conic gradients is to create a glow effect, like this:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Here's the strategy: we push the gradient down so that we only see the top half of it. Then, we control the colors from 50% to 100%:

Overall, conic gradients are still somewhat uncommon on the web, but they have some really practical use cases! It's worth having this tool in your toolbelt.

Metal knob

We can simulate a brushed metal aesthetic with a bunch of greyscale colors:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The era of skeuomorphism is gone, but if it ever makes a comeback, we'll be all set!


---

## Easing Gradients

Source: /css-for-js/09-little-big-details/05.04-easing-gradients

Easing Gradients

Remember how in Module 8, in the context of the CSS transition property, we talked about timing functions like linear and ease-out?

Those timing functions refer to how a value should be interpolated over time. But those same functions can also refer to how to interpolate something over space.

Let's imagine we're moving a box by 100px over 10 seconds. In a linear timing function, it will move by 10px every second.

Now, let's imagine we're drawing a gradient from a hue of 0 degrees, to a hue of 40 degrees, over 10rem. In a linear timing function, the color changes by 4 degrees every rem.

But just like we can choose a different timing function for motion, we can also choose a different timing function for gradients!

Here's what this looks like. Play around with the different options to get a feel for it:

Timing Function
linear (default)
ease
ease-in
ease-out
ease-in-out
linear (default)

No matter which timing function you choose, the start and end colors remain constant. We're adjusting how the two colors are mixed in-between.

This turns the corner from "interesting" to "practical" when we apply it to an overlay gradient:

“Dogs From Above”
Timing Function
linear (default)
ease-in-out
ease-in
ease-out
ease
linear (default)

As with motion, a linear timing function produces an abrupt, artificial effect. When we apply ease-in-out, the gradient becomes smooth and organic. No more harsh line at the top!

Using easing gradients

Unfortunately, easing gradients aren't a part of the CSS language yet (though there is an active proposal for it!
).

In the future, hopefully we'll be able to specify them as easily as this:

.box {
  background-image: linear-gradient(
    to bottom,
    hsla(330, 100%, 45%, 1),
    ease-in-out,
    hsla(210, 100%, 45%, 1)
  );
}

In the meantime, we'll use a tool that will simulate these timing functions by generating a bunch of color stops:

.box {
  /* Simulated "ease-in-out": */
  background-image: linear-gradient(
    to bottom,
    hsl(330, 100%, 45.1%) 0%,
    hsl(331, 89.25%, 47.36%) 8.1%,
    hsl(330.53, 79.69%, 48.96%) 15.5%,
    hsl(328.56, 70.89%, 49.96%) 22.5%,
    hsl(324.94, 63.52%, 50.4%) 29%,
    hsl(319.21, 54.99%, 50.3%) 35.3%,
    hsl(310.39, 46.14%, 49.68%) 41.2%,
    hsl(296.53, 39.12%, 49.7%) 47.1%,
    hsl(280.63, 42.91%, 53.43%) 52.9%,
    hsl(265.14, 47.59%, 56.84%) 58.8%,
    hsl(250.13, 52.52%, 59.88%) 64.7%,
    hsl(235.88, 59.2%, 60.91%) 71%,
    hsl(225.81, 68.23%, 57.85%) 77.5%,
    hsl(218.93, 74.97%, 54.21%) 84.5%,
    hsl(213.89, 79.63%, 49.97%) 91.9%,
    hsl(210, 100%, 45.1%) 100%
  );
}

The tool I use is this web-based tool by Andreas Larsen
. If you use PostCSS, there's a plugin
 you can use as well.

It's a small detail, but upgrading to easing gradients can really make a product feel polished.

A caveat with this tool
(warning)

The tool produces a CSS snippet that looks like this:

.forNow {
  linear-gradient(
    ...
  );
};

Curiously, this snippet is incomplete. linear-gradient is a value, but it's missing the property!

Update it to use background-image:

.forNow {
  background-image: linear-gradient(
    ...
  );
};

---

## Exercises

Source: /css-for-js/09-little-big-details/05.05-gradient-exercises

Exercises
Image overlay gradient

Earlier, we saw how an easing gradient can remove the harsh line on image overlays:

Let's create this UI from scratch, using an easing gradient to smooth out the harsh transition.

To generate the easing gradient, you can use Andreas Larson's Easing Gradients tool
.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<!--
  Acceptance criteria:

  • Image should be 300px by 200px.
  • Gradient should be 100px tall.
  • Gradient should max out at 85%
    opacity
-->
<style>

</style>

<figure>
  <img
    class="photo"
    alt="Two upside-down dog heads"
    src="https://courses.joshwcomeau.com/cfj-mats/upside-down-dogs.jpg"
  />
  <figcaption>“Dogs From Above”</figcaption>
</figure>
Result
Refresh results pane

Solution:

Solution code
(success)

 Show more
Overlapping shapes

Gradients can be used to create some pretty nifty patterns.

For example, with linear-gradient, we can create these overlapping triangles:

We can use radial-gradient to create overlapping circles:

Your task is to recreate both of these effects! You should have a different class for each background (eg. .linear-slopes, .radial-slopes).

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

Thanks to students spk265 and Erik André for helping come up with this exercise
!

Trophy display

As we've seen, conic gradients can be used to create a glow / spotlight effect. I use this effect on the course marketing page
 as a decorative flourish, for the highest tier:

Your goal is to update the code playground below to create a similar effect. Here's the mockup:

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

## Gradient Dead Zones

Source: /css-for-js/09-little-big-details/05.06-gradient-dead-zone

Gradient Dead Zones

Have you ever noticed that sometimes, gradients get a bit "grey" in the middle?

Dead zone

This happens because gradients in CSS are essentially like your car's GPS: it will try and take the shortest, most direct route between two colors, using RGB values.

We can approximate this effect by drawing a line on the color wheel:

What if, instead, we took the scenic route? If we curve around the color wheel, we'll wind up with a much nicer-looking gradient:

Here's the before/after:

By picking saturated midpoint colors, we create a much more vibrant gradient!

How do we come up with appropriate midpoint values? As it happens, I have a blog post all about this! Check it out, if you'd like a deeper dive: “Make Beautiful Gradients”
.

I've also created a handy tool that will generate gradients for you:

Gradient Generator

Finally, there's also an entry in the Treasure Trove that digs a bit deeper into the design aspect (coming up with nice gradient colors), and shares some additional tools.


---

## Mobile UX Improvements

Source: /css-for-js/09-little-big-details/06-mobile-ux

Mobile UX Improvements

Mobile browsers are remarkably similar to their desktop counterparts, considering they’re running in totally different contexts. But there are some differences that we need to be aware of.

In this lesson, we'll look at some specific usability improvements for mobile devices.

Tap rectangles and text selection

When tapping an interactive element on mobile devices, the browser will flash a "tap rectangle" briefly.

For example, here's what happens when we tap the 3D button explored earlier in the course:

Notice the grey rectangle that flashes quickly? The color varies between iOS and Android, but the effect is constant.

Why does it do this? Well, the box can serve as helpful feedback, to confirm that you've successfully tapped an interactive element. But our button offers plenty of feedback as-is, so we don't need it in this case.

We can remove it with this declaration:

.pushable {
  -webkit-tap-highlight-color: transparent;
}

One more thing: on iOS, if the button is held down for a second, the phone will try and select the text within the button:

The user-select property allows us to set an element to be unselectable:

.pushable {
  user-select: none;
}

With great power comes great responsibility. We should exercise great caution when disabling browser features meant to improve usability! In this case, I feel pretty confident that we are improving the experience, not degrading it, but these properties should be used extremely conservatively.

Increasing target sizes

As we talked about in Module 5, there are several categories of input devices:

“fine” pointers, like a mouse or trackpad
“coarse” pointers, like a finger on a touchscreen or a gesture in front of a Kinect
non-pointer devices, like the keyboard

It's hard to be precise with a coarse pointer. Given that mobile users typically use a touchscreen with a finger, we need to ensure that our interactive elements have a large tappable area.

Apple recommends a minimum tap target size of 44 pixels by 44 pixels. This is a minimum, though; it's better to overshoot this target.

Here's a little trade secret, though: this doesn't mean that we have to make everything visually bigger.

Consider this example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Our button has a pseudo-element that extends outwards by 8px in every direction. Our button may only be 32px tall, but the tap target size is 48px:

Here's how this works:

Make sure the link/button is a containing block for positioned elements by setting position: relative (assuming it's not already being set!)
Add a child pseudo-element, and make it absolutely-positioned.
Set top / left / right / bottom to a negative value, so that it extends outwards.

This trick allows us to increase the size of the tap target without affecting the design, which can be indispensable in some situations.

Automatically calculating tap targets
(success)

Is there a way to abstract away this calculation, so that our pseudoelements automatically become at least 44px by 44px?

Discord user Kevin (@third774) came up with a rather clever way to do this, using calc:

 Show more

---

## Pointer Events

Source: /css-for-js/09-little-big-details/07-pointer-events

Pointer Events

When you send a tweet on Twitter, a little toast notification lets you know that it was successful. It also creates an invisible barrier:

If we dig into the code, we'll discover the problem: that small blue toast notification is housed in a much larger container:

Now, we could solve this problem by updating the structure to not need a big honking parent container. Using fixed positioning and the auto-margin trick, we could add the toast element without a larger invisible parent:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .toast {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 32px;
    margin: auto;
    /* Firefox requires a vendor prefix */
    width: -moz-fit-content;
    width: fit-content;
  }
</style>

<button class="random">
  Random button
</button>

<div class="toast">
  No parent required!
</div>
Result
Refresh results pane

But what if we couldn't? What if we needed a parent, so that we could use CSS Grid to set up a complex layout of floating elements?

That's where the magic of pointer events comes in.

Browser support
(info)

pointer-events has magnificent browser support
 — all modern browsers, plus IE11.

Disabling pointer events

The pointer-events property allows us to set an element to be a hologram: you can see it, but you can't touch it.

Try clicking this button to see what I mean:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

We can still focus the button using the keyboard, and we can still select the text in some browsers. But we can't trigger a click event on it. Clicks pass right through.

Here's the really wild thing, though: we can ‘undo’ pointer-events in descendants!

We can set a parent to ignore pointer-events, but then restore the default value (auto) to a child. The child will support clicks/taps, but the parent won't.

Let's use this delightful behavior to our advantage in our toast-notification problem:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The .toast-wrapper will ignore clicks, so that we can click the .random button behind it. But its child, .toast will happily accept pointer interactions.

Being able to selectively ignore clicks without locking anything in for the element's descendants is a pretty wild super-power. This trick has gotten me out of a few jams now.


---

## Clipping With clip-path

Source: /css-for-js/09-little-big-details/08-clip-path

Clipping With clip-path

One of the most underrated CSS properties is clip-path. It's incredible.

clip-path allows us to trim a DOM node into a specific shape. For example, here we can use it to create a triangle:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .triangle {
    width: 100px;
    height: 80px;
    background-color: deeppink;
    clip-path: polygon(
      0% 100%,
      50% 0%,
      100% 100%
    );
  }
</style>

<div class="triangle"></div>
Result
Refresh results pane

Like the transform property, clip-path has no effect on layout. An element with clip-path applied will still take up the same amount of space in the DOM.

For a long time, we had to rely on hacky tricks like using transparent borders to create shapes in CSS. These days, it's way easier with clip-path.

There are several ways to use clip-path, but for now we'll focus on the polygon() function.

This function relies on a coordinate system. We'll explore that system in this video:

Correction: When drawing the diagonal hourglass shape, I draw the points in the wrong order, based on how I added the dots 🙈 It should go from left to right to top to bottom.

Clippy
(success)

Using the polygon function, we can manually come up with the values for simple shapes like triangles or hourglasses. But what if we want something more complex?

A wonderful tool created by Bennett Feely lets us create clip-path strings using a dynamic, interactive UI.

Learn more in the Treasure Trove

Browser support
(info)

clip-path is supported across all major browsers
. Like so many nice things, though, it isn't supported in Internet Explorer.

Technically, the property is only partially supported in Chrome and Safari, but all of the stuff in this lesson is supported by all browsers. "Partial support" refers to the fact that we can't reference paths defined in external SVGs, an edge-case we don't need to worry about.


---

## Animations

Source: /css-for-js/09-little-big-details/08.01-animated-clip-path

Animations

Even as a static property, clip-path is very cool. The fact that it can be animated using transition or keyframe animations makes it even cooler!

Try focusing or hovering over this triangle to see the effect:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .triangle {
    clip-path: polygon(
      0% 100%,
      50% 0%,
      100% 100%
    );
    transition: clip-path 250ms;
    will-change: transform;
  }

  .triangle-wrapper:hover .triangle,
  .triangle-wrapper:focus .triangle {
    clip-path: polygon(
      0% 50%,
      100% 0%,
      50% 100%
    );
  }
</style>

<button class="triangle-wrapper">
  <span class="triangle" />
</button>
Result
Refresh results pane

In order for transition to work, both polygon definitions need to have the same number of points. It works by interpolating each point; in the example above, the first point goes from (0%, 100%) to (0%, 50%), moving straight up by half of the available height.

If you do wish to animate between two elements with a different number of points, you'll need to cheat by adding multiple points in the same spot. For example, here's how to transform a 4-pointed “stop” button into a 3-pointed “play” button:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .triangle {
    clip-path: polygon(
      0% 0%,
      100% 0%,
      100% 100%,
      0% 100%
    );
    transition: clip-path 250ms;
    will-change: transform;
  }

  .triangle-wrapper:hover .triangle,
  .triangle-wrapper:focus .triangle {
    clip-path: polygon(
      0% 0%,
      100% 50%,
      100% 50%,
      0% 100%
    );
  }
</style>

<button class="triangle-wrapper">
  <span class="triangle"></span>
</button>
Result
Refresh results pane

The end state still has 4 points, but the middle two points are in exactly the same spot, and so it appears to produce a 3-sided shape.

Animated clip-paths unlock a ton of interesting options for unique micro-interactions and animations.

Layer promotion
(info)

You may have noticed something a bit curious: we're changing the clip-path property, but we've set will-change: transform! Why not will-change: clip-path?

In Chrome (and possibly other browsers), setting will-change: transform will promote the element to its own layer. Curiously, setting will-change: clip-path doesn't have the same effect. As a result, a larger surface area needs to be painted on each frame.

In my anecdotal experience, setting will-change: transform appears to cut the average paint time from ~20ms to ~0.5ms.

Incidentally, Chrome has signaled that they're working on implementing hardware acceleration for clip-path
.


---

## Rounded Shapes

Source: /css-for-js/09-little-big-details/08.02-round-shapes

Rounded Shapes

The polygon function is great for cutting a shape out of straight lines, but what if we want a rounded shape?

clip-path supports both a circle function and an ellipse function:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    clip-path: ellipse(
      100px 80px at 50% 50%
    );
  }
</style>

<div class="wrapper">
  <img src="https://courses.joshwcomeau.com/cfj-mats/architecture-joel-filipe.jpg" />
</div>
Result
Refresh results pane

The syntax looks like this:

.wrapper {
  clip-path: ellipse(
    xRadius yRadius at xPosition yPosition
  )
}

This effectively makes it like a super-charged border-radius. We can choose exactly which part of the element we want to crop. We can create funky off-center cuts like this:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    clip-path: ellipse(
      100px 200px at 50% 80%
    );
  }
</style>

<div class="wrapper">
  <img src="https://courses.joshwcomeau.com/cfj-mats/architecture-joel-filipe.jpg" />
</div>
Result
Refresh results pane

Like with polygonal clip-paths, we can also animate circular clip-paths! Try focusing or hovering over the image below:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Path definitions
(info)

We can also specify a path definition. path is beyond the scope of this course, but it allows us to draw complex shapes that leverage straight lines and curves (using arcs and béziers):

 Show more

---

## With Shadows

Source: /css-for-js/09-little-big-details/08.03-with-shadows

With Shadows

Here's something a bit curious: why isn't there a shadow visible on this element?

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .triangle {
    clip-path: polygon(
      0% 100%,
      50% 0%,
      100% 100%
    );
    filter: drop-shadow(
      1px 2px 4px hsl(0deg 0% 0% / 0.5)
    );
  }
</style>

<div class="triangle"></div>
Result
Refresh results pane

The reason is that filters are applied before clip-path. There's an order of operations here, and it means that the shadow is being clipped out.

We can solve this by moving the drop-shadow to the parent element:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .wrapper {
    filter: drop-shadow(
      1px 2px 4px hsl(0deg 0% 0% / 0.5)
    );
  }
  .triangle {
    clip-path: polygon(
      0% 100%,
      50% 0%,
      100% 100%
    );
  }
</style>

<div class="wrapper">
  <div class="triangle"></div>
</div>
Result
Refresh results pane

We need to use filter: drop-shadow because box-shadow won't contour the clipped shape, it'll add the shadow to the rectangular box-model container.

This is a fairly common gotcha, but fortunately, the workaround isn't too much trouble!


---

## Exercises

Source: /css-for-js/09-little-big-details/08.04-exercises

Exercises
Drop-in text

Using clip-path and a keyframe animation, recreate the following effect:

For bonus points, use a transform to accentuate the effect!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .highlighted {
    background: hsl(50deg 100% 70%);
    padding: 12px 24px;
    font-size: 1.25rem;
    font-weight: bold;
    width: -moz-fit-content;
    width: fit-content;
    border-radius: 4px;
  }
</style>

<p class="highlighted">
  The World's Best Keyboard
</p>
Result
Refresh results pane

Solution:

Solution code
(success)

 Show more
Rising nav link

In this exercise, our goal is to recreate this effect:

As we saw in the last module's workshop, we'll need to edit the markup in order to achieve this effect. Be sure to think about the accessibility implications as well.

For the pink color, you can use hsl(333deg 100% 50%) (or any color you like!).

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

---

## Optical Alignment

Source: /css-for-js/09-little-big-details/09-optical-alignment

Optical Alignment

Let's suppose we have a heading inside a container with 32px of padding:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  .card {
    padding: 32px;
    border-radius: 4px;
    background: white;
  }
  h2 {
    font-size: 2rem;
  }
</style>

<article class="card">
  <h2>Hello World</h2>
</article>
Result
Refresh results pane

This box has even padding, 32px on each side. But if we actually measure it, we'll discover that the padding is far from symmetrical:

Why is there so much extra padding on top??

It's because we're not measuring from the container to the characters themselves. We're measuring to the text selection box:

This is unfortunate, because it means that if we use symmetrical padding, our element will appear misaligned!

Instead of aligning things based on the mathematical values, we should align things based on their perceived symmetry. This is known as optical alignment.

We've touched on optical alignment a bit in this course already. In this lesson, we're going to go deeper, learn why this is an issue, and see how to solve for it.

Translating designs

To understand why this is an issue, we need to consider how typography is rendered in design software like Figma.

Here's the same text, at the same size, rendered in Figma:

In design software, text nodes will have a tiny amount of space around them (the reason there's more space along the bottom is for letters that descend, like j or p).

This is why our implementation won't quite look right even if we use the exact same values that we see listed in Figma! The numbers can't be trusted, because typography is handled differently between design software and the web.

We'll explore in this video:

Learn more about measuring distances on-screen with my Treasure Trove entry, “Measuring Pixels”.

Reconciling optical alignment and design tokens

It's common in modern design systems to use space tokens which correspond to specific pixel/rem values.

To use Tailwind as an example: Instead of applying a pixel value for padding, you typically use utility classes:

p-1: 0.25rem
p-2: 0.5rem
p-3: 0.75rem
p-4: 1rem
p-5: 1.25rem
…And so on

The goal with these spacing systems is to ensure consistent spacing across an application, so that every possible space is selected from a finite scale. This would be great if spacing on the web was internally consistent. But as we've seen, it isn't.

Ironically, by exclusively selecting values from a spacing system like this, you're ensuring that your app will have inconsistent spacing.

If spacing is important to you, your only real choice is to step outside the scale and apply bespoke spacing when necessary.

Future solutions
(info)

This is a Known Problem, one that is currently being worked on.

The drafted leading-trim and text-edge properties will allow us to remove this extra vertical space, to more closely approximate how text is laid out in design software (and, frankly, everywhere that isn't the web).

Unfortunately, it's still very early days; it hasn't been implemented in any browsers
.

For now, we'll need to tackle this the hard way.

Utility components

For shifting individual elements around, like the number in the notification badge, I created a utility component:

function ShiftBy({
  x = 0,
  y = 0,
  children,
  as = "div",
  style = {},
  ...delegated
}) {
  const Element = as;

  return (
    <Element
      style={{ transform: `translate(${x}px, ${y}px)` }}
      {...delegated}
    >
      {children}
    </Element>
  );
}

This component is used like this:

<Notifications>
  <ShiftBy y={1}>
    {numOfNotifications}
  </ShiftBy>
</Notifications>

Having a utility component makes it easy to make quick adjustments for optical alignment.

In cases where we need to cancel some padding, like the "Hello World" heading example, we should use negative margin instead of transform: translate. This component could be updated to support either transforms or negative margins to make it even more useful!
*

Pixel perfection

I published a blog post all about optical alignment and pixel-perfect implementations. It builds on the ideas discussed in this lesson.

Read it here: “Chasing the Pixel-Perfect Dream
”.


---

## Scrolling

Source: /css-for-js/09-little-big-details/10-scrolling

Scrolling

Scrolling is probably the most fundamental gesture on the web. Almost every website and web application is built on the notion that the page should be scrollable in at least 1 direction!

While we almost never want to mess with the scroll gesture itself, there are a ton of ancillary things we can do to improve the overall scroll experience!

In these lessons, we'll learn how to support smooth scroll-to-element, implement mobile-app style scroll snapping, and more!


---

## Smooth Behavior

Source: /css-for-js/09-little-big-details/10.01-smooth-scrolling

Smooth Behavior

There are a few problems that used to be Hard JavaScript Problems, but are now Easy CSS Problems. Smooth scrolling is one of them.

For context, let's imagine that our HTML looks like this:

<h2 id="chapter-2">Chapter Two</h2>

<a href="#chapter-3">Skip to Next Chapter</a>

<p><!-- Content excluded --></p>
<p><!-- Content excluded --></p>
<p><!-- Content excluded --></p>
<p><!-- Content excluded --></p>

<h2 id="chapter-3">Chapter III</h2>

When the user clicks on the "Skip to Next Chapter" link, they'll be scrolled down the page, so that the "Chapter III" heading is at the top of the viewport.

By default, this process is instantaneous. The user is teleported to the new location. But what if we could smooth out the process?

Here's an example, taken from this very course platform!

We can enable it site-wide with 1 CSS declaration:

@media (prefers-reduced-motion: no-preference) {
  html {
    scroll-behavior: smooth;
  }
}

It's important to gate this property behind a prefers-reduced-motion media query; the fast-scrolling animation is exactly the sort of motion that can be problematic for some people.

Smooth scrolling is disabled by default. The default value for the scroll-behavior property is auto, which jump-cuts the user to the new location.

Scroll-jacking
(warning)

In this lesson, we're focused exclusively on action-driven scrolling — the user clicks a link or a button, and the browser takes them to the appropriate place.

You might be wondering how to implement "general" smooth scrolling, so that when the user scrolls through the page, a smooth effect is used.

This is known as “scroll-jacking, and it's never a good idea. Most people hate when a website changes how it feels to scroll up/down the page. It feels like a loss of control.

It's also impossible to do well. You might create the most natural-feeling scroll effect for folks using finger scrolling, but that same effect will feel terrible for someone using a mouse wheel. There is a surprisingly wide array of scroll inputs used, and they all have different characteristics. There is no smooth scrolling that works well for all of them.

Browser support
(info)

As of September 2024, this property is available in all major browsers, and is sitting at ~95% support. 🎉

I also don’t think we really need to worry about browser support for features like this. Smooth scrolling is a perfect use case for progressive enhancement — folks on supported browsers will have a slightly improved experience, but the product will still be perfectly usable for folks using Internet Explorer.

If you really need to support this feature universally, a battle-tested polyfill
 does exist. And you can see up-to-date support on caniuse
.

Customizing the scroll behavior

scroll-behavior doesn't let us tweak the duration or easing of the scroll animation. It's up to the browser and the operating system.

Believe it or not, though, I think this is a good thing.

To understand why, we need to understand what the point of smooth scrolling is.

In my opinion, it's not really about polish or branding. It's a usability feature; Smooth scrolling provides continuity, a sense of cohesion between where you started and where you landed. It prevents the disorientation that comes from clicking a link and suddenly being teleported to a different part of the page.

We don't actually want the user to consciously notice the scroll animation, though. It should serve as a subconscious cue, something that happens in the background. By not letting developers customize smooth scrolling on a site-by-site basis, the experience is consistent and familiar. Which is exactly what we want.

Accessing in JavaScript

Sometimes, we want to control scroll position from within JavaScript. For example, maybe we want to scroll the user to the top of the page when they submit a form:

function handleSubmit(ev) {
  window.scrollTo(0, 0);
}

By default, the scrollTo method will inherit the behavior specified in CSS. If you've added scroll-behavior: smooth to the html tag, window.scrollTo will automatically be smooth!

We can also manually specify scroll behaviour, using the long-form version of this method:

const prefersReducedMotion = getPrefersReducedMotion();

window.scrollTo({
  top: 0,
  left: 0,
  behavior: prefersReducedMotion ? 'auto' : 'smooth',
});

Note that we want to first check if the user has expressed a preference for motion; the getPrefersReducedMotion function is defined in the “Animation Accessibility” lesson

Scrolling into view

The scrollTo method takes a pixel value. This is good for scrolling users to the very top of the page, but what if you want to scroll them to a particular element? Like, say, the main heading of the page?

The scrollIntoView method is perfect for this:

const prefersReducedMotion = getPrefersReducedMotion();

const target = document.querySelector('.title');

target?.scrollIntoView({
  behavior: prefersReducedMotion ? 'auto' : 'smooth',
});

Like scrollTo, scrollIntoView can opt into smooth scrolling. Learn more about it on MDN
.

(If you haven't seen the ?. operator before, it's called the Optional Chaining operator
, and it's a wonderful addition to JS!)

SPA trouble

If you're working in a single-page application (eg. a React app), you may notice some curious behaviour with smooth scrolling.

For example, if I was to enable smooth scrolling app-wide on this course platform, this would be the experience when changing lessons:

In a traditional server-rendered application, clicking a link would load an entirely new HTML file, with the scroll position being instantly reset to the top. In a SPA, though, the navigation happens client-side.

On this course platform, the user is scrolled to the top of the page when a new lesson is loaded, but this happens from within JS! So when the JS framework tries to restore the scroll position, simulating a traditional server-rendered application, smooth scrolling gets in the way.
*

There are other little issues too. For example, closing a full-screen playground triggers a weird animated scroll.

To solve these problems, I've disabled page-wide smooth scrolling, and opted in on a case-by-case basis.

We can create a SmoothScrollTo component that uses smooth scrolling for specific links:

function SmoothScrollTo({ id, children }) {
  const prefersReducedMotion = usePrefersReducedMotion();

  function handleClick(ev) {
    // Disable the default anchor-clicking behavior
    // of scrolling to the element
    ev.preventDefault();

    const target = document.querySelector(`#${id}`);
    target?.scrollIntoView({
      behavior: prefersReducedMotion ? 'auto' : 'smooth',
    });
  }

  return (
    <a
      href={`#${id}`}
      onClick={handleClick}
    >
      {children}
    </a>
  )
}

usePrefersReducedMotion is a React hook I've created that performs the prefers-reduced-motion check. You can learn more about it in my blog post, Accessible Animations in React
.

Using this method, we can be very precise with our smooth-scrolling, while still leveraging the native behavior built into the browser.

Because we're still rendering an <a> tag, everything else still works as you'd expect; links can be opened in new tabs, and the page will still work even with JS disabled (assuming the React application is server-side rendered).


---

## Scroll Snapping

Source: /css-for-js/09-little-big-details/10.02-scroll-snapping

Scroll Snapping

Let's suppose that we're implementing a mobile design based around the idea of swiping side-to-side with your thumb:

We start by creating a container element with overflow: auto, and stuffing it with full-width elements:

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
    height: 100%;
    overflow: auto;
  }
  .box {
    min-width: 100%;
  }
</style>
<div class="wrapper">
  <div class="box one">
    First Box
  </div>
  <div class="box two">
    Second Box
  </div>
  <div class="box three">
    Third Box
  </div>
  <div class="box four">
    Fourth Box
  </div>
</div>
Result
Refresh results pane

This works, but it's loosey-goosey. With the standard momentum-based scrolling, we're flying all over the place:

We want to implement scroll snapping, so that when the user stops scrolling, the scroll automatically shifts so that the nearest element is fitted to the screen.

Fortunately, these days, we can do this in a couple lines of CSS!

Browser support
(info)

CSS scroll-snapping is surprisingly well-supported
 — it exists in all modern browsers, and is even partially supported in IE!

Similar to CSS Grid, Internet Explorer implements an older version of the scroll-snapping spec. We won't be covering the old way in this lesson. In most cases, scroll-snapping is a progressive enhancement, and not something we need universal support for.

Implementation

There are two primary scroll-snap properties:

scroll-snap-type — this controls the direction and precision of the scroll snapping.
scroll-snap-align — this controls which part of the child we want to snap.

Here's how these properties get used:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Not working for you?
(warning)

If you aren't experiencing scroll-snapping in this playground, it's likely that the playground's iframe is interfering with it!

You might need to click inside the "Result" pane to focus the inner document, within the iframe.

If that still doesn't work, you can try it out in a real document
, outside of an iframe.

scroll-snap-type goes on the parent, and we control which axis we want to snap to. We also need to give it a "precision", either mandatory or proximity.

mandatory means that the element will always snap, no matter what. If the element has been scrolled by 49%, it will snap back to the beginning. If it's 51%, it'll jump to the next one:

proximity is more subtle, and it only triggers a snap when the user is near a snap point:

What exactly does "near" mean, in this case? The specific heuristics are controlled by the browser. We can't control where the threshold is.

The second property is scroll-snap-align. This property lets us set the snap point for the children. In this case, we chose start, since we want the left edge of the element to snap to the left edge of the container.

In other situations, we may wish to snap to the center of the element. Center snap alignment helps when we want to see "previews" of sibling elements on either side:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In the playground above, with scroll-snap-align: center, each element has an anchor in the very middle, and that anchor snaps to the center of the parent container:

Compare this to scroll-snap-align: start, where the anchor is on the left edge of the element, snapping to the left edge of the container:

Exercises
Musical Artists

Alright, let's apply these ideas to a more-realistic scenario!

Suppose we're building a Spotify-type application, and we want to show a horizontal list of related artists. When scrolling side-to-side, we want to snap it so that each artist is centered in the viewport:

Remember, you might need to click within the “Result” pane to enable scroll snapping! In some browsers, scroll snapping only works when the iframe has focus.

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

## Scrollbar Colors

Source: /css-for-js/09-little-big-details/10.03-scrollbar-colors

Scrollbar Colors

Styling the scrollbar is somewhat controversial.

There are some folks who feel like the scrollbar shouldn't be touched, that it's a native part of the web and we shouldn't subvert user expectations by getting creative with the scrollbar.

There's an important distinction, though, between two different ways to tweak scrollbar styles:

We can make the scrollbar ostentatious, brightly-colored, as a design statement.
We can tweak the scrollbar so that it fits the theme of our application, helping it blend in.

If we veer too far away from the platform default, some users might not recognize that it's a functional scrollbar. They might assume it's a border, and not even attempt to use it to navigate. As a result, some say that this is a potential accessibility issue.

That said, I believe it's possible to use custom scrollbar styles that improve the user experience. For example, on this course platform, I use custom scrollbar styles to help the scrollbar "blend in", and prevent it from calling too much attention to itself.

Here's what it would look like (on Chrome + macOS) without custom scrollbar styles:

By choosing more-subtle colors, the sidebar blends in with the application. It's still clearly recognizable as a scrollbar, but it isn't monopolizing the user's focus.

Examining scrollbars

Before we start splashing colors on the scrollbar, let's learn some terminology!

The scrollbar is made up of at least 2 components: the thumb and the track:

Every operating system has its own scrollbar, and this scrollbar will be used for just about all applications. This means that scrollbars aren't usually browser-specific, they're OS-specific.

Here are the current scrollbars for macOS and Windows:

macOS

Windows

There is no universal standard when it comes to scrollbar thickness. Historically, they've hovered between 12px and 17px wide, but we shouldn't make any assumptions about their width.

Scrolling on mobile devices is a bit different. On mobile, there is no visible scrollbar. When you drag the screen, a thumb appears along the right edge, to provide context for where you are on the page.

As we've discussed in the overflow lesson, macOS will mimic this "mobile-style" floating scrollbar if you're using a supported peripheral, something like a trackpad or magic mouse:

Changing colors

The CSS specification does provide a nifty CSS property to tweak scrollbar colors:

body {
  scrollbar-color: color1 color2;
}

scrollbar-color accepts two color values. The first color is for the thumb, the second color for the track.

Unfortunately, these properties are only supported in Firefox at the moment. For all other browsers, we'll need to rely on legacy vendor-prefixed alternatives.

They work a bit differently. Instead of a unique property, we'll use the familiar background-color property, but apply it on global pseudo-elements:

::-webkit-scrollbar {
  /* Track color */
  background-color: color2;
}

::-webkit-scrollbar-thumb {
  /* Thumb color */
  background-color: color1;
}

By combining both sets of styles, we achieve fantastic browser support
. IE is missing, but surely that isn't a problem for a nice-to-have thing like scrollbar colors.

We can assemble them both into a complete working demo:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

On Firefox, the end result is a native-looking scrollbar with new colors. But on other browsers, we wind up with a bit of a different result:

Firefox

Chrome

Why is the non-Firefox scrollbar so clunky and 8-bit? Well, by specifying a custom color, we reset all of its native properties. It's like how operating systems come with their own button styles, ones that disappear when you tweak the border or background.

Here's the good news, though: many CSS properties can be used inside the -webkit-scrollbar pseudo-elements!

By using border and border-radius, we can create something that looks roughly the same across all browsers:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

We can't use padding to increase the space around the thumb, but we can fake it with a border that matches the track color.

A :hover pseudoselector allows us to brighten the color on mouse-over.

Mobile scrollbar styles

In my experimentation, we can't tweak the scrollbar styles on iOS. Even though the properties are supported in iOS safari, they appear to have no effect.

In Android, the scrollbar styles work as you'd expect.

But that begs the question: should we style mobile scrollbars?

On mobile devices, the scrollbar doesn't take up any space; the thumb floats above the content. And it's fairly inobtrusive. If our goal is to create a well-blended scrollbar, our custom CSS might do more harm than good!

Therefore, I wrap my scrollbar styles in a media query:

@media (pointer: fine) {
  html {
    scrollbar-color: /* ... */;
  }

  ::-webkit-scrollbar {
    /* ... */
  }
  ::-webkit-scrollbar-thumb {
    /* ... */
  }
}

Unfortunately, there is no "mobile devices only" media query. I think the best option is to use pointer: fine, even though it’s not perfect; it means our scrollbar styles won’t be applied for folks who use a computer without a mouse/trackpad, for example. But given that the custom scrollbar styles are a cosmetic enhancement, I don’t think we need 100% accuracy here.

Previous versions of this lesson used min-device-width, which has since been deprecated, and min-width, which isn’t as accurate as pointer: fine. Thanks to Discord user Darmovys for the suggestion!


---

## Scroll Optimization

Source: /css-for-js/09-little-big-details/10.04-scroll-optimization

Scroll Optimization

There are a couple handy optimizations we can add, to improve the experience when it comes to scrolling.

Scroll margin

As we saw in the Smooth Scrolling lesson, clicking a link will scroll the page so that the matched heading sits right at the top of the viewport.

But what if you have a fixed or sticky header? In that case, the heading will be hidden behind that element:

This used to be a pretty annoying problem to solve, but fortunately, it's gotten quite a bit easier: we can use the scroll-margin-top property!

h2 {
  scroll-margin-top: 6rem;
}

We're defining the distance that an element should sit from the top of the viewport when it's scrolled into view! You can experiment with different values until you find the one that feels right.

Here's the effect it has:

Browser support
(info)

Happily, scroll-margin-top is very well supported
, working across all modern browsers.

Avoiding scroll-based layout shifts

Have you heard of the CLS (Cumulative Layout Shift) metric?

Created by Google, CLS is a measure of how much movement there is on the page, typically in the first few seconds as the page is loading.

I've updated the Module 7 Workshop to load the data asynchronously, creating a few undesirable layout shifts:

There are two reasons that it's important to optimize for CLS:

Layout shifts are unpleasant! They're jarring and chaotic, and they can cause you to accidentally click on the wrong thing.
Starting in 2021, Google has incorporated CLS into its search ranking algorithm, meaning that focusing on CLS can help improve SEO.

The CLS metric measures two things: how many items move, and how significant the shift is. A small icon moving by a few pixels won't be judged as harshly as a big element popping into view and pushing all of the content down.

Optimizing CLS is a huge topic, but there's a quick win we can tackle entirely on the CSS side:

body {
  overflow-y: scroll;
}

This CSS property ensures that the page will always have a visible scrollbar, even if the page isn't tall enough to warrant one.

Why is this a good thing? When the scrollbar pops into view, it causes a layout shift. Every element on the page shifts a few pixels to the left, to make room for the scrollbar
*
.

Notice how everything shifts when the page becomes too tall to fit:

As wild as it sounds, we can drastically improve our CLS score by making sure the page starts with a scrollbar, rather than waiting for it to appear after the data loads. Twitter user Tim Vereecke saw a massive CLS improvement
 by making this change.

It's up to you whether you want to do this site-wide, or only on pages that you know will require a scrollbar once all the data loads.

A modern solution!
(info)

It's a bit annoying that we need to think about this; a scrollbar appearing shouldn't cause problems!

Since I created this lesson, a fix has arrived. The new scrollbar-gutter property lets us reserve space for the scrollbar 100% of the time, no matter whether there is a scrollbar or not. We use it like this:

html {
  scrollbar-gutter: stable;
}

As I write this in March 2025, this property is available in all major browsers, but browser support is still only ~84%
.

This property works great in most cases, but I’ve noticed some funkiness when it comes to position: fixed elements. It also isn’t inheritable by default, so you’ll want to add this declaration to any critical scroll containers.

Learn more in a detailed blog post by Bramus
!

Scroll container side-effects
(warning)

When we add overflow-y: scroll to the body tag, we turn it into a scroll container
. This means that instead of having a document-based page scroll, we'll instead be scrolling within the body element.

This can lead to some strange bugs. For example, when full-screening a video, it causes the user's scroll position to be lost. When they close the video, they'll find they've been scrolled to the top. It isn't entirely clear to me why this happens, but I suspect it has something to do with the fact that full-screening "collapses" the page, and the browser can't accurately restore the scroll position in a scroll container.

This trick can still be worthwhile, at least until scrollbar-gutter lands! Just be sure to test carefully, and maybe avoid it if fullscreen video is a core part of your product.

Other CLS wins

Here are some other tricks I've learned around optimizing CLS:

Fixed image sizes

Unless you give images a width and height, the browser won't know their dimensions until the image finishes loading. As a result, images will default to being 0px wide and 0px tall, and a big layout shift will occur when the image loads!

To prevent this, we need to specify two of the following CSS properties:

width
height
aspect-ratio

aspect-ratio means that we can solve this problem even if the image is fluid / scales with the container!

It does mean that you'll need to know the image's intrinsic dimensions before the image loads. This can be tricky if the image is dynamic, but you can solve this by storing the image dimensions in your data model (eg. if blog posts have images, be sure to store the width and height in the DB, not just the src!).

If all else fails, you can always prescribe a fixed size, and use object-fit: cover to ensure it doesn't get squashed!

Grouped loading

In the New Grid Times example above, we experience a lot of layout shifts because we have multiple independent sections that each have their own separate data requirements.

We can improve the experience by "grouping" things together. For example, maybe we can wait until all stories in the main grid have finished loading before showing any of them:

function App() {
  const [mainStory, setMainStory] = React.useState(null);
  const [secondaryStories, setSecondaryStories] =
    React.useState(null);
  const [opinionStories, setOpinionStories] = React.useState(null);

  const areAllStoriesLoaded =
    !!mainStory &&
    !!secondaryStories &&
    !!opinionStories;

  if (!areAllStoriesLoaded) {
    return <Spinner />
  }

  return (
    /* Regular app here */
  );
}

This is a tradeoff; we reduce the number of layout shifts, but it also means that the user won't get to see any stories until they've all loaded; on a slow connection, this can make a big difference!

In the future, tools like React Suspense will help with this problem. For now, you'll need to come up with the right tradeoff for your particular use case.


---

## Focus Improvements

Source: /css-for-js/09-little-big-details/11-focus

Focus Improvements

If I've done my job correctly, at this point in the course you should know all about how not everyone interfaces with computers in the same way. Some folks navigate exclusively with non-pointer devices, like the keyboard, or a set of paddles, or a sip-and-puff switch.

If you're not pointing and clicking, you need to know which element currently has focus. And that's where focus indicators come in!

In the lessons that follow, we'll learn how to optimize the experience for folks who navigate without pointer devices.


---

## Focus Visible

Source: /css-for-js/09-little-big-details/11.01-focus-visible

Focus Visible

At any given moment, exactly one element on the page will be considered “active”. We refer to this as the element being focused.

There are many ways that focus can move between elements, including:

Hitting the “Tab” key will cycle to the next interactive element
Clicking an interactive element will focus it

Browsers have a built-in way of letting users know which element is focused. As I write this in January 2023, on macOS Chrome, it looks like this:

Focus indicators vary between browsers and operating systems, and they've changed a lot over the years. Often, it's represented as a blue glow, or a black outline.

These indicators are important—without them, someone navigating without a pointer device would have no way of knowing which element is selected, or where they are on the page!

But these visual outlines were also a bit of a pet peeve for designers. “Those blue rings clash with our sophisticated aesthetic!”, they'd proclaim. “Get rid of them!”

To help with this problem, a new pseudo-class was added: :focus-visible. This pseudo-class is very similar to :focus, but it only matches when the element is focused and the user is using a non-pointer input device (eg. keyboard, paddles, sip-and-puff switch, …).

The idea was that developers could wipe out the default focus styles, and re-add them to :focus-visible, so that they wouldn't be shown to folks using a mouse, trackpad, or touchscreen.

A year or two ago, though, browsers started updating their User-Agent stylesheets. These days, focus indicators are applied to :focus-visible instead of :focus:

/* This is what browsers do nowadays: */
button:focus-visible {
  outline: 5px auto -webkit-focus-ring-color;
}

In other words, those annoying blue rings are already removed for people using a pointer device! We don't need to do anything as developers anymore.

Experiment with these interactive elements to see for yourself:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

(If you're using Safari, you'll need to hold Option while tabbing to select links and buttons.)

In my tests across all major browsers on Windows and macOS, focus rings no longer show up when clicking links and buttons. They do still show up on text inputs, but that seems like a good thing; you need to know which element is focused when typing!
*

Thanks to the modern web, there is no longer any reason to remove focus outlines!. The following code should not exist in your codebase, unless you're replacing the default focus indicator with an even higher-contrast one.

button {
  outline: none;
}

Keeping track of focus
(success)

You can track which element is focused in JavaScript with document.activeElement.

The Chrome devtools allow you to set up "live expressions". This expression will be polled several times a second, and the result is shown in the console:

This can be useful for testing focus during interactions (eg. opening/closing modals).

Learn more about live expressions
 in the Chrome docs.


---

## Focus Within

Source: /css-for-js/09-little-big-details/11.02-focus-within

Focus Within

Using child selectors, it's possible to style a descendant when an ancestor is focused:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  a:focus .highlighted {
    background: hsl(55deg 100% 75%);
  }
</style>

<a href="/">
  Focus me and <span class="highlighted">see the magic!</span>
</a>
Result
Refresh results pane

This is a pattern we've seen a few times in this course; when a parent has a hover/focus/active state, apply some CSS to a child.

But what if we wanted to do the opposite? What if we wanted to apply a style to the parent when a child is focused?

Put down that JavaScript, we can solve this with CSS now, using the :focus-within pseudoclass!

Browser support
(success)

:focus-within has very good browser support
: it's supported in all modern desktop and mobile browsers. It isn't supported in Internet Explorer.

Friendly reminder: if you're using Safari or macOS Firefox, tab navigation skips links by default. You can change this behaviour in System Preferences. For more information, check out this article: No, Tabbing Is Not Broken
.

In practice

The most common use case for :focus-within is forms:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In this example, we apply some CSS to the parent <form> tag whenever any of its descendants are focused. We're increasing the prominence of the shadow, and simulating a page lift with a vertical translate (it would be more realistic to use transform: scale(1.1), but scaled text looks funky on some displays).

Unfortunately, there are no equivalents for other states (eg. :hover-within).


---

## Focus Outlines

Source: /css-for-js/09-little-big-details/11.03-focus-outlines

Focus Outlines

The outline property is a bit sneaky.

When we apply outline styles to a non-interactive element, like a <div> or a <p>, it essentially acts like a border. It takes on a solid color with hard edges.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .with-outline {
    outline: 2px solid blue;
  }
</style>

<div class="with-outline">
  This div has an outline.
</div>
Result
Refresh results pane

Non-interactive outlines will look the same across all browsers and devices, just like a border.

When we focus an interactive element, though, we're treated to a browser-specific “focus outline”. This outline is controlled with the outline property as well, but it's a fundamentally different beast.

Customizing focus outlines

What happens if we change the outline-color property of a focus outline?

Try it for yourself:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  a {
    outline-color: red;
  }
</style>

<a href="/">Typical link</a>
Result
Refresh results pane

If you're using Chrome, you should see a “focus outline”, but with a red color instead of blue.

On Firefox and Safari, though, this property has no effect.

The outline-color property is broadly supported
, but that support is about typical outlines. Not focus outlines.

Is there a way to “force” focus outlines to behave like typical outlines, so that we can apply a custom color? We can, but we probably shouldn't.

Here's how we can do it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Specifically, by setting outline-style to solid in the outline shorthand, we override the focus outline, and replace it with a standard outline.

Here's why this is usually a bad idea, though: focus outlines are a tried-and-true convention, one that users have come to expect. The default styling is instantly recognizable as a focus indicator. The non-focus outlines look more like borders, and people don't associate borders with focus. That's my opinion on the matter, at least.

For browsers that support it, changing outline-color alone is a happy compromise. We can tailor the focus indicator to our app's theme without fundamentally changing it. A red focus outline is still recognizable as a focus outline.

As we've said many times in this course, we should be OK with different people having different experiences, so long as each person has a good experience. We can still use outline-color even though it isn't supported in all browsers because our application is fully usable either way.


---

## Floats

Source: /css-for-js/09-little-big-details/12-floats

Floats

As we saw in Module 6, the float property allows us to wrap text around images and other media, Microsoft-Word-style.

Before we had Flexbox, floats were a critical tool for constructing layouts, even though it was never designed with layouts in mind
*
. We don't need to use floats for layouts anymore, but that doesn't mean it's obsolete!

The CSSWG? certainly hasn't forgotten about floats. They've continued to iterate on its API, and have even added some interesting new features!

In this lesson, we'll see how floats fit into the modern CSS toolkit.

Quick reminder

Here's how we can use the float property to wrap text around an image:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  img {
    float: left;
    margin-right: 16px;
  }
</style>

<p>
  Lorem Ipsum is simply dummy text of the printing and typesetting industry.
  Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and
  scrambled it to make a type specimen book.
</p>
<img src="https://courses.joshwcomeau.com/cfj-mats/cat-300px.jpg" />
<p>
  It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
</p>
<p>
  Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.
</p>
Result
Refresh results pane

We can position a floated element on either side, by specifying either float: left or float: right. We can also use logical properties, inline-start and inline-end, though they have slightly worse browser support
 (around 90% as I write this in mid-2024).

Shapes

Historically, a floated element would "block out" a rectangle. Text would wrap around that rectangle.

Recently, floats have gained an additional superpower: they can now specify a shape for text to wrap around!

Check this out:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

With another seldom-used value, text-align: justify, we can create magazine-style layouts:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

shape-outside lets us specify a shape that text should wrap around. circle is the most straightforward value, but it accepts many different shapes:

clip-path-style polygons
SVG-style paths, to define complex straight and curved shapes
Auto-detection, by passing a URL to an image with transparency

This is pretty magical. Check out how text wraps around my 3D avatar:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In order to make this work, we add shape-margin, a special property that adds a gap between the opaque pixels in an image's shape and the surrounding content.

We also need to add margin-right, since shape-margin can't push the content beyond the image's content size (try removing margin-right to see what I mean).

shape-outside is a hidden gem. Most developers assume that floats aren't relevant anymore, and they miss out on some pretty cool functionality as a result! And because this effect is so rarely used, it really stands out to users.

Browser support
(info)

shape-outside and shape-margin are supported in all major browsers
, but not Internet Explorer.

Clearfixing

Floats have one notorious drawback—if you're not careful, they can break the heck out of your layout.

Watch what happens when an image is floated without much content beside it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The parent <div class="wrapper"> isn't growing to contain this image! As a result, it's spilling out the bottom.

When we float an image, we take it out of flow. When the parent .wrapper is trying to determine how tall it should be, it ignores floated elements just like it'd ignore an absolutely-positioned one.

In order to fix this, we need to rely on another legacy CSS property — clear.

The clear property allows us to place additional content below a floated element, in case we don't want it to wrap around it:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Even if we don't have another paragraph of text, we can leverage this mechanic to our advantage. An empty element that clears floats will cause the parent to grow to contain it!

This is commonly called a clearfix. It's typically abstracted away like this:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Our parent .wrapper element now renders a pseudo-element that applies clear: both (which will clear both left and right floated elements) right after the content. It doesn't actually matter that this element is empty; the fact that it exists causes the parent to grow to include the entire floated element, and the 0px-tall element below.


---

## :has

Source: /css-for-js/09-little-big-details/13-has

:has

If you spend time in front-end developer communities, you’ve probably heard some excited chatter about the :has pseudo-class.

Honestly, I wasn’t sure how useful it would be for me. I mostly work with React, which means I tend not to use complex selectors; I can do all the complex stuff in JS, after all! It didn’t really seem like the benefits of this new CSS feature would really be relevant for me.

In the summer of 2024, I spent a few months rebuilding my blog, and I made a point of trying to use as many new CSS features as I could. And my goodness, I was wrong about :has. It’s an incredibly handy utility, even in a CSS-in-JS context!

In this lesson, I'll introduce you to :has and share some of the most interesting real-world use cases I’ve found so far, along with some truly mindblowing experiments.

The basics

All of the CSS selectors we’ve seen in this course have worked in a “top down” fashion.

For example, by separating multiple selectors with a space, we can selectively style a child based on its parent:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  /*
    Style all <a> tags that are
    contained within <p> tags:
  */
  p a {
    font-weight: bold;
    color: inherit;
    text-decoration-color: hotpink;
    text-decoration-thickness: 2px;
  }
</style>

<p>
  This paragraph includes <a href="/">an anchor
  tag, commonly known as a “link”</a>. Using
  the child combinator, we’re applying styles
  to anchor tags when they’re included in a
  paragraph.
</p>

<p>
  By contrast, these links aren’t in a
  paragraph, so they don't get the same styles:
</p>

<footer>
  <ul>
    <li>
      <a href="/">Home</a>
    </li>
    <li>
      <a href="/">About</a>
    </li>
    <li>
      <a href="/">Contact</a>
Result
Refresh results pane

The :has pseudo-selector works in a “bottom up” fashion; it allows us to style a parent based on its children:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This might not seem like a big deal, but it opens so many interesting new doors. Over the past few months, I’ve had one epiphany after another, moments where I went “Woah, that means I can do this??”

Browser support

Before we get to all the cool demos, we should briefly talk about browser support. :has is supported in all 4 major browsers, starting from:

Safari 15.4, introduced in March 2022
Chrome/Edge 105, introduced in August 2022
Firefox 121, introduced in December 2023

As I write this in December 2024, :has is at ~94% browser support. You can view current browser support data
 on caniuse.

Honestly, 94% isn’t a slam-dunk when it comes to browser support… That means roughly 1 in 16 people are using an unsupported browser!

Fortunately, most of the use cases I’ve found for :has are optional “nice-to-have” bonuses, so it’s not really a big deal if they don’t show up for everyone. And in other cases, we can use feature queries (discussed in Module 5) to provide fallback CSS.

Styling based on states

On my blog’s new “About Josh” page
, I use a “bento box” layout containing a bunch of little cards. Some of these cards have clickable children:

For folks who navigate with a keyboard, however, the experience was a bit more funky. Some of the children dynamically change size, leading to curious focus outlines like this:

To solve this problem, I moved the focus outline to the parent container. Here’s what it looks like now:

This solves our problem, and I think it also looks pretty nice!

Let’s dig into how this works. Here’s roughly what the HTML looks like:

<div class="bento-card">
  <p>
    I'm
    <button>188cm</button>
    tall.
  </p>
</div>

In the past, I might’ve solved this by making the whole .bento-card container a <button>, but this isn’t a good idea. Cramming so much stuff into a button would introduce several usability and accessibility issues; for example, users can't click-and-drag to select text inside buttons!

Fortunately, we can keep our nice semantic markup and accomplish our goals with :has:

.bento-card:has(button:focus-visible) {
  outline: 2px solid var(--color-primary);
}

/* Remove the default button focus outline */
.bento-card button {
  outline: none;
}

When .bento-card contains a focused button, we add an outline to it. The outline is applied to the parent .bento-card, rather than to the button itself.

I'm removing the default focus outline from the button, to prevent double focus indicators. This is something we should be very cautious about. In fact, our solution isn’t yet complete, since we also need to provide a fallback experience for folks using older browsers.

Here’s what that looks like:

@supports selector(:has(*)) {
  .bento-card:has(button:focus-visible) {
    outline: 2px solid var(--color-primary);
  }

  .bento-card button {
    outline: none;
  }
}

In this updated version, the outline modifications will only be applied for folks who visit using modern browsers. If someone is using a legacy browser, none of this stuff will apply, and they’ll see the standard focus outlines. Even though it’s a little funky, I think it’s a reasonable fallback experience.

I'm also taking a little shortcut here: rather than test for the specific selector I'm using (.bento-card:has(button:focus-visible)), I'm instead using the smallest valid :has selector, :has(*). The browser won't actually try and resolve the selector we supply, so it doesn’t matter which elements are selected. @supports works by looking at the syntax and establishing whether it's valid or not.

Why not use :focus-within?
(info)

We recently learned about the :focus-within pseudo-class, which lets us select an element containing a focused descendant. We could use it to solve this problem as well:

.bento-card:focus-within {
  outline: 2px solid var(--color-primary);
}

The :focus-within pseudo-class has been around much longer than :has, and so it has significantly better browser support
. Seems like a better approach, no?

There are two reasons why I prefer :has in this situation:

:focus-within matches the :focus state, not the :focus-visible state. This means that the outline will show even for users who click the button using a mouse. There is no :focus-visible-within.
I don’t want to show the focus outline when any descendant is focused, I only want it to apply when a button is focused. Some of the cards contain focusable links:

If I used :focus-within, it wouldn't be clear to the user which interactive child is actually focused!

Ultimately, :focus-within can be useful, but it’s a pretty coarse tool. We have much finer control using :has.

Another state-based example

CSS has dozens and dozens of pseudo-classes beyond :focus-visible, and we can use any of them to apply CSS conditionally with :has!

Let’s look at another example from my blog. Here’s a custom form control I use in a couple of places. I call it an “X/Y Pad”:

Adjust X/Y position with arrow keys
X:
0.00
Y:
0.00

(This is an interactive element! You can click and drag the handle to change the X/Y values. For keyboard users, you can focus the handle and use the arrow keys.)

Notice that while you drag/adjust the handle, the container changes color! The code looks something like this:

<style>
  .xy-pad {
    --dot-color: gray;
  }
  .xy-pad:has(.handle:active),
  .xy-pad:has(.handle:focus-visible), {
    --dot-color: var(--color-primary);
  }
</style>

<div class="xy-pad">
  <svg>
    <!-- Dotted background here -->
  </svg>

  <button class="handle"></button>
</div>

The :active pseudo-class is applied when a button is being clicked and held. While the user is dragging the handle, our :has selector matches, and we change the value of a CSS variable, --dot-color.

Additionally, I've added a secondary selector with :focus-visible, so that keyboard users get the same treatment.

The --dot-color CSS variable is used in several places, for the borders and lines and dots. The dots themselves are dynamically generated as a bunch of SVG circles:

<circle fill="var(--dot-color)">
Global detection

This is maybe the coolest use-case I've found so far. We can use :has as a sort of global event listener.

For example, suppose we’re building a modal/dialog component. When the modal is open, we want to disable scrolling on the page. We can do this by applying some CSS to the <html> tag:

/* Scrolling disabled while this is set: */
html {
  overflow: hidden;
}

Here’s how I would have solved this in the past, using a JS framework like React:

// Register a side-effect that runs whenever `isOpen` changes:
React.useEffect(() => {
  if (isOpen) {
    // Save the current value for `overflow`,
    // so that we can restore it later:
    const { overflow } =
      document.documentElement.getComputedStyle();

    // Apply the new value to disable scrolling:
    document.documentElement.style.overflow = "hidden";

    // Register a cleanup function that undoes this work,
    // when `isOpen` flips back to `false`:
    return () => {
      document.documentElement.style.overflow = overflow;
    };
  }
}, [isOpen]);

Don’t worry if you’re not familiar with React effects. The point here is that this is a really clunky way to solve this problem!

We can solve this in a much nicer way with :has:

html:has([data-disable-document-scroll="true"]) {
  overflow: hidden;
}

If the HTML contains an element that sets this data attribute, no matter where it is in the DOM, we’ll apply overflow: hidden.

Inside our Modal component, we’ll trigger it by conditionally setting the data attribute:

function Modal({ isOpen, children }) {
  return (
    <div
      data-disable-document-scroll={isOpen}
    >
      {/* Modal stuff here */}
    </div>
  );
}

How friggin’ cool is that?? The instant our modal opens, this data attribute gets flipped to "true", which means our :has selector becomes fulfilled, and scrolling becomes disabled. If this data attribute flips back to "false", or if the element itself is removed from the DOM, scrolling will automatically be restored. ✨

This example uses React, but we can leverage the same trick in a vanilla JavaScript context. Here’s a quick sketch:

function toggleModal(isOpen) {
  const element = document.querySelector('...');
  element.dataset.disableDocumentScroll = isOpen;
}

What about performance?
(info)

You might be wondering about the performance implications of this strategy. With :has on the root HTML tag, doesn't that mean that the browser would have to inspect the entire DOM in order to tell if the condition is met or not?

I decided to test this using the new “Selector Stats” feature
 in the Chrome devtools. I ran it on a blog post that uses :has.

On that page, with more than 2500 DOM nodes, this selector took an average of 0.1 milliseconds (0.0001 seconds) to resolve. I took this measurement on one of the slowest computers I've ever used in my life, a $100 Intel Celeron laptop that struggles with things like displaying images. The result was more than 10x faster on my 2021 MacBook Pro.

Browsers are really good at doing style recalculation. This isn't something we need to worry about. 😄

JavaScript-free Dark Mode

Jen Simmons discovered that we can use this trick to create a JavaScript-free “Dark Mode” toggle. Here’s an example:

<style>
  /* Default (light mode) colors: */
  body {
    --color-text: black;
    --color-background: white;
  }

  /* Dark mode colors: */
  body:has(#dark-mode-toggle:checked) {
    --color-text: white;
    --color-background: black;
  }
</style>

<!-- Somewhere in the DOM: -->
<input id="dark-mode-toggle" type="checkbox">
<label for="dark-mode-toggle">
  Enable Dark Mode
</label>

When the user clicks the checkbox, the :checked pseudo-class is applied to it, which causes our :has selector to match. We overwrite the baseline CSS variables with new dark-mode ones, and the theme is effectively swapped!

To be clear, Dark Mode is a surprisingly complicated thing
, and this approach isn’t really a complete implementation (for example, it doesn’t save/restore the user’s preferred option, or inherit the default theme from the operating system). Plus, I wouldn’t want a core piece of functionality to depend on a CSS feature with only ~94% support. But still, it’s friggin’ cool that we can add a “Dark Mode” toggle with only a single CSS rule and no JS!

You can read more about this approach, and see lots of other cool examples, in Jen’s wonderful blog post
.

The missing selector

So far, all of the examples we’ve looked at involve styling the parent based on one of its descendants. This is very cool, but it’s only the tip of the iceberg.

Check this out:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In this scenario, I'm selecting all paragraphs that come right before a <figure> tag. The big difference here is that there’s no parent/child relationship; the paragraphs and figures are siblings!

Now, to be clear, we’ve been able to do similar things in CSS for quite a while, using the “next-sibling combinator”, +. This little fella allows us to select an element that comes after a given selector:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

On its own, the + combinator can only be used to select elements that come after a given selector in the DOM. It only works in one direction. With :has, we can flip the order, which means that together, we can select elements in either direction!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

We’re not limited to direct siblings, either. With :has, we can style one element based on another element in a totally different container!

Here’s a wild example, adapted from Ahmad’s comprehensive blog post on :has
. Try hovering over the category buttons and/or the books:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Alternative control schemes
(warning)

If you’re reading this on a mobile/tablet device and don't have a mouse to hover with, you can alternatively tap the category buttons to trigger the same effect. And if you’re a keyboard user, you can focus the category buttons.

The CSS for these alternative control schemes can be found in the styles.css tab.

Hovering over one of the category buttons will add a hover state to the buttons themselves, as well as any books that match the selected category! Likewise, hovering over one of the books highlights the matching category.

It’s hard to parse the CSS in the constrained space within the playground, so here’s the core CSS logic in a more spacious box:

html:has([data-category="sci-fi"]:hover) [data-category="sci-fi"] {
  background: var(--highlight-color);
}

The first part of this selector uses the same “global detection” logic we saw earlier. We’re checking to see if the DOM contains a node that:

Sets the category data attribute to "sci-fi", and
Is currently being hovered.

Instead of applying styles directly to the <html> tag, though, we’re instead looking for any descendants that have the category data attribute set to "sci-fi".

To paraphrase the logic here, I'm essentially saying: “If the HTML document contains at least 1 hovered element with category set to "sci-fi", apply the following CSS to all elements with that category”. In this particular case, the CSS I'm applying is a lilac background color, but it could be anything!

The wild thing about this example is that the actual DOM structure doesn’t matter. The category buttons are in a totally different part of the DOM from the book elements. There’s no parent/child relationship, or even a sibling relationship! The only thing they have in common is that they’re both descendants of the root <html> tag, same as any other node in the document.

It kinda feels like :has is the “missing selector” in CSS. Historically, there have been a bunch of relationships we just couldn’t express in CSS. With :has, we can select any element based on the properties/status of any other element. No limits!

The best tool for the job

As we’ve seen, the :has selector is incredibly powerful. Things that used to require JavaScript can now be accomplished exclusively using CSS!

But just because we can solve problems like this, does that mean we should?

I'm a big fan of using whichever tool can solve the problem with the least amount of complexity. And when a problem can be solved either with CSS or JavaScript, the CSS solution tends to be much simpler.

With :has, however, things can get pretty complicated. Here’s a “final” version of the snippet we just saw, including alternative controls for mobile/keyboard:

html:where(
  :has([data-category="sci-fi"]:hover),
  :has([data-category="sci-fi"]:focus-visible),
  :has([data-category="sci-fi"]:active),
) [data-category="sci-fi"],
html:where(
  :has([data-category="fantasy"]:hover),
  :has([data-category="fantasy"]:focus-visible),
  :has([data-category="fantasy"]:active),
) [data-category="fantasy"],
html:where(
  :has([data-category="romance"]:hover),
  :has([data-category="romance"]:focus-visible),
  :has([data-category="romance"]:active),
) [data-category="romance"] {
  background: var(--highlight-color);
}

(The :where pseudo-class allows us to “group” related selectors. It’s equivalent to writing each clause out as a separate selector.)

If I was building this UI using a framework like React, I think it would actually be simpler to create a state variable that tracks which category is currently active. It would also be more flexible; we could have dynamic categories, rather than hardcoded ones. And books could belong to multiple categories. And it would work in Internet Explorer.

I included this example because it really is an incredible demonstration of what :has can do, but if I was building this particluar UI for real, I would implement this logic in JavaScript.

In practice, I find myself using :has in less grandiose ways, like the focus outlines on the “About” page
, or for disabling scroll on mobile. It’s a super handy selector in these circumstances, and works very well in the context of a React application!

If you'd like to learn more about :has, there are tons of amazing resources out there. Here are some of my favourites:

Selecting Previous Siblings With CSS :has()
, by Tobias Ahlin
CSS :has() Interactive Guide
 by Ahmad Shadeed
Level Up Your CSS Skills With The :has() Selector
, by Stephanie Eckles

---

## In Conclusion

Source: /css-for-js/09-little-big-details/14-conclusion

In Conclusion

You've made it to the very final lesson in the course — congratulations! 🎉

This course has been a journey. Over the past 200+ lessons, we've seen how to work with all major layout modes, to build all sorts of amazing things with CSS.

And yet, like with so many things in software development, we aren't finished learning. CSS is an incredibly rich, deep language. If I've done my job correctly, I've given you a solid foundation, one you can build on for the rest of your career.

Thank you so much for giving this course so much of your time and attention. I can't wait to see what you do with your CSS skills!!

Where do you go from here? If you haven't already seen it, I recommend checking out the Video Archive. It builds upon the knowledge from this course, and aims to help show you my thought process when attempting novel or challenging UIs.

The Joy of React
(success)

If you’ve enjoyed my teaching style and would like to keep learning from me, you might be interested in my other course, The Joy of React
!

My goal with The Joy of React is to help you discover how fun it can be to build dynamic web apps with React when you have a deep intuition for how it works. It uses the exact same multi-format style as CSS for JavaScript Developers.

You can use the coupon code LAYOUT_LEGEND to take 10% off the purchase price. This is a special coupon I created exclusively for folks like you, who have completed CSS for JavaScript Developers. 😄

You can learn more about the course here:

The Joy of React

