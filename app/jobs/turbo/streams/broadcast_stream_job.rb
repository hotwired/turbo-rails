class Turbo::Streams::BroadcastStreamJob < ActiveJob::Base
  discard_on ActiveJob::DeserializationError

  def perform(stream, content:)
    Turbo::StreamsChannel.broadcast_stream_to(stream, content: content)
  end

  def self.perform_later(stream, content:)
    super(stream, content: content.to_str)
  end
end
