class UserBookmarksController < ApplicationController
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
