Rails.application.routes.draw do
  # devise_for :users

  namespace :auth do
    post :signup
    post :login
    post :refresh
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
    resources :map_urls, only: [:index] do
      member do
        post :nearbysearch
        post :create_store, path: 'create-store'
        post :deny
      end
    end
  end

  resources :stores, only: [:index, :show] do
    collection do
      get :search_by_location, path: 'search-by-location'
    end
  end
end
