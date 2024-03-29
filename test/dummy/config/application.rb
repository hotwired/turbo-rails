require_relative 'boot'

require "action_controller/railtie"
require "action_cable/engine"
require "active_job/railtie"
require "active_model/railtie"
require "active_record/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults (
      case (rails_version = ENV["RAILS_VERSION"])
      when "main", nil then 7.1
      else rails_version.to_f
      end
    )

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
