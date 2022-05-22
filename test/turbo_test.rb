ENV["RAILS_ENV"] = "test"

require "minitest/autorun"
require "rails"
require "rails/test_help"
require "byebug"

require_relative "dummy/config/environment"

ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActionCable.server.config.logger = Logger.new(STDOUT) if ENV["VERBOSE"]

module ActionViewTestCaseExtensions
  def render(*arguments, **options, &block)
    ApplicationController.renderer.render(*arguments, **options, &block)
  end
end

class ActiveSupport::TestCase
  include ActiveJob::TestHelper
end

class ActionDispatch::IntegrationTest
  include ActionViewTestCaseExtensions
end

class ActionCable::Channel::TestCase
  include ActionViewTestCaseExtensions
end
