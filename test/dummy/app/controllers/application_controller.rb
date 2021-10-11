class ApplicationController < ActionController::Base
  before_action { sleep params.fetch(:sleep, 0).to_f }
end
