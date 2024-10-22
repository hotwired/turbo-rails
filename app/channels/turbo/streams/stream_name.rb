# Stream names are how we identify which updates should go to which users. All streams run over the same
# <tt>Turbo::StreamsChannel</tt>, but each with their own subscription. Since stream names are exposed directly to the user
# via the HTML stream subscription tags, we need to ensure that the name isn't tampered with, so the names are signed
# upon generation and verified upon receipt. All verification happens through the <tt>Turbo.signed_stream_verifier</tt>.
#
# Signed stream names do not expire. To prevent unauthorized access through leaked stream names it is recommended to
# authorize subscriptions and/or authenticate connections based on your needs.
module Turbo::Streams::StreamName
  STREAMABLE_SEPARATOR = ":"

  # Used by <tt>Turbo::StreamsChannel</tt> to verify a signed stream name.
  def verified_stream_name(signed_stream_name)
    Turbo.signed_stream_verifier.verified signed_stream_name
  end

  # Used by <tt>Turbo::StreamsHelper#turbo_stream_from(*streamables)</tt> to generate a signed stream name.
  def signed_stream_name(streamables)
    Turbo.signed_stream_verifier.generate stream_name_from(streamables)
  end

  module ClassMethods
    # Can be used by <tt>config.turbo.base_stream_channel_class</tt> or a custom channel to obtain signed stream name
    # from <tt>params</tt>.
    def verified_stream_name_from_params
      self.class.verified_stream_name(params[:signed_stream_name])
    end

    # Can be used by <tt>config.turbo.base_stream_channel_class</tt> or a custom channel to obtain signed stream name
    # parts from <tt>params</tt>.
    def verified_stream_name_parts_from_params
      verified_stream_name_from_params.split STREAMABLE_SEPARATOR
    end
  end

  private
    def stream_name_from(streamables)
      if streamables.is_a?(Array)
        streamables.map  { |streamable| stream_name_from(streamable) }.join(STREAMABLE_SEPARATOR)
      else
        streamables.then { |streamable| streamable.try(:to_gid_param) || streamable.to_param }
      end
    end
end
