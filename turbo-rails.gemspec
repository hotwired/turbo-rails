Gem::Specification.new do |s|
  s.name     = "turbo-rails"
  s.version  = "0.1"
  s.authors  = [ "Sam Stephenson", "Javan Mahkmali", "David Heinemeier Hansson" ]
  s.email    = "david@loudthinking.com"
  s.summary  = "The speed of a single-page web application without having to write any JavaScript"
  s.homepage = "https://github.com/basecamp/turbo"
  s.license  = "MIT"

  s.required_ruby_version = ">= 2.7.0"

  s.add_dependency "rails", ">= 6.0.0"

  s.add_development_dependency "bundler", "~> 2.1"

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
