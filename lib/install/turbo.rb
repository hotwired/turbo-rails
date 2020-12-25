APPLICATION_LAYOUT_PATH = Rails.root.join("app/views/layouts/application.html.erb")

if APPLICATION_LAYOUT_PATH.exist?
  say "Yield head in application layout for cache helper"
  insert_into_file APPLICATION_LAYOUT_PATH.to_s, "\n    <%= yield :head %>", before: /\s*<\/head>/

  say "Add Turbo include tags in application layout"
  insert_into_file APPLICATION_LAYOUT_PATH.to_s, "\n    <%= turbo_include_tags %>", before: /\s*<\/head>/
else
  say "Default application.html.erb is missing!", :red
  say "        Add <%= turbo_include_tags %> and <%= yield :head %> within the <head> tag in your custom layout."
end

say "Enable redis in bundle"
uncomment_lines "Gemfile", %(gem 'redis')

say "Switch development cable to use redis"
gsub_file "config/cable.yml", /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
