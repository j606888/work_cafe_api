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

  namespace :user do
    resource :me, controller: :me, only: [:show]
    resources :map_urls, only: [:index, :create]
    resources :favorites, only: [:index, :show] do
      post :toggle, on: :collection
    end
    resources :hiddens, only: [:index, :create]
    resources :store_sources, path: 'store-sources', only: [:create]
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
  end

  resources :stores, only: [:index, :show] do
    collection do
      get :search_by_location, path: 'search-by-location'
    end
  end

  get 'hello', to: 'hello#index'

  root to: "hello#index"
end
