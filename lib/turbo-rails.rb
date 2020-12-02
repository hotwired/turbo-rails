require "turbo/engine"

module Turbo
  extend ActiveSupport::Autoload

  class << self
    attr_writer :signed_stream_verifier_key

    def signed_stream_verifier
      @signed_stream_verifier ||= ActiveSupport::MessageVerifier.new(signed_stream_verifier_key, digest: "SHA256", serializer: JSON)
    end

    def signed_stream_verifier_key
      @signed_stream_verifier_key or raise ArgumentError, "Turbo requires a signed_stream_verifier_key"
    end
  end
end
