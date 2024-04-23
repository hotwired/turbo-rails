require "test_helper"

class Turbo::DebouncerTest < ActiveSupport::TestCase
  test "executes just the last call and ignores all previous ones" do
    debouncer = Turbo::Debouncer.new(delay: 0.2)
    calls = []

    %w[a b c d e f g].each do |letter|
      debouncer.throttle { calls << letter}
    end

    assert calls.empty?

    debouncer.wait

    assert_equal 1, calls.size
    assert_equal "g", calls.first

    debouncer.throttle { calls << "h"}
    debouncer.wait

    assert_equal 2, calls.size
    assert_equal "h", calls.last
  end

  test "calls the cleanup block after it executes" do
    calls = []
    debouncer = Turbo::Debouncer.new(delay: 0.2, cleanup: -> { calls << :cleanup })

    debouncer.throttle { calls << :first}

    assert calls.empty?

    debouncer.wait

    assert_equal [:first, :cleanup], calls
  end
end
