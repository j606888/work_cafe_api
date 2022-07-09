class Admin::MapCrawlersController < Admin::ApplicationController
  def create
    map_crawler = MapCrawlerService::Create.call(
      user_id: current_admin.id,
      lat: params.require(:lat),
      lng: params.require(:lng),
      radius: params.require(:radius)
    )

    render json: map_crawler
  end
end
