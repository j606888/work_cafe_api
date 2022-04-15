class Admin::MapUrlsController < Admin::ApplicationController
  def index
    map_urls = AdminService::QueryMapUrls.new(**{
      per: params[:per],
      page: params[:page],
      state: params[:state]
    }.compact).perform

    render 'index', locals: { map_urls: map_urls }
  end

  def nearbysearch
    res = AdminService::Nearbysearch.new(
      map_url_id: params.require(:id)
    ).perform
    render json: res
  end

  def create_store
    store = AdminService::CreatePlaceFromMapUrl.new(
      map_url_id: params.require(:id),
      place_id: params.require(:place_id)
    ).perform

    render json: store
  end

  def deny
    AdminService::DenyMapUrl.new(
      map_url_id: params.require(:id)
    ).perform

    head :ok
  end
end
