# CSS for JS - Module 6: Typography and Media

---

## Introduction • Josh W Comeau's Course Platform

Source: /css-for-js/06-typography-and-media/01-introduction

Typography and Images

In this module, we'll take a closer look at how text and images work on the web.

It's a particularly exciting time to be learning about these topics. Browser vendors have been busy, and we can safely use a bunch of fancy new properties and techniques to create better user experiences.

This is a pretty jam-packed module. We'll learn about:

The secrets of text rendering, from kerning to rasterization
Understanding and managing text overflow, and how to do single-line and multi-line ellipses.
Two alternative layout modes: floats and columns
Web fonts, and how to optimally load them for the best user experience
Variable fonts, a magical new font format
The best icon solutions in a modern JS context
Responsive image-handling with srcset and the <picture> element
Modern image formats like .avif, and how to use them while still supporting all browsers.
Customizing image placement using object-fit and object-position
The intersection of images and Flexbox, and how to sidestep common issues

Let's do this!


---

## Text Rendering

Source: /css-for-js/06-typography-and-media/02-text-rendering

Text Rendering

Here's a question for you: if you took the exact same HTML and CSS and viewed it in two different browsers, would it appear identical?

I was curious about this, so I went about capturing some screenshots, controlling for variables like viewport size. Here's the results:

Safari, macOS
Chrome, macOS
Toggle
Expand

Overall, I'd say that things are pretty similar, but definitely not identical down to the pixel.

One thing that stands out to me is that the precise placement of each character differs between browsers. Here's a zoomed-in version:

Chrome, macOS
Safari, macOS
Toggle
Expand

The most substantial tweak between these two screenshots is around the commas — Chrome tucks the commas closer to the preceding word than Safari. But if you look closely, you'll notice that most of the letters shift very slightly between browsers.

Kerning

To the best of my understanding, the reason that the letter placement is slightly different between browsers is that the browsers implement different kerning algorithms.

Kerning refers to the spacing between individual characters. Characters are nudged left or right so that they "feel" right. This process is half art, half science.

Naturally, the browser doesn't do any kerning for monospaced fonts, since those characters need to align neatly into columns.

Using CSS, we can opt to disable kerning altogether with font-kerning: none, but we aren't offered any fine-grained control. letter-spacing, the property that allows us to increase/decrease the space between individual characters, acts as a "kerning multiplier" — it amplifies whatever kerning the browser decides on.

Say Hello To Our Special Guest, HANK GREEN!!

font-kerning
normal
none
letter-spacing
0em

Custom kerning?
(info)

Over the course of my career, I can think of a few times when designers asked me to tweak the kerning for a particularly important heading.

We can do this with a few steps:

Disable the built-in kerning with font-kerning: none.
Wrap each letter in a span.
Shift letters closer/further using letter-spacing, picking custom values for each span.

If you don't have a designer by your side guiding these adjustments, you should proceed with caution. It takes a long time to develop an instinct for kerning, and if you're not careful, you might wind up making things look worse!

If you're interested in improving your kerning skills, a super-neat kerning minigame
 can help you practice.

Text Rasterization

In addition to the role that browsers play, the browser's operating system also affects how typography is rendered. Here's the same website in the same browser, but across two different operating systems:

Chrome, Windows 10
Chrome, macOS
Toggle
Expand

These screenshots were taken from my blog
. Despite using the exact same CSS and the same webfont (Wotfard
), the text winds up looking quite different!

To understand what’s going on here, we need to learn about rasterization and anti-aliasing.

In the very early days of computing, fonts were essentially collections of images. Each character was represented by a single picture. A "font" was a big repository of images, one for each character at each font size. This is known as a "bitmap font".

Bitmap fonts are still a thing today, but they're rare. It's much more common for fonts to use vector formats like ttf, otf, svg, and woff/woff2. In a vector font, we store a mathematical set of instructions for each character.

The main benefit to a vector font is that it can be scaled to any size without the letters becoming pixellated and blurry.

In order to turn a vector font into characters on a screen, though, the browser has to figure out which color to make each pixel, a process known as rasterization.

Wikipedia has a great article on font rasterization
, which digs into the different methods that can be used to render text.

The simplest method involves filling in any pixels that the vector path crosses over. In this example, we draw the letter "A" by coloring in the relevant pixels:

It reminds me of those CAPTCHAs, where you have to click each square that includes a stop sign or a traffic light.

As you might imagine, this method of rasterization produces sharp, pixellated text:

To make the text appear smoother, the browser can apply "anti-aliasing". Here are a couple examples, from Wikipedia:

Basic anti-alias algorithm.
Anti-aliasing using hints
embedded in the font file.

So why does our text look different across machines? I believe that both the browser and the operating system play a role in the rasterization and anti-aliasing process. Different algorithms produce different results.

For example, Windows infamously uses colors during their anti-aliasing, adding an orange edge on the left and a blue edge on the right. As far as I know, no other operating systems do this. I have no idea why Windows does. 😅

Can we change the text rasterization in CSS? Kind of… but it's complicated.

Font Smoothing

You may have heard of the -webkit-font-smoothing property.

This property allows us to switch which aliasing algorithm the browser uses. But, tragically, it only works on macOS, and only in Chrome/Safari/Edge (not Firefox).

If you happen to be viewing this in a compatible browser, you can switch between these rendering algorithms here:

Say Hello To Our Special Guest, Hank Green!!

-webkit-font-smoothing
subpixel-antialiased (default)
antialiased
none

Here are close-ups that compare the 3 values:

subpixel-antialiased (default)	antialiased	none

“Subpixel antialiasing” is a fancy technique that uses the R/G/B elements of a pixel to produce more-precise anti-aliasing. This zoomed-in photo from Wikipedia demonstrates the technique:

Essentially, we can increase the perceived resolution by "borrowing" a single color from a neighboring pixel. This bit of extra thickness can be useful for anti-aliasing algorithms.

Fool your eyes!

Try moving your head closer / further from the monitor. When close-up, you should be able to see the 3 color bands. Further away, the text should appear white.

It's a good demonstration of how monitors work! Our eyes can be tricked into seeing white by combining the 3 primary colors.

When this property was added to Apple devices over a decade ago, it helped produce crisper text.

A lot has changed since then, though.

For one thing, our pixel arrangements have gotten more complex. If you look at a modern device's screen under a microscope, you'll discover some pretty creative pixel arrangements.

For example, check out the Apple Watch and the iPhone XS Max:

(Sources: Apple Watch
 and iPhone
)

Another big thing has changed too. Most displays are "high-DPI". As we saw in the last module, this means that every software pixel is being mapped onto multiple hardware pixels.

Modern iPhones have a 3x device pixel ratio, which means each software pixel is being represented by 9 hardware pixels.

Given how tiny modern pixels are, do we get any benefit from subpixel antialiasing? Apple doesn't think so.

Since macOS Mojave, released in 2018, Apple has disabled subpixel antialiasing by default. If you use a retina display, subpixel antialiasing appears to do more harm than good, creating muddier, less-legible text.

Confusingly, however, macOS browsers like Chrome and Safari don't "inherit" the system default. We need to explicitly flip it to use antialiased:

*, *:before, *:after {
  box-sizing: border-box;
  -webkit-font-smoothing: antialiased;
}

Bad for accessibility?
(info)

You may have heard that changing this property is an accessibility risk, because antialiased text is less legible. A widely-shared 2012 article, “Stop ‘Fixing’ Font Smoothing”
, made the case that subpixel-antialiasing was inherently superior, and produced crisper text than the antialiasing alternative.

I believe that this was true in 2012, but I don't think it's the case anymore.

Other browsers

-webkit-font-smoothing only works on macOS Chrome/Safari/Edge. Unless you're building an Apple fanclub site, this will almost certainly be a minority of users. What about for everyone else?

macOS Firefox comes with an alternative property, -moz-osx-font-smoothing, but it only lets us toggle between grayscale and auto. And, in most cases, auto defaults to grayscale. I've experimented with this property, and haven't noticed any difference whatsoever.

And on Windows, there are no properties at all. Windows does have a subpixel-antialiasing algorithm called ClearType, but it isn't exposed in CSS.

In my anecdotal experience, I've noticed that macOS Firefox has the chunky subpixel look, whilst Windows browsers have the thinner antialiased look.

Take a look for yourself:

macOS Chrome, subpixel	macOS Chrome, antialiased	Windows Chrome	macOS Firefox

Admittedly, I haven't tested this across a wide range of Windows devices, so your mileage may vary.

Just what is “WebKit”, anyway?
(info)

WebKit is a browser rendering engine developed by Apple
*
, and used in Safari on macOS, and all mobile browsers on iOS (Safari, Chrome, Firefox, etc).

Early versions of Chrome and Opera also used WebKit, across all platforms (Windows, macOS, Android). In 2013, Google announced that it was forking WebKit to create its own rendering engine, Blink.

Nowadays, Chrome and Microsoft Edge also use Blink as their rendering engine.

This means that just about every major browser has its roots in the WebKit codebase. This history helps explain why -webkit prefixes are supported in many non-Safari browsers!


---

## Text Overflow

Source: /css-for-js/06-typography-and-media/03-text-overflow

Text Overflow

Have you ever thought about how the browser's text placement algorithm works? How does it decide when to line-break?

It turns out, the algorithm is (relatively) straightforward and intuitive. If you've ever had to manually edit a Markdown file to keep each line under 80 characters, you've likely followed a very similar process.

It goes something like this:

(Text source: The Underground Railroad by William Still
)

The browser groups characters into "words". A word, in this case, is a collection of characters that can't be broken up. “https://www.google.com” is a word. So is “kool_kat_99”.

Words are separated by "breaking characters". The CSS specification refers to them as soft wrap opportunities
. Each whitespace character is a soft wrap opportunity. So is the dash character (-).

When content would spill outside the containing block, the browser looks for the closest soft wrap opportunity, and splits everything afterwards to the next line. This process repeats for all of the text.

Non-breaking spaces
(info)

Suppose we want to add a space to our paragraph, but in a way that doesn't create a soft wrap opportunity. In other words, a space that can't be used to line-break.

