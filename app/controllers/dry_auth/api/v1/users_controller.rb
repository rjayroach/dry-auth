
module DryAuth
  module Api
    module V1
      class UsersController < DryAuth::Api::ApiController

        # 
        # Show's the user profile
        #
        def show
          # If no user_id param is passed then a user is editing their profile, so use current_user
          @user = params[:id] ? User.find(params[:id]) : current_user
        end

      end # UsersController
    end # V1
  end # Api
end # DryAuth

