Rails.application.routes.draw do
  # devise_for :users

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
    resources :map_crawlers, only: [:create]
  end

  resources :stores, only: [:index, :show] do
    collection do
      get :search_by_location, path: 'search-by-location'
    end
  end
end
