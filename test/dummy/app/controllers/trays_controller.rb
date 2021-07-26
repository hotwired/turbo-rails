class TraysController < ApplicationController
  def show
  end

  def new
    render 'new', with_turbo_frame: true
  end

  def create
    case params[:return_to]
    when "recede_or_redirect"       then recede_or_redirect_to tray_url(id: 1)
    when "resume_or_redirect"       then resume_or_redirect_to tray_url(id: 1)
    when "refresh_or_redirect"      then refresh_or_redirect_to tray_url(id: 1)
    when "recede_or_redirect_back"  then recede_or_redirect_back_or_to tray_url(id: 5)
    when "resume_or_redirect_back"  then resume_or_redirect_back_or_to tray_url(id: 5)
    when "refresh_or_redirect_back" then refresh_or_redirect_back_or_to tray_url(id: 5)
    else
      raise "Supply return_to to direct response"
    end
  end

  def part_one
    render partial: 'part_of_tray'
  end

  def part_two
    render partial: 'part_of_tray', with_turbo_frame: true
  end

  def part_three
    render partial: 'part_of_tray', with_turbo_frame: false
  end
end
