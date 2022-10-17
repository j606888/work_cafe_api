class UserBookmarkService::Create < Service
  def initialize(user_id:, store_id:)
    @user_id = user_id
    @store_id = store_id
  end

  def perform
    UserBookmark.create!(
      user_id: @user_id,
      store_id: @store_id
    )
  end
end
