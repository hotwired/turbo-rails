Rails.application.routes.draw do
  resources :pages, only: :show
  resources :articles do
    delete :destroy_all, on: :collection
  end
  resources :messages do
    collection do
      get :section
    end
  end
  resources :trays
  resources :posts
  resources :notifications
  namespace :users do
    resources :profiles
  end
  namespace :admin do
    resources :companies
  end
  resource :request_id
end
