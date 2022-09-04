class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    BookmarkService::Create.call(
      user_id: current_user.id,
      name: params.require(:name)
    )

    head :ok
  end

  def index
    bookmarks = Bookmark.select("bookmarks.*, count(bookmark_stores.bookmark_id) AS store_count")
      .left_joins(:bookmark_stores)
      .where(user_id: current_user.id)
      .order("bookmarks.id asc")
      .group("bookmarks.id")

    render 'index', locals: {
      bookmarks: bookmarks,
    }
  end

  def show
    bookmark = BookmarkService::QueryOne.call(
      user_id: current_user.id,
      bookmark_random_key: params.require(:id)
    )

    render 'show', locals: { bookmark: bookmark, stores: bookmark.stores }
  end

  def destroy
    BookmarkService::Delete.call(
      user_id: current_user.id,
      bookmark_random_key: params.require(:id)
    )

    head :ok
  end
end
