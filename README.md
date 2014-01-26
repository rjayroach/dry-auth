# DryAuth

[![Build Status](https://semaphoreapp.com/api/v1/projects/6a4f592a-4a69-4976-983f-c10726d6a718/130967/shields_badge.png )](https://semaphoreapp.com/api/v1/projects/6a4f592a-4a69-4976-983f-c10726d6a718/130967/shields_badge.png)

DryAuth is a simple AAA solution for Rails applications.

By bundling commonly used gems into a single Rails Engine DryAuth, as it's name implies, provides a simple Do Not Repeat Yourself AAA solution for Rails applications.
It uses Devise for Authentication, CanCan and Rolify for authorization and PaperTrail for accounting.
In addition to bundling the gems, it provides:

1. A JSON authentication API
1. A GUI for CRUD on User and Roles tables for admin roles
1. A User Preferences view for a single user to update their profile
1. A menu system to access the above

## Getting started

In your Gemfile:

```ruby
gem "dry_auth"
```

## Usage

Building a User Extenison model for storing information related to the Application's User
In the engine or app which is going to link to DryAuth::User do the following:


  1. Generate a user model (Engine::User) that stores a reference to DryAuth::User:

	<pre><code>
	rails g model user dry_auth_user:references name
	rake [<engine>:install:migrations] db:migrate
	</pre></code>


  2. update the User model association

	See: mcp_common/app/models/mcp_common/user.rb


  3. Create an association from an application model to DryAuth::User

	In the application, create an initializer to add association and delegates to DryAuth::User:

```ruby
Rails.application.config.to_prepare do

  # 
  # Add an association to the User model to FacebookUser
  #
  DryAuth::User.class_eval do
    # todo conditions on this association? would be when provider.eql? 'facebook'
    has_one :facebook_user, class_name: 'CacheParty::FacebookUser', dependent: :destroy
  end


  # 
  # Create a new CacheParty::FacebookUser when a new AuthProfile is created and the provider name is 'facebook'
  # NOTE: The method below has knowledge of the inner workings of DryAuth User and AuthUser classes
  #   Specifically, it assumes that the auth_profile will have a valid reference to a user (which is reasonable)
  #
  DryAuth::AuthProfile.class_eval do

    # After saving an AuthProfile, check for an existing record of FacebookUser and create one if it doesn't exist
    after_save :facebook_user_create, if: "self.provider.eql?('facebook') and self.user.facebook_user.nil?"

    #
    # Create a FacebookUser setting the username to the uid returned from facebook
    #
    def facebook_user_create
      Rails.logger.debug "Creating CacheParty::FacebookUser for DryAuth::User from #{ __FILE__ }\n"
      self.user.create_facebook_user(facebook_id: self.uid)
    end
  end

end
```



  4. create a partial to render to edit fields:

	The file must live in:  app/views/\<engine\>/users/\_form.html.erb

	See: mcp_common/app/views/mcp_common/users/\_form.html.erb

  5. Strong Parameters on DryAuth::UserController



## Adding Roles and Authorization

See: https://github.com/EppO/rolify/wiki/Tutorial



