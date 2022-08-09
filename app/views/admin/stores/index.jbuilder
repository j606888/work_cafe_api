json.stores do
  json.array!(stores) do |store|
    json.partial! 'stores/item', store: store
  end
end

json.partial! 'layouts/paging', resources: stores
