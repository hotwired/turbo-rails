require "turbo_test"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
  config.match = :prefer_exact
end
