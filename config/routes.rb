Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root :to => "pages#index"

  post "sign_in_via_facebook" => "apis#sign_in_via_facebook", as: :sign_in_via_facebook
  
  resources :dreams

  get "how-it-works" => "pages#how_it_works", as: :how_it_works
  get "about" => "pages#about", as: :about
end
