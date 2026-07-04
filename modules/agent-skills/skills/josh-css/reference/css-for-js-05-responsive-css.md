# CSS for JS - Module 5: Responsive CSS

---

## Introduction • Josh W Comeau's Course Platform

Source: /css-for-js/05-responsive-css/01-introduction

Responsive and Behavioural CSS

One of the trickiest things about building user interfaces is that they have to support such a wide range of possible experiences. Think about all of the things that differ from one user to another:

Screen size and orientation
Device type (phone, tablet, laptop, desktop, watch, smart-fridge…)
Input mechanism (mouse, trackpad, finger, keyboard, dictation…)
User preferences and settings (dark/light mode, high-contrast, reduced motion)
User zoom level / default font size
Device and network performance

And that's just to name a few!

In order to help us build flexible and resilient interfaces that meet these challenges, CSS has become a very powerful language.

The main tool in our arsenal is the media query, and we'll definitely cover how to use it in this module. But we'll also see how to build fluid constraint-based interfaces. And we'll see how to use modern (but well-supported) CSS functions that give us incredible adaptability. These tools will help us solve a ton of common UX pitfalls.

I'm so excited for this module. Let's get right into it!


---

## Working with Mobile Devices

Source: /css-for-js/05-responsive-css/02-mobile-landscape

Working with Mobile Devices

In 1996, the movie Space Jam
 was released. A website was created, to help hype the launch:

This website is still online
, unchanged in 25 years. It's amazing how backwards-compatible the web is!

Back then, it was a fair assumption that just about everybody was looking at your website on a full-screened window on a desktop monitor, running with a resolution of 640x480.

Because every user was using an identically-sized device, you could hardcode sizes. The Space Jam website uses HTML tables for its layout, with a locked size of 500px wide.

In the early days of the web, this was standard. Every website had a fixed size. Designers created the UI in Photoshop and exported directly to HTML. It was like printing a flyer. There was nothing dynamic or responsive about it, because there didn't need to be.

When Apple released the iPhone, it was clear something needed to change, since for the first time, websites were expected to run on small screens as well as large ones. To work around this, developers started creating "alternative" mobile websites. If you tried to visit facebook.com on an iPhone, you'd be redirected to “m.facebook.com”, an entirely different HTML file designed for phones.

This practice was known as adaptive design. The server would serve different HTML files depending on the user-agent.

Building two versions of every website was a cumbersome process, and when Apple released the iPad, sized halfway between phones and desktop monitors, it became clear that a new paradigm was needed.

Responsive design is the idea that all clients will receive identical HTML files from the server, but those HTML files will be flexible, and will display differently on different devices. Using CSS, we can tweak the layout to work across many different form factors.

Adaptive design was much more work than responsive design, since we had to create multiple versions of the site from scratch. But it was significantly less complex; figuring out how to get a single HTML file to look good across all devices is no small task!

In this module, we'll learn all about how to structure our CSS to make this manageable. But first, we need to learn a bit about modern mobile devices.

Mobile Quirks
More pixels

Nowadays, just about every phone comes with a "High DPI" display. DPI stands for "Dots Per Inch", and it refers to the pixel density. Apple has branded this the "Retina display", but the same technology is used on Android phones.

The iPhone 15 has a native resolution of 1179×2556 pixels—for context, this is more than most large desktop monitors!

If we take that resolution literally, and try to render a website, it'll be completely illegible:

Mobile devices have a “device pixel ratio”. This can be accessed in JavaScript with the following statement:

console.log(window.devicePixelRatio);

This number is the ratio between the physical LED pixels on the device, and the "theoretical" pixels we use in CSS.

On my iPhone, this number is 3. This means that a 10px length will actually be 30px long. Each software pixel actually corresponds to 9 hardware pixels:

(In reality, pixels aren't tiny squares
, but for our purposes, we can pretend they are.)

Mapping a software pixel to multiple hardware pixels happens “under the hood”. In CSS, we can only access software pixels:

.box {
  /*
    This CSS will ACTUALLY draw a
    150×150 box on a modern iPhone.
  */
  width: 50px;
  height: 50px;
  background: pink;
}

This is especially important to know when rendering images: We want to use large images on high-DPI screens, to make sure they look sharp and clear. We'll see how to do this later on in the course.

The magical meta tag

To make sure that our pages render correctly on mobile, it's imperative that we add the following meta tag to our HTML:

<meta
  name="viewport"
  content="width=device-width, initial-scale=1"
>

This tag comes stock with every HTML skeleton and boilerplate out there. It's included by default when generating an app with tools like create-react-app.

But what is it doing, exactly?

This tag was invented by Apple as a way to disable some of the "optimizations" that the browser makes. Android quickly adopted it as well, and it's making its way
 into the CSS specification.

When the iPhone was released, mobile websites didn't exist. Safari would therefore render the website as if it was a desktop browser window with a width of 980px, and then scale it down to fit on its 320px-wide screen.

This gave users a 30,000-foot view of the page, and they could pinch-to-zoom when they spotted the content they were interested in, sort of like a mini-map.

We don't want mobile browsers to do this anymore. On the modern web, pages are built with the expectation that they'll be viewed on a narrow mobile screen.

width=device-width instructs the browser to set the viewport width to match the device's width (so, 320px instead of 980px). initial-scale=1 says that we should start at 1x zoom.

Other options
(info)

This meta tag also allows us to constrain the user's ability to zoom, either by setting a min/max scale, or by disabling it altogether.

This can be useful when building certain types of applications. For example, if we were building Google Maps, we would want to disable user scaling so that we could implement our own pinch gestures. But this is an escape hatch that 99.9% of applications don't need, and shouldn't use. Zooming is a critical browser feature, and disabling or limiting it will make our products less accessible.


---

## Mobile Testing

Source: /css-for-js/05-responsive-css/03-mobile-testing

Mobile Testing

One of the best things we can do to reduce the number of bug reports we get is to regularly check our websites and web applications on mobile devices.

I personally use two devices in my testing:

An Apple iPhone (my actual phone)
A Xiaomi Redmi 7A

When I purchased it, a few years back, the Redmi 7A was the most popular "budget" smartphone option in India. I picked it specifically because I wanted a representative option for what a global low-end device feels like.

For folks living outside of India, you can pick up a budget Android smartphone for US$100 or less on AliExpress
. Note that it ships from China, so it may take a few months to arrive, depending on where you live.

Alternatively, you can search your local classified ads (on sites like Craigslist) to find lower-end second-hand Android phones.

An eye-opening experience
(info)

If you currently use a high-end smartphone, I highly suggest spending a week or two using a low-end Android phone as your "daily driver".

The conventional wisdom on Twitter is that React and other JS frameworks are bloated and will run poorly on budget Android phones. My experience was quite different, however.

Popular React applications like Twitter and Airbnb were noticeably slower than on my iPhone, but they were perfectly usable. I was actually pretty surprised by how decent the experience was!

On the other hand, ad-heavy CMS-driven sites like the New York Times / Washington Post were awful. Just loading the homepage for sites like this would take 30+ seconds.

Performance is important and we should try to reduce the amount of JavaScript we include in our bundles, but it often feels to me like JS frameworks are held to a much higher performance standard than the rest of the web.

If you don't have access to a physical Android device, another option is to use a service like BrowserStack
. BrowserStack offers a huge range of devices, browsers, and operating systems. It allows you to load your site on a real device, which you can see and interact with through a screen-share.

It's not perfect—because of latency and other factors, it won't give you a realistic sense of the user experience. But it can help validate that a layout works on a specific device.

It's also not cheap; as I write this, plans start at US$40/month. If you currently work as a software developer, though, this is something that your employer should be able to pay for.

Local development flows

Most front-end developers don't test as often as they should on mobile devices, probably because it can be pretty painful!

We want to make it easy for us to check out our CSS on our mobile devices. If it's easy, we'll do it regularly.

We'll need to set up 2 distinct superpowers:

The ability to access localhost on our phone
The ability to "remote debug", by opening the devtools for our mobile browser on our desktop machine.
Accessing localhost

I have experimented with lots of methods for getting my local development server (eg. localhost:3000) to run on my phone. The best method I've found is to use a tunnelling service like ngrok
.

ngrok is software that you run on your development machine. It will burrow through your firewall and router and make a specified port publicly-available. It provides a randomly-generated URL that you can visit on your phone, which'll forward you to your localhost server.

ngrok is cross-platform (macOS, Windows, and Linux). There is a paid version, but the free tier is more than sufficient for what we need.

You can install ngrok via NPM. Follow the “Global Install” instructions:

ngrok on NPM

Once it's set up, you ought to be able to open a terminal and run:

ngrok http 3000

Replace the number “3000” with the port that your application runs on. If you typically visit http://localhost:8000, you'll want to use 8000 instead.

You should see some output like this:

The “Forwarding” field shows us a URL we can visit. In this case, visiting http://ff2b68d21f8e.ngrok.io will load http://localhost:3000. I can visit this URL on my phone, or a tablet, or a computer running a different OS.

Using your device’s local IP address
(info)

Several students have suggested that instead of using a service like ngrok, we can instead access the development server from our mobile devices using its local IP address. For example, if your work computer has a local IP of 192.168.0.7, you could visit http://192.168.0.7:3000 on your phone. In theory, as long as both devices are connected to the same local network, this should work.

In practice, however, I’ve found that this approach is hit-or-miss. I’ve tried this a few times over the years, and have found that more often than not, there’s some issue that blocks it from working, from router misconfiguration to device security policies. Services like ngrok or localtunnel are much more reliable, in my experience.

That said, if this approach does work for you (or if you have the networking skills to troubleshoot any issues), feel free to use it!

ngrok troubleshooting
(warning)

In some cases, you might need to register for an account
 with ngrok, to generate an auth token. You can learn more about that in their official documentation
.

If all else fails, there are other tunnelling services you can try:

localtunnel
serveo
Remote debugging

Being able to view our development server on our phone is neat, but it's only half the battle: what happens if we want to inspect it, to figure out which CSS is being applied?

Remote debugging is the process of using our desktop developer tools to inspect a browser tab running on our mobile device.

The instructions will vary by phone type and desktop operating system.

Debugging on the device
(info)

Instead of using a remote debugger, where the debugger runs on a nearby desktop computer, there are also mobile devtools that allow debugging right on the device.

Personally, I find it easier to use devtools on a laptop/desktop computer, but there are some options for those who prefer to do everything on-device:

Eruda
 — iOS and Android, free and open-source.
Inspect Browser
 — iOS only, paid.

Thanks to Discord user avocato for letting me know about Eruda.

iOS phones

To debug an iOS device, we need to start by enabling remote debugging in the iPhone settings. Follow the official WebKit instructions
 to get this enabled.

Next, plug the phone into your desktop, and allow access (if asked, confirm the dialog that reads "Trust this machine?").

On your phone, visit the website you wish to debug.

For macOS users, we can use desktop Safari to debug our iPhone. Open Safari, and select Develop › phone name › tab name:

This will open the Safari DevTools, connected to the page on your phone.

Can we debug iOS Chrome?
(info)

This technique will allow us to debug iOS Safari, but what if we want to check our site in iOS Chrome?

As far as I know, this isn't possible, but it also isn't that big of a deal.

On iOS, all browsers are secretly Safari. Google Chrome on iOS uses a WebView that defers all page-rendering to iOS Safari. In other words, iOS Chrome isn't actually a discrete browser; it's more like a Chrome-scented skin for Safari.

Why does Google do this? Because they don't have a choice; Apple doesn't allow any other browser renderers to be used.

This draconian policy does have one upside: we don't have to test our products on multiple browsers on iOS.

For Windows users, we can't use Safari to debug our iPhones.

The best tool I've found is called Inspect
. It's a cross-platform developer tool that allows you to debug iOS devices using the Chrome developer tools:

This software is fantastic, but it isn't free. At the time of writing, there is a 30-day free trial, and then you'll need to pay $49 USD per year.

Discord user Avocato shared a free open-source option as well, chii
. I haven't used it myself, but it looks interesting!

Android phones

Fortunately, things are a bit more straightforward on Android. Regardless of whether your development machine is Windows, macOS, or Linux, we can follow the same instructions.

The most up-to-date instructions will be found in this article: “Remote Debug Android Devices”
.

After following these instructions, you should be able to open a DevTools window connected directly to your Android Chrome session:

(The color output is funky, but everything else seems to work fine!)

Alternatively, if you use Firefox on your Android device and/or prefer desktop Firefox's debugging tools, you can follow the MDN guides for debugging with Firefox
.


---

## Media Queries

Source: /css-for-js/05-responsive-css/04-media-queries

Media Queries

When it comes to building responsive interfaces, the media query is the primary tool in our toolbox.

As a refresher, here's what the syntax looks like:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .signup-button {
    color: deeppink;
    font-size: 1rem;
  }

  @media (max-width: 400px) {
    .signup-button {
      font-size: 2rem;
    }
  }
</style>

<button class="signup-button">
  Sign Up
</button>
Result
Refresh results pane

The @media keyword is known as an "at-rule". at-rules are a special kind of CSS statement that changes behaviour. There are a handful of at-rules that all do different things; another example is @keyframes, which allows you to define an animation sequence.

