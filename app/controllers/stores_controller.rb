class StoresController < ApplicationController
  before_action :authenticate_user!, only: [:hide, :unhide, :hidden, :bookmarks, :add_to_bookmark, :remove_from_bookmark]

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
      user_id: current_user&.id,
      lat: helpers.to_float(params.require(:lat)),
      lng: helpers.to_float(params.require(:lng)),
      limit: helpers.to_integer(params[:limit]),
      keyword: params[:keyword],
      open_type: params[:open_type],
      open_week: helpers.to_integer(params[:open_week]),
      open_hour: helpers.to_integer(params[:open_hour]),
      wake_up: helpers.to_boolean(params[:wake_up]),
      recommend: params[:recommend],
      room_volume: params[:room_volume],
      time_limit: params[:time_limit],
      socket_supply: params[:socket_supply],
      explore_mode: helpers.to_boolean(params[:explore_mode])
    }.compact)

    open_now_map = OpeningHourService::IsOpenNowMap.call(
      store_ids: stores.map(&:id)
    )
    photos_map = StorePhotoService::QueryByStores.call(
      store_ids: stores.map(&:id)
    )

    render 'location', locals: {
      stores: stores,
      open_now_map: open_now_map,
      photos_map: photos_map
    }
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
    review_report = StoreService::ReviewReport.call(
      store_id: store.id
    )
    store_photos = store.store_photos
    is_hide = UserHiddenStore.find_by(
      user: current_user,
      store: store
    ).present?
    is_review = Review.exists?(
      user: current_user,
      store: store
    )

    render 'show', locals: {
      store: store,
      opening_hours: opening_hours,
      is_open_now: is_open_now,
      store_photos: store_photos,
      reviews: reviews,
      is_hide: is_hide,
      is_review: is_review,
      review_report: review_report
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

    render 'location', locals: { stores: stores, open_now_map: open_now_map,  photos_map: {} }
  end

  def bookmarks
    bookmarks = current_user.bookmarks
    store = StoreService::QueryOne.call(
      place_id: params.require(:id)
    )
    bookmark_stores = BookmarkStore.where(bookmark: bookmarks, store: store)
    bookmark_stores_map = bookmark_stores.pluck(:bookmark_id).index_with(true)

    render 'bookmarks', locals: {
      bookmarks: bookmarks,
      bookmark_stores_map: bookmark_stores_map
    }
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
    store = StoreService::QueryOne.call(
      place_id: params.require(:id)
    )
    bookmark = BookmarkService::QueryOne.call(
      user_id: current_user.id,
      bookmark_random_key: params.require(:bookmark_random_key)
    )
    BookmarkStoreService::Delete.call(
      store_id: store.id,
      bookmark_id: bookmark.id
    )

    head :ok
  end
end
