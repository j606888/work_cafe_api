class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    BookmarkService::Create.call(
      user_id: current_user.id,
      name: params.require(:name)
    )

    head :ok
  end
end