Media queries selectively apply rules based on one or more conditions. In this case, we're saying that the .signup-button selector should adopt an additional declaration when the viewport is 400px wide or less.

Notice that the button always has pink text. Media queries allow us to merge rules together. We're not picking "one or the other"—when the viewport is 400px or smaller, declarations from both rules will apply:

color: deeppink;
font-size: 2rem;

Media queries are really like if statements in JavaScript. We can think of it like this:

let signupButtonStyles = {
  color: 'deeppink',
  fontSize: '1rem'
}

if (windowWidth <= 400) {
  signupButtonStyles.fontSize = '2rem';
}

It's also important to note that media queries don't affect specificity. The only reason that font-size: 2rem beats font-size: 1rem is because it comes later. Notice what happens when the order is flipped:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The button never changes size, because the font-size: 2rem declaration is always overwritten by the font-size: 1rem declaration.

In JS terms, it's as if we had done this:

let signupButtonStyles = {}

if (windowWidth <= 400) {
  signupButtonStyles.fontSize = '2rem';
}

signupButtonStyles.color = 'deeppink';
signupButtonStyles.fontSize = '1rem';
With styled-components

Here's how we use a media query with styled-components:

const SignupButton = styled.button`
  color: deeppink;
  font-size: 1rem;

  @media (max-width: 400px) {
    font-size: 2rem;
  }
`;

styled-components allows us to nest media queries within our component definitions.

This might seem like a small thing, but it totally changes our mental model when it comes to styling. With regular media queries, declarations are grouped by viewport size:

/* All mobile styles */
.wrapper {
  padding: 8px;
  border: 2px solid;
}
.button {
  font-size: 1rem;
}
h2.title {
  font-size: 2rem;
}

/* All tablet styles */
@media (min-width: 550px) {
  .wrapper {
    padding: 16px;
    border: 3px solid;
  }
  h2.title {
    font-size: 2.5rem;
  }
}

/* All desktop styles */
@media (min-width: 1100px) {
  .button {
    font-size: 1.5rem;
  }

  h2.title {
    font-size: 3em;
  }
}

With styled-components, all of the declarations for an element are in the same spot:

// All Wrapper styles
const Wrapper = styled.div`
  padding: 8px;
  border: 2px solid;

  @media (min-width: 550px) {
    padding: 16px;
    border: 3px solid;
  }
`;

// All Button styles
const Button = styled.button`
  font-size: 1rem;

  @media (min-width: 1100px) {
    font-size: 1.5rem;
  }
`;

// All Title styles
const Title = styled.h2`
  font-size: 2rem;

  @media (min-width: 550px) {
    font-size: 2.5rem;
  }

  @media (min-width: 1100px) {
    font-size: 3rem;
  }
`;

This pattern makes it way easier to reason about which styles apply to which elements. Everything you need to know, in 1 place.

Fortunately, this "nested media queries" thing is not unique to styled-components. CSS preprocessors like Sass also support nested media queries. I suggest using this pattern if your tool allows for it.

Mobile-first vs desktop-first

There are two distinct ways we can write the media query we saw above:

.signup-button {
  color: deeppink;
  font-size: 1rem;
}

@media (max-width: 400px) {
  .signup-button {
    font-size: 2rem;
  }
}
.signup-button {
  color: deeppink;
  font-size: 2rem;
}

@media (min-width: 401px) {
  .signup-button {
    font-size: 1rem;
  }
}

The first snippet is known as desktop-first, since our default styles (the ones not inside @media) target desktop devices, and then we specify overrides for mobile devices. By contrast, the second snippet is mobile-first, since the main styles are for mobile devices (400px or smaller).

To be clear, the end result is the same. These are two different roads to the same place. But the mental model is different.

Which should I use?
(info)

When starting a new project, you'll need to pick whether you take a desktop-first or a mobile-first approach.

Honestly, I don't believe that there is a single "right" answer to this question. This is one of those unsatisfying "it depends" situations.

Here's how I think about it:

 Show more
Mixing patterns

Here's a pattern I try to avoid:

<style>
  @media (max-width: 600px) {
    .desktop-button {
      display: none;
    }
  }

  @media (min-width: 601px) {
    .mobile-button {
      display: none;
    }
  }
</style>

<button class="desktop-button">
  Click me
</button>
<button class="mobile-button">
  Tap me
</button>

This code is designed to "toggle" between two buttons: on mobile, the .mobile-button is shown. On desktop, .mobile-button is hidden and .desktop-button is shown instead.

One minor problem is that fractional viewport widths (eg. 600.5px) are possible, according to the specification. I've seen this firsthand when the page is embedded in an iframe, but there may be other situations that lead to non-integer viewport widths.

But here's the real reason I try not to do this: It complicates the mental model.

I believe that our applications should be either mobile-first or desktop-first. If we consistently use a single set of media queries, it'll help us quickly scan chunks of CSS to understand the structure.

How would we solve this problem without mixing queries? Here's how I'd structure this:

.desktop-button {
  display: none;
}

@media (min-width: 601px) {
  .desktop-button {
    display: revert;
  }

  .mobile-button {
    display: none;
  }
}

revert is a special keyword that restores the property to its default value. It's a way of undoing the display: none set outside the media query.

Alternatively, if the application is desktop-first, it would look like this:

.mobile-button {
  display: none;
}

@media (max-width: 600px) {
  .mobile-button {
    display: revert;
  }

  .desktop-button {
    display: none;
  }
}

Structuring things this way is more verbose, but I think it's worth it.

That said, there are exceptions. Sometimes, it's just too much trouble to structure things this way.

For example, if we have a completely different layout that only exists on tablet, it can be nice to wrap it in a "tablet only" media query:

@media (min-width: 500px) and (max-width: 1023px) {
  .wrapper {
    display: flex;
    flex-direction: row;
    gap: 32px;
    align-items: flex-start;
    justify-content: center;
  }

  .wrapper:first-child {
    width: 200px;
    min-height: 200px;
  }
}

It is possible to rewrite this to only use min-width, but it would ultimately make the CSS harder to understand.

Ultimately, this comes down to judgment and intuition, and the only way to build that intuition is to experiment. Try both approaches, and see what works best for you in your applications!

Media queries and units

When creating min-width / max-width media queries, should we use pixels? Or maybe another unit, like rems?

/* Should we do this: */
@media (min-width: 800px) {
  }

/* …Or this: */
@media (min-width: 50rem) {
}

What's the difference? As we learned in Module 1, the rem unit is equal to 16px by default, but can be redefined, either by the developer or by the end user.

Suppose the user has poor vision, and they want to boost the size of text. They go into their browser settings, and crank up the baseline font size to 32px. Now, each rem unit is equal to 32px instead of 16px.

And so here's the question: Should our media queries be affected by the user's chosen baseline font size?

For a long time, I thought the answer was “no”, and I used pixels for all media queries. But over the past few months, I've reconsidered this position.

To help me explain why, let's use this course platform as an example. In this example, they've cranked the baseline font size to 32px:

Pixel Media Query
Rem Media Query
Toggle
Expand

With pixel-based media queries, we stick with the desktop layout no matter what the user does with their default font size. When cranked to 32px, it means we wind up with a really cramped layout: the sidebar expands and fills half of the screen (since it uses a rem-based width).

When we use rem-based media queries, we flip to the mobile view (even though they're using a desktop-sized window). The large text has more room to breathe, and it's generally just a much better experience.

For this reason, I recommend using rem media queries in most situations.

You can also use em instead of rem; the two units function exactly the same way, when it comes to media queries.

For more information, check out my blog post, “The Surprising Truth about Pixels and Accessibility”
.

Do as I say, not as I said
(info)

I started using rem-based media queries in my own work in mid-2022. Unfortunately, this course was created before this point. As a result, some lessons in this course will still use pixel-based media queries. Sorry for any confusion!


---

## Exercises

Source: /css-for-js/05-responsive-css/05-exercises

Exercises
Disappearing sidebar

Below you'll find a two-column layout: A sidebar with navigation links, and a main content area.

Update the code so that the navigation column disappears on windows less than 700px wide:

Feel free to solve this using either mobile-first or desktop-first methodology.

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
    align-items: baseline;
    gap: 32px;
    padding: 32px 0;
  }
  .sidebar {
    flex: 1;
    max-width: 350px;
    background: white;
    padding: 24px 32px;
    border-radius: 0 16px 16px 0;
  }
  main {
    flex: 3;
    background: white;
    padding: 24px 32px 32px;
    border-radius: 16px 0 0 16px;
  }
</style>

<div class="wrapper">
  <nav class="sidebar">
    <h2>Contents</h2>
    <ul>
      <li>
        <a href="/">Intro</a>
      </li>
      <li>
        <a href="/">Chapter 1</a>
      </li>
      <li>
        <a href="/">Chapter 2</a>
      </li>
      <li>
Result
Refresh results pane

Solution:

The code from the solution:

.wrapper {
  padding: 32px;
}

.sidebar {
  display: none;
}

main {
  border-radius: 16px;
}

@media (min-width: 700px) {
  .wrapper {
    padding: 32px 0;
  }

  .sidebar {
    display: revert;
  }

  main {
    border-radius: 16px 0 0 16px;
  }
}
Mobile modal

In this exercise, we're given an application with a pre-built modal, and asked to make it mobile-responsive.

Here's how it currently looks when being shrunk:

Your task is to add mobile styles, so that the modal takes up the full screen, and looks like this:

This exercise will be solved on CodeSandbox:

Access starter code

Solution:

View final solution code
Bonus: Building accessible modals

Note: In this video, I use Reach UI, but this library is no longer being actively maintained. Instead, I recommend using the <Dialog> component from Radix Primitives
.

Also, if you don't use React, there are other tools you can use to build accessible modals:

a11y-dialog
 A Vanilla JS solution
