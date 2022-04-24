class StoresController < ApplicationController
  def index
    stores = StoreService::QueryAll.new(**{
      city: params[:city],
      districts: params[:districts],
      page: params[:page],
      per: params[:per]
    }.compact).perform

    render 'index', locals: { stores: stores }
  end

  def show
    store = StoreService::QueryOne.new(
      id: params.require(:id)
    ).perform

    render 'show', locals: { store: store }
  end

  def search_by_location
    stores = StoreService::SearchByLocation.new(
      lat: params.require(:lat).to_f,
      lng: params.require(:lng).to_f,
      zoom: params.require(:zoom)
    ).perform

    render 'search_by_location', locals: { stores: stores }
  end
end
