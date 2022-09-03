require 'sidekiq/web'

Rails.application.routes.draw do
  # devise_for :users
  mount Sidekiq::Web => '/sidekiq'

  namespace :auth do
    post :signup
    post :login
    post :refresh
    post :google, action: 'google_sign_in'
  end

  namespace :admin do
    resources :map_crawlers, path: 'map-crawlers', only: [:create, :index]
    resources :stores, only: [:index, :show] do
      collection do
        get :location
        post :hide_all_unqualified, path: 'hide-all-unqualified'
      end

      member do
        post :sync_photos, path: 'sync-photos'
      end
    end
    resources :blacklists, only: [:index, :create, :destroy]
    resources :users, only: [:index]
  end

  resources :stores, only: [:show] do
    collection do
      get :hint
      get :location
      get :hidden
    end

    member do
      post :hide
      post :unhide
    end
  end

  resources :bookmarks, only: [:create]

  get 'hello', to: 'hello#index'

  root to: "hello#index"
end
