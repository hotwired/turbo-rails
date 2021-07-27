app_layout_path = Rails.root.join("app/views/layouts/application.html.erb")
importmap_path = Rails.root.join("app/assets/javascripts/importmap.json.erb")

def engine_root
  defined?(ENGINE_ROOT) && Pathname.new(ENGINE_ROOT)
end

if engine_root
  engine_name = File.basename(ENGINE_ROOT)
  app_layout_path = engine_root.join("app/views/layouts/#{engine_name}/application.html.erb")
  importmap_path = engine_root.join("app/assets/javascripts/#{engine_name}/importmap.json.erb")
end

if app_layout_path.exist?
  say "Yield head in application layout for cache helper"
  insert_into_file app_layout_path.to_s, "\n    <%= yield :head %>", before: /\s*<\/head>/

  if app_layout_path.read =~ /stimulus/
    say "Add Turbo include tags in application layout"
    insert_into_file app_layout_path.to_s, %(\n    <%= javascript_include_tag "turbo", type: "module-shim" %>), after: /<%= stimulus_include_tags %>/

    if importmap_path.exist?
      say "Add Turbo to importmap"
      insert_into_file importmap_path, %(    "turbo": "<%= asset_path "turbo" %>",\n), after: /  "imports": {\s*\n/
    end
  else
    say "Add Turbo include tags in application layout"
    insert_into_file app_layout_path.to_s, %(\n    <%= javascript_include_tag "turbo", type: "module" %>), before: /\s*<\/head>/
  end
else
  say "Default application.html.erb is missing!", :red
  say %(        Add <%= javascript_include_tag("turbo", type: "module-shim") %> and <%= yield :head %> within the <head> tag after Stimulus includes in your custom layout.)
end

if engine_root
  say "Appending redis to Gemfile"
  append_to_file engine_root.join("Gemfile"), %(gem 'redis')

  say "Create config/cable.yml to use redis"
  create_file engine_root.join("config/cable.yml") do
    <<~FILE
      development:
        adapter: redis
        url: redis://localhost:6379/1

      test:
        adapter: test

      production:
        adapter: redis
        url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
        channel_prefix: dummy_production
    FILE
  end
else
  say "Enable redis in bundle"
  uncomment_lines Rails.root.join("Gemfile"), %(gem 'redis')

  say "Switch development cable to use redis"
  gsub_file Rails.root.join("config/cable.yml"), /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
end

say "Turbo successfully installed ⚡️", :green
