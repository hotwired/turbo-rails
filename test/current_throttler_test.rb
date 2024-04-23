require "test_helper"
require "action_cable"

class Turbo::CurrentThrottlerTest < ActiveSupport::TestCase
  test "sets the current throttler for a block of code" do
    assert_equal :debouncer, Turbo.current_throttler

    result = Turbo.with_throttler(:rate_limiter) do
      assert_equal :rate_limiter, Turbo.current_throttler
      :the_result
    end

    assert_equal :the_result, result
    assert_equal :debouncer, Turbo.current_throttler
  end

  test "raised errors will raise and clear the current request id" do
    assert_equal :debouncer, Turbo.current_throttler

    assert_raise "Some error" do
      Turbo.with_throttler(:rate_limiter) do
        raise "Some error"
      end
    end

    assert_equal :debouncer, Turbo.current_throttler
  end
end
