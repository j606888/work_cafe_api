json.stores do
  json.array!(stores) do |store|
    json.(store, :id, :name, :image_url, :address, :city, :district, :phone, :rating, :lat, :lng, :url)
  end
end

json.partial! 'layouts/paging', resources: stores
