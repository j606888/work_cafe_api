json.array!(stores) do |store|
  json.partial! 'item', store: store
  json.open_now open_now_map[store.id]
end
