require "action_controller/railtie"
require "action_view/railtie"
require "webpacker"
require "turbo-rails"

module TestDummyApp
  class Application < Rails::Application
    config.secret_key_base = "abcdef"
    config.eager_load = true
    config.load_defaults 6.0 if Rails::VERSION::MAJOR >= 6
  end
end
