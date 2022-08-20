class MapCrawlerService::Create < Service
  MIN_RADIUS = 100
  MAX_RADIUS = 2000
  MAX_LOOP_COUNT = 5

  def initialize(user_id:, lat:, lng:, radius:)
    @user_id = user_id
    @lat = lat
    @lng = lng
    @radius = radius
  end

  def perform
    new_store_count = 0
    repeat_store_count = 0
    blacklist_store_count = 0

    memo, result_radius = fetch_places_from_google(
      lat: @lat,
      lng: @lng,
      radius: @radius
    )

    memo.each do |place|
      if name_is_blacklisted?(place[:name])
        blacklist_store_count += 1
      elsif place_id_exist?(place[:place_id])
        repeat_store_count += 1
      else
        new_store_count += 1
        StoreService::Create.call(place_id: place[:place_id])
      end
    end

    MapCrawler.create!(
      user_id: @user_id,
      lat: @lat,
      lng: @lng,
      radius: result_radius,
      total_found: memo.length,
      new_store_count: new_store_count,
      repeat_store_count: repeat_store_count,
      blacklist_store_count: blacklist_store_count
    )
  end

  private

  def fetch_places_from_google(lat:, lng:, radius:)
    validate_radius(radius)

    memo = []
    res = GoogleMapPlace.cafe_search(
      location: [lat, lng].join(","),
      radius: radius
    )
    loop_count = 0
    loop do
      memo += res.places
      sleep(2)
      res = res.next_page
      break if res.nil?

      loop_count += 1
      if loop_count > MAX_LOOP_COUNT
        raise Service::PerformFailed, "Over max loop count" 
      end
    end

    if memo.length >= 60
      fetch_places_from_google(
        lat: lat,
        lng: lng,
        radius: radius - 200
      )
    else
      [memo, radius]
    end
  rescue GoogleMapPlace::ZeroResultsException => e
    return [[], radius]
  end

  def validate_radius(radius)
    return if radius >= MIN_RADIUS && radius <= MAX_RADIUS

    raise Service::PerformFailed, "Radius `#{radius}` invalid"
  end

  def name_is_blacklisted?(name)
    Blacklist.keywords.any? do |blacklist|
      name.include?(blacklist)
    end
  end

  def place_id_exist?(place_id)
    Store.exists?(place_id: place_id)
  end
end
