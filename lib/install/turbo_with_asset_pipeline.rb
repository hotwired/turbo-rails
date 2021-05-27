APPLICATION_LAYOUT_PATH = Rails.root.join("app/views/layouts/application.html.erb")
IMPORTMAP_PATH = Rails.root.join("app/assets/javascripts/importmap.json.erb")
CABLE_CONFIG_PATH = Rails.root.join("config/cable.yml")

if APPLICATION_LAYOUT_PATH.exist?
  say "Yield head in application layout for cache helper"
  insert_into_file APPLICATION_LAYOUT_PATH.to_s, "\n    <%= yield :head %>", before: /\s*<\/head>/

  if APPLICATION_LAYOUT_PATH.read =~ /stimulus/
    say "Add Turbo include tags in application layout"
    insert_into_file APPLICATION_LAYOUT_PATH.to_s, %(\n    <%= javascript_include_tag "turbo", type: "module-shim" %>), after: /<%= stimulus_include_tags %>/

    if IMPORTMAP_PATH.exist?
      say "Add Turbo to importmap"
      insert_into_file IMPORTMAP_PATH, %(    "turbo": "<%= asset_path "turbo" %>",\n), after: /  "imports": {\s*\n/
    end
  else
    say "Add Turbo include tags in application layout"
    insert_into_file APPLICATION_LAYOUT_PATH.to_s, %(\n    <%= javascript_include_tag "turbo", type: "module" %>), before: /\s*<\/head>/
  end
else
  say "Default application.html.erb is missing!", :red
  say %(        Add <%= javascript_include_tag("turbo", type: "module-shim") %> and <%= yield :head %> within the <head> tag after Stimulus includes in your custom layout.)
end

if CABLE_CONFIG_PATH.exist?
  say "Enable redis in bundle"
  uncomment_lines "Gemfile", %(gem 'redis')

  say "Switch development cable to use redis"
  gsub_file CABLE_CONFIG_PATH.to_s, /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
else
  say 'ActionCable config file (config/cable.yml) is missing. Uncomment "gem \'redis\'" in your Gemfile and create config/cable.yml to use the Turbo Streams broadcast feature.'
end

say "Turbo successfully installed ⚡️", :green
