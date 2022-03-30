source 'https://rubygems.org'

gemspec

rails_version = ENV.fetch("RAILS_VERSION", "6.1")

if rails_version == "main"
  rails_constraint = { github: "rails/rails" }
else
  rails_constraint = "~> #{rails_version}.0"
end

gem "rails", rails_constraint
gem "sprockets-rails"

gem 'rake'
gem 'byebug'
gem 'puma'

group :development, :test do
  gem 'importmap-rails'
end

group :test do
  gem 'capybara'
  gem 'rexml'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'sqlite3'
end
