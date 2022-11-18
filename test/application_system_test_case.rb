require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def assert_no_javascript_errors
    before = page.driver.browser.logs.get(:browser)

    yield

    logs = page.driver.browser.logs.get(:browser) - before
    errors = logs.select { |log| /severe/i.match?(log.level) }
    error_messages = errors.map(&:message)

    assert_equal [], error_messages
  end
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
end