There is a special HTML entity that can be used in this case: &nbsp;.

 Show more

Balanced text
(info)

Many designers are unhappy with the default text-placement algorithm. It can lead to "widows", a single word left on its own at the bottom of a paragraph:

A more sophisticated algorithm would try and "balance" the text, to avoid lopsided text elements like this.

A few years ago, Adobe made a CSS proposal to support an alternative text-placement algorithm. This has recently started landing in browsers under the text-wrap property
:

As I write this in early 2024, browser support is so-so, with around 70% support
. This may be sufficient for a “nice-to-have” enhancement like this, but if you'd prefer to have a consistent experience for everyone, there are polyfills / libraries you can use:

Adobe's original JavaScript polyfill
React Wrap Balancer
, a React component that balances the text. Created by Vercel developer Shu Ding

Here's a question: what happens if a single word is too long to fit in the container? What if there are no "soft wrap opportunities" present, to keep a word from overflowing?

You've probably been in this frustrating situation before:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

When we think about the algorithm, it makes sense why this is happening: the browser can only split based on "soft wrap opportunities". The line containing antidisestablishmentarianism has no such opportunities.

By now, overflow is a familiar antagonist, and we have some tools we can use to deal with it. We can add a scrollbar with overflow: auto, or we can opt for the nuclear option and truncate everything with overflow: hidden.

When dealing with text, though, we have some additional tools.

Wrapping onto multiple lines

With the overflow-wrap property, we can linewrap longer words/strings:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

overflow-wrap: break-word tweaks the text-placing algorithm. If the browser realizes that it can't fit the current word, and it doesn't have any spare soft wrap opportunities, this declaration gives the browser permission to break after any character.

This property is supported across all browsers. In Internet Explorer, the property is called word-wrap instead of overflow-wrap, so you'll need to supply both properties if targeting IE.

Hyphenation

overflow-wrap: break-word splits long words across multiple lines without any visual indication that a word has been split.

In print media, where splitting words is much more common, a convention has been created for it: the hyphen.

A hyphen is a dash character (-) used to join two segments of the same word, like this:

This sentence is truncated prema-
turely with a hyphen, to indi-
cate that the word continues
on the next line.

Adding hyphens is not part of the text-placement algorithm, but we can add it in with the hyphens property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

hyphens: auto is more aggressive than overflow-wrap: break-word. overflow-wrap only kicks in when there are no soft wrap opportunities (spaces or dashes) earlier in the line, whereas hyphens: auto will prefer to hyphenate rather than push long words onto the next line.

In theory, we shouldn’t need overflow-wrap: break-word when we have hyphens: auto, but in practice, I've found I get the best results when I combine them. overflow-wrap: break-word does a better job ensuring that text never overflows or causes layout issues. It's tricky since there's quite a bit of variation here, between browsers and operating systems.

In terms of text selection, the hyphens will not be selectable. This is good, since it means line-broken URLs can be copy/pasted properly.

In terms of browser support, this property is supported across all browsers, including IE.

Gotchas
(warning)

hyphens: auto only works if the lang attribute is set on the <html> tag (and it mainly only works in English, though some browsers have added hyphen support for other languages; see a complete list
 on MDN).

Also, hyphens: auto varies quite a bit between browsers and devices. Chrome will add hyphens to a long URL on macOS, but not on Windows. Firefox doesn't support hyphenated words on proper nouns
.

Ellipsis

Another option is that we can trail off, leaving the sentence unfinis…

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Weirdly, we need overflow: hidden in order for text-overflow to work. A bit odd, but it is what it is.

Single-line ellipsis

In other cases, we may wish to prevent line-wrapping altogether, and add an ellipsis if the string can't fit on a single line.

Sometimes, this appears not to work. For example, in this playground, we want to add an ellipsis for student names that are too large to fit. Instead, they're line-wrapping:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Notice that certain student names, like George and Shafaqat, are line-wrapping instead of being truncated.

There's a subtle but important thing here: overflow management kicks in after the line-breaking algorithm. First, the browser figures out where to put the line-breaks. Then, it figures out what to do about the overflow.

In order to truncate the content, we need to disable line-wrapping altogether. We can do that with white-space: nowrap:

tbody th {
+ white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 250px;
}

Try copying this into the playground above!

Use with caution
(warning)

Before we add these properties, we should stop and think about the usability implications. Will the user still be able to use our product if they can't see the rest of the text?

In the example above, we can conceal part of the student's name because, presumably, the teacher is familiar enough with their students' names that they don't need the complete value.
*

Ellipses are also useful when showing previews/abstracts.

If the user isn't already familiar with the values, or the text can't be expanded to view the full thing, we should pick an alternative solution that doesn't conceal the text.

Multi-line ellipsis

What if we want to show a few lines, and add the ellipsis afterwards?

For a long time, this was a very hard problem that required some very complicated JavaScript. Fortunately, there is a modern way to solve this problem: the -webkit-line-clamp property.

Despite the vendor prefix, this property works in all major browsers
, though it does require a couple of companion declarations:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

We need overflow: hidden to hide the lines that will be clamped off.

If you're thinking that this is an awful lot of ceremony, with -webkit-box-orient and display: -webkit-box, you're not alone: browsers are working on a new version of this property, called line-clamp. Unfortunately, at the time of writing, it's still early days.

Watch out for Flexbox/Grid!
(warning)

Every now and then, I’ll run into a situation where -webkit-line-clamp appears not to work. Here’s a basic reproduction of the issue:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In this playground, I’m trying to limit the text to three lines. At the end of the third line, I do see the ellipsis (...), but curiously, the rest of the text remains visible. 🤔

Here’s the issue: -webkit-line-clamp doesn’t actually delete the extra characters. Instead, it reduces the height of the element so that only three lines are visible. We then hide the overflow with overflow: hidden.

But with Flexbox, elements are stretched to fill their container. In this case, the container has a height of 10rem, and by default, the paragraph will be stretched to fill its container. This causes the excess lines to become visible, since they’re no longer overflowing.

We can solve this problem by changing the alignment of the paragraph, within Flexbox:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane
Exercises
Improve text formatting

Update this UI to add multi-line ellipsis and hyphenation:

It may not hyphenate precisely the same way depending on screen size and browser, so you don't need to match it exactly.

Be sure to work on the exercise in fullscreen mode by clicking “”, so that you have enough space to see the three-column view.

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

Note: In the solution video, the article titles use Title Case. The exercise has since been updated, because Firefox doesn't support hyphenation on Capitalized Words.

Solution code
(success)

 Show more

---

## Print-style Layouts

Source: /css-for-js/06-typography-and-media/04-print-style-text

Print-style Layouts

In the early days of the web, it was imagined that websites would be styled similarly to print media like books and magazines. It was all about documents, not applications.

As the web has matured, it's developed its own style, and that style can be followed using tools like Flexbox and Grid.

But what if we want to create a print-style layout on the web?

In this lesson, we'll revisit some of CSS' forgotten gems to see how we can create a book-style layout:

Column layout

So far, we've seen a few layout modes:

Flow layout, the “OG” layout algorithm.
Positioned layout, letting us position elements based on an anchor (either its in-flow position, a containing block, or the viewport).
Flexible Box (“Flexbox”) layout, for arranging elements in a row or column.

To accomplish this goal, we'll need 1 more layout mode: Multi-Column Layout.

This layout mode is fairly niche, but it does something that no other layout mode can do: automatically split content across multiple columns, in a manner that allows the parent container to grow and shrink accordingly.

Here's an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Try tweaking columns: 2 to columns: 3 to change the number of columns.

This layout mode is really pretty incredible. Notice that it can even spread paragraphs across multiple columns:

If we want to make sure that a particular child isn't broken across columns, like that third paragraph, we can do so with the following declaration:

p {
  break-inside: avoid;
}

This will stop the algorithm from splitting a paragraph across multiple columns:

The algorithm's chief concern is distributing content evenly so that all columns are the same height. It's very good at its job; it re-evaluates whenever new content is added, to find the ideal distribution. This obscure layout mode can accomplish things that no other layout mode can.

Floats

Let's look at yet another layout algorithm!

Floats were a fundamental building block of the pre-Flexbox toolkit. In the late '00s / early '10s, floats were all the rage. They allowed us to build common UI elements like sidebars.

Their reign was short-lived, as Flexbox offered a much-more elegant solution to these types of problems. And now that CSS Grid has widespread browser support, Floats are often thought of as a relic of the past, a tool from a bygone era.

So why are we talking about it? Well, it turns out that there are some things that only floats can accomplish. And the CSSWG? hasn't forgotten about it, either—they've continued to beef up float capabilities. It can do some wild stuff nowadays!

Floats allow text to "wrap around" an embedded element. Check out how text wraps around this image:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

A floated element is like a boulder in a stream; the other content flows smoothly around it. In this case, text wraps seamlessly around an image, but we can use this trick for any embedded element, not just images!

We can choose which side the element should be floated by passing either left or right to the float property. Try switching the above code snippet to float the image on the opposite side!

Floated items don't come with any default margin. This means that the surrounding text will run right up to the floated element, which often feels claustrophobic. By adding margin-right to a left-floated element, we create a bit of buffer around it.

Indentation

On the web, it's conventional for paragraphs to be differentiated through spacing; we can tell where the paragraphs are because there's a bunch of space between them.

This isn't the only way to differentiate paragraphs, though. Books generally use indentation instead.

The first line of each paragraph is inset, and this is how our eyes can distinguish one paragraph from another. There isn't any additional space between them.

How might we accomplish this on the web? There are a couple options.

We can select the first letter in a paragraph with the :first-letter pseudo-element. A bit of margin can accomplish this effect:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

This method works, but there's an even-more-explicit way we can do it: using the text-indent CSS property:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

text-indent is not a new property: it is supported in all browsers, all the way back to IE 6!

::first-letter is still useful for certain typographical effects, like "drop caps" (a larger first letter, typically on the first paragraph in a page/chapter).

Justified alignment

