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

  def hide_all_unqualified
    StoreService::HideAllUnqualified.call

    head :ok
  end

  def sync_photos
    store = StoreService::QueryOne.call(
      place_id: params.require(:id)
    )
    StorePhotoService::CreateFromGoogle.call(
      store_id: store.id
    )

    head :ok
  end
end
