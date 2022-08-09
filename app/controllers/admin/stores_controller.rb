class Admin::StoresController < Admin::ApplicationController
  skip_before_action :authenticate_admin!

  def index
    stores = StoreService::Query.call(**{
      page: helpers.to_integer(params[:page]),
      per: helpers.to_integer(params[:per]),
      cities: params[:cities],
      rating: helpers.to_float(params[:rating])
    }.compact)

    render 'index', locals: { stores: stores }
  end
end