In print, it's common for text to be "justified" — this means that the spacing between each word is tweaked so that each line fills the available horizontal space:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Try resizing the pane above to see how the text adapts as its width grows and shrinks!

More info on justification
(info)

It's interesting to read about how print designers think about typography. In The Elements of Typographic Style
, author Robert Bringhurst explains that text should be "ragged" (fancy typographic word for left-aligned) when using a sans-serif or monospace font, or when there isn't much horizontal space.

If the column of text is too narrow, justified alignment will either produce awkward spacing or way too much hyphenation.

Exercises
Build a book

Using the techniques described in this lesson, apply some print styles to the playground below.

You can use this image as reference:

This image is provided as an example, not a mockup. Don't worry about matching it exactly. You can use HSL to come up with a similar color.

The font used is Merriweather. It's been applied automatically. We'll learn more about web fonts later in this module.

Note: The crease down the middle is done using linear gradients. It's not the main focus for this lesson, and we'll learn much more about gradients later on, but you're welcome to give it a shot!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This excerpt taken from The Friendly Killers, by S. M. Tenneshaw.

Solution:

Solution code
(success)

 Show more

Initial Letter
(info)

In the future, doing "drop caps" will be as simple as using a single CSS property:

p:first-of-type::first-letter {
  initial-letter: 2; /* Number of lines to span */
}

At the time of writing, this property is not yet supported in Firefox
. Given that this is a purely cosmetic effect, it may be alright to use it anyway, depending on the circumstances.


---

## Masonry Grid with Columns

Source: /css-for-js/06-typography-and-media/05-masonry-layout

Masonry Grid with Columns
(Optional lesson)

In the previous lesson, we saw how CSS column layout can be used to implement "print" layouts, like books or magazine articles. But that's not all it can do: in this lesson, we'll see how it can be used to implement a masonry layout.

A quick caveat
(info)

Masonry layouts have historically been very tricky to pull off on the web. The approach discussed in this lesson is robust, but fairly limited; it won't work in many situations. These limitations are discussed below.

What is masonry layout?

Made famous by sites like Pinterest and Unsplash, masonry layout is a way of stacking elements in an asymmetric grid, like this:

This layout method is commonly used with images, because it allows us to create a seamless grid with elements of all different sizes. If we tried to recreate something like this with CSS Grid or Flexbox, we'd wind up with something much less appealing:

Let's see how CSS columns allow us to create a masonry layout:

Correction: At 2:16, I say "letter-spacing", when I meant to say "line-height".

Here's the code playground from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Limitations

This method of creating a masonry layout is great, but it won't work in all circumstances.

For one thing, items are laid out from top to bottom:

This is incongruent with the path our eyes take over the elements. We generally view content on the web from side to side
*
, something like this:

If our content is unordered, this may not seem like a big deal, but it's important to remember that tab order is also affected. If these elements are interactive, the tab sequence looks like this:

It can be pretty jarring, especially when the masonry grid is tall enough not to fit in the viewport.

This has one more important ramification: if we dynamically add more items to the grid (eg. infinite scroll), they don't get added onto the end, as we'd expect. Instead, the elements are added to the final column, and everything is redistributed.

Here's how we expect it to process new items (new items indicated with a blue color + border):

…And here's how it actually processes new items:

Preserving order
(info)

On his blog, Tobias Ahlin shares a rather clever way
 to use order and :nth-of-type pseudoclasses to better approximate a Masonry layout with Flexbox.

It's definitely a heavier cognitive lift, but it can be a worthwhile approach if the order is important!

The future

The good news is that browser vendors recognize that web developers want an easy way to implement masonry layouts, and they're working on it. Soon, we'll be able to use a special variant of CSS Grid that will let us create masonry rows:

.container {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: masonry;
}

This new variant is customizable, letting us easily control the order that elements are rendered in!

The bad news is that as I write this, no browsers support this variant
. Once it reaches mainstream support, I'll update this lesson.

In the meantime, if you need a pagination-safe masonry layout, I suggest using a JavaScript library. The most popular option is aptly named Masonry.js
 (which has been wrapped for React
 and possibly other frameworks).


---

## Text Styling

Source: /css-for-js/06-typography-and-media/06-text-styling

Text Styling

In the first module of this course, we covered the fundamentals of typography, things like creating bold/italic text, font sizes, and text alignment.

In this lesson, we're gonna expand on that knowledge. We'll learn a few more tricks, and see how text layout intersects with some of the stuff we've learned in the other modules.

Line length

Have you ever tried to read Wikipedia on a very large screen? Until recently, it looked like this:

Until a design refresh in 2026 (which introduced narrow/wide mode), Wikipedia didn’t constrain the maximum width. It used to grow as wide as it could.

This might seem like a good thing, since it makes use of all available space, but it makes the text much harder to read. Having to scan such wide lines tends to fatigue our eyes. And when we reach the end of a line, it's hard to figure out which line is next.

When I encounter text like this on the web, I wind up needing to use text selection in order to track where the line wraps:

Research on the ideal line length is a bit mixed, but most sources agree that the acceptable range is between 50 and 75 characters per line
.

Fortunately, CSS has a built-in unit for this purpose—the ch unit:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  p {
    max-width: 50ch;
    margin-bottom: 1em;
  }
</style>

<p>
  Many poor golf courses are made in a futile attempt to eliminate the element of luck. You can no more eliminate luck in golf than in cricket, and in neither case is it possible to punish every bad shot. If you succeeded you would only make both games uninteresting.
</p>
<p>
  It is an important thing in golf to make holes look much more difficult than they really are. People get more pleasure in doing a hole which looks almost impossible, and yet is not so difficult as it appears.
</p>
<p>
  Excerpt taken from <cite>GOLF ARCHITECTURE</cite> by Dr. A Mackenzie, published 1920.
</p>
Result
Refresh results pane

1ch is equal to the width of the 0 character, at the current font size.

Does setting a width of 50ch mean that we'll get an average of 50 characters per line? Not exactly. Depending on your font, the 0 character might be significantly thinner or thicker than average.

On this platform, I use a font called Wotfard
. Wotfard's “0” is chunky: I've found that 50ch creates line lengths around 70 characters long.

Ultimately, we don't need to be too precise here. As long as we're somewhere near the sweet spot of 50-75 characters, our users will have a pleasant reading experience.

Text alignment

In Module 4, we saw how Flexbox can be used to precisely control the distribution of elements, including paragraphs.

You may wonder: does text-align still have a role to play, in a Flexbox / Grid world?

It does seem like the two approaches can be used interchangeably, within a Flex column:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

In fact, though, they do very different things. Check out this example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

What's going on here? Well, text-align: center moves all of the individual characters to the middle of each line, the way you'd expect centering to work in a rich text editor.

align-items, though, is more about layout alignment. It positions the paragraph as a block. It doesn't affect the individual characters within that block.

We can see what's going on more clearly by adding a pink border to each paragraph:


---

## Font Stacks

Source: /css-for-js/06-typography-and-media/07-font-stacks

Font Stacks

The font-family property is how we change the font for a given element (and its children, since the property is inheritable).

Curiously, it's usually given multiple comma-separated values:

.title {
  font-family: 'Lato', Futura, Helvetica, Arial, sans-serif;
}

This acts as a sort of "preference list". We've given the browser a list of fonts we'd like to use, in priority order. Ideally, it'll pick the first one, but if it's not available, it can use the second, or the third, or the fourth.

The last font in the list should always be the "category" for the font, like serif, sans-serif, monospace, or cursive. This ensures that if none of the other options are available, the browser will use its default font for that category.

Fonts can be unavailable for two reasons:

The font isn't installed on the user's device.
The font is a web font, and it hasn't yet been downloaded.

While every operating system comes with dozens of fonts, there are only a small handful that are "universally" available. Fonts like:

Arial
Courier New
Georgia
Verdana
Tahoma
Times New Roman

The helpful website CSS Font Stack
 shows how common each font is between Windows and macOS. For example, Calibri is available on 83% of Windows devices, but only 39% of macOS ones. Even historically-standard fonts like Arial aren't available for 100% of users.

So the goal with a font stack is to provide a menu of fonts that the browser can pick from, making sure that every user sees an acceptable font and nobody sees the (usually quite ugly) default serif browser font.

Consistent experiences across devices
(info)

You might be wondering: don't we want all users to see the exact same font? Why would we specify a list of possible fonts? Won't that lead to inconsistent experiences?

Indeed, fonts can be an important part of a brand identity. Airbnb commissioned their own font, Cereal
, and I imagine they want to make sure all users see it.

Unfortunately, we don't really live in a world where we can guarantee that sort of thing. As we'll learn in the lessons ahead, optimizing for the best user experience can mean making some sacrifices with fonts.

System font stack

A rising trend in recent years is to use the "system font stack". This is a stack of fonts that default to the nicest default option for each platform.

It looks like this:

p {
  font-family:
    -apple-system, BlinkMacSystemFont, avenir next, avenir, segoe ui,
    helvetica neue, helvetica, Ubuntu, roboto, noto, arial, sans-serif;
}

That's a lot of fonts!

Over the years, the default system font on macOS has changed. As I write this, macOS and iOS both use the "San Francisco" font
. -apple-system and BlinkMacSystemFont are aliases for the current system font. avenir next and avenir are fonts from previous versions of macOS.

When a user running Windows 10 visits our app, the browser won't recognize the first 4 options, but it will recognize Segoe UI — as I write this, Segoe UI is the default system font in Windows 10.

The system font stack is nice because it automatically matches the conventions of the user's device, just like the radio buttons or select tags. And modern operating systems use well-designed fonts, so our application won't suffer cosmetically.

There are system font stacks for serif and monospace fonts as well. Find the full set at systemfontstack.com
.

Here's an example of the same page, rendered in Windows 10 and macOS Big Sur, using serif and sans-serif font stacks:

You can view this live on your own machine
 to see how it looks with your system fonts.

CSS Variables to the rescue!
(info)

When it comes to working with the system font stack, CSS variables make life way nicer:

