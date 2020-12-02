class MessagesController < ApplicationController
  def show
    render page_update: page_update.remove("message_1")
  end

  def create
    respond_to do |format|
      format.html { redirect_to message_url(id: 1) }
      format.page_update { render page_update: page_update.append(:messages, "message_1") }
    end
  end
end
