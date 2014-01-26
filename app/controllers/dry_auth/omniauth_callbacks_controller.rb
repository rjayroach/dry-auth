require_dependency "dry_auth/application_controller"

module DryAuth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController

    skip_before_filter :authenticate_user!

    #before_filter :debug_auth

    # 
    # Handle authentication callbacks from 3rd party providers
    #
    def all
      DryAuth.logger.info { '+' * 50 }

      user = User.from_omniauth(env["omniauth.auth"])
      # Returns true if the record is persisted, i.e. it’s not a new record and it was not destroyed, otherwise returns false.
      if user.persisted?
        DryAuth.logger.info { 'in user.persisted? true' }
        sign_in user
      else
        DryAuth.logger.info { 'in user.persisted? false' }
        session["devise.user_attributes"] = user.attributes
      end

      DryAuth.logger.info { 'Redirecting user' }
      if request.env['omniauth.origin']
        DryAuth.logger.info { "Redirecting to #{request.env['omniauth.origin']}" }
        redirect_to request.env['omniauth.origin']
      else
        DryAuth.logger.warn { "User returned without omniauth.origin" }
        DryAuth.logger.warn { "Request referer: #{request.referer}" }
        #DryAuth.logger.warn { request.env["omniauth.auth"].to_yaml }
        if cookies.signed[:after_auth_url]
          DryAuth.logger.warn { "Got cookie (thankfully!)" }
          redirect_url = "/#{cookies.signed[:after_auth_url]}"
        else
          DryAuth.logger.warn { "NO cookie!" }
          redirect_url = FanClub::Engine.routes.url_helpers.handle_error_path
        end
        redirect_to redirect_url
        Rails.logger.warn { "User returned without omniauth.origin! Redirecting to #{redirect_url}" }
      end

      DryAuth.logger.info { '+' * 50 }
    end

    # One alias_method for each supported provider
    alias_method :facebook, :all

    private

    def debug_auth
      Rails.logger.debug '=' * 50
      Rails.logger.debug request.env["omniauth.auth"].to_yaml
      Rails.logger.debug "Omniauth origin #{request.env['omniauth.origin']}"
      Rails.logger.debug '=' * 50
      Rails.logger.debug "#{request.env['omniauth.auth']['info'].email}"
      Rails.logger.debug "#{request.env['omniauth.auth']['info']['email']}"
      Rails.logger.debug '=' * 100
      raise request.env["omniauth.auth"].to_yaml
    end

  end
end
