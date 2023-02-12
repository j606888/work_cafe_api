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
    resources :stores, only: [:index] do
      collection do
        post :hide_all_unqualified, path: 'hide-all-unqualified'
      end

      member do
        post :sync_photos, path: 'sync-photos'
      end
    end
    resources :chain_stores, path: 'chain-stores', only: [:index]
    resources :users, only: [:index]
    namespace :report do
      get :dashboard
    end
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

    resources :reviews, only: [:create] do
      collection do
        get '/', action: :store_reviews
        delete '/', action: :destroy
        get 'me'
      end
    end

    resources :store_photos, path: 'store-photos', only: [:create] do
      collection do
        get '/upload-link', action: :get_upload_link
      end
    end

    resources :not_cafe_reports, path: 'not-cafe-reports', only: [:create]

    resources :user_bookmarks, path: 'user-bookmarks', only: [:create] do
      collection do
        delete '/', action: :destroy
      end
    end
  end

  resources :reviews, only: [:index]
  # resources :store_photos, path: 'store-photos', only: [:index]
  resources :tags, only: [:index]
  resources :user_bookmarks, path: 'user-bookmarks', only: [:index]

  get 'hello', to: 'hello#index'

  root to: "hello#index"
end
