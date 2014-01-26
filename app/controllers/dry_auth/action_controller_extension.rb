


module DryAuth
  module ActionControllerExtension
    def self.included(base)
      # TODO logging when using dummy apps (at least mcp_call) cause rails s to fail: can't find class_name
      #Rails.logger.debug { "\nLoading #{self.class_name} from #{__FILE__}" }
      #Rails.logger.debug { "\nModifying #{base.class_name} from #{__FILE__}" }
      # base.send(:include, InstanceMethods) 
      base.before_filter :set_locale
      # Get a deprecation warning when setting the layout on Base
      # TODO find a way to set it in ApplicationController itself
      #base.layout  "layouts/mcp_common/application"
      # TODO this is a devise method and throws an error when its applied, so for now keep it in app's application controller
      #before_filter :authenticate_user!
      base.around_filter :user_time_zone, if: :current_user
    end

  
    def user_time_zone(&block)
      Time.use_zone(current_user.time_zone, &block)
    end


    #private
    def set_locale
      Rails.logger.debug { "#{'@' * 30} BEGIN SET_LOCALE" }
      Rails.logger.debug { "HTTP_ACCEPT_LANGUAGE: #{request.env['HTTP_ACCEPT_LANGUAGE']}" }
      Rails.logger.debug { "I18n.default_locale: #{I18n.default_locale}" }
      Rails.logger.debug { "params[:locale]: #{params[:locale]}" }
      Rails.logger.debug { "session[:locale]: #{session[:locale]}" }
      Rails.logger.debug { "current_user.locale: #{current_user.locale if current_user}" }
      Rails.logger.debug { "I18n.locale: '#{I18n.locale}'" }

      # The locale for this request is first set to the default of the system
      current_locale = I18n.default_locale
      source = 'Default'

      # If a parameter named 'locale' is sent via the browser then that overrides all other locale settings
      if params[:locale].present?
        current_locale = params[:locale]
        session[:locale] = current_locale
        source = 'Parameter'

      # If the user is logged in and user's locale is different to current locale then update session locale
      elsif current_user and current_user.locale and not current_user.locale.empty?
        current_locale = current_user.locale 
        session[:locale] = current_locale
        source = 'Current User'

      # If there is no logged in user, check the session for an existing locale
      elsif session[:locale]
        current_locale = session[:locale]
        source = 'Session'

      # If no session locale and no current user then fall back to the browser setting
      elsif request.env['HTTP_ACCEPT_LANGUAGE']
        current_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first 
        source = 'Browser'
      end


      # Now, update the session
      I18n.locale = current_locale

      Rails.logger.debug { "params[:locale]: #{params[:locale]}" }
      Rails.logger.debug { "session[:locale]: #{session[:locale]}" }
      Rails.logger.debug { "current_user.locale: #{current_user.locale if current_user}" }
      Rails.logger.debug { "I18n.locale: '#{I18n.locale}' set from #{source}" }
      Rails.logger.debug { "#{'@' * 30} END SET_LOCALE" }
    end

  end


  module Controller extend ActiveSupport::Concern
    included do
      rescue_from CanCan::AccessDenied do |exception|
        Rails.logger.debug { "Processing CanCan::AccessDenied from #{__FILE__}" }
        redirect_to root_path, alert: exception.message
      end
    end
  end

end


