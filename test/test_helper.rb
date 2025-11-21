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

    Thread.current.keys.each do |key|
      Thread.current[key] = nil if key.to_s.start_with?("turbo-")
    end
  end

  def with_production_debouncer(&block)
    Turbo::ThreadDebouncer.with(debouncer_class: Turbo::Debouncer, &block)
  ensure
    # Wait for any scheduled tasks to complete and verify cleanup
    sleep Turbo::Debouncer::DEFAULT_DELAY + 0.2

    turbo_keys = Thread.current.keys.select { |k| k.to_s.start_with?("turbo-") }
    assert_empty turbo_keys, "Thread-locals were not cleaned up" if RUBY_VERSION >= "3.3"
  end
end

class ActionDispatch::IntegrationTest
  include ActionViewTestCaseExtensions
end

class ActionCable::Channel::TestCase
  include ActionViewTestCaseExtensions
end
