Rails.application.routes.draw do
  # devise_for :users

  namespace :auth do
    post :signup
    post :login
  end

  namespace :user do
    resource :me, controller: :me, only: [:show]
    resources :map_urls, only: [:index, :create]
  end

  namespace :admin do
    resources :map_urls, only: [:index] do
      member do
        post :nearbysearch
        post :create_store, path: 'create-store'
        post :deny
      end
    end
  end

  resources :stores, only: [:index, :show]
end
