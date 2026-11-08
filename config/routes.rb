Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index, :update]
  end
  get "/inventories", to: "inventories#index", as: :inventories
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users, only: [:new, :create]
  resource :profile, only: [:show, :edit, :update]

  
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
