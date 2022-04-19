class Admin::MapCrawlersController < Admin::ApplicationController
  def index
    map_crawlers = MapCrawlerService::QueryAll.new(**{
      page: params[:page],
      per: params[:per],
      status: params[:status]
    }.compact).perform

    render 'index', locals: { map_crawlers: map_crawlers }
  end

  def bind
    MapCrawlerService::Bind.new(
      params.require(:id)
    ).perform

    head :ok
  end

  def deny
    MapCrawlerService::Deny.new(
      params.require(:id)
    ).perform

    head :ok
  end

  def show
    map_crawler = MapCrawler.find(params.require(:id))
    render json: map_crawler
  end
end
