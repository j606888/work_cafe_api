json.store_photos do
  json.array!(store_photos) do |store_photo|
    json.(store_photo, :id, :random_key, :image_url)

    json.store do
      json.partial! 'stores/item', store: store_photo.store
    end
  end
end
json.partial! 'layouts/paging', resources: store_photos
