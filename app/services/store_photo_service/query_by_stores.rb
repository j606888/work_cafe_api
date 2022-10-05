class StorePhotoService::QueryByStores < Service
  def initialize(store_ids:)
    @store_ids = store_ids
  end

  def perform
    store_photos = StorePhoto.where(store_id: @store_ids)
    store_photos.group_by(&:store_id)
  end
end
