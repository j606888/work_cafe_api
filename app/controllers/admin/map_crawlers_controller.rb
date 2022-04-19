class Admin::MapCrawlersController < Admin::ApplicationController
  def index
    map_crawlers = MapCrawlerService::QueryAll.new(**{
      page: params[:page],
      per: params[:per],
      status: params[:status]
    }.compact).perform

    render 'index', locals: { map_crawlers: map_crawlers }
  end
end
