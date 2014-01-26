# DryAuth

[![Build Status](https://semaphoreapp.com/api/v1/projects/6a4f592a-4a69-4976-983f-c10726d6a718/130967/shields_badge.png )](https://semaphoreapp.com/api/v1/projects/6a4f592a-4a69-4976-983f-c10726d6a718/130967/shields_badge.png)

DryAuth is a simple AAA solution for Rails applications. By bundling commonly used gems into a single Rails Engine.

DryAuth, as it's name implies, provides a simple Do Not Repeat Yourself AAA solution for Rails applications.
It uses Devise for Authentication, CanCan and Rolify for authorization and PaperTrail for accounting.
In addition to bundling the gems, it provides:


1. A JSON authentication API
1. A GUI for CRUD on a User database and generating token keys
1. A GUI for roles
1. A menu system

It is intended as a quick add that provides the above services to a Rails application with minimal effort


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


  3. create an initializer to add association and delegates to DryAuth::User:

	See: mcp_common/initializers/user.rb


  4. create a partial to render to edit fields:

	The file must live in:  app/views/\<engine\>/users/\_form.html.erb

	See: mcp_common/app/views/mcp_common/users/\_form.html.erb

  5. Strong Parameters on DryAuth::UserController



## Adding Roles and Authorization

See: https://github.com/EppO/rolify/wiki/Tutorial



