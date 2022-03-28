module Turbo
  module TestAssertions
    extend ActiveSupport::Concern

    included do
      # FIXME: Should happen in Rails at a different level
      delegate :dom_id, :dom_class, to: ActionView::RecordIdentifier
    end

    def assert_turbo_stream(action:, target: nil, targets: nil, status: :ok, &block)
      assert_response status
      assert_equal Mime[:turbo_stream], response.media_type
      selector =  %(turbo-stream[action="#{action}"])
      selector << %([target="#{target.respond_to?(:to_key) ? dom_id(target) : target}"]) if target
      selector << %([targets="#{targets}"]) if targets
      assert_select selector, count: 1, &block
    end

    def assert_no_turbo_stream(action:, target: nil, targets: nil)
      assert_equal Mime[:turbo_stream], response.media_type
      selector =  %(turbo-stream[action="#{action}"])
      selector << %([target="#{target.respond_to?(:to_key) ? dom_id(target) : target}"]) if target
      selector << %([targets="#{targets}"]) if targets
      assert_select selector, count: 0
    end
  end
end
