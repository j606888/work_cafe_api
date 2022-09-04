json.array!(bookmarks) do |bookmark|
  json.partial! 'bookmarks/item', bookmark: bookmark
  json.store_count bookmark.store_count
end

