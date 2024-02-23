require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem "rails"
  gem "propshaft"
  gem "puma"
  gem "sqlite3", "~> 1.4"
  gem "turbo-rails"

  gem "capybara"
  gem "cuprite", require: "capybara/cuprite"
end

ENV["DATABASE_URL"] = "sqlite3::memory:"
ENV["RAILS_ENV"] = "test"

require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_view/railtie"
# require "action_mailer/railtie"
# require "active_job/railtie"
require "action_cable/engine"
# require "action_mailbox/engine"
# require "action_text/engine"
require "rails/test_unit/railtie"

class App < Rails::Application
  config.load_defaults Rails::VERSION::STRING.to_f

  config.root = __dir__
  config.hosts << "example.org"
  config.eager_load = false
  config.session_store :cookie_store, key: "cookie_store_key"
  config.secret_key_base = "secret_key_base"
  config.consider_all_requests_local = true
  config.action_cable.cable = {"adapter" => "async"}
  config.turbo.draw_routes = false

  Rails.logger = config.logger = Logger.new($stdout)

  routes.append do
    root to: "application#index"
  end
end

Rails.application.initialize!

ActiveRecord::Schema.define do
  create_table :messages, force: true do |t|
    t.text :body, null: false
  end
end

class Message < ActiveRecord::Base
end

class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers

  class_attribute :template, default: DATA.read

  def index
    render inline: template, formats: :html
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, using: :chrome, screen_size: [1400, 1400], options: {js_errors: true}
end

Capybara.configure do |config|
  config.server = :puma, {Silent: true}
  config.default_normalize_ws = true
end

require "rails/test_help"

class TurboSystemTest < ApplicationSystemTestCase
  test "reproduces bug" do
    visit root_path

    assert_text "Loaded with Turbo"
  end
end

__END__
<!DOCTYPE html>
<html>
  <head>
    <%= csrf_meta_tags %>

    <script type="importmap">
      {
        "imports": {
          "@hotwired/turbo-rails": "<%= asset_path("turbo.js") %>"
        }
      }
    </script>

    <script type="module">
      import "@hotwired/turbo-rails"

      addEventListener("turbo:load", () => document.body.innerHTML = "Loaded with Turbo")
    </script>
  </head>

  <body>Loaded without Turbo</body>
</html>
