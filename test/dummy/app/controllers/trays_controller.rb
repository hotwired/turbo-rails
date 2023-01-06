class TraysController < ApplicationController
  def show
  end

  def create
    case params[:return_to]
    when "recede_or_redirect"               then recede_or_redirect_to tray_url(id: 1)
    when "resume_or_redirect"               then resume_or_redirect_to tray_url(id: 1)
    when "refresh_or_redirect"              then refresh_or_redirect_to tray_url(id: 1)
    when "recede_or_redirect_back"          then recede_or_redirect_back_or_to tray_url(id: 5)
    when "resume_or_redirect_back"          then resume_or_redirect_back_or_to tray_url(id: 5)
    when "refresh_or_redirect_back"         then refresh_or_redirect_back_or_to tray_url(id: 5)
    when "refresh_or_redirect_with_options" then refresh_or_redirect_to tray_url(id: 5), notice: "confirmed", native_params: { custom: 123 }
    else
      raise "Supply return_to to direct response"
    end
  end
end
