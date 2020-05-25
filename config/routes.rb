Rails.application.routes.draw do
  
  resources :interviews
  root "interviews#index"
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  resources :users , only: [:new, :create]
  resources :sessions , only: [:new, :create, :destroy]
end
