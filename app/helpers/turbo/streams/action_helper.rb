module Turbo::Streams::ActionHelper
  # Creates a `turbo-stream` tag according to the passed parameters. Examples:
  #
  #   turbo_stream_action_tag "remove", target: "message_1"
  #   # => <turbo-stream action="remove" target="message_1"></turbo-stream>
  #
  #   turbo_stream_action_tag "replace", target: "message_1", template: %(<div id="message_1">Hello!</div>)
  #   # => <turbo-stream action="replace" target="message_1"><template><div id="message_1">Hello!</div></template></turbo-stream>
  def turbo_stream_action_tag(action, target:, template: nil, replace_if_present: nil)
    target   = convert_to_turbo_stream_dom_id(target)
    template = action.to_sym == :remove ? "" : "<template>#{template}</template>"

    if replace_if_present
      replacement = convert_to_turbo_stream_dom_id(replace_if_present)
      %(<turbo-stream action="remove" target="#{replacement}"></turbo-stream>
        <turbo-stream action="#{action}" target="#{target}">#{template}</turbo-stream>).html_safe
    else
      %(<turbo-stream action="#{action}" target="#{target}">#{template}</turbo-stream>).html_safe
    end
  end

  private
    def convert_to_turbo_stream_dom_id(target)
      target.respond_to?(:to_key) ? ActionView::RecordIdentifier.dom_id(target) : target
    end
end