html {
  --font-sans-serif:
    -apple-system, BlinkMacSystemFont, avenir next, avenir, segoe ui,
    helvetica neue, helvetica, Ubuntu, roboto, noto, arial, sans-serif;
  --font-serif:
    Iowan Old Style, Apple Garamond, Baskerville, Times New Roman,
    Droid Serif, Times, Source Serif Pro, serif, Apple Color Emoji,
    Segoe UI Emoji, Segoe UI Symbol;

  /* Set a global default */
  font-family: var(--font-sans-serif);
}

/* Apply different fonts as needed */
p {
  font-family: var(--font-serif);
}

---

## Web Fonts

Source: /css-for-js/06-typography-and-media/08-web-fonts

Web Fonts

If we want to use a font that doesn't come pre-installed on the user's device, we can download and use a custom font!

There are lots of ways to do it. In this lesson, we'll look at a couple popular services that can help, and also see how to do it from scratch.

Using Google Fonts

Google Fonts
 is an online repository of free, open-source web fonts. They have hundreds of popular options.

It also effectively works as a CDN for fonts; they serve the fonts for us, from their own servers.

Google Fonts works by providing a snippet that looks like this:

<link rel="preconnect" href="https://fonts.gstatic.com">
<link
  href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@1,400;1,600&display=swap"
  rel="stylesheet"
>

Drop this in the <head> of your HTML file.

The snippet will download a stylesheet which downloads a font. We can access that font in our CSS:

.thing {
  font-family: 'Open Sans', sans-serif;
}

Web fonts should be wrapped in quotes ('Open Sans', not Open Sans). This isn't strictly required if your web font is a single word, but it's a helpful convention: it indicates which fonts in the stack are web fonts vs. local fonts.

No HTML file?
(info)

If you use a framework like Next.js, you may be a bit confused by the lack of an index.html anywhere in the project.

Some frameworks generate this file automatically, so that they can include the JS bundles and perform other optimizations.

These frameworks generally include built-in methods for working with web fonts. In Next.js, for example, there's the next/font module
.

You might need to do some research to figure out how to do this for your framework of choice.

The main benefit to Google Fonts is that it's nice and easy. Drop an HTML snippet in your app, and you're good to go!

There are some downsides, though:

Lots of amazing fonts aren't available on Google Fonts
Self-hosted web fonts can perform better

Gatsby creator Kyle Matthews discovered that self-hosting fonts can save 300ms on desktop, and 1s+ on mobile 3G
.

Performance trade-offs
(info)

I was initially surprised to learn that Google Fonts was a bit sluggish. Why are their servers so slow??

It's not actually about server speed, it's about the difference in approach.

 Show more

GDPR compliance
(warning)

In 2022, a German court ruled that Google Fonts doesn't comply with GDPR
, the EU privacy laws. A website owner was fined €100 for the violation.

To stay fully compliant with GDPR, you should self-host your fonts. We'll explore how to do this in the “Font Optimization” lesson.

Using modern tooling

Vercel, the company behind the Next.js framework, has released an interesting free resource called Fontsource
.

The idea with Fontsource is that it provides an easy-to-use method to install and use self-hosted web fonts. It's built specifically for modern JS applications, letting you NPM install the fonts you wish to use. They support all Google Fonts, as well as additional open-source free-to-use fonts.

You can learn more by reading their documentation
.

Angular v11+ has built-in support for Google Fonts, with configuration for inlining the fonts directly. You can learn more in the Angular docs
.

The manual way

What if you want to use a font that isn't available on Google Fonts or Fontsource?

The rest of this lesson shows how to add web fonts "from scratch". Feel free to skip the rest of this lesson if you're happy with another option (though it may still be interesting to learn more about how web fonts work!).

Converting formats

The fonts that run on our computers typically come in .otf or .ttf file formats. These file formats were never intended to be used on the web, and their files tend to be relatively enormous.

Our first order of business is to convert our font into a web-friendly format. You can use online converter tools like Fontsquirrel's webfont generator
.

The font-face tag

How do we tell the browser that we want to use a web font? The @font-face at-rule has us covered:

@font-face {
  font-family: 'Wotfard';
  src: url('/fonts/wotfard-regular.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
}

@font-face {
  font-family: 'Wotfard';
  src: url('/fonts/wotfard-medium.woff2') format('woff2');
  font-weight: 500;
  font-style: normal;
}

@font-face {
  font-family: 'Wotfard';
  src: url('/fonts/wotfard-bold.woff2') format('woff2');
  font-weight: 700;
  font-style: normal;
}

@font-face {
  font-family: 'Wotfard';
  src: url('/fonts/wotfard-regular-italic.woff2') format('woff2');
  font-weight: 400;
  font-style: italic;
}

We need multiple statements because each font weight and style has its own file. In this case, I'm loading 3 different font weights (regular, medium, and bold) and an italic variant for the regular weight.

The font file itself doesn't contain any "metadata" about what weight/style it is, so we need to link them up. That's what all the declarations in the @font-face statement are doing. We specify the source for a set of characters (src), and then the associated metadata with that set (font-family, font-weight, font-style).

IE support
(info)

In the old days, we needed to supply 3 or 4 font files for each character set, because different browsers supported different formats.

These days, things have gotten a lot better. The .woff2 format is a modern, highly-optimized format that works across all major browsers, but not in Internet Explorer.

My personal opinion is that web fonts are a nice-to-have. I think it's perfectly fine to use a built-in fallback font for IE users. But if you'd prefer that IE users have access to the web font, you'll need to specify a .woff fallback.

 Show more

Our goal is to start loading the fonts ASAP, so I like to put these @font-face statements right in the index.html:

<html>
<head>
  <style>
    @font-face {
      font-family: 'Wotfard';
      src: url('/fonts/wotfard-regular.woff2') format('woff2');
      font-weight: 400;
      font-style: normal;
    }

    /* Other @font-face statements omitted for brevity */
  </style>
</head>

When those @font-face statements are parsed by the browser, the font file declared under src will be fetched and loaded. You can use the font in your CSS the way you'd use any font:

.something {
  font-family: 'Wotfard';
  font-weight: 400;
}

Static files in React
(warning)

One of the tricky things about React is that you can't access static files like fonts or images in the same way you would in a standard HTML/CSS project. They generally need to be placed in a special /public directory, or you’ll need to import them the same way you’d import a JS module.

It depends on what bundler / meta-framework you’re using (eg. Vite, Next.js, etc), so I’d recommend searching for “static files” in your tool’s documentation to learn how to do it.

Faux bolds and italics

The @font-face statement lets us connect a specific font weight value (eg. 700) to a character set. When we use either font-weight: bold or font-weight: 700, the browser will use the heavier characters instead of the default ones.

But what happens if we try to use bold text when we haven't supplied a bold font file?

The browser can create "faux" bold text. It achieves this by expanding the thickness of every line in every font, stretching it out in all directions. This tends to create muddy, indistinct letters.

For example, here's a side-by-side of a font's true bold, vs. the browser's imitation:

True bold
Faux bold
Toggle
Expand

When font designers create bold variants of a font, they're very intentional and strategic about how they change the characters, optimizing for aesthetics and readability. Browser-generated faux-bolds are much less sophisticated; they just make the lines thicker.

Similarly, when it comes to italics, the browser simply slants the letters, whereas true italics use alternate characters:

True italic
Faux italic
Toggle
Expand

To be fair, I'm using a highly-stylized font (Playfair Display
) in these examples. The differences can be more subtle than this. But it's the kind of small detail that can make a surprisingly big impact on how polished/professional your site/application appears to users.

Number rounding
(info)

Let's suppose that we decide on including two font styles from our web font: the 400 weight, and the 800 weight.

What do you suppose happens when you use a "bold" font weight?

.thing {
  font-weight: bold;
}

Or, what if you use a number in-between the numbers you've set up?

.thing {
  font-weight: 700;
}
 Show more

---

## Font Loading UX

Source: /css-for-js/06-typography-and-media/09-font-display

Font Loading UX

When a person visits our site for the first time, they'll need to download all of the web font files we're using
*
.

This doesn't happen instantaneously. In most cases, our HTML will be ready-to-go while the font files are still zipping around the internet.

What should we do?

There are two main options:

Wait until the web font has been downloaded before showing any text.
Render the text in a "fallback" font, one that is locally installed on the user's device.

Both of these options introduce problems. With Option 1, we're depriving the user of the text they care about. With Option 2, the experience can be quite jarring, flipping between fonts and causing layout shifts.

Option 1 is colloquially known as FOIT — Flash Of Invisible Text. Option 2 has been called FOUT — Flash Of Unstyled Text.

As long as users need to download web fonts when they visit our page, this problem will exist. Fortunately, however, we can improve things a bit with some modern CSS.

Works on my machine
(info)

It may surprise you to learn that this is a problem. It's likely that you've never experienced any flashes of unstyled/invisible text, when viewing your application on your machine!

There are some things to keep in mind:

On localhost, the font can be downloaded instantly, so you won't encounter this problem.
In production, you'll only notice this the first time you visit the page, since the browser will cache it for your site.
You might already have the font installed locally on your machine.
Your internet connection might be significantly faster than the worldwide average.

For a more realistic picture of how your users see your application, you should throttle your network speeds
 and disable local fonts
.

The font-display property

To control how a font should be rendered before it's available, we can take advantage of the font-display property.

It's included in our @font-face statement:

