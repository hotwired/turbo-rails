class MessagesController < ApplicationController
  def show
    @message = Message.new(record_id: 1, content: "My message")
  end

  def new
    sleep params[:sleep].to_i
  end

  def create
    sleep params[:sleep].to_i

    respond_to do |format|
      format.html { redirect_to message_url(id: 1) }
      format.turbo_stream { render turbo_stream: turbo_stream.append(:messages, "message_1") }
    end
  end
end