vue-accessible-modal
 (I haven't personally used this, but I poked at the demo and it seems solid)

---

## Other Queries

Source: /css-for-js/05-responsive-css/06-other-queries

Other Queries

When we talk about “media queries”, we're generally talking about adapting our CSS based on the screen/window size of the client. But that's only one of the tricks media queries have up their sleeves!

Hovering

Hovering is a gesture only possible when using a pointer device, like a mouse or a trackpad. On mobile devices, we typically use our fingers, and our fingers are incapable of hovering.

When Apple created iOS Safari, they decided that tapping on an interactive element (like a link or button) should trigger the hover state. This is a questionable decision nowadays, but it made sense at the time—web developers at the time assumed that everyone could hover, since smartphones weren't a thing yet. It was common for tooltips to only be shown on hover, for example, so Apple was making sure that these UI elements still worked on touchscreens.

Android devices work the same way. Tapping an interactive element will show the "hover" state.

This is a problem for two reasons:

The hover state sticks around until the user taps something else.
Hover states can be accidentally triggered while scrolling, since scrolling on a touchscreen involves swiping with fingers. If their finger happens to land on an interactive element, the hover state will trigger unintentionally.

In this lesson, we’ll see how media queries help us address this problem!

Double-tap to continue
(info)

If you've been an iPhone user for a few years, you may have run into some curious behaviour: sometimes, tapping a link or a button will trigger the hover state, but nothing else. It requires a second tap to actually click the link/button.

This used to happen if the element in question had a hover style that changed the visibility of an element (eg. showing/hiding a child element).

Fortunately, iOS Safari no longer behaves this way. Starting in 2019, links/buttons will always trigger a click event on tap, no matter what the hover state is.

So how do we avoid setting hover styles on mobile devices? Your first instinct might be to only apply hover styles on larger screens:

@media (min-width: 1100px) {
  button:hover {
    text-decoration: underline;
  }
}

This isn't quite right, though: plenty of folks on desktop will shrink their windows below this size, despite using a keyboard/mouse. And there are large touchscreens out there. We shouldn't think of hover events as a “big screen” thing, we should think of them as a “mouse/trackpad” thing.

There's another media query we can use for this:

@media (hover: hover) and (pointer: fine) {
  button:hover {
    text-decoration: underline;
  }
}

These queries were introduced with “Interaction Media Features”
 a few years ago. They allow us to apply styles based on which input mechanism the user is using.

What's the difference between "hover" and "pointer"? They actually refer to two distinct capabilities. hover is the ability for a device to move the cursor without also triggering a click/tap on the element underneath; a mouse can do this, but your finger or a stylus can't. pointer refers to the level of control the user has over the position of the cursor.

This table should help make this distinction clear:

	Hover	Pointer
Mouse / Trackpad	hover	fine
Touchscreen (smartphone, tablet)	none	coarse
Keyboard (focus navigation)	none	none
Eye-tracking	none	fine
Basic stylus digitizers	none	fine
Sip-and-puff switches	none	none
Microsoft Kinect / Wii remote	hover	coarse

A "fine" pointer like a mouse or trackpad means that the user can be very precise with their clicks. Using our fingers on a touchscreen, though, is "coarse": we can't be anywhere near as precise.

Somewhat magically, browsers are able to infer which input device you're using! This is a dynamic query: if you switch from using a mouse to using a keyboard (for navigation, not for typing), the values for hover and pointer will update dynamically.

While relatively new, interaction media features are broadly supported in all major browsers
, though Internet Explorer is left out.

Boolean logic in media queries

In the hover/pointer media query above, we also introduced something new: the “and” keyword.

@media (hover: hover) and (pointer: fine) {
  /* styles */
}

“and” is essentially the same as && in JavaScript. In order for the styles to be applied, all of the queries must be satisfied.

Here's another example you may have seen before:

@media screen and (min-width: 600px) {
  /* styles */
}

screen is a “media type”. In this case, we're saying that the styles should only apply when displaying the site/app on a screen. We can also specify print styles which apply when the page is printed onto paper or saved as a PDF.

(specifying screen has become less common in recent years, as browsers have chosen more-sensible defaults when it comes to printing.)

Other boolean operators
(info)

In addition to “and”, it's also possible to specify “or” (||) as well.

Truthfully, “or” isn't super useful. it's more of an academic curiosity than something you'll use in day-to-day life.

 Show more
Preference-based media queries

Another feature of media queries is that they can "hook in" and access user preferences. This allows us to tailor our styles based on the user's personal preferences and needs.

For example, we can detect whether the user prefers light mode or dark mode with this media query:

@media (prefers-color-scheme: dark) {
  /* Dark-mode styles here */
}

It's not just about "preference", though. These queries allow us to create safer, more accessible experiences.

For example, some folks are sensitive to motion. Our fun parallax animation might give them a migraine, or make them feel so nauseous they need to lie down for an hour. We can avoid this by wrapping our animation-based styles in this media query:

@media (prefers-reduced-motion: no-preference) {
  /* Animations here */
}

We'll learn much more about these queries in the lessons and modules ahead. For now, the important takeaway is that media queries aren't just about screen sizes.

Orientation
(info)

Aside from min-width / max-width, there are other ways to target specific window proportions. One of the most interesting is orientation:

@media (orientation: portrait) {
  /* Styles for windows that are taller than they are wide */
}

@media (orientation: landscape) {
  /* Styles for windows that are wider than they are tall */
}

I've done some pretty extensive experimentation with this media query, and have found that it's not usually worth using. It's not as flexible as min-width / max-width, and it leads to confusing conflicts between both types of queries.

In rare cases, though, it can be a useful tool to have in the toolbox.


---

## Breakpoints

Source: /css-for-js/05-responsive-css/07-breakpoints

Breakpoints

To help add structure to a chaotic world, it helps to pick a series of breakpoints.

A breakpoint is a specific viewport width that lets us segment all devices into a small set of possible experiences. For example, we might set a breakpoint at 500px. Any device under 500px will be put in the same bucket, and can be styled separately. This ensures a consistent experience; someone on a 375px-wide phone will share the same layout as someone on a 414px-wide phone.

Picking breakpoint values

There's no such thing as a universal set of "perfect" breakpoints: it will depend on your design, and the devices you target. But I do have some thoughts about how to pick a solid set of values.

Developers typically pick breakpoints based on common device resolutions. The iPhone 12 has a screen width of 375px, so maybe that'll become our "phone" breakpoint.

I don't think that this is the right approach. I believe that the most common device resolutions should sit in the middle of each grouping. A 375px iPhone should probably be in the same bucket as a 320px iPhone SE and a 412px Android phone.

In other words, we should put our breakpoints in dead zones, as far away from “real-world” resolutions as possible. They should be in “no-device land”. This way, all similar devices will share the same layout.

This data visualization shows the most popular screen resolutions by platform, according to StatCounter
. Focus or hover over the dots to see the devices they represent:

500
1000
1500
2000

(Credit to David Gilbertson
 for the idea for this visualization.)

The resolutions come in several clusters. If we draw circles around them, we'll know where to put our breakpoints:

Here are the groups I've identified:

0-550px — Mobile
550-1100px — Tablet
1100-1500px — Laptop
1500+px — Desktop

I don't bother disambiguating between "small" mobile devices (like the iPhone SE, 320px-wide) and "large" mobile devices (like the iPhone X Max, 414px-wide) because I don't generally create distinct layouts for different sizes of phone. Your circumstances might vary, though! Keep your design in mind when picking breakpoint values.

Implementing breakpoints

Our exact implementation will depend on whether we go mobile-first or desktop-first.

Here's how it'd work if we go desktop-first:

/* Default: Desktop monitors, 1501px and up */

@media (max-width: 1500px) {
  /* Laptop */
}

@media (max-width: 1100px) {
  /* Tablets */
}

@media (max-width: 550px) {
  /* Phones */
}

Conversely, if we went mobile-first, it would look like this:

/* Default: Phones from 0px to 549px */

@media (min-width: 550px) {
  /* Tablets */
}

@media (min-width: 1100px) {
  /* Laptop */
}

@media (min-width: 1500px) {
  /* Desktop */
}

Some developers like to create queries for "exclusive" ranges. For example, if we wanted to target only tablet sizes—nothing smaller, nothing bigger—we could do this with the and keyword:

@media (min-width: 550px) and (max-width: 1099.99px) {
  /* Tablet-only styles */
}

In most cases, I don't love this approach, since it forces me to complicate my mental model. But I do have to admit, there are times when this pattern comes in handy.

Managing breakpoints

Unfortunately, CSS doesn't have any built-in way to manage breakpoints. CSS has media queries, and media queries always take "raw" values (like 550px), not breakpoints.

The good news is that just about every CSS preprocessor and framework has a solution for this problem.

Here's how I've solved this using styled-components. First, I create some variables in JS:

// constants.js

// For this example, I'm going mobile-first.
const BREAKPOINTS = {
  tabletMin: 550,
  laptopMin: 1100,
  desktopMin: 1500,
}

const QUERIES = {
  'tabletAndUp': `(min-width: ${BREAKPOINTS.tabletMin}px)`,
  'laptopAndUp': `(min-width: ${BREAKPOINTS.laptopMin}px)`,
  'desktopAndUp': `(min-width: ${BREAKPOINTS.desktopMin}px)`,
}

Because our breakpoints are in no-device-land, it makes it a bit easier to name things. 550px is the smallest possible size for a tablet, so we can name the breakpoint tabletMin. The media query can be named tabletAndUp, since it includes all tablets, laptops, and desktops.

When I want to use a media query, I can interpolate these values:

import { QUERIES } from '../../constants';

const Wrapper = styled.div`
  padding: 16px;

  @media ${QUERIES.tabletAndUp} {
    padding: 32px;
  }
`;

If you're not used to it, this might feel like total anarchy. It doesn't look at all like valid CSS!

The important thing to remember is that styled-components will process this string before the browser tries to parse it. By the time the browser receives the CSS, it's a 100%-normal media query, like this:

.wrapper-abc123 {
  padding: 16px;
}

@media (min-width: 550px) {
  .wrapper-abc123 {
    padding: 32px;
  }
}

These names are a lie
(warning)

For convenience, we've decided to name our media queries based on device categories. It's important to recognize that they won't actually map 1:1 to these devices.

When we talk about "popular screen resolutions", like in our data visualization above, we're talking about the monitor's maximum resolution. A popular desktop screen resolution is 1920x1080, but the user might be viewing our app in a small window sized at 500x600. They'd fall into our "phone" bucket, despite being on a desktop computer.

Similarly, tablets are often used in "landscape mode", which tends to push their resolution into the laptop bucket. But, tablets in landscape mode can now "multi-task", which might push each half into the "phone" bucket!

The point is that we don't actually know what type of device the user is using. Our breakpoints are assumptions, and those assumptions aren't always right.

If we use width-based media queries as-intended, this shouldn't cause any problems. But we do need to be careful not to "over-reach", and tweak things that shouldn't be tweaked based on window width.

 Show more

styled-component themes
(info)

styled-components has a “theming system”. This allows us to access theme variables like colors and breakpoints without needing to import our constants.

We haven't focused on its built-in theming system for a couple reasons:

It's too specific to styled-components.
To understand how it works, you need to be familiar with React context, an advanced API.
The benefits are relatively modest.

If you're a React developer and plan on using styled-components, this aside will have a bit more info for you. Otherwise, though, I would recommend skipping this section, and interpolating the queries as shown above.

 Show more
Rem breakpoints

As I mentioned a couple lessons ago, I've started to use rem-based media queries in my own work.

If you use something like styled-components, you can create rem-based breakpoints using pixel values like this:

// constants.js

// Values in pixels:
const BREAKPOINTS = {
  tabletMin: 550,
  laptopMin: 1100,
  desktopMin: 1500,
}

// Converted to rems:
const QUERIES = {
  'tabletAndUp': `(min-width: ${BREAKPOINTS.tabletMin / 16}rem)`,
  'laptopAndUp': `(min-width: ${BREAKPOINTS.laptopMin / 16}rem)`,
  'desktopAndUp': `(min-width: ${BREAKPOINTS.desktopMin / 16}rem)`,
}

Before, our tabletAndUp query was equal to min-width: 550px. Now, it's equal to min-width: 34.375rem.

Deviating from our breakpoints

You might be wondering: is it bad to pick "one-off" values for our media queries? What if we have a UI that needs to change CSS at a different viewport width?

No matter how perfect our breakpoints are, they'll never be suitable for 100% of cases. I think it's totally fine to use the occasional custom value.

It's important not to get too caught up in “best practices”. Sometimes, you need to do something custom in order to achieve the best possible UX, and that should be encouraged!

That said: if you find that you need to use custom values often, it's probably a sign that your breakpoints are at the wrong spots. I'd say that a well-matched set of breakpoint values should be used 80-90%+ of the time.


---

## CSS Variables

Source: /css-for-js/05-responsive-css/08-css-variables

CSS Variables

CSS variables are one of the most exciting developments to come to CSS of all time. They're incredibly powerful, and they unlock lots of really effective workflows.

We've already seen them briefly, but in this lesson we'll go deeper, to understand exactly what they are, how they work, and why they're so great.

Custom properties

The first thing to understand about CSS variables is that they function exactly like properties (like display, color, etc). We aren't setting a variable, we're creating a brand-new property:

strong {
  display: block;
  color: red;
  --favorite-food: tomato;
  --temperature: 18deg;
}

Custom properties always start with two dashes (--), to differentiate them from built-in properties.

Custom properties are also inheritable, just like color or font-size. Inspect the anchor tag in your devtools to see what I mean:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  main {
    font-size: 2rem;
    --favorite-food: tomato;
  }
</style>

<main>
  <section>
    <a>Hello World</a>
  </section>
</main>
Result
Refresh results pane

The anchor inherits both the font-size and our custom --favorite-food property:

Of course, --favorite-food doesn't have any effect on its own; the CSS rendering engine doesn't make use of that property. But we can access its value using the var function:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

(I'm being a bit cheeky here; tomato is one of the 140 named HTML colors
. Most foods don't actually work as colors.)

Not global

A common misconception is that CSS variables are "global". When we attach a CSS variable to an element, it's only available to that element and its children:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

The variable --color is only available to the a and its children. When main tries to use it, it has no effect, since that property was defined lower in the tree.

It's similar to scopes in JavaScript:

function main() {
  console.log(color); // Not defined

  function section() {
    function a() {
      let color = 'red';
    }
  }
}

The reason for this misconception, I believe, is that CSS variables are often hung on :root:

:root {
  --color-primary: red;
  --color-secondary: green;
  --color-tertiary: blue;
}

:root is an alias for the html tag, the “root” of the HTML document. By attaching our CSS variables to the top-level element, they're inherited through the entire DOM tree.

But we can attach CSS variables to any selector! It doesn't have to be the root html tag. I frequently use CSS variables lower down in the tree. We'll see an example of this shortly.

Disabling inheritance
(info)

By default, all CSS variables are inheritable. This is why CSS variables hung on :root are available globally.

But what if we only want our CSS variable's value to only be available to the element in question, not any of its children?

 Show more
Default values

Our var function takes two arguments. The second argument is a default value:

.btn {
  padding: var(--inner-spacing, 16px);
}

If our .btn element or one of its ancestors assigns a value to the --inner-spacing property, that value will be used. Otherwise, it'll use a fallback of 16px.

Reactive properties

If you've used a CSS preprocessor like Sass or Less, you might be thinking “So what? We've had variables in preprocessors for years!".

The big difference is that CSS preprocessors can only be used to generate initial values. A .scss file will get compiled into a .css file, and the variables are resolved during that process, before the code ever runs in the browser.

With CSS variables, however, the variable exists in the browser. This means we can dynamically change its value with JavaScript.

Check this out:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

CSS variables are reactive—when their value changes, any properties that reference that value also change. In this case, clicking the button causes us to update the value for --inflated-size, which automatically updates the button's font-size property.

Being able to mutate variables from within JS opens lots of exciting doors.

With JS frameworks

CSS variables go hand-in-hand with JS frameworks.

Here's a quick example with React and styled-components:

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

In this example, we assign a new CSS custom property called --main-color to a derived value based on the status prop. Like any other CSS declaration, it can be set in an inline style.

Inside the Wrapper style definition, we access that value and assign it to the color property.

As we learned about earlier in the course, styled-components has its own built-in solution for dynamic styles, but I prefer to use platform features whenever possible. The skills I learn with CSS variables will work with any tool or framework.

(That said, styled-components' interpolation syntax is more powerful, and can do things not possible with CSS variables. For example, we can interpolate in a whole chunk of CSS based on a condition, or dynamically create media queries. So it's worth knowing about both strategies, if you work with styled-components!)

Responsive values

We can use the fact that CSS variables are reactive to our advantage when it comes to responsive design.

As an example, let's look at interactive mobile UI elements like buttons or inputs.

As we saw earlier, our fingers aren't particularly precise instruments when it comes to tapping on things (it's a coarse pointer, in official terms). We've all experienced the frustration of trying to tap on a super-tiny checkbox, and not being able to hit it.

In Apple's Human Interface Guidelines
, they recommend a minimum tap size of 44×44px.

Our CSS for a button might therefore look something like this:

const FancyButton = styled.button`
  /* Other styles omitted for brevity */

  @media (pointer: coarse) {
    min-height: 44px;
  }
`;

This works well enough, but in reality, we'll have many other components that need to implement the same thing! Maybe a TextInput component as well, with a default min-height:

const TextInput = styled.input`
  /* Other styles omitted for brevity */
  min-height: 32px;

  @media (pointer: coarse) {
    min-height: 44px;
  }
`;

We can use CSS variables here to make our life a bit easier.

First, let's define a new global CSS variable, --min-tap-height:

const GlobalStyles = createGlobalStyle`
  @media (pointer: coarse) {
    html {
      --min-tap-height: 44px;
    }
  }
`;

We only define this variable for folks with a coarse pointer. We'll leave the variable undefined for everyone else.

Then, we can use this property inside our styled-components:

const FancyButton = styled.button`
  min-height: var(--min-tap-height);
`;

const TextInput = styled.input`
  min-height: var(--min-tap-height, 32px);
`;

If the user is using a mouse or other “fine” pointer, --min-tap-height will never be set. FancyButton won't have a min-height, and TextInput will fall back to the default value of 32px.

But, if the user is using a finger or similarly “coarse” pointer, --min-tap-height will be set to 44px, and that value will be used in both components.

This is a really handy trick, since it means we aren't saddling individual components with any media queries / responsive logic. At the same time, individual components are still able to set default min-height values using the fallback syntax.

Tap target trickery
(info)

In some cases, we may want to be a bit more subtle with our tap target sizes. In Module 9, we'll learn an alternative way to increase tap target sizes without affecting the design.

Exercise
Stacked cards

This UI features a stacked set of cards. Depending on the viewport size, we want to apply different styles:

As it stands, we're solving this problem by setting new values for padding, gap, and border-radius inside media queries. For example, here's how we're changing padding on main:

main {
  padding: 8px;
}

@media (min-width: 350px) {
  main {
    padding: 16px;
  }
}

@media (min-width: 500px) {
  main {
    padding: 32px;
  }
}

Your mission in this exercise is to see if you can simplify the CSS a bit by using CSS variables.

Acceptance Criteria:

A CSS variable should hold the spacing value, so that the amount of padding/gap/border-radius can be changed by editing a single value.
The media queries should not directly change padding/gap/border-radius.

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

## Variable Fragments

Source: /css-for-js/05-responsive-css/09-variable-fragments

Variable Fragments

One of the coolest things about CSS variables is that they're like lego blocks. We can use them as pieces or fragments.

Take a look at this example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  body {
    --standard-border-width: 4px;
  }

  strong {
    --border-details: dashed goldenrod;
    border:
      var(--standard-border-width)
      var(--border-details);
  }
</style>

<strong>Hello World</strong>
Result
Refresh results pane

We can combine multiple variables to form a single property value. In this case, the end result is the declaration border: 4px dashed goldenrod. As long as the final product is valid, we're golden(rod).

This works because CSS variables are evaluated when they're used, not when they're defined.

Taking this a step further: CSS variables are composable:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  body {
    --pink-hue: 340deg;
    --blue-hue: 275deg;
    --intense: 100% 50%;

    --color-primary: hsl(
      var(--pink-hue)
      var(--intense)
    );
    --color-secondary: hsl(
      var(--blue-hue)
      var(--intense)
    );
  }

  strong {
    color: var(--color-primary);
  }
  a {
    color: var(--color-secondary);
  }
</style>

<p>
  Hi <strong>Mario</strong>!
  <br />
  The princess is in <a href="">another castle</a>.
</p>
Result
Refresh results pane

The --color-primary variable is built up using the variables --pink-hue and --intense. This helps us keep our code DRY, and makes it possible to build rich structures that make it easy to tweak entire color themes!

Exercises
Color theme

In the playground below, we have a color theme set using CSS variables, but there's an awful lot of repetition.

Ideally, we should only have to reference each "hue" value (eg. 245deg) once.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Color shades
(info)

In this example, I'm using a numbering scheme for different shades of the same color. This is a relatively common convention: colors go from 100 to 900, with 100 being the lightest, 900 being the darkest.

I like the numbering scheme because it gives us plenty of room for expansion. In the example above, I'm only using 3 tones for the red/blue, but I can easily add more shades as I need them. On this course platform, I have (and use!) 11 different grays.

Solution:

Dark Mode

Let's use CSS variables to create a dark mode variant for this UI!

You can use the prefers-color-scheme media query to create an alternative set of colors. Your colors should use the same values for “hue” and “saturation”, but should change the “lightness” values to be dark-mode appropriate.

To test this, you can use color mode emulation
 in the browser devtools to switch between light/dark mode. Your OS system setting may not work correctly because my playgrounds use iframes and iframes can be weird with stuff like this.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Solution:

(I toggle the theme in the System Preferences in this video because I didn't know about emulation at the time.)


---

## The Magic of Calc

Source: /css-for-js/05-responsive-css/10-calc

The Magic of Calc

For almost a decade now, CSS has had the ability to do math!

.something {
  width: calc(100px + 24px);
  height: calc(50px + 25px * 4);
}

The expression will be evaluated, and the end result will be used as a value. The above example is equivalent to:

.something {
  width: 124px;
  height: 150px;
}

We can use 4 mathematical operators:

+ (addition)
- (subtraction)
* (multiplication)
/ (division)

Why would we want to do this? For starters, it can be useful for “showing your work”. For example, which of these two declarations make it clearer that you want .something to take up 1/7th of the available space?

.something {
  width: 14.286%;
  width: calc(100% / 7);
}

The real magic of calc, though, is that it allows us to mix units:

.spill-outside {
  margin-left: -16px;
  margin-right: -16px;
  width: calc(100% + 16px * 2);
}

We're saying that this element should take up 100% of its containing block's width, plus an extra 32 pixels. Pretty neat, right?

calc gets even cooler when we combine it with CSS variables. Let's take another look at the “stacked cards” exercise:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

To refresh your memory, the setup here is that we have a stack of cards, and we want them to become more “compact” on smaller screens:

On small screens, --spacing is equal to 8px, and we use that value for 4 different properties. But do we really want to use the exact same values for them?

We can use --spacing as an input, and transform it to a proportional value using calc:

article {
  padding: var(--spacing);
  border-radius: calc(var(--spacing) / 2);
  /*
    8px -> 4px
    16px -> 8px
  */
}

Our equation can be more complex if we want to tweak the relationship between the values:

article {
  border-radius: calc(var(--spacing) / 2 + 2px);
  /*
    8px -> 6px
    16px -> 10px
  */
}

Browser support
(info)

calc feels like a modern bleeding-edge feature, but it's actually been around for a long time, and has exceptional browser support. It's been in Chrome/Firefox/Edge/Safari for years, and it even has IE support, all the way back to IE 9!

If you need to support IE, however, there are some implementation bugs you should be aware of. Check out the “Known Issues” tab on the caniuse “calc” support page
.

Unit conversion

We've talked about how the rem unit is better-suited for setting font sizes, because it can be increased or decreased by the user. But it can be harder to think in terms of rems, since they're generally multiples of 16 rather than 10.

We can use calc to convert pixels to rems.

Let's presume we want our h2 to be 24px:

h2 {
  font-size: 24px;
}

Assuming we haven't set a font-size on our HTML tag, 1rem will be equal to 16px. We can convert from pixels to rems by dividing by 16:

h2 {
  /* 24 / 16 = 1.5 */
  font-size: 1.5rem;
}

Instead of doing this math ourselves, we can let CSS do it for us, using calc:

h2 {
  font-size: calc(24 / 16 * 1rem);
}

The very first number, 24, is our value in pixels. We can use this pattern anywhere we want to be responsible and use the rem unit, without having to change our mental model.

Calculating colors and gradients

As we've learned, the HSL color model is awesome because it gives us an intuitive way to reason about color.

We can leverage that intuition to create color palettes with CSS calc:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

To explain what's going on here: we have a default hue, 0°. On the color wheel, 0° is "pure red". As we increase the hue, the color becomes more and more orange, and then yellow. If we spin the color wheel the other way, we veer towards pink, purple, blue.

In the code above, we're using calc to come up with new hues for each color. The 5 values used are -40°, -20°, 0°, 20°, and 40°.

Negative values?
(info)

When we talk about color hues in HSL, we're generally thinking of them in the range of 0° to 360°. How do negative values fit in?

The trick here is that hue is a circular value. It's like rotating in a circle. If you rotate 360°, you're right back where you started. If you rotate 720°, it's the same thing, you've just done 2 full circles instead of 1.

If 0° and 360° are the same value, it stands to reason that -20° would be the same value as 340°. Happily, we can use these values in CSS!

Being able to use calc with color fragments is really handy when it comes to CSS gradients.

We'll learn all about gradients towards the end of the course, but essentially, a linear gradient has 3 components:

A direction
A start color
An end color

(We can also specify more than 2 colors, but for now, we'll stick with 2).

Here's an example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Let's see how calc gives us some knobs we can turn to tweak this gradient:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Spend some time tweaking --root-hue and --range. It's fun!

Exercise
Art project

Let's get some practice by creating some generative art!

In the playground below, 16 boxes are drawn in a 400×400 container. Your job is to use CSS variables, calc, and linear gradients to come up with a unique work of art.

There is no “right answer” for this exercise. The goal is to experiment and have fun, while also getting comfortable using calc and CSS variables 😄

If you're looking for inspiration, here are some of the things I've done with this template:

“Paintchip”

“Windows”

“Beach Day”

Now it's your turn to do some experimentation! Here's the playground. You'll find some instructions and a quick example in the CSS comments:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

“Solution”:

As mentioned, there is no right answer for this exercise—the goal is to make something unique! Nevertheless, I'll share one possible creation, since I think it's valuable to see how I went about using CSS variables and calc:

Warning: There is some potentially-dizzying motion later in this video, involving multiple spinning boxes.

View the code created in this video.

You can also view the code for the images shown above:

Paintchip
Windows
Beach Day

Generative art tools
(success)

Generative art is a lot of fun, but it can also be super handy! Generative illustrations can spruce up a landing page or add visual flourish to an application.

Several tools have popped up which allow you to easily create generative art for your own projects.

I share some of my favourites over on the Treasure Trove:

Generative Art Tools

---

## Viewport Units

Source: /css-for-js/05-responsive-css/11-viewport-units

Viewport Units

Did you know that CSS has types?

Every value that you might think to use, like 24px or 10% or #FF0000, has a type. It might be a <length> or a <color> or an <angle>, or one of many other possible types
.

Our CSS properties, meanwhile, accept values of specific types. background-color accepts a <color>, so hsl(0deg 100% 50%) is a valid value, but 100% isn't.

The <length> type is one of the most common. Properties like width or padding accept <length> values, and it contains units like px and em and rem, and more obscure ones we'll cover later, like ch.

It also includes viewport units, the subject of this lesson.

There are two main viewport units: vw (Viewport Width) and vh (Viewport Height).

1vw is equivalent to 1% of the viewport width. For example:

.box {
  width: 10vw; /* 10% of the viewport width */
  height: 25vh; /* 25% of the viewport height */
}

We can use these units with width and height, but the really cool thing is that we can use them with any property that accepts <length> units.

In this playground, we use it to increase the distance between letters:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .heading {
    letter-spacing: 2vw;
  }
</style>

<h2 class="heading">Resize me!</h2>
Result
Refresh results pane

Viewport units have excellent browser support
: all major browsers, and even Internet Explorer, all the way back to IE 9!

Digging deeper
(info)

You can learn much more about CSS' type system, and how it helps keep us in check, in Eric Bailey's awesome article, “CSS is a Strongly Typed Language”
.

The mobile height issue

The vh unit in particular is often used to solve one annoying problem: making sure that an element is exactly as tall as the viewport. No taller, no shorter.

Unfortunately, it doesn't quite work as you'd expect on mobile. To understand why, we need to look at how modern mobile browsers work.

When a page is loaded on a mobile browser, it includes an "expanded" browser UI: the address bar is tall and tappable, and an array of buttons line up along the bottom. Once you start scrolling, though, the browser UI slips away, making more space for the content:

The screenshots are from Safari on my iPhone X, but Chrome on Android has a similar effect.

When Apple first introduced this "slide-away" UI feature, the vh unit was dynamic: it would grow to match the viewport height when the UI slid away. This led to some really bad experiences, though: having elements shift and resize when you start scrolling is unexpected, and led to some very janky experiences.

So nowadays, the vh unit always refers to the largest possible height. In our example above, 100vh will always equal 750px, even when the page first loads, and the viewport is actually only 635px tall.

If you set an element to have 100vh, therefore, it won't fit on the screen:

You can try this demo yourself, on your mobile device, at this URL:

courses.joshwcomeau.com/demos/full-height-vh

How do we work around this? We have a few options:

We can use a JS-based solution to change how the vh unit works. The most popular solution is viewport-units-buggyfill
. Personally, I wouldn't recommend this unless you really need the vh unit to work. Even if it works perfectly today, it could break when browsers update (and imagine how hard it would be to trace that bug!)
We can use the percent-based trick we learned in Module 1, passing percentages down so that they can be used where you need them.
We can tweak our designs so that they don't need to fill the viewport exactly. Fixed-height designs tend to be rigid and flaky; better to have a fluid design that doesn't have such a strict height requirement.

The vh unit can still come in handy, but it probably shouldn't be used in this exact situation.

Dynamic viewport units
(success)

So, browser vendors are aware of this issue, and they've been working on fixing it!

There are several new units we can use:

svh — Small Viewport Height
lvh — Large Viewport Height
dvh — Dynamic Viewport Height

The lvh unit works like the vh unit does; it always refers to the full viewport height, once the browser UI has shrunk down.

svh always refers to the smaller height, the height that first shows when the page loads.

Finally, dvh will dynamically adjust as the viewport height changes. This is the way our height: 100% alternative works.

When I originally created this course, these units were only in a very small % of browsers. As I write this update in March 2025, these units have shipped in all major browsers
, and are available for 94% of users!

It's still worth adding a vh fallback for the other 6% of people. Here's how I recommend using viewport units today:

.some-element {
  height: 100vh; /* Fallback for legacy users */
  height: 100dvh;
}

Unfortunately, I haven't had the chance to update the rest of this course. So, anywhere you see me use vh, pretend I'm also adding a dvh declaration!

The desktop scrollbar issue

Unfortunately, vh isn't alone in having some problems: the vw unit isn't perfect either!

Here's the problem: vw refers to the viewport width not counting the scrollbar.

On mobile, this is fine, because the scrollbar floats transparently above the content. On desktop, though, the scrollbar usually takes up its own space, within the viewport. The exact width depends on the platform and on the styling.

This means that if we set an element to stretch to 100vw, and our scrollbar is 15px wide, we'll wind up with 15px of horizontal overflow:

You can also view a live example of this issue, though the issue will only be present on desktop (on mobile, scrollbars don't take up any width).

Enabling scrollbars on macOS
(info)

As we saw in the “Overflow” lesson, macOS treats scrollbars a little bit differently from other operating systems.

If you're using a device with horizontal scroll, like a trackpad or a magic mouse, macOS will hide scrollbars by default, and show them as a semi-transparent overlay when needed.

We should update this setting so that our experience matches that of our users. It can be done in the system preferences. Set “Show scroll bars” to “Always”:

Can we fix this? Sorta, but not really. 😬

In an earlier version of this lesson, I included a JS snippet that would dynamically measure the width of the scrollbar, and make it available to us through a CSS variable. Since publishing this lesson, though, I've come to realize that it's not the best idea. This is for several reasons:

If you're using "server-side rendering" in a JS framework like React, there will be a delay before the JS runs, meaning that the value won't be defined at first, potentially breaking the layout.
If the page loads without a scrollbar, but later introduces one (eg. after fetching data from the network), the scrollbar width won't be defined.
While it seems to work pretty well in most situations I've tried, there are probably more edge-cases I haven't run into.

This is a bummer, but honestly, I don't really find the vw unit super useful. As we learned about in Module 1, block-level elements will expand horizontally, making it much easier to use percentage-based widths compared to percentage-based heights.

The one common use case I've seen for vw is to "break out" of parent containers, but I have a grid-based approach that feels much less hacky to me.

I'll include my JS snippet below, but please use it with caution:

Legacy JS snippet
(warning)

Here's the content this lesson used to contain, showing how to dynamically compute the scrollbar width and store it in a CSS variable:

 Show more
vmin and vmax

There are two more nifty viewport units: vmin and vmax.

vmin will refer to the shorter dimension, while vmax refers to the longer one. On a portrait phone, 50vmin is equivalent to 50vw, but on a landscape monitor, 50vmin would be equal to 50vh.

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

These units are nifty, but honestly, I don't find myself reaching for them that often. If they have practical everyday use cases, I haven't discovered them yet.

Update, January 2024: I’ve discovered a practical everyday use case! We can use border-radius: 100vmax; to create perfectly-circular corners, no matter how big or small an element is. We'll cover it later in the course.


---

## Clamping Values

Source: /css-for-js/05-responsive-css/12-clamping-values

Clamping Values

Let's suppose we have a column of text, and we want it to occupy 65% of the viewport:

We can do that with a percentage-based width, and some auto-margins for centering:

.column {
  width: 65%;
  margin-left: auto;
  margin-right: auto;
}

This works great for the sizes shown in the GIF, but it doesn't scale well beyond that. On large screens, the lines are much too long to read comfortably:

Meanwhile, on phones, the column is much too narrow:

We can constrain this value using our friends min-width and max-width:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

(Depending on your screen size, you might need to hit the
Toggle fullscreen
 icon to make the playground full-screen, to give you the space to see this effect, as you resize the "Result" pane.)

The really cool thing about min-width and max-width is that we can mix units. We can set our column to take up 65% of the available space, but limit it between 500px and 800px:

There's a problem though. When we reduce the viewport even further, we cause a horizontal overflow:

Why does this happen? Well, we've given our element a minimum width of 500px! Phone screens are narrower than that.

On mobile, we want our .column to fill the entire available width, which is the default behaviour of block-level elements. So, we can solve this by moving our styles to within a media query:

@media (min-width: 550px) {
  .column {
    width: 65%;
    min-width: 500px;
    max-width: 800px;
  }
}

We set the query to trigger at 550px, 50px larger than our minimum width. We need to add a 50px buffer because of the page's built-in padding/margin. Otherwise, we'll still overflow slightly around 500px wide:

This feels like a code smell to me. 550px is a "magic number", and we shouldn't assume that it'll always be the right value; in the future, we might tweak the page's padding, and inadvertently break this UI!

Fortunately, we have another option: clamp. Here's what it looks like:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

clamp takes 3 values:

The minimum value
The ideal value
The maximum value

It works quite a bit like the trio of min-width, width, and max-width, but it combines it into a single property value. In other words, these two rules are functionally identical:

/* Method 1 */
.column {
  min-width: 500px;
  width: 65%;
  max-width: 800px;
}

/* Method 2 */
.column {
  width: clamp(500px, 65%, 800px);
}

By moving our built-in constraints to the clamp value, we free up max-width. Our solution combines them:

.column {
  width: clamp(500px, 65%, 800px);
  max-width: 100%;
}

In this snippet, we're essentially applying two maximum widths: 800px and 100%. Our .column element will never be larger than 800px or 100% of the available space.

This is handy, but it's only one example of the cool things clamp can do.

It works with other properties!

Historically, we've only been able to limit widths and heights. There is no min-padding/max-padding or min-font-size/max-font-size.

The amazing thing about clamp is that it's a value, not a property. This means that it can be used with just about any property!

Here's a silly example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

We'll see how this trick can be used to create fluid typography in an upcoming lesson.

Min and max

clamp allows us to specify a lower and upper bound. But what if we only want to limit one end?

There are min and max functions we can use as well:

.box {
  padding: min(32px, 5vw);
}

This works just like Math.min
 in JavaScript—it evaluates to whichever value is smaller.

In this example, our .box will have dynamic padding that scales with the viewport width, but only until it reaches 32px; it won't grow larger than that.

Browser support
(info)

clamp has very good browser support
. It's supported in the latest versions of all major browsers, though it's notably absent in Internet Explorer.

For a while, clamp was less supported than its sibling functions min and max, because of Safari. Starting in Safari 13.4, however, there's no difference: all browsers support min, max, and clamp equally well.

Exercises
Max-height hero

A popular pattern is to have a "hero" that fills most of the viewport:

Unfortunately, these types of user interfaces generally suffer from two problems:

1. If the font size is cranked up and/or if additional content is added, it can overflow onto the subsequent content:

2. On large & tall screens, it looks a little silly:

Update the playground below so that it meets these constraints:

A default height of 80vh
A max height of 500px, to prevent it from getting too big on taller viewports:
If the content doesn't fit, the hero should grow to prevent an overflow. You can test this by duplicating the content a bunch:

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

Correction: At around 6:15, I say "500px is the bigger of these two values", but I meant to say smaller.

---

## Scrollburglars

Source: /css-for-js/05-responsive-css/13-scrollburglars

Scrollburglars

A scrollburglar is my cute made-up name for a common phenomenon: A webpage has an accidental horizontal scrollbar that allows you to scroll by a few pixels.
*

Frustratingly, there isn't a single cause for this phenonenon. They can be triggered by lots of different things. Some examples:

An element has an explicit width that is too large to fit in the parent container.
A replaced element (eg. a video or an image) is used without constraining its width to fit in the parent container.
A really long word like “disestablishmentarianism” forces an element to be too wide for its parent container.
An element is explicitly pulled outside of the parent (positioned elements with negative left/right values, elements with negative margin, etc).

Our first step when solving these sorts of issues is to find the specific element causing the overflow, and fix it so that it stops doing that.

Our second (and often neglected) step is to try and find a way to prevent this issue from reoccuring.

Exercises

I've created a Git repository which has 3 different projects, each with a horizontal scrollbar on mobile. You can access it here:

https://github.com/css-for-js/scrollburglars

The exercises are sorted by difficulty. The 2nd and 3rd are quite a bit more challenging than the first.

Growth mindset and productive failure
(info)

For this lesson, I'm "front-loading" the exercises. You're being asked to solve a problem before we've covered the techniques you'll need to come up with a solution.

I recommend spending 5-10 minutes on each exercise. It is very likely that you won't come up with a solution in that time, and that's 100% OK. After 5 or 10 minutes, watch the solution video and I'll show you how to solve it.

Why would I ask you to try solving a problem you probably won't be able to solve? Because there is value in this process. Struggling with a problem is the best way to ensure that you learn. If I start with an explanation, and you breeze through the exercises, that knowledge probably won't be absorbed into your brain. In a month, when you encounter a scrollburglar in the real world, you won't remember how you solved it.

This is an increasingly-popular practice. It's known as productive failure. From a 2019 scientific article
:

In Productive Failure, the conventional instruction process is reversed so that learners attempt to solve challenging problems ahead of receiving explicit instruction. While students often fail to produce satisfactory solutions (hence “Failure”), these attempts help learners encode key features and learn better from subsequent instruction (hence “Productive”).

When I worked at Khan Academy, we spoke a lot about cultivating a “growth mindset”. A growth mindset is the belief that our brains are elastic, that we become smarter through practice, and that failure is the fastest way to learn.

If you're interested in cultivating a growth mindset, I recommend this free series of lessons
 from Khan Academy.

All of that said, this is your course, and I encourage you to use it in whichever manner is most worthwhile for you.

Exercise 1: Recut

Solution video:

View the final code on Github

An alternative solution?
(info)

Several students have asked if this is an acceptable solution:

.max-w-md {
  max-width: 28rem; /* Unchanged */
  width: 100%;
}

By setting width: 100%, the image will shrink if the available space is less than 28rem. It appears to satisfy all of the conditions!

But there's a (slight) catch.

 Show more
Exercise 2: Warp and Weave

Solution video:

View the final code on Github

Exercise 3: Blog example

Solution video:

A modern solution
(success)

When I recorded this solution, overflow: clip wasn’t yet well-supported. These days, though, it has pretty darn good support
. We can solve our problem with a single line of CSS, and it doesn’t have any of the tradeoffs:

html {
  overflow-x: clip;
}

As I mentioned at the end of the video, I have another video that digs into a complex but thorough solution to this problem. It’s not as relevant these days, with overflow: clip, but if you need to support legacy browsers at your work and want to know how to solve this problem, you can watch this video and refer to the final code on Github below:

View the original final code on Github

A JS snippet to help
(info)

Discord member SSHari shared a small JS console script that can be used to quickly identify elements that are wider than the viewport:

function checkElemWidth(elem) {
  if (elem.clientWidth > window.innerWidth) {
    console.info(
      "The following element has a larger width than " +
      "the window’s outer width"
    );
    console.info(elem);
    console.info("\n\n");
  }

  // Recursively check all the children
  // of the element to find the culprit.
  [...elem.children].forEach(checkElemWidth);
}

checkElemWidth(document.body);

It won't find all possible scrollburglars, because there are so many different ways for scrollburglars to be produced. But of the 3 examples above, this snippet correctly identified the culprit in two of them!

Note that I tweaked this snippet a bit. You can see SSHari's initial snippet on Github
.

Even more tools!
(success)

Firefox, as well as developer browser Polypane, both have tools to help you find scroll containers. Learn more in this awesome article:

Debug Unwanted Scrollbars

---

## Responsive Typography

Source: /css-for-js/05-responsive-css/14-responsive-typography

Responsive Typography

Here's a surprisingly complicated question: should text get bigger or smaller when viewed on a mobile device (compared to a desktop monitor)?

You might think that text should shrink, so that it can fit on the narrower display. Or, you might feel like text should grow larger, so that users don't have to squint to be able to read it.

The answer to this question will depend on the type of text we're talking about.

Body text

“Body text” is the text in our paragraphs and lists. It's the baseline text that fills most of our pages.

When it comes to body text, the answer to the question above is surprisingly simple: it should stay the same size across all devices.

Why? Because device manufacturers have already done the hard work of making sure that font sizes are consistent!

Here's a photo of me holding my phone, up in front of a desktop display showing the same website:

I did my best to simulate "real" conditions: the phone is about as far from the camera as it usually is from my eyes, and ditto for the desktop monitor.

When we compare the perceived size of the body text, it takes up about as much space in my field of view:

Critically, this text is the same font-size on both screens. The Washington Post isn't doing any trickery to achieve this effect. Font sizes are more-or-less perceptually uniform across devices.

We generally want our body text to be at least 16px
. Anything less and users will need to hold the phone uncomfortably close to their face, or do a bunch of pinch-and-zooming.

What about on very large displays? As counter-intuitive as it is, most web applications use the same font size regardless of display size. Facebook, Twitter, and Google generally stick around 16px no matter how big the screen gets! That said, it's somewhat common for content-heavy sites like blogs to use larger font sizes, up to 21px, for body text.

Font size units
(info)

As we've discussed, we don't want to use the px unit when it comes to typography. This is because browsers let users pick a default font size, but that won't work if we use "absolute" units like pixels.

So, when we say that body text should be at least 16px, what we're really saying is that it should be at least 1rem. The rem unit is relative to the root font size, which defaults to 16px in all browsers.

What if we want to set a different baseline font size, in an accessible way? The following code works:

html {
  font-size: 125%;
}

Even though we can do this, I wouldn't personally recommend it
*
. It's a widely-accepted convention that 1rem is equal to 16px. We're just making things more complicated if we change that convention.

Smaller text

In addition to the "body" text found in paragraphs and lists, we also have smaller bits of text that annotate or label things.

For example, photo captions tend to be quite small:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Is this a problem? I think it depends on the circumstances. If the text is relatively unimportant (eg. copyright notices in the footer), I don't mind if folks have to pinch-to-zoom to read it. But if the content is important, we should bump it up on mobile so that it's easier to read:

@media (max-width: 550px) {
  figcaption {
    font-size: 1rem;
  }
}
Form fields

Form input fields like <input> and <select> generally have a pretty small default font size. This makes them hard to read on mobile devices.

To compensate, iOS Safari will automatically zoom in to focused form fields with small text, to make them easier to read. While this does make them more legible, it makes everything else harder and more tedious.

Fortunately, there is an easy fix: Safari only zooms in if the fields are smaller than 16px.

Check out this video showing the difference:

By default, iOS will zoom in so that the input text is the equivalent of 16px. We can skip this zoom by setting the text to 16px by default:

input, select, textarea {
  font-size: 1rem;
}

If you have an iOS device, you can try out the following demo. Try tapping each input:

courses.joshwcomeau.com/demos/safari-inputs

The only difference between the two inputs is that the second has a font-size of 1rem.

Headings

When it comes to headings, we need a slightly different approach.

Mobile devices are very narrow, and they can't fit that many characters per line. Large headings feel awkward:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

2.5rem (40px) isn't an unreasonable font size for a large desktop heading, but it's totally unwieldy on mobile. It takes up most of the screen!

One way to deal with this is to use media queries; we can decrease the font size on mobile devices:

h1 {
  font-size: 2.5rem;
}

@media (max-width: 550px) {
  h1 {
    font-size: 1.75rem;
  }
}

But there's another option: we can choose a fluid value so that the font scales smoothly with the viewport width.

This concept is discussed in the next lesson.


---

## Fluid Typography

Source: /css-for-js/05-responsive-css/15-fluid-typography

Fluid Typography

The idea with fluid typography is that instead of creating discrete font sizes at specific breakpoints, our typography smoothly scales with the viewport.

This is done with the vw unit:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  h1 {
    font-size: 6vw;
    margin-bottom: 0.5em;
  }
</style>

<h1>
  This is a fluid headline!
</h1>
<p>
  The heading will grow and shrink with the viewport.
</p>
Result
Refresh results pane

Try resizing the Result pane to see how the heading's font size behaves.

This is a neat trick, but there are two problems with it.

The first is that it gets a bit ridiculous on very-large or very-small screens. On an iPhone SE, for example, the heading is almost as small as the body text:

We can solve this problem by using our new friend clamp, to set bounds on how big or small the font can grow:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  h1 {
    font-size: clamp(1.5rem, 6vw, 3rem);
    margin-bottom: 0.5em;
  }
</style>

<h1>
  This is a fluid headline!
</h1>
<p>
  The heading will grow and shrink with the viewport.
</p>
Result
Refresh results pane

clamp lets us set a hard boundary. In this case, our text is guaranteed to always be between 1.5rem and 3rem, no matter what size the viewport is.

Safari quirk
(warning)

Safari supports the vw unit, and it supports clamp, but when they're used together, Safari behaves a little strangely.

Specifically, it only calculates the value when the element first appears. It won't recalculate the font size when the window is resized.

This peculiar rendering behaviour can be fixed with the following declaration:

h1 {
  font-size: clamp(1.5rem, 6vw, 3rem);
  min-height: 0vh;
}
 Show more

There's one more problem with our solution: we've introduced an accessibility violation.

Check out what happens when we zoom the page in/out:

The WCAG guidelines state that text should be scalable up to 200%
. If the default font size is 32px, the user should be able to scale it up to 64px (in fact, many folks with poor vision will crank it up even further than that; 200% is the minimum recommendation).

When we use viewport units for our font sizes, that text is locked at that size. It won't be increased by zooming in or by bumping up the browser's default font size.

We can solve this problem by “mixing in” a relative unit:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

To understand what's going on here, it helps for us to convert all of these units in our heads.

Each vw unit is 1% of the viewport width. With a 1000px-wide window, 4vw will be 40px.

We then add this number with 1rem. By default, 1rem equals 16px. Added together, our total font size at 1000px will be 56px (40px + 16px).

The first half of this equation is controlled by resizing the window. This table shows the calculated results for 3 different viewport widths.

	400px	800px	1600px
6vw	24px	48px	96px
calc(4vw + 1rem)	16 + 16 = 32px	32 + 16 = 48px	64 + 16 = 80px
calc(5vw + 2rem)	20 + 32 = 52px	40 + 32 = 72px	80 + 32 = 112px
clamp(
  2.5rem,
  4vw + 1rem,
  4rem
)	40px (clamped)	32 + 16 = 48px	64px (clamped)

The second half of the equation is controlled by the user's font size. If the user doubles their default font size, 1rem becomes equal to 32px, not 16px.

By mixing a viewport unit with a relative unit, we give the user control over the font size once more, allowing them to crank it up (albeit at a slower rate).

Look ma, no calc!
(info)

Earlier, we saw how calc lets us do math with our CSS values. You may be wondering why we didn't need to use it in this situation, like this:

h1 {
  font-size: clamp(
    1.5rem,
    calc(4vw + 1rem),
    3rem
  );
}

As a courtesy, the clamp function (along with min and max) will automatically resolve any calc-style equations within. This helps keep our code a bit cleaner, with no nested function calls required.

Use responsibly

Fluid typography is useful when it comes to headings and other large text elements, but I don't recommend using this strategy on smaller text like body text.

Our body text is already at the perfect size, without bumping it up or down. Viewport units tend to produce very-small text on mobile. And while users can pinch-zoom to read small text, it's not a pleasant experience.


---

## Fluid Calculator

Source: /css-for-js/05-responsive-css/16-fluid-calculator

Fluid Calculator

So we've seen how the vw unit lets us scale the font size with the viewport width… but what if we want to change the rate of change?

To show you what I mean, try resizing the playground below. Both headings use fluid typography, but they change at very different rates:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .fluid {
    font-size: clamp(
      2rem,
      5vw + 1rem,
      5rem
    );
  }
  .fluid-fast {
    font-size: clamp(
      2rem,
      14vw - 1.5rem,
      5rem
    );
  }
</style>

<h2 class="fluid">Fluid Text</h2>
<h2 class="fluid-fast">Fluid Text</h2>
Result
Refresh results pane

The trick is that we can play with the ratio between viewport and relative units.

I explain this technique in this video:

Here's the tool from the video:

Minimum Size
2rem
Maximum Size
3rem
Fluid font size
2vw
Relative mixin
1rem
Root font size?
16px
Displayed as?
px
rem
5rem
3.75rem
2.5rem
1.25rem
0rem
300px
500px
700px
900px
1100px
1300px
1500px
1700px
1900px
.wrapper {
  font-size: clamp(
    2rem,
    2vw + 1rem,
    3rem
  );
}

A correction about accessibility
(warning)

In the video above, I warn never to pick a “Relative mixin” value between -1 and 1, but this turns out to not be necessary as long as you specify a reasonable minimum value.

Consider this declaration:

.problematic {
  font-size: calc(10vw - 2rem);
}

By default, each rem is equal to 16px, and so if we do the math on a viewport which is 1000px wide, the font-size will be 68px (100px - 16px * 2).

But suppose the user has poor vision, and so they crank up their default font size in the browser settings. Now, each rem is equal to 48px instead of 16px. Because we’re subtracting the rem value, the calculation is now 100px - 48px * 2, which means our text will be a microscopic 4px tall! Paradoxically, subtracting rems means that the text gets smaller as the user bumps up their default font size. 😬

With clamp, however, we can specify a minimum font size. If we specify that minimum value in rems, and don’t pick an absurdly small value, the user will still be able to scale it up as much as they want. Just make sure the specified minimum value is at least 1rem, or whatever value you’re using for paragraphs. That way, this text will always be at least as large as the main body text, regardless of the user’s font scaling.

Exercises
Fluid heading

Tweak this heading so that it meets the following constraints (with a default base font size of 16px):

Minimum 1.5rem, when 700px or smaller
Maximum 3rem, when 1000px or larger

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane

Solution:

Fluid spacing

This trick can be useful even beyond font sizes!

Update the playground below so that the list items grow further apart on larger viewport sizes:

Here are the constraints:

Minimum 1rem, when 400px or smaller
Maximum 5rem, when ~930px or larger

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

Additional challenges

If you'd like more practice using this calculator, here are some additional values to try and match:

Minimum 2rem at 400px, Maximum 4.5rem at 1400px
Minimum 3rem at 800px, Maximum 4rem at 1600px
Minimum 2rem at 1000px, Maximum 4rem at ~1535px

---

## Fluid Design

Source: /css-for-js/05-responsive-css/17-fluid-design

Fluid Design

In the last lesson, we saw how we have two choices when it comes to scaling text based on the viewport:

We can define specific sizes at specific breakpoints using media queries (“responsive”).
We can proportionally grow/shrink text based on the viewport width using the vw unit (“fluid”).

Here are the two strategies side-by-side:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
<style>
  .responsive {
    font-size: 2rem;
  }
  @media (min-width: 400px) {
    .responsive {
      font-size: 2.5rem;
    }
  }
  @media (min-width: 525px) {
    .responsive {
      font-size: 3rem;
    }
  }

  .fluid {
    font-size: clamp(
      2rem,
      6vw + 1rem,
      3rem
    );
  }

  figure {
    padding: 16px;
    border: 2px solid;
    margin: 0;
    margin-bottom: 8px;
  }
  figcaption {
    font-size: 0.875rem;
    color: #444;
    margin-top: 8px;
  }
</style>

Result
Refresh results pane

This responsive vs. fluid dynamic isn't just a typography thing; it's becoming increasingly common to use Flexbox/Grid to build “fluid layouts” instead of defining concrete breakpoints.

That said, fluid isn't inherently better than responsive. They are different approaches with different tradeoffs. Generally, they solve separate problems, though there is some overlap. They're two different tools, and I use them in different situations.

Let's look at an example.

Here's the playground from the video:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane
Advanced Flex techniques

The fluid approach, using Flexbox, can pull off some pretty impressive tricks.

Here's the most extreme version I've found. This snippet is by Adam Argyle. Try resizing the Result pane: there are 4 different layouts supported:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

This demo works by taking advantage of the fact that text inputs and submit buttons have different default minimum widths. It leverages the flex wrapping algorithm to create these 4 different layouts.

This is an undeniably impressive demo. Adam is incredibly talented, and it's clear he possesses a deep intuition of Flexbox mechanics. But honestly, I'm not a fan of this approach in real-world contexts. I think it's a bit too clever for its own good.

Have you ever solved problems on sites like Codewars or Project Euler? These sites let you practice your programming skills by answering tough questions. A question might be something like “Write a function that returns all the prime numbers that are also part of the fibonacci sequence under 1 million”.

When you submit a solution, you're able to see the solutions that other folks have submitted. The most popular solutions are terse and clever and impossible to understand.

The types of clever impress-your-friends "code golf"
*
 code that does well on these sites is in many ways the opposite of real-world code that we write for our day jobs.

When I write code, I want my code to be as easy-to-understand as possible. Next week, when the junior dev on my team has to update this code, I want it to be as accessible for them as possible. It's not about "dumbing down" our solutions, it's about optimizing for clarity. The clearer the code is, the quicker we'll be able to fix bugs and ship new features.

I wrote more about this idea in a blog post a few years back, “Clever Code Considered Harmful”
.

Adam's constraint-driven Flexbox form is an incredibly elegant piece of CSS, but it takes a while to figure out. I suspect Adam himself would agree: this is a fancy demo, but it's probably not the clearest way to create a responsive form.

Sometimes, responsive solutions are simpler. Other times, fluid solutions are simpler. Sometimes, the fluid solution is slightly more complex, but it offers better user experience, so we pick it anyway. There are lots of factors to consider. “Understandability” isn't the only thing that matters, but it's a significant variable in the equation for me.

Form best practices
(info)

In the form demo above, the “placeholder” field is used to label the form field:

This isn't a very good practice.

Placeholders and labels are two different things, with two different purposes. Labels explain what the field is, and placeholders provide an example input, to give users a hint about what's expected and show how to format the data. For example:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
Result
Refresh results pane
 Show more

---

## Container Queries

Source: /css-for-js/05-responsive-css/18-container-queries

Container Queries

In this module, our main tool for implementing responsive design has been the media query. Media queries let us conditionally apply some CSS based on current global values, things like the viewport width, or the user’s motion preferences.

Sometimes, though, we don’t want our layout to change based on the viewport’s size, we want it to change based on the element’s size.

The fluid design stuff we learned about in the previous lesson can sometimes help in these situations, but they’re much more limited than media queries. An obvious gap in CSS has been the ability to provide a chunk of CSS that will be applied if an element is above or below a certain size.

Well, this capability has finally arrived. Container queries are like media queries, but instead of measuring the viewport, they measure an element’s container. This feature has been supported in all major browsers since 2022. Our prayers have been answered!

Here’s what the syntax looks like:

@container (min-width: 40rem) {
  .some-elem {
    font-size: 1.5rem;
  }
}

In this code snippet, the CSS will be applied if .some-elem’s container is 40rem or larger. Pretty cool, right??

Unlike media queries, however, there are some “gotchas” to be aware of with container queries. They’re more complicated than you might expect, at first glance.

I’ve been using container queries for a few months now, and they really are quite lovely once you have the right mental model. In this lesson, we’ll unpack all of this stuff so that you can start using them in your work!

A practical use case

Suppose we have a ProfileCard component, to display critical info about a user’s profile:

Anthony Harris
@theboxmodel

San Francisco, US
Staff UI/UX Designer
Follow
Message

Dr. Kai Bechstein
@pianofingers

Berlin, DE
Physician
Follow
Message

Faajal Singh
@faajal31

Vancouver, CA
Principal Engineer
Follow
Message

In this particular circumstance, each ProfileCard is pretty narrow, and so the information stacks vertically in 1 tall column.

In other circumstances, though, we might have a bit more breathing room. Wouldn’t it be cool if our ProfileCard could automatically shift between layouts, depending on the available space?

Maybe something like this:

Elena Wilson
@blasphemous

Tokyo, JP
Barista
Apr 23, 2017
159 Posts
Follow
Message

In some cases, we can use media queries for this, if our ProfileCard scales with the size of the viewport… But this won’t always be the case.

For example, maybe we’re arranging these cards in a flex grid like this:

Number of Profiles
3

Mario U. Devi
@cheerleader

Delhi, IN
Director of Engineering
Follow
Message

Paul Schmidt
@Paul5

Paris, FR
Tattoo Artist
Follow
Message

Daniel Lopez
@supersawpluck

Chicago, US
Director of Engineering
Follow
Message

With dynamic layouts like this, each ProfileCard will use whichever layout makes the most sense given the amount of space available. It has nothing to do with the size of the viewport!

Clearly, media queries aren’t the right tool for this job. Instead, we can use container queries to solve this problem. Here’s what it looks like:

.child-wrapper {
  container-type: inline-size;
}

.child {
  /* Narrow layout stuff here */
}

@container (min-width: 15rem) {
  .child {
    /* Wide layout stuff here */
  }
}

We define our narrow layout styles inside the .child block, and then we override those styles if the container is 15rem or larger.

But wait, what’s the deal with .child-wrapper? What is that container-type property doing??

Well, this is where things get a bit tricky. In order to use a container query, we first need to explicitly define its container. This can have some unintended consequences.

It’s worth spending a few minutes digging into this. Understanding this core mechanism will save us hours of frustration down the line. Let’s talk about the “impossible problem” with container queries.

Solving an impossible problem

For something like 20 years now, ever since “responsive design” became a thing, developers have been asking for container queries. So why are we only being introduced now??

Well, for something like 20 years, the CSS Working Group has been saying the same thing: It’s impossible to implement container queries. It can’t be done.

This’ll be much easier to understand with an example. Consider this scenario:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

If you’re not familiar with the fit-content keyword, it’s a dynamic value that grows/shrinks based on the element’s content. If you add/remove some words to the paragraph, you’ll notice the paragraph change size:

Num of Characters
12
5.9rem
Hello world!

Now, let’s suppose we want to bump up the font-size of that bold text, depending on the size of its container. We can imagine doing something like this:

p {
  width: fit-content;
}

@container (max-width: 10rem) {
  p strong {
    font-size: 3rem;
  }
}

This seems to make sense… When our parent <p> tag is 10rem or smaller, we apply font-size: 3rem to the <strong> tag within.

But let’s really think about this. When we change an element’s font-size, it doesn’t just affect the height of the characters. It also affects the element’s width:

font-size
1rem
6rem
Hello World!

When our container is 10rem or smaller, we apply styles that cause the container to grow beyond 10rem. The CSS that we apply conditionally causes the condition to no longer be met!

This next demo shows what would happen if this sort of thing were allowed. Reduce the number of characters until the container is less than 10rem, and notice what happens:

Flickering warning
(warning)

Interacting with this demo will cause the UI to flicker. The rate of flickering is roughly 2x per second (so, relatively slow).

Num of Characters
70
32.1rem
Hello world! This is a sentence that includes several different words.

This is mindbending stuff, and it took me a minute to really understand the problem here.

When our <section> is less than 10rem wide, our condition is met, and so we apply some CSS, bumping up the font size. But this causes our <p> tag to expand, which causes the parent <section> to grow beyond the 10rem threshold! The CSS we write inside a container query can affect the container itself, leading to these infinite loops of flickering UI.

This is the core problem that the CSS Working Group said was unsolveable. This is why we haven’t had container queries until now.

We don’t run into this problem with media queries because their conditions are based on immutable global states. CSS does not give us the power to change things like the width of the viewport or the user’s motion preferences. So there’s no way for us to invalidate a media query from within it.

I’m using the fit-content keyword to demonstrate the issue here, but the problem is much more broad than this one niche property. Lots of things in CSS work this way, with parents dynamically responding to their children.

The solution to this unsolveable problem appeared suddenly, with the introduction of a completely unrelated API.

The Containment API

The Containment API, released a few years ago, allows us to specify that certain slices of the DOM are self-contained, and won’t leak out and affect other parts of the DOM.

I don’t want to go on too much of a tangent here, but here’s a quick demonstration that shows how this API works:

Image width
contain
none (default)
size

The axolotl is a ridiculous aquatic salamander. It’s absolutely adorable and looks like a Pokémon. It is one of my favourite animals.

By default, our red box will grow and shrink to contain its children. This is exactly the sort of dynamic behaviour that causes problems for container queries.

By setting contain: size on the parent, we sever this connection. As a result, the height of the container no longer depends on its content. If we don’t specify an explicit height, the container will collapse down to 0px (plus padding).

The Containment API was designed with performance optimizations in mind. CSS is a very dynamic language, and this means the browser often has to do a lot of work when things change. For example: when we tweak the height of the axolotl image, it affects not only the elements within that demo, but everything that follows in this article. Paragraphs like this one gets shifted up and down on every size change, causing a layout recalculation and a repaint.

And so, if we know that an element is self-contained and won’t affect anything else, we can use the contain property to let the browser know that it can skip certain calculations. A helpful analogy for React devs: it’s a bit like React.memo(). We can use contain to opt out of recalculations that we know are unnecessary.

Now, truthfully, I haven’t found myself using contain on a regular basis. Modern browsers are already heavily optimized and will skip calculations that are obviously unnecessary. I get the impression that contain is mostly intended for edge-cases, or for situations where every last drop of performance is critical.

But this API has provided the final foundational piece for container queries! This is how we solve the impossible problem. This API gives us the ability to “short-circuit” the infinite loop by specifying that a parent shouldn’t respond dynamically to its content.

More information on containment
(info)

We’re really only scratching the surface of the Containment API here. If you’d like to go deeper, I recommend checking out this article from Rachel Andrew: Helping Browsers Optimize With The CSS Contain Property
.

Honestly, I don’t think most front-end developers need to use this API, but if you are curious about it, this is the best introductory resource I’ve found.

Our first container query

With all of that context in mind, let’s write a “hello world” container query:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

First, we declare that the <section> element is a container. This will allow any of its descendants to use it as a measuring stick, to apply CSS when certain conditions are met.

Next, we create a container query, selecting the <p> within our container and tweaking its cosmetic styles when the container is 12rem wide or less. When that condition is met, the CSS within that block will be applied, and the text will become bold and red.

If you’re viewing this on a device with a large screen, you can see this for yourself: resize the Result pane by clicking and dragging the divider, or focusing it and using the left/right arrow keys.

There’s a problem with this implementation, though. It becomes apparent when we give our container some cosmetic styles:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

Like we saw with the axolotl example, the parent element is no longer responding dynamically to its children. Instead of growing to fit the paragraphs within, it collapses down to nothing; the only reason we can see the background color at all is because this element happens to have some padding!

When we set container-type: size, we tell the browser that this element’s layout doesn’t depend on its children. This prevents the infinite loop we saw earlier, but it also breaks one of our core assumptions about how CSS works!

As we learned back in Module 1, width and height work differently on the web:

When it comes to width, elements tend to expand, filling the space provided by the parent.
When it comes to height, elements tend to shrinkwrap around their children.

Consider an empty <div> with no CSS applied to it. It will be 0px tall, but it won’t be 0px wide. It’ll grow to fill the entire horizontal space, regardless of whether it has any content or not.

When we set container-type: size, we’re effectively telling the browser to ignore the element’s content when determining its size; it’s as if everything inside had set position: absolute, taking it out of flow. And so, the element collapses down to 0px tall (plus whatever padding/border is set).

Fortunately, there’s another value we can use for the container-type property, inline-size:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The term inline-size here refers to the inline dimension, which is typically width. They named it inline-size instead of width as part of the move towards logical properties, using abstract terms for left/right and width/height to account for different languages and writing modes.

Essentially what we’re saying here is that the width of the element does not depend on its content. As a result, it can be used as a measuring stick by its descendants. The element’s height, by contrast, retains its default behaviour of growing/shrinking based on its content.

The golden rule with container queries is that we can’t change what we measure. container-type: inline-size lets us use min-width/max-width conditions in our container queries, but not min-height/max-height.

(Credit to Miriam Suzanne
 for coining this golden rule. Miriam is also the person who solved the impossible problem with container queries, and the main reason we have them today. She’s the best.)


---

## The Killer Pattern

Source: /css-for-js/05-responsive-css/18.01-container-query-patterns

The Killer Pattern

The most exciting thing about container queries, in my opinion, is that they expand what’s possible in terms of user interface design. They give us new options when it comes to responsive design, creating UIs that would be impractical or impossible using traditional media queries.

There’s one pattern in particular that I find myself using over and over again. Let’s look at an example, from my blog:

This layout is used to display newsletter issues. If you’re not aware, my newsletter is used to tell y’all about new blog posts and courses, and to share special bonus content that doesn’t quite fit here on the blog. You can view this newsletter issue
 to see it live.

On desktop, it’s a two-column layout. The email metadata on the left, the content on the right. On smaller screens, it collapses to a single column:

This is a pretty common design pattern, and it’s easily solved using media queries, but it leads to a curious side-effect: the width of each column actually increases when the viewport shrinks below the mobile threshold.

Keep your eye on the width of the left-hand column as you shrink the (virtual) window, using the slider:

Window Width
21.9rem
Subject line here
From:
Josh Comeau
Reply:
Josh@email.com
Date:
January 1

Hi, screen-reader users! This is a scribble intended to represent text in an email.

You can ignore all text in this container.

When we reach the mobile threshold, our two-column layout becomes a one-column layout, which means the metadata column actually gets bigger, expanding to fill the entire container. It doesn’t have to share any horizontal space with the main content anymore.

Now, here’s where it gets tricky. I have two different layouts for the metadata column, depending on the available space:

Layout Type:
Sparse
Condensed

Some thoughts about passion…

From
Josh W. Comeau
Reply-To
support@joshwcomeau.com
Sent
May 6, 2026

When there’s enough room, I want to show the key/value pairs in a single row. Otherwise, the values should move to a new line.

But we want to do this based on the container’s size, not the viewport’s size! There isn’t a clear linear relationship between the two.

Here’s the ideal behaviour. Notice how the metadata layout changes back-and-forth as the window changes size:

Window Width
Sparse
Condensed
Subject line here
From:
Josh Comeau
Reply:
Josh@email.com
Date:
January 1

Hi, screen-reader users! This is a scribble intended to represent text in an email.

You can ignore all text in this container.

We’re using media queries to control the “top-level” layout, flipping from two columns to one column, but we can’t really use media queries to describe how the stuff within those columns should respond dynamically.

Or, well, technically we can, but it’s messy and fragile. We could do something like this:

.metadata-column {
  /* Condensed styles here */
}

@media (min-width: 35rem) and (max-width: 42rem),
       (min-width: 60rem) {
  .metadata-column {
    /* Sparse styles here */
  }
}

This approach combines multiple media conditions using a comma, which acts like an OR operator. We apply the “Sparse” styles if our viewport is between 35rem to 42rem, or at least 60rem.

But where did these numbers come from? 35rem, 42rem, and 60rem aren’t traditional site-wide breakpoints, they’re the magic numbers that happen to work given the current set of styles. When I’ve gone with this approach in the past, I literally measured the width of the viewport at the points where I wanted it to flip.

This is extremely fragile. It’ll work as long as none of the styles change, but even minor tweaks like adjusting the padding on one of the columns can cause problems.

It’s easy to imagine another developer coming along in a few months, tweaking the gap between the columns, and introducing an overflow issue because the layout isn’t flipping at the right point anymore. They probably won’t even notice, since the issue only happens at a narrow range of viewport widths, but some unlucky users will definitely notice!

Check out how much nicer the solution is with container queries:

<style>
  .metadata-column {
    container-type: inline-size;
  }

  .metadata {
    /* Condensed styles here */
  }

  @container (min-width: 19rem) {
    .metadata {
      /* Sparse styles here */
    }
  }
</style>

<div class="metadata-column">
  <div class="metadata">
    <!-- Stuff here -->
  </div>
</div>

If you use a CSS preprocessor that supports nesting (or are happy with the browser support for native CSS nesting
), we can make this even nicer:

.metadata-column {
  container-type: inline-size;
}

.metadata {
  /* Condensed styles here */

  @container (min-width: 19rem) {
    /* Sparse styles here */
  }
}

As we covered in the previous lesson, the @container at-rule works just like @media, except it uses the size of a defined container element. We specify which element should act as the container with the new container-type property.

Instead of 3 arbitrary numbers, we have 1 intentional number; 19rem, in this example, is the actual size that we’ve chosen for the flip, because the “sparse” layout would feel too cramped below that threshold.

Responsive vs. fluid design
(info)

You might feel like it’s still a bit of a code smell that we have to define any breakpoints at all. Shouldn’t the ideal solution flip automatically between layouts based on whether the text can comfortably fit on 1 line or not?

We saw examples of “breakpoint-free” responsiveness when we talked about fluid design. Fluid design is awesome, but it only really works in a narrow set of circumstances. In cases like this, where we have multiple children that all need to flip at the same point, I don’t believe it’s possible to solve this problem with a fluid approach.

And honestly, I’m not bothered about having an explicit breakpoint in this sort of situation. It doesn’t feel fragile to me at all; it won’t break if we change unrelated things, like the other column or the parent row, since we’re measuring the metadata column itself.

Progressive enhancement
(success)

You might be wondering: what happens when someone visits using an older browser, one which doesn’t support container queries?

The great thing about this strategy is that it fails gracefully. For folks on older browsers, the CSS within our @container at-rule will never get applied. The “condensed” styles will never get overwritten, no matter what the container size is.

This means that our UI won’t stretch out to take advantage of the extra real estate in larger containers, which isn’t ideal, but it also isn’t really a problem. By using min-width container queries, we avoid the real problem of trying to cram too much stuff into a tiny container, leading to overflows and broken UI.

Named containers

Containers are defined using the container-type CSS property. This is how we create the boxes that our container queries will measure.

One of the lesser-known features of this API is that we can choose which container to use, if multiple ancestors establish themselves as containers.

By default, the nearest ancestor will be used. Try to resize the “Result” pane below:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

The setup here is that our .child element has two container ancestors, its parent <section> and grandparent <main>. By default, the nearest ancestor will be used, and indeed, we can see that the element’s parent <section> is currently being used.

We can manually select a different container, though! Check this out:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
Result
Refresh results pane

When we define our container query with @container, we can optionally specify a container-name, which allows us to override the default behaviour and specify a different container!

We can simplify our code a bit by using the container shorthand property:

main {
  container: outer / inline-size;

  /* Equivalent to: */
  container-name: outer;
  container-type: inline-size;
}

The slash character (/) is a modern convention in CSS as a way to separate groups of values, like we saw when we learned about color formats. It has nothing to do with division.

The dawn of a new era

So, I’ve been using container queries in my own work for a few months now, and it still feels to me like we’re just scratching the surface of what’s possible. ✨

In this lesson, we explored the killer use case I’ve discovered so far: responding within media query breakpoints, when columns get wider on smaller viewports. I’ve used this technique all over my blog, from the Gradient Generator
 to my About page
.

And with named containers, this pattern could theoretically be taken even further; we could create multi-layered UIs that respond dynamically to different containers, layouts within layouts.

I’m getting a bit ahead of myself, though. Most developers haven’t even used container queries yet. And most designers aren’t even aware that we have this new capability.

As developers, we implement the mockups that designers prepare for us. This has always been a back-and-forth, a negotiation between what the designers want and what the developers can implement. And for almost 20 years now, we’ve made it clear that “responsive design” was limited to the viewport.

If you’re currently working as a developer, you should let your designer teammates know about container queries. They rely on us to keep them apprised of technological changes.

My hope is that over the next few years, container queries become a standard part of the “product development” toolkit, and the UIs we build get more sophisticated as a result. I’m going to keep experimenting with container queries, and I hope you will too!


---

## An Important Note

Source: /css-for-js/05-responsive-css/18.02-important-note

An Important Note

These lessons about container queries were part of a recent update to this course. Most of the lessons in this course was created earlier, before container queries were as well-supported as they are today.

This means you may encounter situations in exercises/workshops ahead where container queries would make things a lot simpler, but I don’t use them in my solution. Please keep in mind that this wasn’t a tool in my toolbox when I created the solutions.

If you’re not sure whether an exercise solution would be improved with container queries, I’d encourage you to give it a shot! You can share your solution in Discord and I’ll be glad to let you know whether I think it’s an improvement or not.

Container queries and styled-components

styled-components does support container queries as of the most recent version, v6.0. I recently updated this course platform to use this version, so you can use container queries in any React playgrounds.

Like with media queries, we nest the @container rule within the styled-component styles. Here’s what it looks like:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Open in CodeSandbox
Toggle fullscreen
import styled from 'styled-components';

function App() {
  return (
    <Container>
      <Element>
        Hello World
      </Element>
    </Container>
  );
}

const Container = styled.div`
  container-type: inline-size;
`;
const Element = styled.div`
  color: deeppink;

  @container (min-width: 18rem) {
    color: dodgerblue;
    font-weight: bold;
  }
`;

export default App;
Result
Console
Refresh results pane

---

## Feature Queries

Source: /css-for-js/05-responsive-css/19-feature-queries

Feature Queries

In this module, we’ve learned how we can use media and container queries to apply CSS conditionally based on things like the window width. Sometimes, though, we want to apply CSS conditionally based on the browser support of a CSS feature.

For example, suppose we wanted to apply a background color to an element, but only if the user’s browser supports container queries.

Here’s how we’d do that:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  @supports (container-type: inline-size) {
    .box {
      background-color: peachpuff;
    }
  }
</style>

<div class="box">
  Hello World
</div>
Result
Refresh results pane

The @supports at-rule creates a new feature query. It works quite a bit like media queries, but instead of using a narrow set of media features like min-width, we can pass any CSS declaration. If that CSS declaration is recognized by the browser, the CSS within will be applied. Otherwise, it will have no effect:

Code Playground

Reset Code
Show line numbers
Format code using Prettier
Toggle fullscreen
index.html
styles.css
<style>
  @supports (display: spaghetti) {
    /*
      This CSS doesn’t get applied, since
      there is no “spagnetti” layout mode.
    */
    .box {
      background-color: red;
    }
  }
</style>

<div class="box">
  Hello World
</div>
Result
Refresh results pane

This is really useful because it gives us a ton of control over the fallback experience when we use modern CSS features. Without feature queries, we can provide fallback values for individual properties, but we can’t control other properties based on that support.

For example, if we want to set a background color using a modern color format like LCH, we can duplicate the background-color property:

.thing {
  /* Fallback color for older browsers: */
  background-color: hsl(0deg 100% 50%);

  /* More-vibrant color for newer browsers: */
  background-color: oklch(0.65 0.3 30);
}

On older browsers, oklch() won’t exist, and so that second declaration will be considered invalid and will be completely ignored. On newer browsers, that second declaration will overwrite the first hsl() declaration.

This works great in basic cases like this, but it doesn’t provide a way to “group” other styles based on support. With feature queries, we can do stuff like this:

/* Use Flexbox on older browsers */
.wrapper {
  display: flex;
  align-content: flex-start;
}

/* Use CSS Grid on newer browsers */
@supports (display: grid) {
  .wrapper {
    display: grid;
    grid-template-columns: 1fr 1fr;
    align-content: start;
  }
}

If the user’s browser supports CSS Grid, we want to apply grid-specific properties like grid-template-columns, and we also want to change shared properties like align-content. We can group all of our grid-based styles within a feature query, to make sure we can produce the best experience in both cases.

The examples we’ve seen in this lesson are a bit contrived, but we’ll see some real-world examples later in the course when we learn about aspect-ratio, :has, and subgrid.

What if @supports isn't supported?
(info)

Feature queries are not new; they’ve been in all major browsers since 2015. As I write this in December 2025, support is sitting around 99.5% of tracked browsers on caniuse
.
*

That said, it’s an interesting question: what happens if someone visits the site using a super old browser? What will happen with our feature query?

Well, let’s think about this. Suppose we have the following code:

.wrapper {
  display: flex;
  align-content: flex-start;
}

@supports (display: grid) {
  .wrapper {
    display: grid;
    grid-template-columns: 1fr 1fr;
    align-content: start;
  }
}

If the browser doesn’t support feature queries, that entire second chunk of CSS will be considered invalid. Everything inside that @supports block will be ignored. Only that first rule will be applied.

This is exactly what we want! At this point, feature queries have been around for longer than most of the CSS features we’d want to test for, so if the browser doesn’t support feature queries, it almost certainly won’t support whatever CSS we’re testing for. So, we want all of this stuff to be ignored.

For more information, check out this awesome article by Jen Simmons about feature queries
.


---

## Workshop

Source: /css-for-js/05-responsive-css/20-workshop-intro

Workshop

It's time to apply some of this responsive and functional CSS to a larger project!

For this module, we're going to revisit the Sole&Ankle workshop from the Flexbox module's workshop. We're going to make it mobile-responsive:

Access starter files
Download from Github
Work on CodeSandbox

I recommend starting fresh with this repo, rather than continuing on from your Flexbox workshop. The reason is that a lot of the underlying files have been updated. If you choose to keep building on top of your Flexbox workshop, you may find that you're missing some pieces.

As always, step-by-step instructions can be found in the project's README.md
.

You can access the design on Figma:

Figma design

Have fun!

Submit Workshop

I review a small percentage of submitted workshops, as a way to gauge the effectiveness of the lessons in each module. I don't offer code reviews, sorry!


---

## Workshop Solution

Source: /css-for-js/05-responsive-css/20.01-workshop-solution

Workshop Solution

Outdated code in solution videos
(warning)

Since filming these solution videos, I have migrated this workshop from create-react-app to Vite, and updated React to 19. This required a few small changes in terms of file structure. For example, file extensions have been changed from .js to .jsx, since Vite doesn’t allow JSX in plain JS files.

The solution code
 has been updated, so please use that as your source of truth, rather than what’s in the videos.

Exercise 1: Breakpoints setup
View the code on Github
Exercise 2: Mobile header

Correction: The border-top declaration on Header should have been in the tabletAndSmaller media query. This has been fixed in the solution source code on Github:

View the code on Github
Exercise 3: Tweaks to the main view
View the code on Github
Exercise 4: Mobile menu modal

Significant differences here
(warning)

As I mentioned above, these videos were filmed using an older build tool. For the most part, these changes haven’t really affected the code we write in these exercises, but this particular exercise is an exception.

The following solution video uses Reach UI, a tool which has since become abandoned and unmaintained. When I updated the workshops, I also switched from Reach UI to Radix Primitives
.

This library solves the same problem, but it’s a completely different tool, and the solution video below has not been updated. I think it’s still worth watching, since the general styling approach is the same, but do keep in mind that you can’t follow along exactly.

I’ve updated the solution code on Github
 to use Radix Primitives, so please refer to that to see my updated solution.

View the code on Github

Alternative solution
(info)

Radix Primitives can either be used in an “uncontrolled” mode (where it manages the open/closed state internally), or a “controlled” mode (where we manage the state ourselves). For my solution, I chose to go with a controlled approach, managing our own state variable and controlling Radix’s Dialog with its open and onOpenChange props.

Alternatively, we could have wrapped all of the elements in Header.js within Radix’s Dialog.Root, and used its Dialog.Trigger component for the hamburger button.

Which approach is better? It really depends on the circumstances. The uncontrolled approach can be a bit simpler, but it also sacrifices a bit of flexibility. Ultimately, I think both approaches are perfectly valid.

Exercise 5: Fluid desktop navigation
View the code on Github
Exercise 6: Theming with CSS variables
View the code on Github

