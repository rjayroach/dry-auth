
module DryAuth
  module Api
    module V1
      # 
      # Authenticates a user with standard credentials and returns the user's token if successful
      # Also allows user to reset token by calling the destroy method
      #
      class TokensController < McpCommon::Api::ApiController

        skip_before_filter :authenticate_user!


        # 
        # Taken from a POST request
        # Generate a token and return it to the user
        #
        def create
          #Rails.logger.debug 'Receiving request'
          #Rails.logger.debug request
          #email = params[:email]
          login = params[:login]
          password = params[:password]
          if request.format != :json
            render status: 406, json: {message: "The request must be json"}
            return
          end
    
          if login.nil? or password.nil?
            render status: 400, json: {message: "The request must contain the user email and password."}
            return
          end
      
          @user = User.find_by_login(login)
      
          if @user.nil?
            Rails.logger.info "User #{login} failed signin, user cannot be found."
            render status: 401, json: {message: "Invalid username, email or passoword."}
            return
          end

          # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
          @user.ensure_authentication_token!
      
          if not @user.valid_password?(password)
            Rails.logger.info "User #{login} failed signin, password \"#{password}\" is invalid" 
            render status: 401, json: {message: "Invalid username, email or password."}
          else
            render status: 200, json: {token: @user.authentication_token}
          end
        end
    

        # 
        # Reset the User's token
        #
        def destroy
          @user=User.find_by_authentication_token(params[:id])
          if @user.nil?
            Rails.logger.info("Token not found.")
            render status: 404, json: {message: "Invalid token."}
          else
            @user.reset_authentication_token!
            render status: 200, json: {token: params[:id]}
          end
        end
    

      end # TokensController
    end # V1
  end # Api
end # DryAuth

