module DryAuth
  class AuthProfile < ActiveRecord::Base
    belongs_to :user
    
    validates_presence_of :user

    # only one 3rd party provider record per user/provider combination
    validates :provider, uniqueness: {scope: :user_id}

  end
end

