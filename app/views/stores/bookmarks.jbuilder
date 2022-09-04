json.array!(bookmarks) do |bookmark|
  json.partial! 'bookmarks/item', bookmark: bookmark
  json.is_saved bookmark_stores_map[bookmark.id].present?
end

