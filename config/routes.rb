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
    # resources :stores, only: [:index, :show]
    resources :stores, only: [] do
      member do
        post :toggle_favorite, path: 'toggle-favorite'
      end

      collection do
        get :favorites
      end
    end
  end

  namespace :admin do
    resources :map_urls, only: [:index] do
      member do
        post :nearbysearch
        post :create_store, path: 'create-store'
        post :deny
      end
    end
    resources :map_crawlers, only: [:index, :show] do
      member do
        post :bind
        post :deny
      end

      collection do
        post :search
      end
    end
  end

  resources :stores, only: [:index, :show] do
    collection do
      get :search_by_location, path: 'search-by-location'
    end
  end
end
