class AdminService::CreatePlaceFromMapUrl < Service
  def initialize(map_url_id:, name:, place_id:)
    @map_url_id = map_url_id
    @name = name
    @place_id = place_id
  end

  def perform
    map_url = query_map_url!(@map_url_id)
    validate_map_url!(map_url, @name)

    res = GoogleMap.new.place_detail(@place_id)
    ActiveRecord::Base.transaction do
      store = save_store!(map_url, res)
      save_opening_hours(store, res['opening_hours']['periods'])
      map_url.do_accept!
      map_url.update!(place_id: store.place_id)

      store
    end
  end

  private
  def query_map_url!(map_url_id)
    map_url = MapUrl.find_by(id: map_url_id)

    if map_url.nil?
      raise Service::PerformFailed, "MapUrl with id `#{map_url_id}` not found"
    end

    map_url
  end

  def validate_map_url!(map_url, name)
    if map_url.store.present?
      raise Service::PerformFailed, "map_url with id `#{map_url.id}` already bind store"
    end

    if map_url.keyword != name
      raise Service::PerformFailed, "map_url with id `#{map_url.id}` not match name `#{name}`"
    end
  end

  def save_store!(map_url, res)
    store = Store.find_or_initialize_by(place_id: res['place_id'])
    params = {
      map_url: map_url,
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
