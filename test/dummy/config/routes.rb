Rails.application.routes.draw do
  resources :articles
  resources :messages do
    collection do
      get :section
    end
  end
  resources :trays
  resources :posts
  namespace :users do
    resources :profiles
  end
  namespace :admin do
    resources :companies
  end
end