@font-face {
  font-family: 'Great Vibes';
  src: url('/fonts/great-vibes.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap; /* 👈👈👈 */
}

When we add the Google Font snippet, it includes a query parameter that sets this property:

In order to understand this property, we need to talk about the font-display timeline.

The moment an HTML element tries to render text in our web font, a timer starts. Like a hockey game, there are 3 periods:

The block period. During this time, the text will be painted in an invisible ink, so that no text is visible. It'll render the font ASAP if it becomes available during this period.
The swap period. During this time, a fallback font is rendered (the first available font in the font stack). If the web font becomes available during this period, it gets swapped in immediately.
The failure period. If the font isn't loaded during the block or swap periods, it stops trying, and will keep showing the fallback font no matter what happens with the web font.

How long are each of these periods? It depends on the font-display property. Essentially, font-display is a way to control the length of each window.

Let's go through the options:

Block
Legend:
Block Period
Swap Period
0 Seconds

font-display: block prioritizes the availability of the font over everything else. It has a relatively-long block period, and an infinite swap period.

The specification doesn't provide explicit time durations for these periods, but it does provide recommended maximums. For font-display: block, the block period should be no more than 3 seconds.

This value should only be used when the font is absolutely critical. For example, if you use an icon font, we really do want the font to be loaded before the "text" is shown, otherwise we might see random letters instead of the icons. As we'll learn later in this module, though, icon fonts in general should be avoided.

Swap
Legend:
Block Period
Swap Period
0 Seconds

With font-display: swap, there is little to no block period
*
, and an infinitely-long swap period. The goal is to get text rendering as quickly as possible.

This is the value that Google Fonts uses. It's a good option, but I think there's a better one for most cases.

Fallback
Legend:
Block Period
Swap Period
Failure Period
0 Seconds

font-display: fallback is the most intricate value, and I think it strikes the perfect balance.

It features a very-short block period (about 100ms), and a moderate swap period (about 3s).

This is my preferred value. I use it in all of my projects. It prioritizes a smooth user experience above all else:

On speedy connections, it's likely that the font can be downloaded within the block period, preventing an uncomfortable flash between font families
On very slow or intermittent connections, the fallback font is used forever, preventing a random flash between fonts seconds/minutes after the page has loaded.

Ransom note effect
(warning)

For font-display values that have a failure period (fallback and optional, discussed next), there is a small chance that certain fonts in the family won't be loaded.

Let's imagine that we use 3 different font weights with our web font, and the user is on a slow connection. Here's how long they take to load:

Font Name	Load Time
font-regular.woff2	2.1 seconds
font-medium.woff2	2.8 seconds
font-bold.woff2	3.4 seconds

Regular and medium load quickly enough that they're swapped in, but bold takes too long; by the time it loads, we're in the failure period, and so the fallback font is kept.

This means that bold text (eg. headings, <strong> elements) will use a different font family, leading to what the CSS specification charmingly calls a “ransom note” effect.

To be clear, the odds of this happening are very low. In my experience, web fonts tend to come in around the same time. But if you want to guarantee it doesn't happen, you can use font-display: swap, or use a variable font (discussed in the next lesson).

Optional
Legend:
Block Period
Failure Period
0 Seconds

Finally, font-display: optional is a great choice when the font is a subtle improvement, but not really very important. It features a short block period (100ms or less), and no swap period at all. If the font doesn't load immediately, it won't be used at all.

Generally, this value means that users will see the fallback font for their first page, but the web font for all subsequent pages. The first page view loads the font in the background, to be applied on the next page view.

It means that almost everyone will see the fallback font on their first visit, but there won't be any flashes of unstyled text, and no layout shifts caused by a slow-loading font.

So, which value should you use? Ultimately, there's no “right” answer. I prefer font-display: fallback because I think it strikes the right balance for my projects, but you may have different priorities.

Font matching

If you use a font-display with a swap period (everything except optional), there's a good chance that the rendered text will flip from one font to another. If the fonts are very different in size/shape, this can cause a pretty unpleasant layout shift:

Browsers have recently begun implementing a new feature called "font descriptors" (also known as f-mods). These let us tweak the characteristics of our fallback font to match the web font, for a much-less-jarring swap.

Here's what it looks like:

@font-face {
  font-family: "Great Vibes";
  src: url('/fonts/great-vibes.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: "Fallback";
  size-adjust: 95%;
  ascent-override: 90%;
  descent-override: 20%;
  src: local("Arial");
}

body {
  font-family: "Great Vibes", "Fallback", sans-serif;
}

size-adjust, ascent-override, and descent-override all control the vertical size/position of the text. size-adjust is similar to font-size, ascent-override/descent-override are similar to line-height.

As I write this in January 2023, Chrome/Firefox/Edge have implemented the first category, and several tools have popped up to take advantage of it:

Fallback Font Generator
, a tool to help you come up with appropriate size-adjust, ascent-override, and descent-override values.
Fontaine
, a plugin that automatically calculates and applies size-adjust, ascent-override, and descent-override.
next/font
 applies these same optimizations, for folks using Next.js.

I did some experimentation on my blog, and found I had best results using the “Fallback Font Generator” tool to manually tweak things. I chose Verdana as my fallback font, since it looked the most-similar to Wotfard, the web font I use.

Here's the result:

It's not perfect, but it's a heck of a lot better than it was before!

In terms of browser support, size-adjust has been available across all modern browsers since 2023. ascent-override/descent-override have not yet been added to Safari
 as of March 2026, but that shouldn’t stop you from experimenting with this stuff! Even if the properties have no effect for ~20% of users, the remaining 80% will still benefit from this optimization.

You can learn more about f-mods here:

Intro to f-mods from Simon Hearne

---

## Font Optimization

Source: /css-for-js/06-typography-and-media/10-font-optimization

Font Optimization

Font optimization is a huge topic, and one well beyond the scope of this course.

I'll link to some resources at the bottom of this article, but for our purposes, I'm gonna suggest that we let Google do all the hard work for us.

A little-known fact about Google Fonts is that they come heavily optimized. Let's look at an example.

Inter is a critically-acclaimed sans-serif font. It's free and open-source. When you download it from its official website
, each .woff2 font file ranges from 99kb to 151kb. When I added 3 font weights to a sample product, it downloaded 427kb worth of fonts.

When I load the same 3 font weights through Google Fonts, it squeezes them all into 1 file
*
 that was only 37kb. A savings of over 90%!

In this video, we'll show how this is possible, and how we can self-host Google's optimized versions of fonts.

In addition to the method shown in this video, Discord member tris shared a helpful tool, google-webfonts-helper
. It allows you to quickly download optimized fonts from Google Fonts. It seems quite a bit more convenient, though there is a caveat: it doesn't support variable fonts.

Font optimization
(success)

If we can reduce the filesize of each font file, we can increase our expressiveness without harming performance.

For example, if your app only includes a single language like English, you can remove glyphs that only appear in other languages, like é or ç. This can drastically reduce the size of a font file.

Font optimization is beyond the scope of this course, but here are some resources to get you started:

Using Glyphhanger to optimize font files
, by Sara Soueidan
Reduce Web Font Size
, a guide from Google's web.dev.

---

## Variable Fonts

Source: /css-for-js/06-typography-and-media/11-variable-fonts

Variable Fonts

When using web fonts, each weight and style is its own file. If you want to have three weights (regular, medium, and bold) and two styles (regular and italic), you'd need six different font files. Having this many files is a recipe for invisible/unstyled text, as we saw in the last lesson.

Fortunately, a spiffy new technology has come to our rescue: variable fonts.

The idea with a variable font is that the font has parameters that can be tweaked to control the rendered output. The most obvious example is font weight:

Beep Boop

font-weight
500

This font is called Recursive
. It's a delightful font.

With standard fonts, we need to pick 2 or maybe 3 weights. With variable fonts, there are hundreds of valid values.

Notice that the text isn't simply getting thicker—the font actually changes, as if it's being custom-designed for each value:

Font weight is an example of an "axis", essentially a variable that can slide within a specified range. There are 5 standardized axes, but font designers can add custom ones as well. This font, Recursive, defines 5 axes (2 standard and 3 custom):

Ghost Quench

font-weight
500
slant
0
mono
0
casual
0
cursive
on
off

Be sure to try that “casual” slider. It's wild.

Font designers are having fun and building amazing fonts. Decovar
, by David Berlow, provides a suite of different stems and skeletons. You can make some zany and illegible words with it:

Browser support
(info)

Good news! Variable fonts are supported on all major browsers
.

Internet Explorer is, predictably, missing. We can always specify a non-variable fallback, though. Or, we can simply use a locally-installed alternative for IE users.

Variable fonts on Google Fonts

Happily, Google Fonts recently added support for variable fonts! You can view a full list of supported fonts
, and learn how to use them
 in their docs.

As I write this, their docs are unfortunately not super clear.

Here's how to correctly pull variable fonts from Google Fonts:

Here's the final snippet from the video:

<link rel="preconnect" href="https://fonts.gstatic.com">
<link
  rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&display=swap"
>
Variable fonts from scratch

Here's an updated @font-face statement:

@font-face {
  font-family: 'Recursive';
  src:
    url('/fonts/recursive-variable.woff2') format('woff2 supports variations'),
    url('/fonts/recursive-variable.woff2') format('woff2-variations');
  font-weight: 300 1000;
  font-display: fallback;
}

If we want to use "custom" variations like “casual”, we'll need to indicate that it's a special version of the .woff2 format. This was initially done with woff2-variations, but was updated to be woff2 supports variations. During this transition period, we'll need to supply both.

Notice, too, that we specify two numbers for font-weight. This is the range of font weights that this variable font supports. We're specifying that this @font-face statement should apply for any font weight between 300 and 1000, inclusive.

Using variable fonts

When it comes to font weight, things are nice and straightforward. We can use font-weight, same as we always have, except now we can pick any value within our range:

.hello {
  font-weight: 777;
}

But how would we specify custom variations, like "cursive" or "casual"? The new font-variation-settings property can help:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

font-variation-settings accepts a comma-separated list of settings. Each setting tweaks an axis (written as a four-letter string in quotes), and a value (always a number).

We can also use this property to set “built-in” font properties, things like font-weight and font-style:

/* This rule: */
.with-settings {
  font-variation-settings:
    "wght" 725,
    "wdth" 125,
    "slnt" -10;
}

/* …is equivalent to this rule: */
.without-settings {
  font-weight: 725;
  font-stretch: 125%;
  font-style: oblique -10deg;
}

That said, I recommend using the standard properties. font-weight: 725 feels more readable to me than font-variation-settings: "wght" 725. It also seems as though some variable fonts don't implement font-variation-settings correctly; it's more hit-or-miss.

And so really, I view font-variation-settings as a way for us to customize non-standard font aspects, like the cursive/casual options we saw above.

Each font has its own axes and ranges, so you'll need to consult the documentation for each font to figure out what your options are. For Recursive, this information is available on their homepage
:

Exercises
Site footer

In this lesson, we've seen some of the wild and creative things we can do with variable fonts. It's easy to get carried away with some of the more outlandish applications for variable fonts, but it's important to remember that they're immensely practical as well.

For this exercise, we're going to use variable fonts to update a website footer, from this:

…to this:

Because we're using a variable font, we're able to use many different font weights and styles without needing to download a separate font file for each one.

You can find the design on Figma:

https://www.figma.com/file/KbQfipRhstSKwc0EUbnJ71/Variable-Fonts-Exercise

This exercise exists as its own repository. More instructions are available in the README.md:

https://github.com/css-for-js/variable-fonts-exercise

Solution:

View the solution
 on Github.

A small correction
(info)

In the video, you may have noticed that I applied my global CSS using the wildcard selector (*):

* {
  --color-gray-100: hsl(270deg 25% 96%);
  --color-gray-300: hsl(270deg 17% 84%);
  --color-gray-500: hsl(270deg 17% 72%);

  font-family: 'Raleway', sans-serif;
}

This has been changed. In the updated version of the exercise, I instead apply the CSS variables to the root html tag:

html {
  --color-gray-100: hsl(270deg 25% 96%);
  --color-gray-300: hsl(270deg 17% 84%);
  --color-gray-500: hsl(270deg 17% 72%);
}

Ultimately, both of these approaches work, but there's a subtle difference. It's slightly better to place our global CSS variables on the root html tag.

If you're curious, we'll dig into the difference here:

 Show more

---

## Icons

Source: /css-for-js/06-typography-and-media/12-icons

Icons

Icons are a super important part of just about every modern application.

When it comes to the web, there are two common ways of implementing them: we can use an "icon font", where each character resolves to an icon instead of a letter, or we can use SVG, where each icon is an inline SVG DOM node.

Of the two, I much prefer the SVG approach, for so many reasons:

SVGs tend to look more crisp and sharp.
They're easier to position and use (width instead of font-size makes way more sense!).
They can be more accessible.
They can be multi-color.
They can be tweaked and animated.

In this lesson, we'll learn how to use modern SVG icon packs in JavaScript frameworks.

What's an SVG?
(info)

SVG stands for “Scalable Vector Graphic”. Unlike other image formats like JPEG and PNG, which store binary information about the colors of specific pixels, SVG stores the mathematical instructions for how to draw the shapes within the image.

It's written in XML, which means it looks an awful lot like HTML. Here's a "Hello world" SVG which draws a pink circle:

 Show more
Popular icon sets

Unless you have a design team on hand, you'll likely want to use a pre-existing icon set rather than creating one from scratch.

Here are some of my favourites:

Feather icons
Phosphor Icons
icomoon
Material Design icons

More information about Feather Icons
(info)

I share a bit more information about how I use Feather Icons over in the Treasure Trove:

Feather Icons
Using icons

When you visit the homepage for an icon pack, you're given the option to download individual SVG files for each icon.

If you use React, you'll also need to convert each of the SVG files to JSX, so that they can be used as React components. There are online tools that can help with this
, but if you have dozens or hundreds of icons, it winds up being quite a bit of work.

Fortunately, there are packages that can help us out!

In React, for example, Feather's creator has created an NPM package, react-feather. Feather icons can be imported and rendered:

import React from 'react';
import { HelpCircle } from 'react-feather';

function Something() {
  return (
    <div>
      <HelpCircle />
    </div>
  );
}

Similar packages exist for Vue
, Angular
, and even Svelte
.

Icons and accessibility
(warning)

It's important to remember that some of our users will use our product with a screen reader instead of a typical display. Screen readers can accurately dictate the text on our page, but they don't know how to deal with our SVG icons.

There are a number of ways we can add additional text information for folks using a screen reader. Here's my favourite:

<button>
  <HelpCircle />
  <span class="visually-hidden">
    Visit the help center
  </span>
</button>

For more information about the .visually-hidden class, check out the “Hidden Content” lesson.

If you choose to use an icon font, you have an additional challenge: the icon is mapped to a random character, which can produce garbled output to screen readers. You'll need to add aria-hidden to the icon element (as well as provide fallback text, using visually-hidden).

Spacing issues

For all of the benefits that SVG icons bring, there is one super-common, super-frustrating issue with them.

Take a look at the following example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Our button has no padding, and yet there's a noticeable, asymmetric amount of bottom spacing.

Take a minute to think about this. Can you figure out where this space is coming from?

(Keep scrolling for the answer)

The culprit here is something we saw much earlier, in a very different context. The problem is that SVG elements have a default value of display: inline, and inline elements have "magic space".

Using an icon pack can make this a bit tricky, since we may or may not have access to the underlying SVG element. I like to solve this in CSS, using a descendant selector:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
Result
Console
Refresh results pane

Isn't this a bad practice?
(info)

In general, I'm not a fan of nesting when working with a component-driven JavaScript framework.

Nesting makes it harder to understand where styles are coming from; the brilliant thing about solutions like styled-components is that all of an element's styles are colocated in 1 spot
*
. We can solve so many problems by deftly side-stepping the cascade and tying our styles to the element. When we start messing with descendant selectors, we open the door for all sorts of troubles (eg. specificity wars).

In this situation, though, the SVG is an element created by a third-party component. I make an exception for third-party components.

Here's why it's different: I don't have the ability to write styles within the Home component, since it's tucked away inside an NPM package. So instead, my Header component “adopts” it. It becomes the single source of styles.

The most important thing is that we don't "compete" with our own styles. When I write a declaration, I shouldn't have to worry about some other style somewhere else in the app that might be overwriting it. With this solution, all of my styles for that <svg> HTML element are in 1 place. That's what's important.


---

## Images

Source: /css-for-js/06-typography-and-media/13-images

Images

Like so many things in CSS / the web, images are deceptively complex.

It's (relatively) easy to get started with images. Throw a url in an <img> tag, and it displays! And yet, there is so much complexity under the surface.

Working with images in CSS has changed a lot over the past few years. We've gotten some new tools to make it easier, and some other new tools that make it more complex, but better for our users.

Over the next few lessons, we'll dig into the intricacies of image rendering and layout. Before we get ahead of ourselves, though, let's go over the fundamentals.

About the img tag

The img HTML tag has two required attributes:

src
alt

alt is a property that allows you to specify "alternative text". It's meant to serve as a description of what the image contains.

You've probably heard that alt text is important. It provides critical context to folks who aren't able to see the images, whether because of a visual disability or because of a faulty network connection.

Not all images require alternative text. If the image is purely decorative and has no semantic value, you can specify alt="" to indicate that screen readers can ignore it.

How do we know if an image is semantically valuable? I try and imagine what the user experience would be like if the image failed to load. If I don't know what's depicted in the image, would it make the product harder to use? If so, it definitely requires alt text.

In some cases, an image isn't critical to the user experience, but it still provides value. For example, Wikipedia articles include relevant photos. While the article still makes sense without these photos, they provide valuable context, and should be described with alt text.

If you're not sure if an image qualifies as decorative or not, it's best to err on the safe side, and add alt text. Folks using screen readers can easily skip past images, so don't worry about "polluting" the experience for them!

Eric Bailey writes about how to judge if an image is decorative in the blog post “Your Image Is Probably Not Decorative
”.

Writing effective alt text

There is a lot of confusion around how to write effective alternative text.

The goal with alternative text should be to convey the semantic meaning of the image to the user.

Let's look at an example. Suppose we're building an analytics dashboard called Octo Analytics. Here's a mockup I found online (source
):

Like many sites, the company logo is in the top-left corner. Let's assume that it links to the product's homepage.

What should the alt text be, for this green corner logo?

Many developers will describe the image as they see it, something like “Abstract green octopus illustration”. This seems to make sense, but it isn't actually very helpful for real users. What is the purpose of this green octopus? What happens if I click on it?

As sighted users, we can infer a lot of meaning from the visual context. An image in the top-left corner of the page is usually a logo, and it usually links back to the homepage.

If we can't see the layout of the page, though, we don't have that context
*
. So we need to provide it in the alt text.

Here's what I'd set it to:

<img
  alt="Octo Analytics logo - Home"
  src="/logo.png"
/>

We're letting the user know that it's a logo, and that it leads to the homepage. It's the same context that sighted users take for granted.

Interestingly, this means that the exact same image might have totally different alt text depending on the circumstances. The alt text depends on the context the image is used in, not just the contents of the image.

One more thing: Alt text should not include additional contextual information. For example, here's what you shouldn't do:

<img
  src="/landscape.jpg"
  alt="Painting of a beautiful landscape. Artist: C. Essess"
/>

Instead, the attribution should go in a <figcaption> below the image:

<figure>
  <img
    src="/landscape.jpg"
    alt="Painting of a beautiful landscape."
  />
  <figcaption>
    Artist: C. Essess
  </figcaption>
</figure>

Here are the best resources I've found for learning more about writing effective alt text:

How To Design Great Alt Text
 by Deque
Alternative Text
 by WebAIM

Contradictory guidance
(warning)

The two guides linked above, from Deque and WebAIM, are slightly contradictory in places.

For example, Deque recommends company logo images should have the word "logo", as well as some additional context about where the link goes (eg. "Octo Analytics logo - Home"). WebAIM says that the company name alone is sufficient ("Octo Analytics").

Which one of these options is better? Well, it's subjective. On the one hand, WebAIM's suggestion is more terse, saving the user from an unnecessarily-long description. On the other hand, Deque's option is clearer, and the extra bit of information will be helpful for some people / in some contexts.

Here's my personal view: it doesn't really matter which option you go with. Either way, you're doing better than 95% of the sites on the internet.

The important thing is that you're writing alt text with the right goal in mind. You're not simply describing images for people who can't see them. You're trying to provide the context needed so that people can navigate and use your website / web application.

img vs. background-image

In addition to the <img> tag, there's another common way to use images on the web: as a background image, through the background-image CSS declaration.

The background-image property is meant to be used for, well, backgrounds! For example, the old "Space Jam" website has a twinkly star background texture:

I would definitely use background-image in this case, because it functions as a wallpaper, something meant to be hung behind the content, for a purely aesthetic purpose.

It's important to use an img tag for semantically-meaningful images, because background images can't be given alt text.

A mistake developers often make is to use background-image on a semantically-relevant image because they need to take advantage of related CSS properties like background-size and background-position.

Thankfully, modern CSS has our back. In the next lesson, we'll learn how to control image rendering.


---

## Fit and Position

Source: /css-for-js/06-typography-and-media/14-img-fit

Fit and Position

It's important to understand that the <img> tag is fundamentally weird.

img is known as a "replaced element". Unlike other DOM nodes, the browser replaces the <img> tag with a foreign entity: the image itself. Images aren't like other DOM nodes, and they don't always follow the rules.

For example, images are inline elements, and inline elements "go with the flow"; we generally can't give an inline element a height, since that would mess with the layout. And yet, images can be given a height.

Images come with their own intrinsic size, based on the dimensions of the image file. In this example, our image has a natural size of 400 × 300:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<!--
  Because the image is naturally
  400 × 300, it'll take up that
  size by default.
-->
<img
  alt="Blank image showing its own measurements, 400 by 300"
  src="https://courses.joshwcomeau.com/cfj-mats/size-400-300.png"
/>
Result
Refresh results pane

Images also have an intrinsic aspect ratio. This means that if we only supply one dimension, either width or height, the other dimension scales up or down as-needed, to preserve the aspect ratio:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  img {
    width: 200px;
  }
</style>

<img
  alt="Blank image showing its own measurements, 400 by 300"
  src="https://courses.joshwcomeau.com/cfj-mats/size-400-300.png"
/>
Result
Refresh results pane

Even though we haven't set a height, it scales down to 150px, to preserve the same proportions.

What happens if we provide both a width and a height? What if it doesn't match the image's natural aspect ratio?

By default, the image will distort, stretching like a sock being pulled over a foot:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

This may seem like a weird decision for the browser to make, but there isn't really a "right" answer. It's impossible to display an image accurately when we change its proportions. Something's gotta give.

That said, this default behaviour is almost never what we want it to do. A better alternative in most cases is to crop the image, trimming off any excess that can't fit in the specified rectangle.

For many years, this was only possible with background images. Fortunately, modern CSS includes a couple tools that can help us out in this case. First, let's look at object-fit:

Here's the widget from the video:

object-fit
fill (default)
contain
cover
none
Show image “ghost”
Yes
No

“Object”?
(info)

The object-fit property works on images, but it isn't exclusive to images: it can also be used on <video> tags!

In general, it's less relevant with videos, but it can come in handy when working with "video GIFs" (short videos that look/act like animated GIFs, but come in at a fraction of the size).

Object Position

When using an object-fit value like cover, the browser will crop our image so that we see the very center of the image, and trim off the edges. But in some cases, we'll want to use a different anchor point.

object-position lets us specify how the image should be translated or cropped within its available space. It's very similar to background-position, if you're familiar with that property.

In its purest form, object-position takes two numbers: one for the horizontal offset, and one for the vertical offset. Play around with the horizontal position here, with the different object-fit values, to get a sense of how it works:

object-fit
fill
contain
cover
none
object-position
0% 0%

We can also use keywords:

.thing {
  /* Anchor to the top-left corner */
  /* Same as "0% 0%" */
  object-position: left top;
}

Browser support
(info)

The object-fit and object-position properties are supported across every browser except Internet Explorer, according to caniuse
.

The good news is that images will still work for IE users, they'll just be a bit stretched.

Exercises
Swoops

One of my little design tricks is to use SVG swoops like this one for decorative effect:

I generally want this image to grow wider and wider on larger monitors. On smaller devices, though, it looks a bit too swoopy, so I'd prefer to crop it.

Here's the effect we're after:

Update the playground to achieve this result:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The right solution
(warning)

There are lots of valid solutions to this problem, but for this exercise, you should try to solve it using the tools we've been learning about in this lesson. You shouldn't need to use media queries, or overflow: hidden.

Solution:

Scaling and vector images
(info)

You may be wondering: isn't it bad to have an image stretch like this, growing to any possible size? Won't it get pixellated and blurry on large monitors?

This is indeed a concern for raster images, formats like jpg, gif, and png. The swoops above, however, are stored as SVGs. One of the neat things about SVG images is that they can grow to any size without loss of quality. As we saw in the previous lesson, SVGs contain instructions for how to draw the image, not raw color values for individual pixels.


---

## Images and Flexbox

Source: /css-for-js/06-typography-and-media/15-flexbox-interactions

Images and Flexbox

Because the image tag is fundamentally weird, it doesn't always behave the way we expect when it interacts with certain layout modes. This is especially true when it comes to Flexbox.

For example, here we have an image in a flex container. Try resizing the result window, and see if anything curious happens:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  body {
    margin: 0;
    padding: 0;
  }

  main {
    display: flex;
  }

  img {
    flex: 1;
  }
</style>

<main>
  <img
    alt=""
    src="https://courses.joshwcomeau.com/cfj-mats/size-200-300.png"
  />
</main>
Result
Refresh results pane

We've set flex: 1, which sets flex-basis to 0. So why is it overflowing the container on smaller window sizes?

Here's another curiosity: we have two images, and one is set to consume twice as much space as the others. Check out what happens when the window grows, though:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  body {
    margin: 0;
    padding: 0;
  }

  main {
    display: flex;
    gap: 8px;
  }

  img {
    flex: 1;
  }
  .twice-as-big {
    flex: 2;
  }
