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
    bookmarks = current_user.bookmarks

    bookmark_stores_map = {}
    if params[:place_id].present?
      store = StoreService::QueryOne.call(
        place_id: params[:place_id]
      )
      bookmark_stores = BookmarkStore.where(bookmark: bookmarks, store: store)
      bookmark_stores_map = bookmark_stores.pluck(:bookmark_id).index_with(true)
    end

    render 'index', locals: {
      bookmarks: bookmarks,
      bookmark_stores_map: bookmark_stores_map
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
