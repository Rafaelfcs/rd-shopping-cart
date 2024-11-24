require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  resource :cart, only: [:create, :show] do
    post '/cart', to: 'carts#create'
    get '/cart', to: 'carts#show'
  end

  root "rails/health#show"
end
