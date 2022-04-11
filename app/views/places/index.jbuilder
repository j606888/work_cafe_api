json.places do
  json.array!(places) do |place|
    json.(place, :id, :name, :address, :phone, :rating)
  end
end

json.partial! 'layouts/paging', resources: places
