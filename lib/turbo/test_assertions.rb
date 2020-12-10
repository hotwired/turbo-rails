module Turbo
  module TestAssertions
    extend ActiveSupport::Concern

    included do
      # FIXME: Should happen in Rails at a different level
      delegate :dom_id, :dom_class, to: ActionView::RecordIdentifier
    end

    def assert_turbo_update(command:, element: nil, container: nil, &block)
      assert_response :ok
      assert_equal Mime[:turbo_update], response.media_type
      assert_select %(template[data-page-update="#{command}##{element ? dom_id(element) : container}"]), count: 1, &block
    end

    def assert_no_turbo_update(command:, element: nil, container: nil)
      assert_response :ok
      assert_equal Mime[:turbo_update], response.media_type
      assert_select %(template[data-page-update="#{command}##{element ? dom_id(element) : container}"]), count: 0
    end
  end
end
