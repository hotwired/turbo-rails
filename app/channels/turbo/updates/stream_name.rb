# Stream names are how we identify which updates should go to which users. All streams run over the same
# <tt>Turbo::UpdatesChannel</tt>, but each with their own subscription. Since stream names are exposed directly to the user
# via the HTML stream subscription tags, we need to ensure that the name isn't tampered with, so the names are signed
# upon generation and verified upon receipt. All verification happens through the <tt>Turbo.signed_stream_verifier</tt>.
module Turbo::Updates::StreamName
  # Used by <tt>Turbo::UpdatesChannel</tt> to verify a signed stream name.
  def verified_stream_name(signed_stream_name)
    Turbo.signed_stream_verifier.verified signed_stream_name
  end

  # Used by <tt>Turbo::UpdatesHelper#subscribe_to_turbo_updates_from_signed(*streamables)</tt> to generate a signed stream name.
  def signed_stream_name(streamables)
    Turbo.signed_stream_verifier.generate stream_name_from(streamables)
  end

  private
    def stream_name_from(streamables)
      if streamables.is_a?(Array)
        streamables.map  { |streamable| stream_name_from(streamable) }.join(":")
      else
        streamables.then { |streamable| streamable.try(:to_gid_param) || streamable.to_param }
      end
    end
end
