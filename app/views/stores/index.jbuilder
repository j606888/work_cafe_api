json.stores do
  json.array!(stores) do |store|
    json.(store, :id, :name, :address, :phone, :rating, :location_lat, :location_lng, :url)
  end
end

json.partial! 'layouts/paging', resources: stores
