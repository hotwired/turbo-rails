require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, using: :chrome, screen_size: [1400, 1400], options: { js_errors: true }
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
end
