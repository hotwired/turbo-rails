require "test_helper"

class TagBuilderTestCase < ActionView::TestCase
  private

  def view_context
    @view_context ||= ApplicationController.new.view_context
  end

  def turbo_stream
    @turbo_stream ||= Turbo::Streams::TagBuilder.new(view_context)
  end
end
