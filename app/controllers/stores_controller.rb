class StoresController < ApplicationController
  before_action :authenticate_user!, only: [:hide, :unhide, :hidden]

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
      tag_ids: params[:tag_ids]
    }.compact)
    sorted_stores = StoreService::SortedStores.call(stores: stores)

    store_ids = stores.map(&:id)

    open_now_map = OpeningHourService::IsOpenNowMap.call(
      store_ids: store_ids
    )
    photos_map = StorePhotoService::QueryByStores.call(
      store_ids: store_ids
    )
    tag_map = TagService::BuildStoreTagMap.call(
      store_ids: store_ids
    )
    recommend_count_map = Review.where(
      store_id: store_ids,
      recommend: 'yes'
    ).group(:store_id)
      .count
    wake_up_map = Review.where(store_id: store_ids).pluck(:store_id).uniq.index_with(true)

    render 'location', locals: {
      stores: sorted_stores,
      open_now_map: open_now_map,
      photos_map: photos_map,
      tag_map: tag_map,
      recommend_count_map: recommend_count_map,
      wake_up_map: wake_up_map
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
    open_period = StoreService::IsOpenNow.call(
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
    tag_map = TagService::BuildStoreTagMap.call(store_ids: [store.id])
    is_bookmark = UserBookmark.exists?(
      user: current_user,
      store: store
    )

    render 'show', locals: {
      store: store,
      opening_hours: opening_hours,
      open_period: open_period,
      store_photos: store_photos,
      reviews: reviews,
      is_hide: is_hide,
      is_review: is_review,
      review_report: review_report,
      tags: tag_map[store.id] || [],
      is_bookmark: is_bookmark
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
end