</style>

<main>
<img
  alt=""
  src="https://courses.joshwcomeau.com/cfj-mats/size-200-300.png"
/>
<img
  alt=""
  class="twice-as-big"
  src="https://courses.joshwcomeau.com/cfj-mats/size-200-300.png"
/>
</main>
Result
Refresh results pane

Most developers assume that setting flex: 2 will cause the image to scale up twice as quickly, for a layout like this:

Can you make sense of why the images are behaving the way they are? Take a couple minutes and think about the rules of Flexbox and how they may or may not be applied here.

We'll explore in this video:

Exercises
The Whispering Owl

You've been tasked with building a marketing page for the release of a new novel, showing off some of the glowing reviews. We're building it module-by-module, and we've made it to the "reviews" section.

Update the code sample below so that it's laid out like this:

The main challenge is in the Flexbox layout, but there's one more nice-to-have: the book should be truncated. Notice that we can't see the top-left corner of the book in the GIF.

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

## Aspect Ratio

Source: /css-for-js/06-typography-and-media/16-aspect-ratio

Aspect Ratio

As we saw earlier, images have an intrinsic aspect ratio. We can see this in action by passing the exact same CSS to images with different intrinsic ratios:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<section>
  <img
    alt="A wide-open outdoor concrete area. Architecture"
    src="https://courses.joshwcomeau.com/cfj-mats/architecture-hugo-sousa.jpg"
  />
  <img
    alt="A modular building against a blue sky. Architecture"
    src="https://courses.joshwcomeau.com/cfj-mats/architecture-joel-filipe.jpg"
  />
  <img
    alt="A unique building with inset curves. Architecture"
    src="https://courses.joshwcomeau.com/cfj-mats/architecture-julien-moreau.jpg"
  />
