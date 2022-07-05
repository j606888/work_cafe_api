class StoreSourceService::CreateStore < Service
  def initialize(store_source_id:)
    @store_source_id = store_source_id
  end

  def perform
    store_source = query_store_source(@store_source_id)
    detail = fetch_google_map_detail(store_source.place_id)

    ActiveRecord::Base.transaction do
      store = create_store(store_source, detail)
      create_opening_hours(store, detail.open_periods)
      bind_store_source(store_source, detail)
    end
  end

  private

  def query_store_source(store_source_id)
    store_source = StoreSource.find_by(id: store_source_id)
    return store_source if store_source.present?

    raise Service::PerformFailed, "StoreSource with id `#{store_source_id}` not found"
  end

  def fetch_google_map_detail(place_id)
    GoogleMapPlace.detail(place_id)
  end

  def create_store(store_source, detail)
    store = Store.find_or_initialize_by(
      sourceable_type: 'StoreSource',
      sourceable_id: store_source.id,
    )
    store.update!(
      name: detail.name,
      address: detail.address,
      phone: detail.phone,
      url: detail.url,
      website: detail.website,
      rating: detail.rating,
      user_ratings_total: detail.user_ratings_total,
      lat: detail.lat,
      lng: detail.lng,
      city: detail.city,
      district: detail.district,
    )
    store
  end

  def create_opening_hours(store, periods)
    return if periods.blank? || store_never_close?(periods)
    store.opening_hours.delete_all

    periods.each do |period|
      OpeningHour.create!(
        store: store,
        open_day: period['open']['day'],
        open_time: period['open']['time'],
        close_day: period['close']['day'],
        close_time: period['close']['time']
      )
    end
  end

  def store_never_close?(periods)
    periods.length == 1 && periods.first['close'].nil?
  end

  def bind_store_source(store_source, detail)
    store_source.update!(
      aasm_state: 'binded',
      source_data: detail.data
    )
  end
end
