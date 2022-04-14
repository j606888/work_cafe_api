class User::MapUrlsController < User::ApplicationController
  def create
    map_url = UserService::CreateMapUrl.new(
      user_id: current_user.id,
      url: params.require(:url)
    ).perform

    render json: map_url
  end
end
