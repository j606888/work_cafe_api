class Admin::StoresController < Admin::ApplicationController
  skip_before_action :authenticate_admin!

  def index
    stores = StoreService::Query.call(**{
      page: helpers.to_integer(params[:page]),
      per: helpers.to_integer(params[:per]),
      cities: params[:cities],
      rating: helpers.to_float(params[:rating]),
      order: params[:order],
      order_by: params[:order_by]
    }.compact)

    render 'index', locals: { stores: stores }
  end

  def show
    store = StoreService::QueryOne.call(
      place_id: params.require(:id)
    )
    opening_hours = OpeningHourService::QueryByStore.call(
      store_id: store.id
    )

    render 'show', locals: { store: store, opening_hours: opening_hours }
  end
end
