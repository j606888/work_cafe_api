class User::MapUrlsController < User::ApplicationController
  def index
    map_urls = MapUrlService::Query.call(**{
      user_id: current_user.id,
      per: params[:per],
      page: params[:page],
      decision: params[:decision]
    }.compact)

    render 'index', locals: { map_urls: map_urls }
  end

  def create
    map_url = MapUrlService::Create.call(
      user_id: current_user.id,
      url: params.require(:url)
    )

    render json: map_url
  end
end
