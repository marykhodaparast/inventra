Rails.application.routes.draw do
  resources :users, only: [:new, :create]

  
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
