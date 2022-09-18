json.store_photo_groups do
  json.array!(store_photo_groups) do |store_photo_group|
    json.(store_photo_group, :id, :created_at, :updated_at)
    json.photos do
      json.array!(store_photo_group.store_photos) do |store_photo|
        json.(store_photo, :id, :random_key, :image_url)
      end
    end

    json.store do
      json.partial! 'stores/item', store: store_photo_group.store
    end
  end
end
json.partial! 'layouts/paging', resources: store_photo_groups
