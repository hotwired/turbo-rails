# Turbo gives you the speed of a single-page web application without having to write any JavaScript.

Turbo is a html-over-the-wire framework that includes three complimentary techniques to speeding up your server-side rendered application: links, frames, and updates.

It lets you write modern, responsive applications using whatever backend language or framework you'd like (we recommend Ruby on Rails!), and saves you the time normally spent wrestling with JSON APIs and GraphQL. Let a single majestic monolith serve as the core of your application, whether that's accessed via a browser on a desktop computer, a native hybrid app on mobile platforms, through an email gateway, or any other means.

It was extracted from building HEY by Sam Stephenson, Javan Makhmali, and David Heinemeier Hansson from Basecamp.

## Turbo::Links
Accelerate the transition between pages and responses to form submissions by swapping the `<body>` and merging the `head` without computing shared JavaScript or CSS again. No work required on your end.


## Turbo::Frames
Divide a complex page into smaller frames that can be updated independently in response to form submissions or replaced by following links. Like an iframe, but with none of the weirdness of a separate DOM. Works wonders for separating parts of the page that is either personalized or on a different cache schedule from the main structure.

```
<turbo-frame id="message_1">
  <a href="/messages/1/edit">Replace this frame with the response from /messages/1/edit by finding the turbo-frame tag with id="message_1"</a>
</turbo-frame>

<turbo-frame id="messages" src="/messages">
  Lazy loads /messages and replaces the turbo-frame with id="messages" in the response
</turbo-frame>
```

## Turbo::Updates
Perform partial updates to a page over WebSocket or in response to form submissions using just HTML tags. You can remove or replace elements and append or prepend to containers with a single template tag that wraps the HTML being added to the DOM.

```
<template data-page-update="prepend#messages">
  <div id="message_5">This will be prepended to the container with id="messages".</div>
</template>
```
