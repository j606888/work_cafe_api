json.array!(stores) do |store|
  json.partial! 'item', store: store
  json.open_now open_now_map[store.id]
  json.photos photos_map[store.id]&.map(&:image_url) || []
  json.tags tag_map[store.id] || []
  json.recommend_count recommend_count_map[store.id] || 0
  json.wake_up wake_up_map[store.id]
end
