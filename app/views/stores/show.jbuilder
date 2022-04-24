json.(store, :id, :name, :image_url, :address, :phone, :url, :website, :rating, :user_ratings_total, :created_at, :updated_at)

source = store.sourceable.source_data
json.source_data do
  json.reviews source['reviews'] || []
  json.opening_hours store_opening_hours(source['opening_hours'])
end 
