class Admin::MapCrawlersController < Admin::ApplicationController
  skip_before_action :authenticate_admin!

  def create
    map_crawler = MapCrawlerService::Create.call(
      user_id: User.last.id,
      lat: params.require(:lat),
      lng: params.require(:lng),
      radius: params.require(:radius)
    )

    render json: map_crawler
  end

  def index
    map_crawlers = MapCrawlerService::Query.call(
      lat: params.require(:lat).to_f,
      lng: params.require(:lng).to_f
    )

    render json: map_crawlers
  end
end
