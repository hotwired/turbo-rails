module Turbo::IncludesHelper
  def turbo_include_tag
    javascript_include_tag "turbo", type: "module"
  end
end
