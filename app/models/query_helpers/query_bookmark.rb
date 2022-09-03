module QueryHelpers::QueryBookmark
  def find_bookmark_by_id(id)
    bookmark = Bookmark.find_by(id: id)
    return bookmark if bookmark.present?

    raise ActiveRecord::RecordNotFound, "Bookmark with id `#{id}` not found"
  end

  def find_bookmark_by_random_key(random_key)
    bookmark = Bookmark.find_by(random_key: random_key)
    return bookmark if bookmark.present?

    raise ActiveRecord::RecordNotFound, "Bookmark with random_key `#{random_key}` not found"
  end
end
