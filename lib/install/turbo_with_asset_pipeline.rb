APPLICATION_LAYOUT_PATH = Rails.root.join("app/views/layouts/application.html.erb")
IMPORTMAP_PATH = Rails.root.join("app/assets/javascripts/importmap.json.erb")

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

  if APPLICATION_LAYOUT_PATH.read =~ /stimulus/
    say %(        Add <%= javascript_include_tag("turbo", type: "module-shim") %> and <%= yield :head %> within the <head> tag after Stimulus includes in your custom layout.)
  else
    say %(        Add <%= javascript_include_tag("turbo", type: "module") %> and <%= yield :head %> within the <head> tag in your custom layout.)
  end
end

say "Enable redis in bundle"
uncomment_lines "Gemfile", %(gem 'redis')

say "Switch development cable to use redis"
gsub_file "config/cable.yml", /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"

say "Turbo successfully installed ⚡️", :green
