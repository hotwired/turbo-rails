module Turbo::IncludesHelper
  def turbo_include_tags
    javascript_include_tag("turbo", type: "module") # + javascript_include_tag("turbo/streams_channel", type: "module")
  end
end
