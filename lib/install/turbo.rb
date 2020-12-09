say "Add Turbo include tags in application layout"
insert_into_file Rails.root.join("app/views/layouts/application.html.erb").to_s, "\n    <%= turbo_include_tags %>", before: /\s*<\/head>/
