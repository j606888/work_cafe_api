class Admin::StoresController < Admin::ApplicationController
  def index
    stores = StoreService::Query.call(**{
      page: helpers.to_integer(params[:page]),
      per: helpers.to_integer(params[:per]),
      cities: params[:cities],
      rating: helpers.to_float(params[:rating]),
      order: params[:order],
      order_by: params[:order_by],
      ignore_hidden: params[:ignore_hidden] == 'true'
    }.compact)

    render 'index', locals: { stores: stores }
  end

  def location
    stores = StoreService::QueryByLocation.call(**{
      lat: helpers.to_float(params.require(:lat)),
      lng: helpers.to_float(params.require(:lng)),
      limit: helpers.to_integer(params[:limit])
    }.compact)

    render 'location', locals: { stores: stores }
  end

  def show
    store = StoreService::QueryOne.call(
      place_id: params.require(:id)
    )
    opening_hours = OpeningHourService::QueryByStore.call(
      store_id: store.id
    )
    is_open_now = StoreService::IsOpenNow.call(
      store_id: store.id
    )
    store_photos = store.store_photos

    render 'show', locals: {
      store: store,
      opening_hours: opening_hours,
      is_open_now: is_open_now,
      store_photos: store_photos
    }
  end

  def hide_all_unqualified
    StoreService::HideAllUnqualified.call

    head :ok
  end
end
