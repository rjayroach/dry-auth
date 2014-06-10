
=begin
OK!!!! 08-03-13
Worked on this for _quite_ awhile
Referencing from http://railscasts.com/episodes/352-securing-an-api?view=asciicast
the Ahn rest_client is sending its auth_key as an HTTP request header X-API-KEY
Devise only supports sending the token as a query parameter in the URL
In order to support both options, the following code is necessary.
Thanks Fabian!
See: https://groups.google.com/forum/?fromgroups=#!topic/plataformatec-devise/o3Gqgl0yUZo
=end

=begin
This is throwing an eorror when upgrading to rails 4 with a new devise version that deprecate TokenAuthenticatable
See: http://stackoverflow.com/questions/18931952/devise-token-authenticatable-deprecated-what-is-the-alternative
require 'devise/strategies/token_authenticatable'
module Devise
  module Strategies
    class TokenAuthenticatable < Authenticatable
      def params_auth_hash
        return_params = if params[scope].kind_of?(Hash) && params[scope].has_key?(authentication_keys.first)
          params[scope]
        else
          params
        end
        Rails.logger.debug "Mofdify auth strategy see #{__FILE__}"
        return_params.merge!(:auth_token => request.headers["X-API-KEY"]) if request.headers["X-API-KEY"]
        return_params
      end
    end
  end
end

=end
