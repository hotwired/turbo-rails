class StreamObject
  include Turbo::Streams::ActionHelper

  def name
    "Stream Object 1"
  end

  def to_turbo_stream
    turbo_stream_action_tag(:replace, target: "stream_object_1", template: name)
  end
end

class StreamsController < ApplicationController
  def index
    render turbo_stream: StreamObject.new
  end
end
