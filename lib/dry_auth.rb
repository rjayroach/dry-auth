require "dry_auth/engine"
require 'dry_auth/api/api_controller'

module DryAuth
  def self.mcp; 'mcp' end

  def self.logger
    @@logger ||= Logger.new("#{Rails.root}/log/dry_auth.log")
  end

end
