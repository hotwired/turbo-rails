module Turbo::IncludesHelper
  def turbo_include_tags
    javascript_include_tag("turbo", type: "module") + javascript_include_tag("turbo/streams", type: "module", "data-action-cable-src": asset_path("turbo/action_cable"))
  end
end
