require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  resource :cart do
    post '/cart', to: 'carts#create'
    post '/add_item', to: 'carts#add_item'
    get '/cart', to: 'carts#show'
    delete '/:product_id', to: 'carts#remove_item'
  end

  root "rails/health#show"
end
