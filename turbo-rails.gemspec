require_relative "lib/turbo/version"

Gem::Specification.new do |s|
  s.name     = "turbo-rails"
  s.version  = Turbo::VERSION
  s.authors  = [ "Sam Stephenson", "Javan Mahkmali", "David Heinemeier Hansson" ]
  s.email    = "david@loudthinking.com"
  s.summary  = "The speed of a single-page web application without having to write any JavaScript."
  s.homepage = "https://github.com/hotwired/turbo-rails"
  s.license  = "MIT"

  s.required_ruby_version = ">= 2.6.0"

  s.add_dependency "actionpack", ">= 6.0.0"
  s.add_dependency "actionview", ">= 6.0.0"
  s.add_dependency "activejob", ">= 6.0.0"
  s.add_dependency "activesupport", ">= 6.0.0"
  s.add_dependency "bundler", ">= 1.15.0"
  s.add_dependency "railties", ">= 6.0.0"

  s.add_development_dependency "activemodel", ">= 6.0.0"
  s.add_development_dependency "activerecord", ">= 6.0.0"
  s.add_development_dependency "activestorage", ">= 6.0.0"
  s.add_development_dependency "sprockets-rails", ">= 2.0.0"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
