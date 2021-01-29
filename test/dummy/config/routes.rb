Rails.application.routes.draw do
  resources :messages
  resources :trays
  resources :posts
  namespace :users do
    resources :profiles
  end
end
