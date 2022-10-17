class UserBookmarkService::Delete < Service
  def initialize(user_id:, store_id:)
    @user_id = user_id
    @store_id = store_id
  end

  def perform
    user_bookmark = UserBookmark.find_by(
      user_id: @user_id,
      store_id: @store_id
    )

    if user_bookmark.present?
      user_bookmark.delete
    end
  end
end
