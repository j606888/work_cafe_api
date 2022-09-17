class StorePhotosController < ApplicationController
  before_action :authenticate_user!, only: [:get_upload_link, :create, :index]

  def get_upload_link
    url = StorePhotoService::CreatePresignedUrl.call(**{
      store_id: store.id,
      file_extension: params[:file_extension]
    }.compact)

    render json: { url: url }
  end

  def create
    StorePhotoService::CreateFromUser.call(
      user_id: current_user.id,
      store_id: store.id,
      url: params.require(:url)
    )

    head :ok
  end

  def index
    store_photos = StorePhotoService::Query.call(**{
      user_id: current_user.id,
      per: params[:per],
      page: params[:page]
    }.compact)

    render 'index', locals: {
      store_photos: store_photos
    }
  end


  private

  def store
    StoreService::QueryOne.call(
      place_id: params.require(:store_id)
    )
  end
end
