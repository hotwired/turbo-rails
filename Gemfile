source 'https://rubygems.org'

gemspec

rails_version = ENV.fetch("RAILS_VERSION", "7.2")

if rails_version == "main"
  rails_constraint = { github: "rails/rails" }
else
  rails_constraint = "~> #{rails_version}.0"
end

gem "rails", rails_constraint
gem "sprockets-rails"

gem 'rake'
gem 'byebug'

if RUBY_VERSION < "3"
  gem "rack", "< 3"
  gem "puma", "< 6"
else
  gem "rack"
  gem "puma"
end

group :development, :test do
  if rails_version == "6.1"
    gem "importmap-rails", "0.6.1"
  else
    gem "importmap-rails"
  end
end

group :test do
  gem 'capybara'
  gem 'rexml'
  gem 'cuprite', '~> 0.9', require: 'capybara/cuprite'
  gem 'sqlite3', '1.5'
end
