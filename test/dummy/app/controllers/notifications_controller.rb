class NotificationsController < ApplicationController
  def create
    respond_to do |format|
      format.turbo_stream { render :new }
    end
  end
end
