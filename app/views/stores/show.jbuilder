json.(store, :id, :name, :image_url, :address, :phone, :url, :website, :rating, :user_ratings_total, :created_at, :updated_at)

json.opening_hours store.opening_hours do |opening_hour|
  json.(opening_hour, :id, :open_day, :open_time, :close_day, :close_time)
end

source = store.sourceable.source_data
json.source_data do
  json.reviews source['reviews'] || []
end 
