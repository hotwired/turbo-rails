module Turbo
  module TestAssertions
    extend ActiveSupport::Concern

    included do
      # FIXME: Should happen in Rails at a different level
      delegate :dom_id, :dom_class, to: ActionView::RecordIdentifier
    end

    def assert_turbo_stream(action:, target: nil, &block)
      assert_response :ok
      assert_equal Mime[:turbo_stream], response.media_type
      assert_select %(turbo-stream[action="#{action}"][target="#{target.respond_to?(:to_key) ? dom_id(target) : target}"]), count: 1, &block
    end

    def assert_no_turbo_stream(action:, target: nil)
      assert_response :ok
      assert_equal Mime[:turbo_stream], response.media_type
      assert_select %(turbo-stream[action="#{action}"][target="#{target.respond_to?(:to_key) ? dom_id(target) : target}"]), count: 0
    end
  end
end
