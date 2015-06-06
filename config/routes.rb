Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }
  root :to => "pages#index"

  get "api/user" => "apis#user", as: :api_user
  post "api/create_user" => "apis#create_user", as: :api_create_user
  post "api/login_user" => "apis#login_user", as: :api_login_user
  post "sign_in_via_facebook" => "apis#sign_in_via_facebook", as: :sign_in_via_facebook
  delete "api/logout_user" => "apis#logout_user", as: :api_logout_user
  
  resources :dreams

  resources :connections, :only => [:create]
  put "accept_connection/:id" => "connections#accept_connection", as: :accept_connection
  put "decline_connection/:id" => "connections#decline_connection", as: :decline_connection
  get "email_display_as_string/:id" => "connections#email_display_as_string", as: :email_display_as_string

  get "users/:id" => "users/activities#show", as: :activities

  get "how-it-works" => "pages#how_it_works", as: :how_it_works
  get "about" => "pages#about", as: :about
end
