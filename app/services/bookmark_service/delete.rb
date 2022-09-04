class BookmarkService::Delete < Service
  def initialize(user_id:, bookmark_random_key:)
    @user_id = user_id
    @bookmark_random_key = bookmark_random_key
  end

  def perform
    bookmark = BookmarkService::QueryOne.call(
      user_id: @user_id,
      bookmark_random_key: @bookmark_random_key
    )

    if bookmark.category != 'custom'
      raise Service::PerformFailed, "Only custom bookmark can be delete"
    end

    bookmark.destroy
  end
end
