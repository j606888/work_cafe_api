json.array!(stores) do |store|
  json.partial! 'item', store: store
end