</section>
Result
Refresh results pane

The 3 images above are each given the same height (200px), but they wind up taking up drastically different widths, because of their natural aspect ratios.

What if we wanted them all to have the same aspect ratio? We could accomplish this by giving them all the same width and height, and using object-fit to avoid stretching:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<section>
  <img
    alt="A wide-open outdoor concrete area. Architecture"
    src="https://courses.joshwcomeau.com/cfj-mats/architecture-hugo-sousa.jpg"
  />
  <img
    alt="A modular building against a blue sky. Architecture"
    src="https://courses.joshwcomeau.com/cfj-mats/architecture-joel-filipe.jpg"
  />
  <img
    alt="A unique building with inset curves. Architecture"
    src="https://courses.joshwcomeau.com/cfj-mats/architecture-julien-moreau.jpg"
  />
</section>
Result
Refresh results pane

This is handy — we can tweak the width and height to change the effective aspect ratio for all images.

But what if we don't know the specific pixel size? Maybe our images use a percentage-based width. Or, the image will grow and shrink inside a Flex container.

How can we scale our images proportionally, at a prescribed aspect ratio?

We can do that with the help of a brand-new property, aspect-ratio:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The aspect-ratio property takes two slash-separated numbers, like 4 / 3 or 7 / 11. This is a ratio of width to height; an aspect ratio of 2 / 1 means that the image will be twice as wide as it is tall.

This new feature is huge. It allows us to auto-calculate the height of an element based on its dynamic width, whether that's a percentage or a flex-grow ratio.

Here's another example, using Flexbox. Try changing the aspect-ratio to see how nifty it is!

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The aspect-ratio property isn't specific to images, either; it works on any element, including notoriously-tricky ones like <video> tags or iframes.

Padding fallback

The aspect-ratio has very solid browser support
 nowadays, but it'll never be supported in Internet Explorer. If we want to support all browsers, we can rely on an old hack using padding-bottom.

Here's what the code looks like:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

What the heck is going on here?

If we inspect it in the developer tools, we're given a bit of a hint:

The .padding-hack element has been given a height of 0px, so its content box is 228px by 0px. But the resulting image is square, because it has 228px of bottom padding, exactly the same amount as the width.

As we saw in Module 1, percentages in padding always refer to width. When we set padding-bottom: 50%, for example, we're saying that the element's bottom padding should be half of its width. Not its height.

So by combining 0px height with a percentage-based padding-bottom, we can recreate any aspect ratio:

.padding-hack {
  /* Equivalent to `aspect-ratio: 2 / 1` */
  height: 0px;
  padding-bottom: 50%;
}

.padding-hack-other {
  /* Equivalent to `aspect-ratio: 5 / 7` */
  height: 0px;
  padding-bottom: calc(7 / 5 * 100%);
}

