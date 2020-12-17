class MessagesController < ApplicationController
  def show
    render turbo_stream: turbo_stream.remove("message_1")
  end

  def create
    respond_to do |format|
      format.html { redirect_to message_url(id: 1) }
      format.turbo_stream { render turbo_stream: turbo_stream.append(:messages, "message_1") }
    end
  end
end
