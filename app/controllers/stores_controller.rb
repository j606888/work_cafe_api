class StoresController < ApplicationController
  before_action :authenticate_user!, only: [:hide, :hidden]

  def hint
    results = StoreService::BuildSearchHint.call(**{
      lat: helpers.to_float(params[:lat]),
      lng: helpers.to_float(params[:lng]),
      keyword: params.require(:keyword),
      open_type: params[:open_type],
      open_week: helpers.to_integer(params[:open_week]),
      open_hour: helpers.to_integer(params[:open_hour]),
    }.compact)

    render json: { results: results }
  end

  def location
    stores = StoreService::QueryByLocation.call(**{
      mode: 'address',
      user_id: current_user.id,
      lat: helpers.to_float(params.require(:lat)),
      lng: helpers.to_float(params.require(:lng)),
      limit: helpers.to_integer(params[:limit]),
      keyword: params[:keyword],
      open_type: params[:open_type],
      open_week: helpers.to_integer(params[:open_week]),
      open_hour: helpers.to_integer(params[:open_hour]),
    }.compact)

    open_now_map = OpeningHourService::IsOpenNowMap.call(
      store_ids: stores.map(&:id)
    )

    render 'location', locals: { stores: stores, open_now_map: open_now_map }
  end

  def show
    store = StoreService::QueryOne.call(
      place_id: params.require(:id)
    )
    reviews = store.store_source.source_data['reviews'] || []
    opening_hours = OpeningHourService::QueryByStore.call(
      store_id: store.id
    )
    is_open_now = StoreService::IsOpenNow.call(
      store_id: store.id
    )
    store_photos = store.store_photos
    is_hide = UserHiddenStore.find_by(
      user: current_user,
      store: store
    ).present?

    render 'show', locals: {
      store: store,
      opening_hours: opening_hours,
      is_open_now: is_open_now,
      store_photos: store_photos,
      reviews: reviews,
      is_hide: is_hide
    }
  end

  def hide
    store = StoreService::QueryOne.call(
      place_id: params.require(:id)
    )
    UserHiddenStoreService::Create.call(
      user_id: current_user.id,
      store_id: store.id
    )

    head :ok
  end

  def unhide
    store = StoreService::QueryOne.call(
      place_id: params.require(:id)
    )
    UserHiddenStoreService::Delete.call(
      user_id: current_user.id,
      store_id: store.id
    )

    head :ok
  end

  def hidden
    stores = UserHiddenStoreService::QueryStores.call(
      user_id: current_user.id
    )
    open_now_map = OpeningHourService::IsOpenNowMap.call(
      store_ids: stores.map(&:id)
    )

    render 'location', locals: { stores: stores, open_now_map: open_now_map }
  end

  def add_to_bookmark
    store = StoreService::QueryOne.call(
      place_id: params.require(:id)
    )
    bookmark = BookmarkService::QueryOne.call(
      user_id: current_user.id,
      bookmark_random_key: params.require(:bookmark_random_key)
    ) 
    BookmarkStoreService::Create.call(
      store_id: store.id,
      bookmark_id: bookmark.id
    )

    head :ok
  end

  def remove_from_bookmark

  end
end
