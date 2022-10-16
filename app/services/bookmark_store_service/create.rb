class BookmarkStoreService::Create < Service
  include QueryHelpers::QueryBookmark
  include QueryHelpers::QueryStore

  def initialize(store_id:, bookmark_id:)
    @store_id = store_id,
    @bookmark_id = bookmark_id
  end

  def perform
    store = find_store_by_id(@store_id)
    bookmark = find_bookmark_by_id(@bookmark_id)

    BookmarkStore.create!(
      store: store,
      bookmark: bookmark
    )
  end
end
