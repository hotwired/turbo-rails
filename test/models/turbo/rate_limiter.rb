require "test_helper"

class Turbo::RateLimiterTest < ActiveSupport::TestCase
  test "executes just the first fex call and ignore all following ones" do
    debouncer = Turbo::RateLimiter.new(max: 1, interval: 0.2)
    calls = []

    %w[a b c d e f g].each do |letter|
      debouncer.throttle { calls << letter}
    end

    assert_equal 1, calls.size
    assert_equal "a", calls.first

    debouncer.wait

    assert_equal 1, calls.size
    assert_equal "a", calls.first

    %w[h i j k l].each do |letter|
      debouncer.throttle { calls << letter}
    end

    assert_equal 2, calls.size
    assert_equal "h", calls.last

    debouncer.wait

    assert_equal 2, calls.size
    assert_equal "h", calls.last
  end

  test "calls the cleanup block after it executes" do
    calls = []
    debouncer = Turbo::RateLimiter.new(
      max: 2, 
      interval: 0.2,
      cleanup: -> { calls << :cleanup }
    )

    debouncer.throttle { calls << :first}
    debouncer.throttle { calls << :second}
    debouncer.throttle { calls << :third}
    debouncer.throttle { calls << :fourth}

    assert_equal [:first, :second], calls

    debouncer.wait

    assert_equal [:first, :second, :cleanup], calls
  end
end
