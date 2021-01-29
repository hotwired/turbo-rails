# Turbo

[Turbo](https://turbo.hotwire.dev) gives you the speed of a single-page web application without having to write any JavaScript. Turbo accelerates links and form submissions without requiring you to change your server-side generated HTML. It lets you carve up a page into independent frames, which can be lazy-loaded and operate as independent components. And finally, helps you make partial page updates using just HTML and a set of CRUD-like container tags. These three techniques reduce the amount of custom JavaScript that many web applications need to write by an order of magnitude. And for the few dynamic bits that are left, you're invited to finish the job with [Stimulus](https://github.com/hotwired/stimulus).

On top of accelerating web applications, Turbo was built from the ground-up to form the foundation of hybrid native applications. Write the navigational shell of your Android or iOS app using the standard platform tooling, then seamlessly fill in features from the web, following native navigation patterns. Not every mobile screen needs to be written in Swift or Kotlin to feel native. With Turbo, you spend less time wrangling JSON, waiting on app stores to approve updates, or reimplementing features you've already created in HTML.

Turbo is a language-agnostic framework written in TypeScript, but this gem builds on top of those basics to make the integration with Rails as smooth as possible. You can deliver turbo updates via model callbacks over Action Cable, respond to controller actions with native navigation or standard redirects, and render turbo frames with helpers and layout-free responses.


## Turbo Drive

Turbo is a continuation of the ideas from the previous Turbolinks framework, and the heart of that past approach lives on as Turbo Drive. When installed, Turbo automatically intercepts all clicks on `<a href>` links to the same domain. When you click an eligible link, Turbo prevents the browser from following it. Instead, Turbo changes the browser’s URL using the History API, requests the new page using `fetch`, and then renders the HTML response.

During rendering, Turbo replaces the current `<body>` element outright and merges the contents of the `<head>` element. The JavaScript window and document objects, and the HTML `<html>` element, persist from one rendering to the next.

Whereas Turbolinks previously just dealt with links, Turbo can now also process form submissions and responses. This means the entire flow in the web application is wrapped into Turbo, making all the parts fast. No more need for `data-remote=true`.


## Turbo Frames

Turbo reinvents the old HTML technique of frames without any of the drawbacks that lead to developers abandoning it. With Turbo Frames, you can treat a subset of the page as its own component, where links and form submissions replace only that part. This removes an entire class of problems around partial interactivity that before would have required custom JavaScript.

It also makes it dead easy to carve a single page into smaller pieces that can all live on their own cache timeline. While the bulk of the page might easily be cached between users, a small personalized toolbar perhaps cannot. With Turbo::Frames, you can designate the toolbar as a frame, which will be lazy-loaded automatically by the publicly-cached root page. This means simpler pages, easier caching schemes with fewer dependent keys, and all without needing to write a lick of custom JavaScript.


## Turbo Streams

Partial page updates that are delivered asynchronously over a web socket connection is the hallmark of modern, reactive web applications. With Turbo Streams, you can get all of that modern goodness using the existing server-side HTML you're already rendering to deliver the first page load. With a set of simple CRUD container tags, you can send HTML fragments over the web socket (or in response to direct interactions), and see the page change in response to new data. Again, no need to construct an entirely separate API, no need to wrangle JSON, no need to reimplement the HTML construction in JavaScript. Take the HTML you're already making, wrap it in an update tag, and, voila, your page comes alive.

With this Rails integration, you can create these asynchronous updates directly in response to your model changes. Turbo uses Active Jobs to provide asynchronous partial rendering and Action Cable to deliver those updates to subscribers.


## Installation

The JavaScript for Turbo can either be run through the asset pipeline, which is included with this gem, or through the package that lives on NPM, through Webpacker.

1. Add the `turbo-rails` gem to your Gemfile: `gem 'turbo-rails'`
2. Run `./bin/bundle install`
3. Run `./bin/rails turbo:install`

Running `turbo:install` will install through NPM if Webpacker is installed in the application. Otherwise the asset pipeline version is used.

If you're using Webpack and need to use either the cable consumer or the Turbo instance, you can import [`Turbo`](https://turbo.hotwire.dev/reference/drive) and/or [`cable`](https://github.com/hotwired/turbo-rails/blob/main/app/javascript/turbo/cable.js) (`import { Turbo, cable } from "@hotwired/turbo-rails"`), but ensure that your application actually *uses* the members it `import`s when using this style (see [turbo-rails#48](https://github.com/hotwired/turbo-rails/issues/48)).

If you're using a [native adapter](https://turbo.hotwire.dev/handbook/native), you'll need to assign `window.Turbo`, even if it's not used for anything else:

```js
import { Turbo } from "@hotwired/turbo-rails"
window.Turbo = Turbo
```

## Usage

You can watch [the video introduction to Hotwire](https://hotwire.dev/#screencast), which focuses extensively on demonstration Turbo in a Rails demo. Then you should familiarize yourself with [Turbo handbook](https://turbo.hotwire.dev/handbook/introduction) to understand Drive, Frames, and Streams in-depth. Finally, dive into the code documentation by starting with [`Turbo::FramesHelper`](https://github.com/hotwired/turbo-rails/blob/main/app/helpers/turbo/frames_helper.rb), [`Turbo::StreamsHelper`](https://github.com/hotwired/turbo-rails/blob/main/app/helpers/turbo/streams_helper.rb), [`Turbo::Streams::TagBuilder`](https://github.com/hotwired/turbo-rails/blob/main/app/models/turbo/streams/tag_builder.rb), and [`Turbo::Broadcastable`](https://github.com/hotwired/turbo-rails/blob/main/app/models/concerns/turbo/broadcastable.rb).


## Compatibility with Rails UJS

[Rails UJS](https://github.com/rails/rails/tree/main/actionview/app/assets/javascripts) includes four features that make user interfaces slick. Some work directly with Turbo, while others are superseeded by it.

#### `data-confirm`

`data-confirm` works in browsers.

If using a native adapter, you may need to implement additional logic, such as a [WKUIDelegate](https://developer.apple.com/documentation/webkit/wkuidelegate#//apple_ref/occ/intfm/WKUIDelegate).

#### `data-disable-with`

`data-disable-with` works, with a caveat:

- Submit buttons are not automatically re-enabled on a failed submission. You can add a [Stimulus controller](https://github.com/hotwired/turbo/issues/55#issuecomment-757346604) to bring this behavior back.

#### `data-remote`

`data-remote` **is not compatible with Turbo**. Set `config.action_view.form_with_generates_remote_forms = false`  (or use Rails 6.1 defaults) to ensure your forms are not marked as `remote: true`, and avoid setting `remote: true` on links or buttons. If you currently have a `link_to url, remote: true`, the recommendation is to replace this link with a styled `button_to`, so you'll flow through a regular form, and you'll be better off with a11y compliance.

#### `data-method`

`data-method` works, with a caveat:

- You can't disable Turbo on `data-method` links, so `link_to url, method: :delete, data: { turbo: false }` will still run through Turbo. If you need to disable Turbo for a specific `data-method` link, use a styled `button_to` instead.


## Development

* To run the Rails tests: `bundle exec rake`.
* To compile the JavaScript for the asset pipeline: `yarn build`


## License

Turbo is released under the [MIT License](https://opensource.org/licenses/MIT).
