class User::MapUrlsController < User::ApplicationController
  def index
    map_urls = UserService::QueryMapUrls.new(**{
      user_id: current_user.id,
      per: params[:per],
      page: params[:page],
      status: params.require(:status)
    }.compact).perform

    render 'index', locals: { map_urls: map_urls }
  end

  def create
    map_url = UserService::CreateMapUrl.new(
      user_id: current_user.id,
      url: params.require(:url)
    ).perform

    render json: map_url
  end
end
