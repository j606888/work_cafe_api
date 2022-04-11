json.stores do
  json.array!(stores) do |store|
    json.(store, :id, :name, :address, :phone, :rating)
  end
end

json.partial! 'layouts/paging', resources: stores
