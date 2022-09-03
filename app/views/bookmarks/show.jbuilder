json.(bookmark, :random_key, :name, :category)
json.stores do
  json.array!(stores) do |store|
    json.partial! 'stores/item', store: store
  end
end
