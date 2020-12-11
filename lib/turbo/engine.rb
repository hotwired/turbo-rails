require "rails/engine"
require "turbo/test_assertions"

module Turbo
  class Engine < Rails::Engine
    isolate_namespace Turbo
    config.eager_load_namespaces << Turbo
    config.turbo = ActiveSupport::OrderedOptions.new

    initializer "turbo.assets" do
      Rails.application.config.assets.precompile += %w( turbo )
    end

    initializer "turbo.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        include Turbo::Updates::TurboUpdatesTagBuilder, Turbo::Frames::FrameRequest, Turbo::Links::NativeNavigation
        helper Turbo::Engine.helpers
      end
    end

    initializer "turbo.broadcastable" do
      ActiveSupport.on_load(:active_record) do
        include Turbo::Broadcastable
      end
    end

    initializer "turbo.mimetype" do
      # TODO: Replace page-update with turbo-stream when ???
      Mime::Type.register "text/html; page-update", :turbo_stream
    end

    initializer "turbo.renderer" do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Renderers.add :turbo_stream do |turbo_stream_html, options|
          self.content_type = Mime[:turbo_stream] if media_type.nil?
          turbo_stream_html
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
          class PageUpdateEncoder < IdentityEncoder
            header = [ Mime[:turbo_stream], Mime[:html] ].join(",")
            define_method(:accept_header) { header }
          end

          @encoders[:turbo_stream] = PageUpdateEncoder.new
        end
      end
    end
  end
end