The problem with this alternative is that the element's content box will be 0px tall. We need this element to hold an image, but it can't do it with 0px of usable space!

We can solve that with absolute positioning. The .padding-hack element becomes a containing block with position: relative. Our image uses absolute positioning to take it out of flow and fill that containing block.

This fallback approach is a pain. It's hacky and it pollutes our markup. Is there an alternative?

Progressive enhancement

In most cases, the aspect-ratio property is used to add a bit of visual polish, for presentational purposes. It isn't usually required for functionality.

Given that most browsers support it, it's reasonable to ask: can we start using it, and provide a different-but-still-good alternative experience, for those using unsupported browsers?

I think so. Here's one way to do this:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

On supported browsers, our images will all scale as squares:

On unsupported browsers, a fixed 200px height will be used instead:

To accomplish this, we’re using feature queries, discussed in the previous module.


---

## Responsive Images

Source: /css-for-js/06-typography-and-media/16-responsive-images

Responsive Images

As we learned in Module 5, modern screens come in all sorts of configurations and densities. A new iPhone has a 3-to-1 ratio between hardware and software pixels. These are known as "high-DPI" displays.

If we render an image at its native size, it's going to be fuzzy on a high-DPI display. To keep things crisp, we need to serve different images depending on the screen's pixel ratio.

When exporting assets from the design tool, it's common to export 2 or 3 versions of the image. The ratio is generally included in the filename, like this:

cat.jpg (300 × 300)
cat@2x.jpg (600 × 600)
cat@3x.jpg (900 × 900)

Let's talk about how we can use those assets properly.

Image components
(info)

Image optimization is a huge topic, and we're only going to scratch the surface of it in this course.

If you use a meta-framework like Gatsby or Next, there's some good news: these tools come with battle-tested Image components that implement all the hard stuff for you:

next/image
gatsby-image

These packages offer a ton of neat features out-of-the-box:

 Show more
The srcset attribute

The quickest way to get up and running with responsive images is to use the srcset HTML attribute:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<img
  alt=""
  src="https://courses.joshwcomeau.com/cfj-mats/responsive-diamond.png"
  srcset="
    https://courses.joshwcomeau.com/cfj-mats/responsive-diamond.png 1x,
    https://courses.joshwcomeau.com/cfj-mats/responsive-diamond@2x.png 2x,
    https://courses.joshwcomeau.com/cfj-mats/responsive-diamond@3x.png 3x
  "
/>
Result
Refresh results pane

srcset is essentially a "plural" version of src. The browser will scan through the list and apply the first one that matches.

We keep a redundant src property strictly for older browsers: srcset enjoys universal browser support
 amongst modern browsers, but the src attribute ensures that IE users will still see our images.

To help debug, the browser devtools will let you know which source is currently being served if you hover over the URL in the Elements pane:

camelCase in JSX
(warning)

React expects all HTML attributes to be camelCase. This means that this attribute should be written as srcSet, not srcset.

If you forget, a helpful console warning will let you know.

The picture element

There's another way to solve the same problem: the <picture> element!

Here's what that looks like:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Structurally, this looks pretty similar to our srcset solution. We've essentially moved the srcset solution to a new <source> element, and wrapped the whole thing in a <picture>.

The benefit to this approach is that we can specify multiple sources. This allows us to supply different file formats:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

If you're not familiar, AVIF is a fascinating new image format. It's based on the lessons learned in video compression, and it creates dramatically smaller images; in this example, the .avif version of our 3x image is 75% smaller than the .png!

<picture> allows us to use modern image formats in a safe way, by providing fallbacks for other browsers.

When the browser encounters a <picture> tag, it scans through the <source> children, and the individual paths within srcset. The order matters: When the browser finds a match, it will download the image from the server and show it to the user. We want our smallest files (AVIF) to be on top.

When I originally published this lesson, AVIF hadn’t yet made it into all modern browsers, but things have changed quite a bit. As of April 2026, AVIF is supported in all major browsers since January 2024, and it’s sitting around 95% support
. So, really, most people will load the optimized .avif image, but it’s always a good idea to have fallbacks for folks on older or more niche browsers.

Here are some resources, if you're interested in learning more about modern image formats, or using them in your applications:

“AVIF Has Landed”
, an introductory article by Jake Archibald.
Squoosh
, a webapp created by Google to allow comparison and conversion between modern image formats.

Why so funky?
(info)

The <picture> element has been rightly criticized for being overly complex. Why does it need to have a nested <img> tag? Can't it just be its own thing?

In fact, there's a very good reason for the bewildering structure: backwards-compatibility.

 Show more
Styling and targeting picture elements

Because <picture> breaks what was a single element (img) into multiple elements (picture, source, img), it may not be clear how to style it.

First, we should ignore <source> tags from a styling perspective. They're essentially metadata: they aren't visible, and shouldn't be targeted.

Next, it's important to understand that no matter which source is selected, the <img> tag will always be used, and it acts like any other image tag. The sources exist to "swap out" the src attribute. We want to add additional properties, like alt text, to the <img> tag, and not to <picture> or <source>.

Finally, the <picture> element behaves like a <span>, an inline wrapper that wraps around the <img> tag
*
.

This <picture> wrapper comes in handy. For example, we can use it to our advantage inside a Flex container:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Deciding which to use

There's no doubt about it: the <picture> element can do some pretty cool stuff. We've only scratched the surface!

It can also add quite a bit of friction to our work, however. If we want to support 3 media types and 3 device pixel ratios, we need to generate 9 images for every image! This can be very tedious if you don't have a process to do it automatically.

You'll need to find the right balance for you and your team.

As mentioned at the start of this article, there are projects that exist to solve these problems for you, things like next/image
 and gatsby-image
. They do have some tradeoffs of their own, but they can reduce a lot of the associated friction.


---

## Background Images

Source: /css-for-js/06-typography-and-media/17-background-images

Background Images

As CSS has evolved, the <img> tag has grown much more flexible and powerful, but there's one thing that it can't do: tile the image. When we have a repeating pattern, we'll need to use a CSS background image instead.

Let's look at an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  body {
    background-image:
      url('https://courses.joshwcomeau.com/cfj-mats/geometric-pattern.png');
  }
</style>

<main>
  <h1>Hello World</h1>
</main>
Result
Refresh results pane

By default, a background image will be rendered at its native size, and then tiled across the element.

There's a problem with this, though. As we've discussed, most monitors are "high DPI". If we render an image at its natural size, it'll look blurry and fuzzy, since a single software pixel is being stretched across multiple hardware pixels.

To keep things crisp, we'll need to provide different images for different devices, scaling up based on the pixel ratio. When it comes to background images, we can do this with a media query, min-resolution:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  body {
    background-image:
      url('https://courses.joshwcomeau.com/cfj-mats/geometric-pattern.png');
    background-size: 450px;
  }

  @media (min-resolution: 2dppx) {
    body {
      background-image:
        url('https://courses.joshwcomeau.com/cfj-mats/geometric-pattern@2x.png');
    }
  }

  @media (min-resolution: 3dppx) {
    body {
      background-image:
        url('https://courses.joshwcomeau.com/cfj-mats/geometric-pattern@3x.png');
    }
  }
</style>

<main>
  <h1>Hello World</h1>
</main>
Result
Refresh results pane

The min-resolution media query has very good browser support
 nowadays. If you need to support older versions of Safari (specifically earlier than Safari 16, released in 2022), you should also add a fallback query using -webkit-min-device-pixel-ratio.

Notice that we also need to specify a background-size in pixels; otherwise, our high-DPI images will render in their native size, producing much larger images without any additional clarity. The background-size should match the width of the standard 1x image.

Fit and positioning

The background-size property also accepts certain keyword values, just like object-fit. For example, we can choose to have our background image cover the element:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

In fact, the object-fit property was inspired by background-size. It was added to the specification when the authors realized that developers were using background images instead of <img> tags specifically for the background-size property.

There's also background-position, which works just like object-position.

Background repeat

By default, the background image will be tiled side-by-side, top-to-bottom. In most cases, this is fine, but it does mean that the pattern will be truncated at the bottom and on the right.

The background-repeat property allows us to tweak this algorithm. There are two additional options that can be used:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

round will scale the image up or down, to avoid having the image cut off at the bottom or the right. It preserves the aspect ratio.

space won't tweak the size of the image. Instead, it'll leave gaps between the images.

Generative backgrounds

In addition to accepting the URL to an image file, the background-image property also accepts gradients.

We'll explore gradients more in a future module, but I wanted to share this neat resource: pure-CSS background patterns, generated using very-clever gradients.

“Magic Pattern” CSS background patterns

---

## Workshop: Unsprinkle

Source: /css-for-js/06-typography-and-media/18-workshop

Workshop: Unsprinkle

In this workshop, we're going to apply what we've learned about typography and images to improve the performance, accessibility, and UX of an existing web application.

Our application is called Unsprinkle, a photo-sharing website:

Access starter files

As always, you can choose to fork and clone the Git repository, or else fork the CodeSandbox and work in-browser:

Download from Github
Work on CodeSandbox

You'll find step-by-step instructions in the workshop's README.md.

No design is provided, as the application is complete from a design perspective. Our focus is on optimization.

This workshop is on the shorter end, but jam-packed with actionable lessons and little nuggets. Have fun!

Submit Workshop

I review a small percentage of submitted workshops, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## Workshop Solution

Source: /css-for-js/06-typography-and-media/19-workshop-solution

Workshop Solution

Outdated code in solution videos
(warning)

Since filming these solution videos, I have migrated this workshop from create-react-app to Vite, and updated React to 19. This required a few small changes in terms of file structure. For example, file extensions have been changed from .js to .jsx, since Vite doesn’t allow JSX in plain JS files.

The solution code
 has been updated, so please use that as your source of truth, rather than what’s in the videos.

Exercise 1: Optimize fonts
View the code on Github
Exercise 2: Improve images
View the code on Github
Exercise 3: Accessibility issues
View the code on Github
Exercise 4: Tag overflow
View the code on Github

