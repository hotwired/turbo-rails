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

# For edge Rails, don't use Rack 3 yet.
# Remove this when https://github.com/rails/rails/pull/46594 has merged.
gem 'rack', '< 3'

group :development, :test do
  gem 'importmap-rails'
end

group :test do
  gem 'capybara'
  gem 'rexml'
  gem 'cuprite', '~> 0.9', require: 'capybara/cuprite'
  gem 'sqlite3'
end
