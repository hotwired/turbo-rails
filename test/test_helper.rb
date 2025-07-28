# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

ActionCable.server.config.logger = Logger.new(STDOUT) if ENV["VERBOSE"]

module ActionViewTestCaseExtensions
  delegate :render, to: ApplicationController
end

ActiveSupport.on_load :active_support_test_case do
  include ActiveJob::TestHelper

  setup do
    Turbo.current_request_id = nil
  end
end

ActiveSupport.on_load :action_dispatch_integration_test do
  include ActionViewTestCaseExtensions
end

ActiveSupport.on_load :action_cable_channel do
  ActionCable::Channel::TestCase.include ActionViewTestCaseExtensions
end
