module Turbo::IncludesHelper
  def turbo_include_tags
    javascript_include_tag("turbo", type: "module")
  end
end
