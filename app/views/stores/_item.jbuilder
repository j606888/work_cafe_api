json.(store, :id, :place_id, :name, :address, :vicinity, :city, :district, :phone, :url, :website, :rating, :user_ratings_total, :image_url, :lat, :lng, :permanently_closed, :hidden, :created_at, :updated_at)

if defined?(store_photos)
  json.photos store_photos.map(&:image_url)
end
