require 'mcp_common/api/api_controller'

# 
# Add authentication to any Api that inherits from this controller
# Nothing more now, but place holder to add aditional authentication functionality as needed
module DryAuth
  module Api
    class ApiController < McpCommon::Api::ApiController


      # Parse the HTTP header for X-API-KEY to authenticate the client
      # The API KEY is a Devise token so there is a separate key for each instance of the application
      #prepend_before_filter :get_api_key
  
      before_filter :authenticate_user!


      # 
      # Deprecated: See fucntionality in DryAuth initializer for devise token authentication
      #
      def get_api_key
        if api_key = params[:auth_token].blank? && request.headers["X-API-KEY"]
          params[:auth_token] = api_key
        end
        #Rails.logger.debug params #.to_yaml
        #Rails.logger.debug "API KEY passed is #{request.headers['X-API-KEY']}"
      end

    end
  end
end

