json.array!(bookmarks) do |bookmark|
  json.(bookmark, :id, :name, :random_key, :category)
  json.is_saved bookmark_stores_map[bookmark.id].present?
end

