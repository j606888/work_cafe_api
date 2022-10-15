class StorePhotosController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def get_upload_link
    url = StorePhotoService::CreatePresignedUrl.call(**{
      store_id: store.id,
      file_extension: params[:file_extension]
    }.compact)

    render json: { url: url }
  end

  def create
    StorePhotoService::CreateFromUser.call(**{
      user_id: current_user&.id,
      store_id: store.id,
      review_id: params.require(:review_id),
      url: params.require(:url)
    }.compact)

    head :ok
  end

  private

  def store
    StoreService::QueryOne.call(
      place_id: params.require(:store_id)
    )
  end
end
