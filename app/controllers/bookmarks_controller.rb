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

    render json: bookmarks
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
