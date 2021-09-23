class MessagesController < ApplicationController
  def show
    @message = Message.new(id: 1, content: "My message")
  end

  def index
    @messages = Message.all
  end

  def create
    respond_to do |format|
      format.html { redirect_to message_url(id: 1) }
      format.turbo_stream { render turbo_stream: turbo_stream.append(:messages, "message_1"), status: :created }
    end
  end

  def update
    @message = Message.new(id: 1, content: "My message")
  end
end
