class Admin::BlacklistsController < Admin::ApplicationController
  skip_before_action :authenticate_admin!

  def index
    blacklists = BlacklistService::Query.call()

    render json: blacklists
  end

  def create
    BlacklistService::Create.call(
      keyword: params.require(:keyword)
    )

    head :ok
  end

  def destroy
    BlacklistService::Delete.call(
      id: params.require(:id)
    )

    head :ok
  end
end
