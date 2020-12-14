module Turbo::StreamsHelper
  # Returns a new <tt>Turbo::Streams::TagBuilder</tt> object that accepts update commands and renders them them as
  # the template tags needed to send across the wire. This object is automatically yielded to turbo_update.erb templates.
  def turbo_update
    Turbo::Streams::TagBuilder.new(self)
  end

  # Used in the view to create a subscription to a stream identified by the <tt>streamables</tt> running over the
  # <tt>Turbo::StreamsChannel</tt>. The stream name being generated is safe to embed in the HTML sent to a user without
  # fear of tampering, as it is signed using <tt>Turbo.signed_stream_verifier</tt>. Example:
  #
  #   # app/views/entries/index.html.erb
  #   <%= turbo_stream_from Current.account, :entries %>
  #   <div id="entries">New entries will be appended to this container</div>
  #
  # The example above will process all page updates sent to a stream name like <tt>account:5:entries</tt>
  # (when Current.account.id = 5). Updates to this stream can be sent like
  # <tt>entry.broadcast_append_to entry.account, :entries, contrainer: "entries"</tt>.
  def turbo_stream_from(*streamables)
    tag.meta data: { controller: "turbo-streams", turbo_streams_channel_value: {
      channel: "Turbo::StreamsChannel", signed_stream_name: Turbo::StreamsChannel.signed_stream_name(streamables)
    } }
  end
end
