class Admin::MapCrawlersController < Admin::ApplicationController
  skip_before_action :authenticate_admin!

  def create
    MapCrawlerService::CreateWorker.perform_async(
      User.last.id,
      params.require(:lat),
      params.require(:lng),
      params.require(:radius)
    )

    head :ok
  end

  def index
    map_crawlers = MapCrawlerService::Query.call(
      lat: params.require(:lat).to_f,
      lng: params.require(:lng).to_f
    )

    render json: map_crawlers
  end
end
