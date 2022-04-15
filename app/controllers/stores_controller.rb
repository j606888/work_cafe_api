class StoresController < ApplicationController
  def index
    stores = StoreService::QueryAll.new(**{
      page: params[:page],
      per: params[:per]
    }.compact).perform

    render 'index', locals: { stores: stores }
  end

  def show
    store = StoreService::QueryOne.new(
      id: params.require(:id)
    ).perform

    render json: store
  end

  def search_by_location
    stores = StoreService::SearchByLocation(
      lat: params.require(:lat),
      lng: params.require(:lng),
      zoom: params.require(:zoom)
    )

    render 'index', locals: { stores: stores }
  end
end
