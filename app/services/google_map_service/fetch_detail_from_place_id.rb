class GoogleMapService::FetchDetailFromPlaceId < Service
  def initialize(place_id:)
    @place_id = place_id
  end

  def perform
    res = GoogleMap.new.place_detail(@place_id)

    store = ActiveRecord::Base.transaction do
      store = save_store!(res)
      save_opening_hours(store, res['opening_hours']['periods'])
      store
    end
    store
  end

  private
  def save_store!(res)
    store = Store.find_or_initialize_by(place_id: res['place_id'])
    params = {
      name: res['name'],
      address: res['formatted_address'],
      phone: res['formatted_phone_number'],
      location_lat: res['geometry']['location']['lat'],
      location_lng: res['geometry']['location']['lng'],
      rating: res['rating'],
      user_ratings_total: res['user_ratings_total'],
      url: res['url'],
      website: res['website'],
      source_data: res
    }.compact
    binding.pry

    store.update!(params)
    store
  end

  def save_opening_hours(store, periods)
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
end
