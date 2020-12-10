class MessagesController < ApplicationController
  def show
    render turbo_update: turbo_update.remove("message_1")
  end

  def create
    respond_to do |format|
      format.html { redirect_to message_url(id: 1) }
      format.turbo_update { render turbo_update: turbo_update.append(:messages, "message_1") }
    end
  end
end
