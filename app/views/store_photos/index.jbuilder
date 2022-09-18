json.store_photo_groups do
  json.array!(store_photo_groups) do |store_photo_group|
    json.id store_photo_group.id
    json.created_at store_photo_group.created_at.to_i
    json.updated_at store_photo_group.updated_at.to_i

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
