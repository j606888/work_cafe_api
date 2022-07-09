class StoreBlacklistException < StandardError; end

class StoreSourceService::CreateFromUrl < Service
  GOOGLE_MAP_PREFIX = "maps/place"

  def initialize(url:)
    @url = url
  end

  def perform
    matched = parse_from_url(@url)
    place = google_map_nearbysearch(matched[:keyword], matched[:location])

    validate_not_blacklist(place.name)
    store_source = create_store_source(place)

    if should_auto_pass?(place.types)
      StoreSourceService::CreateStore.call(store_source_id: store_source.id)
    end

    store_source.reload
    store_source
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
    if StoreSource.exists?(place_id: place.place_id)
      raise Service::PerformFailed, "Place with place_id `#{place.place_id}` already exist"
    end

    StoreSource.create!(
      place_id: place.place_id,
      name: place.name,
      source_data: place.data,
      create_type: 'user'
    )
  end

  def should_auto_pass?(types)
    types.include?('cafe')
  end

end
