json.array!(stores) do |store|
  json.partial! 'stores/item', store: store
end
