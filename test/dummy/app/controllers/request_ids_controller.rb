class RequestIdsController < ApplicationController
  def show
    render json: { turbo_frame_request_id: Turbo.current_request_id }
  end
end
