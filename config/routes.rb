
DryAuth::Engine.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: McpCommon::ApiConstraints.new(version: 1, default: true) do
      resources :tokens, only: [:create, :destroy]
      resources :users, only: [:show]
      get "/profile" => "users#show"
    end
  end

  devise_for :users, {
    class_name: "DryAuth::User", module: :devise,
    path_names: {sign_up: "new_user", sign_in: "login", sign_out: "logout"},
    # OA: next line to point omniauth callbacks at custom controller; Note the fixed path for callback is MountPoint/users/auth
    # See RC#235 for omniauth
    controllers: {omniauth_callbacks: "dry_auth/omniauth_callbacks"}
  }

  resources :users

  # Map user's profile to a fixed url, rather than users/:id
  # See: http://railscasts.com/episodes/203-routing-in-rails-3
  get "/profile/edit", to: "users#edit"
  get "/profile", to: "users#show"


  # Omniauth routes; See RC#235
#user_omniauth_authorize        /auth/:provider(.:format)        dry_auth/omniauth_callbacks#passthru {:provider=>/(?!)/}
#user_omniauth_callback        /auth/:action/callback(.:format) dry_auth/omniauth_callbacks#(?-mix:(?!))

#  match '/:provider/callback', to: 'omniauth_callbacks#passthru'
#  match '/failure', to: redirect('/')
#  match 'signout', to: 'sessions#destroy', as: 'signout'

  #match '/:provider', to: "omniauth_callbacks#passthru", as: 'omniauth_authorize', provider: /(?!)/
  #match '/facebook', to: "omniauth_callbacks#passthru", as: 'omniauth_authorize', provider: /(?!)/
# this is the one
#  match '/:action/callback/', to: 'omniauth_callbacks#(?-mix:(?!))', as: 'omniauth_callback'
  #match '/facebook/callback/', to: 'omniauth_callbacks#(?-mix:(?!))', as: 'omniauth_callback'

#  match '/failure', to: redirect('/')
#  match 'signout', to: 'sessions#destroy', as: 'signout'
end


