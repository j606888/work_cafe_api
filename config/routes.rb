Rails.application.routes.draw do
  # devise_for :users
  namespace :google_map do
    post :parse_place_id
  end

  namespace :auth do
    post :signup
    post :login
  end
end
