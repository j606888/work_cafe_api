class BookmarkService::QueryOne < Service
  def initialize(user_id:, bookmark_random_key:)
    @user_id = user_id
    @bookmark_random_key = bookmark_random_key
  end

  def perform
    bookmark = Bookmark.find_by(random_key: @bookmark_random_key)
    if bookmark.nil?
      raise Service::PerformFailed, "Bookmark with random_key `#{@bookmark_random_key}` not found"
    end

    if bookmark.user_id != @user_id
      raise Service::PerformFailed, "Bookmark not belongs to user `#{@user_id}`"
    end

    bookmark
  end
end
