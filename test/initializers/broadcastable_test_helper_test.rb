require "test_helper"

class Turbo::BroadcastableTestHelperInstallationTest < ActiveSupport::TestCase
  test "is installed when ActiveSupport::TestCase loads, before the suite runs" do
    check = <<~RUBY
      require "active_support/test_case"

      if ActiveSupport::TestCase.include?(Turbo::Broadcastable::TestHelper)
        puts "installed when ActiveSupport::TestCase loaded"
      else
        abort "Turbo::Broadcastable::TestHelper is not installed when ActiveSupport::TestCase loads"
      end
    RUBY

    environment = {
      "RAILS_ENV" => "test",
      "BUNDLE_GEMFILE" => File.expand_path("../../Gemfile", __dir__)
    }

    output, = capture_subprocess_io do
      system(environment, RbConfig.ruby, File.expand_path("../dummy/bin/rails", __dir__), "runner", check, exception: true)
    end

    assert_includes output, "installed when ActiveSupport::TestCase loaded"
  end
end
