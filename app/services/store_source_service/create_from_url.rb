class StoreBlacklistException < StandardError; end

class StoreSourceService::CreateFromUrl < Service
  GOOGLE_MAP_PREFIX = "maps/place"

  def initialize(user_id:, url:)
    @user_id = user_id
    @url = url
  end

  def perform
    matched = parse_from_url(@url)
    place = google_map_nearbysearch(matched[:keyword], matched[:location])

    validate_not_blacklist(place.name)
    store_source = create_store_source(place)

    if should_auto_pass?(place.types)
      # TODO, these should be done in another service
      detail = google_map_detail(place.place_id)
      store = create_store(store_source, detail)
      save_opening_hours(store, detail.open_periods)

      store_source.do_bind
      store_source.update!(source_data: detail.data)
    end
  end

  private

  def parse_from_url(url)
    readable_url = CGI.unescape(url)
    captured = %r{maps/place/(?<keyword>.*)/@(?<location>.*),\d+.?\d*z/}
    match = readable_url.match(captured)
    if match.nil?
      raise Service::PerformFailed, "Url parsed failed, url: `#{readable_url}`"
    end

    {
      keyword: match['keyword'],
      location: match['location']
    } 
  end
  
  def google_map_nearbysearch(keyword, location)
    GoogleMapPlace.nearbysearch(
      keyword: keyword,
      location: location,
      radius: 3000
    )
  end

  def validate_not_blacklist(name)
    return unless STORE_BLACKLIST.include?(name)

    raise StoreBlacklistException, "Store name `#{name}` is in blacklist" 
  end

  def create_store_source(place)
    store_source = StoreSource.find_or_initialize_by(place_id: place.place_id)
    store_source.update!(
      name: place.name,
      source_data: place.data,
      create_type: 'user'
    )
    store_source
  end

  def should_auto_pass?(types)
    types.include?('cafe')
  end

  def google_map_detail(place_id)
    GoogleMapPlace.detail(place_id)
  end

  def create_store(store_source, detail)
    # photo = GoogleMapPlace.photo('something')

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

  def save_opening_hours(store, periods)
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
end
