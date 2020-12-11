module Turbo::StreamHelper
  # Returns a new <tt>Turbo::Updates::TagBuilder</tt> object that accepts update commands and renders them them as
  # the template tags needed to send across the wire. This object is automatically yielded to turbo_stream.erb templates.
  def turbo_stream
    Turbo::Stream::TagBuilder.new(self)
  end

  # Used in the view to create a subscription to a stream identified by the <tt>streamables</tt> running over the
  # <tt>Turbo::UpdatesChannel</tt>. The stream name being generated is safe to embed in the HTML sent to a user without
  # fear of tampering, as it is signed using <tt>Turbo.signed_stream_verifier</tt>. Example:
  #
  #   # app/views/entries/index.html.erb
  #   <%= subscribe_to_turbo_stream_from_signed Current.account, :entries %>
  #   <div id="entries">New entries will be appended to this container</div>
  #
  # The example above will process all page updates sent to a stream name like <tt>account:5:entries</tt>
  # (when Current.account.id = 5). Updates to this stream can be sent like
  # <tt>entry.broadcast_append_to entry.account, :entries, contrainer: "entries"</tt>.
  def subscribe_to_turbo_stream_from_signed(*streamables)
    tag.meta data: { controller: "turbo-updates", turbo_stream_channel_value: {
      channel: "Turbo::StreamChannel", signed_stream_name: Turbo::StreamChannel.signed_stream_name(streamables)
    } }
  end
end
