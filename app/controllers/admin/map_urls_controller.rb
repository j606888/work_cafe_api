class Admin::MapUrlsController < Admin::ApplicationController
  def index
    map_urls = AdminService::QueryMapUrls.new(**{
      per: params[:per],
      page: params[:page]
    }.compact).perform

    render 'index', locals: { map_urls: map_urls }
  end

  def nearbysearch
    res = AdminService::Nearbysearch.new(
      map_url_id: params.require(:id)
    ).perform
    render json: res
  end
end
