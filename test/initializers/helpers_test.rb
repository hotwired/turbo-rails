require "test_helper"

class Turbo::HelpersInInitializersTest < ActionDispatch::IntegrationTest
  test "AC::Base has the helpers in place when initializers run" do
    assert_includes $dummy_ac_base_ancestors_in_initializers, Turbo::Streams::TurboStreamsTagBuilder
    assert_includes $dummy_ac_base_helpers_in_initializers, Turbo::StreamsHelper
  end
end
