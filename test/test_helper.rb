# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

ActionCable.server.config.logger = Logger.new(STDOUT) if ENV["VERBOSE"]

module ActionViewTestCaseExtensions
  def render(...)
    ApplicationController.renderer.render(...)
  end
end

class ActiveSupport::TestCase
  include ActiveJob::TestHelper

  parallelize workers: :number_of_processors
end

class ActionDispatch::IntegrationTest
  include ActionViewTestCaseExtensions
end

class ActionCable::Channel::TestCase
  include ActionViewTestCaseExtensions
end
