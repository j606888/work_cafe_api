class UserBookmarksController < ApplicationController
  def index
    stores = current_user.user_bookmarks.includes(:store).map(&:store)

    store_ids = stores.map(&:id)
    photos_map = StorePhotoService::QueryByStores.call(
      store_ids: store_ids
    )

    render 'index', locals: {
      stores: stores,
      photos_map: photos_map
    }
  end

  def create
    UserBookmarkService::Create.call(
      user_id: current_user.id,
      store_id: store.id
    )

    head :ok
  end

  def destroy
    UserBookmarkService::Delete.call(
      user_id: current_user.id,
      store_id: store.id
    )

    head :ok
  end

  private

  def store
    StoreService::QueryOne.call(
      place_id: params.require(:store_id)
    )
  end
end
