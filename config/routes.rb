Rails.application.routes.draw do
  # devise_for :users
  namespace :google_map do
    post :parse_place_id
  end

  namespace :auth do
    post :signup
    post :login
  end

  namespace :user do
    resource :me, controller: :me, only: [:show]
  end

  resources :places, only: [:index, :show]
end
