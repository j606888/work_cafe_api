class BookmarkService::CreateDefaults < Service
  include QueryHelpers::QueryUser

  DEFAULT_BOOKMARK_ATTRS = [
    {
      category: 'favorite',
      name: '喜愛的地點'
    },
    {
      category: 'interest',
      name: '想去的地點'
    }
  ]  

  def initialize(user_id:)
    @user_id = user_id
  end

  def perform
    user = find_user_by_id(@user_id)
    validate_default_not_exist!(user)

    DEFAULT_BOOKMARK_ATTRS.each do |attr|
      Bookmark.create!(
        category: attr[:category],
        name: attr[:name],
        user: user
      )
    end
  end

  private

  def validate_default_not_exist!(user)
    return if Bookmark.where(user: user).empty?

    raise Service::PerformFailed, "Bookmarks for user `#{user.id}` already exist"
  end
end
