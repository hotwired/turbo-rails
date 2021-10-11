class Turbo::Controller < ApplicationController
  private

    def protect_against_forgery?
      false
    end
end
