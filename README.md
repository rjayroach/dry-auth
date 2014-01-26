# DryAuth

https://semaphoreapp.com/api/v1/projects/6a4f592a-4a69-4976-983f-c10726d6a718/130967/shields_badge.png


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

?????


# Adding Roles and Authorization

See: https://github.com/EppO/rolify/wiki/Tutorial



