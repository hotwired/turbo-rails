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
        include Turbo::Updates::PageUpdateTagBuilder, Turbo::Frames::FrameRequest, Turbo::Links::NativeNavigation
        helper Turbo::Engine.helpers
      end
    end

    initializer "turbo.broadcastable" do
      ActiveSupport.on_load(:active_record) do
        include Turbo::Broadcastable
      end
    end

    initializer "turbo.mimetype" do
      Mime::Type.register "text/html; page-update", :page_update
    end

    initializer "turbo.renderer" do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Renderers.add :page_update do |page_updates_html, options|
          self.content_type = Mime[:page_update] if media_type.nil?
          page_updates_html
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
        # Support `as: :page_update`. Public `register_encoder` API is a little too strict.
        class ActionDispatch::RequestEncoder
          class PageUpdateEncoder < IdentityEncoder
            header = [ Mime[:page_update], Mime[:html] ].join(",")
            define_method(:accept_header) { header }
          end

          @encoders[:page_update] = PageUpdateEncoder.new
        end
      end
    end
  end
end
