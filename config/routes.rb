# require 'flipper'

Rails.application.routes.draw do
  resources :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # mount Flipper::UI.app(Flipper) => '/flipper'
  root "movies#index"

  resources :movies do
    resources :reviews
  end

  resource :session, only: [:new, :create, :destroy]
  get "signup" => "users#new"
  get "signin" => "sessions#new"
end
