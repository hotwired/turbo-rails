require "test_helper"
require "action_cable"

class Turbo::CurrentRequestIdTest < ActiveSupport::TestCase
  test "sets the current request id for a block of code" do
    assert_nil Turbo.current_request_id

    result = Turbo.with_request_id("123") do
      assert_equal "123", Turbo.current_request_id
      :the_result
    end

    assert_equal :the_result, result
    assert_nil Turbo.current_request_id
  end

  test "raised errors will raise and clear the current request id" do
    assert_nil Turbo.current_request_id

    assert_raise "Some error" do
      Turbo.with_request_id("123") do
        raise "Some error"
      end
    end

    assert_nil Turbo.current_request_id
  end
end
