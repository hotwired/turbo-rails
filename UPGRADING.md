# Upgrading from Rails UJS / Turbolinks to Turbo

Turbo supersedes the functionality offered by Rails UJS to turn links and form submissions into XMLHttpRequests, so if you're making a complete switch from Rails UJS / Turbolinks to Turbo, you should ensure that you have `config.action_view.form_with_generates_remote_forms = false` set in your `config/application.rb`. But not all applications can upgrade in one jump, and may need to have Rails UJS coexist alongside Turbo. Here are the steps you need to follow:

## 1. Ensure Rails UJS is using compatible selectors
Rails UJS is offered either directly from the Rails framework or by the classic jquery-ujs plugin. Whichever of these you use, you can leave in place, but you need to either upgrade to a compatible version (see https://github.com/rails/rails/pull/42476) or vendor the JavaScript file needed in your app and tweak it yourself.

## 2. Replace the turbolinks gem in Gemfile with turbo-rails
You no longer want `gem 'turbolinks'` in your Gemfile, but instead `gem 'turbo-rails'`. But in order to have Turbo work with the old-style XMLHttpRequests issued by UJS, you'll need to shim the old Turbolinks behavior that made those requests compatible with 302s (by invoking Turbolinks, now Turbo, directly).

First you need to add `app/controllers/concerns/turbo/redirection.rb`, which should be included in `ApplicationController` as `Turbo::Redirection`:

```ruby
module Turbo
  module Redirection
    extend ActiveSupport::Concern

    def redirect_to(url = {}, options = {})
      turbo = options.delete(:turbo)

      super.tap do
        if turbo != false && request.xhr? && !request.get?
          visit_location_with_turbo(location, turbo)
        end
      end
    end

    private
      def visit_location_with_turbo(location, action)
        visit_options = {
          action: action.to_s == "advance" ? action : "replace"
        }

        script = []
        script << "Turbo.clearCache()"
        script << "Turbo.visit(#{location.to_json}, #{visit_options.to_json})"

        self.status = 200
        self.response_body = script.join("\n")
        response.content_type = "text/javascript"
        response.headers["X-Xhr-Redirect"] = location
      end
  end
end
```

Then you need `test/helpers/turbo_assertions_helper.rb`, which should be included in `ActionDispatch::IntegrationTest`:

```ruby
module TurboAssertionsHelper
  TURBO_VISIT = /Turbo\.visit\("([^"]+)", {"action":"([^"]+)"}\)/

  def assert_redirected_to(options = {}, message = nil)
    if turbo_request?
      assert_turbo_visited(options, message)
    else
      super
    end
  end

  def assert_turbo_visited(options = {}, message = nil)
    assert_response(:ok, message)
    assert_equal("text/javascript", response.try(:media_type) || response.content_type)

    visit_location, _ = turbo_visit_location_and_action

    redirect_is       = normalize_argument_to_redirection(visit_location)
    redirect_expected = normalize_argument_to_redirection(options)

    message ||= "Expected response to be a Turbo visit to <#{redirect_expected}> but was a visit to <#{redirect_is}>"
    assert_operator redirect_expected, :===, redirect_is, message
  end

  # Rough heuristic to detect whether this was a Turbolinks request:
  # non-GET request with a text/javascript response.
  #
  # Technically we'd check that Turbolinks-Referrer request header is
  # also set, but that'd require us to pass the header from post/patch/etc
  # test methods by overriding them to provide a `turbo:` option.
  #
  # We can't check `request.xhr?` here, either, since the X-Requested-With
  # header is cleared after controller action processing to prevent it
  # from leaking into subsequent requests.
  def turbo_request?
    !request.get? && (response.try(:media_type) || response.content_type) == "text/javascript"
  end

  def turbo_visit_location_and_action
    if response.body =~ TURBO_VISIT
      [ $1, $2 ]
    end
  end
end
```

## 3. Replace the inclusion of turbolinks in your pack file with turbo
You probably have something like `require("turbolinks").start()`, which needs to become `import "@hotwired/turbo-rails"`. You don't need to start anything. Turbo is automatically started (and assigned to `window.Turbo`) upon importation.


## 4. Replace all turbolinks namespaces with turbo
If you have anything like `document.addEventListener("turbolinks:before-cache" ...)`, you'll need to replace those event names with the turbo-namespaced version, like `turbo:before-cache`. Same goes for calls to `Turbolinks.visit`, which you'll need to replace them with calls to `Turbo.visit`. And DOM element attributes, like `data-turbolinks-action`, which need to become `data-turbo-action` (remember all those `data: { turbolinks: false }` -> `data: { turbo: false }` too).


## 5. Optional: Provide backwards compatible shims for mobile adapters
If you've built native apps using the Turbolinks mobile adapters, and you need to transition those as well, you might need a shim to translate calls to Turbolinks to Turbo. For Basecamp, this is what we needed:

```js
// Compatibility shim for mobile apps
window.Turbolinks = {
  visit: Turbo.visit,

  controller: {
    isDeprecatedAdapter(adapter) {
      return typeof adapter.visitProposedToLocation !== "function"
    },

    startVisitToLocationWithAction(location, action, restorationIdentifier) {
      window.Turbo.navigator.startVisit(location, restorationIdentifier, { action })
    },

    get restorationIdentifier() {
      return window.Turbo.navigator.restorationIdentifier
    },

    get adapter() {
      return window.Turbo.navigator.adapter
    },

    set adapter(adapter) {
      if (this.isDeprecatedAdapter(adapter)) {
        // Old mobile adapters do not support visitProposedToLocation()
        adapter.visitProposedToLocation = function(location, options) {
          adapter.visitProposedToLocationWithAction(location, options.action)
        }

        // Old mobile adapters use visit.location.absoluteURL, which is not available
        // because Turbo dropped the Location class in favor of the DOM URL API
        const adapterVisitStarted = adapter.visitStarted
        adapter.visitStarted = function(visit) {
          Object.defineProperties(visit.location, {
            absoluteURL: {
              configurable: true,
              get() { return this.toString() }
            }
          })

          adapter.currentVisit = visit
          adapterVisitStarted(visit)
        }
      }

      window.Turbo.registerAdapter(adapter)
    }
  }
}

// Required by the desktop app
document.addEventListener("turbo:load", function() {
  const event = new CustomEvent("turbolinks:load", { bubbles: true })
  document.documentElement.dispatchEvent(event)
})
```
