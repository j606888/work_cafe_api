json.stores do
  json.array!(stores) do |store|
    json.(store, :id, :name, :image_url, :address, :city, :district, :phone, :rating, :lat, :lng, :url, :user_ratings_total)
  end
end

json.partial! 'layouts/paging', resources: stores
