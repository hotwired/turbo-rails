module Turbo::IncludesHelper
  def turbo_include_tag
    javascript_include_tag "turbo", type: "module"
    javascript_include_tag "turbo/updates_channel", type: "module"
  end
end
