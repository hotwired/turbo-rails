class Users::ProfilesController < ApplicationController
  def show
    @profile = Users::Profile.new(id: 1, name: "User")
  end
end
