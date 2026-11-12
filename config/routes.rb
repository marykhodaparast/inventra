Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [ :index, :update ]
  end
  resources :inventories, only: [:index, :new, :create, :edit, :update, :destroy] do
    resources :categories, only: [:create, :update, :destroy]
    resources :custom_fields, only: [:create, :update, :destroy]
    resources :items, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  end
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users, only: [ :new, :create ]
  resource :profile, only: [ :show, :edit, :update ]


  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
