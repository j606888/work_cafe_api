class Admin::BlacklistController < Admin::ApplicationController
  skip_before_action :authenticate_admin!

  def index
    blacklists = BlacklistService::Query.call()

    render json: blacklists
  end
end
