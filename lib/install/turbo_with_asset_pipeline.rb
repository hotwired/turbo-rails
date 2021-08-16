APP_JS_PATH = Rails.root.join("app/javascript/application.js")
CABLE_CONFIG_PATH = Rails.root.join("config/cable.yml")
IMPORTMAP_PATH = Rails.root.join("config/initializers/importmap.rb")

if APP_JS_PATH.exist?
  say "Import turbo-rails in existing app/javascript/application.js"
  append_to_file APP_JS_PATH, %(import "@hotwired/turbo-rails"\n)
else
  say <<~INSTRUCTIONS, :red
    You must import @hotwire/turbo-rails in your application.js.
  INSTRUCTIONS
end

if IMPORTMAP_PATH.exist?
  say "Pin @hotwired/turbo-rails in config/initializers/importmap.rb"
  insert_into_file \
    IMPORTMAP_PATH.to_s, 
    %(  pin "@hotwired/turbo-rails", to: "turbo.js"\n\n),
    after: "Rails.application.config.importmap.draw do\n"
else
  say <<~INSTRUCTIONS, :red
    You must add @hotwire/turbo-rails to your importmap to reference them via ESM.
  INSTRUCTIONS
end

if CABLE_CONFIG_PATH.exist?
  say "Enable redis in bundle"
  uncomment_lines "Gemfile", %(gem 'redis')

  say "Switch development cable to use redis"
  gsub_file CABLE_CONFIG_PATH.to_s, /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
else
  say 'ActionCable config file (config/cable.yml) is missing. Uncomment "gem \'redis\'" in your Gemfile and create config/cable.yml to use the Turbo Streams broadcast feature.'
end
