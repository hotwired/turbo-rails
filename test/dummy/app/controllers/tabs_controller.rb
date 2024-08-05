# frozen_string_literal: true

class TabsController < ApplicationController
  def index; end
  def show
    render locals: { name: params[:id] }
  end
end
