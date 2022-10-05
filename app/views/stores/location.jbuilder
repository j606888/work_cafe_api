json.array!(stores) do |store|
  json.partial! 'item', store: store
  json.open_now open_now_map[store.id]
  json.photos photos_map[store.id]&.map(&:image_url) || []
end
