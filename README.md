# DryAuth

[![Build Status](https://semaphoreapp.com/api/v1/projects/6a4f592a-4a69-4976-983f-c10726d6a718/130967/shields_badge.png )](https://semaphoreapp.com/api/v1/projects/6a4f592a-4a69-4976-983f-c10726d6a718/130967/shields_badge.png)

DryAuth is a simple AAA solution for Rails applications. 
It's purpose, as it's name implies, is to provide a simple Do Not Repeat Yourself AAA solution for Rails applications.

## Features

DryAuth bundles commonly used gems into a single Rails Engine and provides additional features out of the box:

* A JSON authentication API
* A GUI for CRUD on User and Roles tables for admin roles
* A User Preferences view for a single user to update their profile
* A menu system to access the above
* A view for history changes stored by PaperTrail (todo)
* Auth Profiles for 3rd party authentication credentials mapped to the User

## Dependencies

To provide AAA, it depends on the following:

1. Authentication: [Devise](https://github.com/plataformatec/devise)
1. Authorization: [CanCan](https://github.com/ryanb/cancan) and [Rolify](https://github.com/EppO/rolify)
1. Accounting: [PaperTrail](https://github.com/airblade/paper_trail)


## Getting started

In your Gemfile:

```ruby
gem "dry_auth"
```

## Usage

DryAuth provides drop-in AAA by providing a User model.
This model needs to be associated to the application's User model, e.g. Member, Author, etc.

### Model Assocation

1. Generate a user model, e.g FacebookUser, in the application with a reference to DryAuth::User

	rails g model facebook_user dry_auth_user:references name
	rake dry_auth:install:migrations db:migrate


1. Update the User model association

	```ruby
	class FacebookUser < ActiveRecord::Base
	  belongs_to :user, class_name: "DryAuth::User"
	end


1. Create an association from an application model to DryAuth::User, 

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

### Customized Views

To add fields to DryAuth's User edit view

  4. create a partial to render to edit fields:

	The file must live in:  app/views/\<engine\>/users/\_form.html.erb

	See: mcp_common/app/views/mcp_common/users/\_form.html.erb

### TODO

  5. Strong Parameters on DryAuth::UserController



## Adding Roles and Authorization

See: https://github.com/EppO/rolify/wiki/Tutorial



