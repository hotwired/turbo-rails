require "turbo/engine"

module Turbo
  extend ActiveSupport::Autoload

  mattr_accessor :draw_routes, default: true

  class << self
    attr_writer :signed_stream_verifier_key, :localized_broadcasts

    def localized_broadcasts
      @localized_broadcasts ||= false
    end

    def with_localized_broadcasts(value = true)
      old_value = @localized_broadcasts
      @localized_broadcasts = value
      yield
    ensure
      @localized_broadcasts = old_value
    end

    def signed_stream_verifier
      @signed_stream_verifier ||= ActiveSupport::MessageVerifier.new(signed_stream_verifier_key, digest: "SHA256", serializer: JSON)
    end

    def signed_stream_verifier_key
      @signed_stream_verifier_key or raise ArgumentError, "Turbo requires a signed_stream_verifier_key"
    end
  end
end
