json.(store, :id, :place_id, :name, :address, :city, :district, :phone, :url, :website, :rating, :user_ratings_total, :image_url, :lat, :lng, :permanently_closed, :hidden, :wake_up, :created_at, :updated_at)

if defined?(store_photos)
  json.photos store_photos.map(&:image_url)
end
