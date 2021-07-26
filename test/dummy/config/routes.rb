Rails.application.routes.draw do
  resources :messages
  resources :trays do
    member do
      get :part_one
      get :part_two
      get :part_three
    end
  end
  resources :posts
  namespace :users do
    resources :profiles
  end
  namespace :admin do
    resources :companies
  end
end
