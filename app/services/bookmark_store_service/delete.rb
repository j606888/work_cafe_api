class BookmarkStoreService::Delete < Service
  def initialize(store_id:, bookmark_id:)
    @store_id = store_id,
    @bookmark_id = bookmark_id
  end

  def perform
    bookmark_store = BookmarkStore.find_by(
      store_id: @store_id,
      bookmark_id: @bookmark_id
    )
    if bookmark_store.nil?
      raise Service::PerformFailed, "BookmarkStore with store_id `#{@store_id}`, bookmark_id `#{@bookmark_id}` not found"
    end

    bookmark_store.delete
  end
end
