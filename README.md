# <img src="assets/logo.png?sanitize=true" width="24" height="24" alt="Turbo"> Turbo

[Turbo](https://turbo.hotwired.dev) gives you the speed of a single-page web application without having to write any JavaScript. Turbo accelerates links and form submissions without requiring you to change your server-side generated HTML. It lets you carve up a page into independent frames, which can be lazy-loaded and operate as independent components. And finally, helps you make partial page updates using just HTML and a set of CRUD-like container tags. These three techniques reduce the amount of custom JavaScript that many web applications need to write by an order of magnitude. And for the few dynamic bits that are left, you're invited to finish the job with [Stimulus](https://github.com/hotwired/stimulus).

On top of accelerating web applications, Turbo was built from the ground-up to form the foundation of hybrid native applications. Write the navigational shell of your [Android](https://github.com/hotwired/turbo-android) or [iOS](https://github.com/hotwired/turbo-ios) app using the standard platform tooling, then seamlessly fill in features from the web, following native navigation patterns. Not every mobile screen needs to be written in Swift or Kotlin to feel native. With Turbo, you spend less time wrangling JSON, waiting on app stores to approve updates, or reimplementing features you've already created in HTML.

Turbo is a language-agnostic framework written in TypeScript, but this gem builds on top of those basics to make the integration with Rails as smooth as possible. You can deliver turbo updates via model callbacks over Action Cable, respond to controller actions with native navigation or standard redirects, and render turbo frames with helpers and layout-free responses.


## Navigate with Turbo Drive

Turbo is a continuation of the ideas from the previous [Turbolinks](https://github.com/turbolinks/turbolinks) framework, and the heart of that past approach lives on as Turbo Drive. When installed, Turbo automatically intercepts all clicks on `<a href>` links to the same domain. When you click an eligible link, Turbo prevents the browser from following it. Instead, Turbo changes the browser’s URL using the History API, requests the new page using `fetch`, and then renders the HTML response.

During rendering, Turbo replaces the current `<body>` element outright and merges the contents of the `<head>` element. The JavaScript window and document objects, and the HTML `<html>` element, persist from one rendering to the next.

Whereas Turbolinks previously just dealt with links, Turbo can now also process form submissions and responses. This means the entire flow in the web application is wrapped into Turbo, making all the parts fast. No more need for `data-remote=true`.

Turbo Drive can be disabled on a per-element basis by annotating the element or any of its ancestors with `data-turbo="false"`. If you want Turbo Drive to be disabled by default, then you can adjust your import like this:

```js
import "@hotwired/turbo-rails"
Turbo.session.drive = false
```

Then you can use `data-turbo="true"` to enable Drive on a per-element basis.

[See documentation](https://turbo.hotwired.dev/handbook/drive).

## Decompose with Turbo Frames

Turbo reinvents the old HTML technique of frames without any of the drawbacks that lead to developers abandoning it. With Turbo Frames, **you can treat a subset of the page as its own component**, where links and form submissions **replace only that part**. This removes an entire class of problems around partial interactivity that before would have required custom JavaScript.

It also makes it dead easy to carve a single page into smaller pieces that can all live on their own cache timeline. While the bulk of the page might easily be cached between users, a small personalized toolbar perhaps cannot. With Turbo::Frames, you can designate the toolbar as a frame, which will be **lazy-loaded automatically** by the publicly-cached root page. This means simpler pages, easier caching schemes with fewer dependent keys, and all without needing to write a lick of custom JavaScript.

This gem provides a `turbo_frame_tag` helper to create those frames.

For instance:
```erb
<%# app/views/todos/show.html.erb %>
<%= turbo_frame_tag @todo do %>
  <p><%= @todo.description %></p>

  <%= link_to 'Edit this todo', edit_todo_path(@todo) %>
<% end %>

<%# app/views/todos/edit.html.erb %>
<%= turbo_frame_tag @todo do %>
  <%= render "form" %>

  <%= link_to 'Cancel', todo_path(@todo) %>
<% end %>
```

When the user will click on the `Edit this todo` link, as direct response to this direct user interaction, the turbo frame will be replaced with the one in the `edit.html.erb` page automatically.

[See documentation](https://turbo.hotwired.dev/handbook/frames).

### A note on custom layouts

In order to render turbo frame requests without the application layout, Turbo registers a custom [layout method](https://api.rubyonrails.org/classes/ActionView/Layouts/ClassMethods.html#method-i-layout). 
If your application uses custom layout resolution, you have to make sure to return `"turbo_rails/frame"` (or `false` for TurboRails < 1.4.0) for turbo frame requests:

```ruby
layout :custom_layout

def custom_layout
  return "turbo_rails/frame" if turbo_frame_request?
  
  # ... your custom layout logic
```

If you are using a custom, but "static" layout,

```ruby
layout "some_static_layout"
```

you **have** to change it to a layout method in order to conditionally return `false` for turbo frame requests:

```ruby
layout :custom_layout

def custom_layout
  return "turbo_rails/frame" if turbo_frame_request?
  
  "some_static_layout"
```

## Come Alive with Turbo Streams

Partial page updates that are **delivered asynchronously over a web socket connection** is the hallmark of modern, reactive web applications. With Turbo Streams, you can get all of that modern goodness using the existing server-side HTML you're already rendering to deliver the first page load. With a set of simple CRUD container tags, you can send HTML fragments over the web socket (or in response to direct interactions), and see the page change in response to new data. Again, **no need to construct an entirely separate API**, **no need to wrangle JSON**, **no need to reimplement the HTML construction in JavaScript**. Take the HTML you're already making, wrap it in an update tag, and, voila, your page comes alive.

With this Rails integration, you can create these asynchronous updates directly in response to your model changes. Turbo uses Active Jobs to provide asynchronous partial rendering and Action Cable to deliver those updates to subscribers.

This gem provides a `turbo_stream_from` helper to create a turbo stream.

```erb
<%# app/views/todos/show.html.erb %>
<%= turbo_stream_from dom_id(@todo) %>

<%# Rest of show here %>
```

[See documentation](https://turbo.hotwired.dev/handbook/streams).

## Installation

This gem is automatically configured for applications made with Rails 7+ (unless --skip-hotwire is passed to the generator). But if you're on Rails 6, you can install it manually:

1. Add the `turbo-rails` gem to your Gemfile: `gem 'turbo-rails'`
2. Run `./bin/bundle install`
3. Run `./bin/rails turbo:install`
4. Run `./bin/rails turbo:install:redis` to change the development Action Cable adapter from Async (the default one) to Redis. The Async adapter does not support Turbo Stream broadcasting.

Running `turbo:install` will install through NPM if Node.js is used in the application. Otherwise the asset pipeline version is used. To use the asset pipeline version, you must have `importmap-rails` installed first and listed higher in the Gemfile.

If you're using node and need to use the cable consumer, you can import [`cable`](https://github.com/hotwired/turbo-rails/blob/main/app/javascript/turbo/cable.js) (`import { cable } from "@hotwired/turbo-rails"`), but ensure that your application actually *uses* the members it `import`s when using this style (see [turbo-rails#48](https://github.com/hotwired/turbo-rails/issues/48)).

The `Turbo` instance is automatically assigned to `window.Turbo` upon import:

```js
import "@hotwired/turbo-rails"
```


## Usage

You can watch [the video introduction to Hotwire](https://hotwired.dev/#screencast), which focuses extensively on demonstrating Turbo in a Rails demo. Then you should familiarize yourself with [Turbo handbook](https://turbo.hotwired.dev/handbook/introduction) to understand Drive, Frames, and Streams in-depth. Finally, dive into the code documentation by starting with [`Turbo::FramesHelper`](https://github.com/hotwired/turbo-rails/blob/main/app/helpers/turbo/frames_helper.rb), [`Turbo::StreamsHelper`](https://github.com/hotwired/turbo-rails/blob/main/app/helpers/turbo/streams_helper.rb), [`Turbo::Streams::TagBuilder`](https://github.com/hotwired/turbo-rails/blob/main/app/models/turbo/streams/tag_builder.rb), and [`Turbo::Broadcastable`](https://github.com/hotwired/turbo-rails/blob/main/app/models/concerns/turbo/broadcastable.rb).

### RubyDoc Documentation

For the API documentation covering this gem's classes and packages, [visit the
RubyDoc page][].

[visit the RubyDoc page](https://rubydoc.info/github/hotwired/turbo-rails/main)

## Compatibility with Rails UJS

Turbo can coexist with Rails UJS, but you need to take a series of upgrade steps to make it happen. See [the upgrading guide](https://github.com/hotwired/turbo-rails/blob/main/UPGRADING.md).

## Testing


The [`Turbo::TestAssertions`](./lib/turbo/test_assertions.rb) concern provides Turbo Stream test helpers that assert the presence or absence of `<turbo-stream>` elements in a rendered fragment of HTML. `Turbo::TestAssertions` are automatically included in [`ActiveSupport::TestCase`](https://edgeapi.rubyonrails.org/classes/ActiveSupport/TestCase.html) and depend on the presence of [`rails-dom-testing`](https://github.com/rails/rails-dom-testing/) assertions.

The [`Turbo::TestAssertions::IntegrationTestAssertions`](./lib/turbo/test_assertions/integration_test_assertions.rb) are built on top of `Turbo::TestAssertions`, and add support for passing a `status:` keyword. They are automatically included in [`ActionDispatch::IntegrationTest`](https://edgeguides.rubyonrails.org/testing.html#integration-testing).

The [`Turbo::Broadcastable::TestHelper`](./lib/turbo/broadcastable/test_helper.rb) concern provides Action Cable-aware test helpers that assert that `<turbo-stream>` elements were or were not broadcast over Action Cable. They are not automatically included. To use them in your tests, make sure to `include Turbo::Broadcastable::TestHelper`.

## Development

Run the tests with `./bin/test`.


## License

Turbo is released under the [MIT License](https://opensource.org/licenses/MIT).
