module DryAuth
  class User < ActiveRecord::Base
    has_many :auth_profiles, dependent: :destroy
    rolify
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    #devise :database_authenticatable, :registerable,
    #       :recoverable, :rememberable, :trackable, :validatable
  
    #devise :token_authenticatable, :database_authenticatable,
    devise :database_authenticatable,
           :rememberable, :trackable, :validatable
    # OA
    devise :omniauthable

    before_validation :ensure_time_zone

    def ensure_time_zone; self.time_zone = 'UTC' if self.time_zone.blank?; end

    # Support time zones for users
    # See: http://railscasts.com/episodes/106-time-zones-revised?view=asciicast
    validates_inclusion_of :time_zone, in: -> {ActiveSupport::TimeZone.zones_map(&:name)}

    #
    # Allow user to login with either username or email address
    # See: https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
    attr_accessor :login

    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end
    # end changes for username or email address


    # 
    # Find a user by username or email
    # Used by JSON API TokensController to authenticate a user
    #
    def self.find_by_login(login)
      t = self.arel_table
      self.where(t[:username].eq(login).or(t[:email].eq(login.downcase))).first
    end
  
  


    #
    # See: http://railscasts.com/episodes/235-devise-and-omniauth-revised?view=asciicast
    #
    def self.new_with_session(params, session)
      if session["devise.user_attributes"]
        new(session["devise.user_attributes"], without_protection: true) do |user|
          user.attributes = params
          user.valid?
        end
      else
        super
      end    
    end
    

    def to_label
      self.email
    end

    # create a token for users with the :api role
    before_save :ensure_auth_token
    def ensure_auth_token; self.ensure_authentication_token if self.has_role? :api end

    # users with an :admin role have to have the role removed before being deleted
    # todo: the admin user himself cannot do it, another admin has to remove the role
    # thus ensuring there is always at least one user with an :admin role
    before_destroy :prohibit_destroy_admin
    def prohibit_destroy_admin; false if self.has_role? :admin end


=begin
  unknown user logs in with credentials from 3rd party
  if the credentials already exist in an auth profile
    update the profile and return the associated user record
  else
    create auth profile
    search for user with hash's email value
    if no user found, create the user
    return the associated user record
  end

User has one or more AuthProfiles
User.facebook = AuthProfile.where(provider: facebook)
User.facebook.cache = McpExt::FacebookUser
=end

    # 
    # Omniauth authentication
    # Called from OmniauthCallbacksController when a 3rd party
    #   has returned data from our authentication request
    # See: http://railscasts.com/episodes/360-facebook-authentication?view=asciicast
    #
    # The auth parameter is the authentication obejct (decoded by omniauth) the contains details of the user
    # 
    def self.from_omniauth(auth)
      Rails.logger.debug { "\n" + "#=" * 20 + "  Begin: Autentication\n" }
      Rails.logger.debug { "#{self.class} (from_omniauth):\n Received #{auth.to_yaml}" }


      # The code below will get executed with EITHER an existing profile (.first) or a new profile
      p = AuthProfile.where(auth.slice(:provider, :uid)).first_or_initialize.tap do |profile|

        # Parse generic auth hash fields
        profile.provider = auth.provider
        profile.uid = auth.uid
        profile.oauth_token = auth.credentials.token
        profile.oauth_expires_at = Time.at(auth.credentials.expires_at)


        # If the profile does not already have a valid user attached:
        if !profile.user

          # There is no user associated with this profile
          Rails.logger.debug { "User NOT found for this profile\n" }

          # generate a random string
          o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten

          # If returned email is blank, then generate a random email address
          email = auth.info.email.to_s
          if email.blank?
            email = "#{(0...10).map{ o[rand(o.length)] }.join}@#{(0...10).map{ o[rand(o.length)] }.join}.local"
            Rails.logger.warn { "Returned email was blank. Setting to #{email}" }
          end
            
          profile.user = User.where(email: email).first
          if profile.user.nil?
            profile.user = User.create!(
              password: (0...50).map{ o[rand(o.length)] }.join,
              email: email,
              username: email
            )
            Rails.logger.debug "Created New User with email #{email}"
          else
            Rails.logger.debug "Updating User with email #{email}"
          end

        end
      end

      # And finally, save the (updated or new) profile
      p.save!
      #   and log the user record that is associated to this profile
      Rails.logger.debug "Attempt to save profile #{p.uid} with user:\n #{p.user.to_yaml}"
      Rails.logger.debug { "\n" + "#=" * 20 + "  End: Autentication\n" }

      # and return the profile's user record
      p.user
    end


    #
    # Return an AuthProfile for the twitter provider if it exists
    #
    def twitter_auth_cache
      self.auth_profiles.where(provider: 'twitter').first
    end


    #
    # Return an AuthProfile for the facebook provider if it exists
    #
    def facebook_auth_cache
      self.auth_profiles.where(provider: 'facebook').first
    end

    #
    # Return the facebook uid as the field name 'facebook_id'
    def facebook_id 
      self.facebook_auth_cache.uid
    end

  end
end


