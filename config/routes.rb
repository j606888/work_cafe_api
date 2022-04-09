Rails.application.routes.draw do
  namespace :google_map do
    post :parse_place_id
  end
end
