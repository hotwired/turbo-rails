class Turbo::Streams::BroadcastStreamJob < Turbo::Streams::BaseJob
  def perform(stream, content:)
    Turbo::StreamsChannel.broadcast_stream_to(stream, content: content)
  end
end
