module Turbo::Streams::ActionHelper
  def turbo_stream_action_tag(action, target:, content: nil)
    target   = convert_to_turbo_stream_dom_id(target)
    template = content ? "<template>#{content}</template>" : ""

    %(<turbo-stream action="#{action}" target="#{target}">#{template}</turbo-stream>).html_safe
  end

  private
    def convert_to_turbo_stream_dom_id(element_or_dom_id)
      if element_or_dom_id.respond_to?(:to_key)
        element = element_or_dom_id
        ActionView::RecordIdentifier.dom_id(element)
      else
        dom_id = element_or_dom_id
      end
    end
end
