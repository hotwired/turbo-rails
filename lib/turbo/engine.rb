require "rails/engine"
require "turbo/test_assertions"

module Turbo
  class Engine < Rails::Engine
    isolate_namespace Turbo
    config.eager_load_namespaces << Turbo
    config.turbo = ActiveSupport::OrderedOptions.new
    config.autoload_once_paths = %W(
      #{root}/app/channels
      #{root}/app/controllers
      #{root}/app/controllers/concerns
      #{root}/app/helpers
      #{root}/app/models
      #{root}/app/models/concerns
      #{root}/app/jobs
    )

    initializer "turbo.assets" do
      if Rails.application.config.respond_to?(:assets)
        Rails.application.config.assets.precompile += %w( turbo )
      end
    end

    initializer "turbo.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        include Turbo::Streams::TurboStreamsTagBuilder, Turbo::Frames::FrameRequest, Turbo::Native::Navigation
        helper Turbo::Engine.helpers
      end
    end

    initializer "turbo.broadcastable" do
      ActiveSupport.on_load(:active_record) do
        include Turbo::Broadcastable
      end
    end

    initializer "turbo.mimetype" do
      Mime::Type.register "text/vnd.turbo-stream.html", :turbo_stream
    end

    initializer "turbo.renderer" do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Renderers.add :turbo_stream do |turbo_streams_html, options|
          self.content_type = Mime[:turbo_stream] if media_type.nil?
          turbo_streams_html
        end
      end
    end

    initializer "turbo.signed_stream_verifier_key" do
      Turbo.signed_stream_verifier_key = config.turbo.signed_stream_verifier_key ||
        Rails.application.key_generator.generate_key("turbo/signed_stream_verifier_key")
    end

    initializer "turbo.test_assertions" do
      ActiveSupport.on_load(:active_support_test_case) do
        include Turbo::TestAssertions
      end
    end

    initializer "turbo.integration_test_request_encoding" do
      ActiveSupport.on_load(:action_dispatch_integration_test) do
        # Support `as: :turbo_stream`. Public `register_encoder` API is a little too strict.
        class ActionDispatch::RequestEncoder
          class TurboStreamEncoder < IdentityEncoder
            header = [ Mime[:turbo_stream], Mime[:html] ].join(",")
            define_method(:accept_header) { header }
          end

          @encoders[:turbo_stream] = TurboStreamEncoder.new
        end
      end
    end
  end
end
