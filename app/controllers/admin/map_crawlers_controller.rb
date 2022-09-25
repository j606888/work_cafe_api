class Admin::MapCrawlersController < Admin::ApplicationController
  def create
    MapCrawlerService::CreateWorker.perform_async(
      current_admin.id,
      params.require(:lat),
      params.require(:lng),
      params.require(:radius)
    )

    head :ok
  end

  def index
    map_crawlers = MapCrawlerService::Query.call(**{
      lat: params.require(:lat).to_f,
      lng: params.require(:lng).to_f,
      limit: helpers.to_integer(params[:limit])
    }.compact)

    render json: map_crawlers
  end
end
