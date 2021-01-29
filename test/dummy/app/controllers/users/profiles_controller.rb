module Users
  class ProfilesController < ApplicationController
    
    def show
      @profile = Users::Profile.new(record_id: 1, name: "User")
    end
    
  end
end