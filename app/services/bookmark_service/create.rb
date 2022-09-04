class BookmarkService::Create < Service
  include QueryHelpers::QueryUser

  def initialize(user_id:, name:)
    @user_id = user_id
    @name = name
  end

  def perform
    user = find_user_by_id(@user_id)
    Bookmark.create!(
      user: user,
      name: @name,
      category: 'custom'
    )
  end
end
