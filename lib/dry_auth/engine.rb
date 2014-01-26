
# 3rd party libraries
require 'cancan'
require 'devise'
require 'rolify'
require 'omniauth'
require "omniauth-facebook"

# local libraries
require_relative 'ability'

module DryAuth
  class Engine < ::Rails::Engine
    isolate_namespace DryAuth

    # 
    # After rails loads all gems and engines and processes all intializiers
    # this code will add methods to the application's base ApplicationController
    # See: http://stackoverflow.com/questions/3468858/rails-3-0-engine-execute-code-in-actioncontroller
    # 
    initializer 'dry_auth.controller' do |app|  
      ActiveSupport.on_load(:action_controller) do  
        Rails.logger.debug { "\nInitializing from #{__FILE__}" }
        include ActionControllerExtension  
        include Controller
        helper McpCommon::ApplicationHelper
      end
    end


    config.generators do |g|
      g.test_framework :rspec,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => false,
        :request_specs => true,
        :fixtures => true
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.helper = false
      g.stylesheets = false
    end 

  end
end

