Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root :to => "pages#index"

  get "sign_in_via_facebook" => "apis#sign_in_via_facebook", as: :sign_in_via_facebook
end
