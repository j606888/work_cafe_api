json.stores do
  json.array!(stores) do |store|
    json.(store, :id, :name, :address, :phone, :rating, :lat, :lng, :url)
  end
end
