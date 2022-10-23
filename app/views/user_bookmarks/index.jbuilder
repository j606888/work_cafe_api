json.array!(stores) do |store|
  json.partial! 'stores/item', store: store
  json.photos photos_map[store.id]&.map(&:image_url) || []
end
