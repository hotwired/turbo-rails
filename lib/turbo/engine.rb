require "rails/engine"

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

    # If the parent application does not use Action Cable, app/channels cannot
    # be eager loaded, because it references the ActionCable constant.
    #
    # When turbo-rails depends on Rails 7 or above, the entire block can be
    # reduced to
    #
    #   unless defined?(ActionCable)
    #     Rails.autoloaders.once.do_not_eager_load("#{root}/app/channels")
    #   end
    #
    initializer "turbo.no_action_cable", before: :set_eager_load_paths do
      unless defined?(ActionCable)
        if Rails.autoloaders.zeitwerk_enabled?
          Rails.autoloaders.once.do_not_eager_load("#{root}/app/channels")
        else
          # This else branch only runs in Rails 6.x + classic mode.
          config.eager_load_paths.delete("#{root}/app/channels")
        end
      end
    end

    # If you don't want to precompile Turbo's assets (eg. because you're using webpack),
    # you can do this in an intiailzer:
    #
    # config.after_initialize do
    #   config.assets.precompile -= Turbo::Engine::PRECOMPILE_ASSETS
    # end
    PRECOMPILE_ASSETS = %w( turbo.js turbo.min.js turbo.min.js.map )

    initializer "turbo.assets" do
      if Rails.application.config.respond_to?(:assets)
        Rails.application.config.assets.precompile += PRECOMPILE_ASSETS
      end
    end

    initializer "turbo.configs" do
      config.after_initialize do |app|
        Turbo.draw_routes = app.config.turbo.draw_routes != false
      end
    end

    initializer "turbo.helpers", before: :load_config_initializers do
      ActiveSupport.on_load(:action_controller_base) do
        include Turbo::Streams::TurboStreamsTagBuilder, Turbo::Frames::FrameRequest, Turbo::Native::Navigation
        helper Turbo::Engine.helpers
      end
    end

    initializer "turbo.request_id_tracking" do
      ActiveSupport.on_load(:action_controller) do
        include Turbo::RequestIdTracking
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
      ActionController::Renderers.add :turbo_stream do |turbo_streams_html, options|
        self.content_type = Mime[:turbo_stream] if media_type.nil?
        turbo_streams_html
      end
    end

    initializer "turbo.signed_stream_verifier_key" do
      config.after_initialize do
        Turbo.signed_stream_verifier_key = config.turbo.signed_stream_verifier_key ||
          Rails.application.key_generator.generate_key("turbo/signed_stream_verifier_key")
      end
    end

    initializer "turbo.test_assertions" do
      ActiveSupport.on_load(:active_support_test_case) do
        require "turbo/test_assertions"
        include Turbo::TestAssertions
      end

      ActiveSupport.on_load(:action_cable) do
        ActiveSupport.on_load(:active_support_test_case) do
          require "turbo/broadcastable/test_helper"
          include Turbo::Broadcastable::TestHelper
        end
      end

      ActiveSupport.on_load(:action_dispatch_integration_test) do
        require "turbo/test_assertions/integration_test_assertions"

        include Turbo::TestAssertions::IntegrationTestAssertions
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
