ENV["RAILS_ENV"] = "test"

require "minitest/autorun"
require "rails"
require "rails/test_help"
require "byebug"

require_relative "dummy/config/environment"

ActionCable.server.config.logger = Logger.new(STDOUT) if ENV["VERBOSE"]

class ActiveSupport::TestCase
  include ActiveJob::TestHelper
end
