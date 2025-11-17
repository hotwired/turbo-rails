# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

ActionCable.server.config.logger = Logger.new(STDOUT) if ENV["VERBOSE"]

module ActionViewTestCaseExtensions
  delegate :render, to: ApplicationController
end

class ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    Turbo.current_request_id = nil
  end

  def with_production_debouncer(&block)
    old_class = Turbo::ThreadDebouncer.debouncer_class
    Turbo::ThreadDebouncer.debouncer_class = Turbo::Debouncer
    yield
  ensure
    Turbo::ThreadDebouncer.debouncer_class = old_class

    # Wait for all debounced tasks to complete and clean up
    Thread.current.keys.each do |key|
      if key.to_s.start_with?("turbo-")
        Thread.current[key]&.wait
        Thread.current[key] = nil
      end
    end
  end
end

class ActionDispatch::IntegrationTest
  include ActionViewTestCaseExtensions
end

class ActionCable::Channel::TestCase
  include ActionViewTestCaseExtensions
end
