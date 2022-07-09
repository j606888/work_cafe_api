class MapUrlService::Create < Service
  include QueryHelpers::QueryUser

  def initialize(user_id:, url:)
    @user_id = user_id
    @url = url
  end

  def perform
    user = find_user_by_id(@user_id)
    map_url = MapUrl.create!(user: user, url: @url, decision: 'waiting')

    matched = parse_from_url!(@url)
    if matched.nil?
      map_url.update!(decision: 'parse_failed')
      return map_url
    end

    place = google_map_nearbysearch(matched[:keyword], matched[:location])
    map_url.update!(
      keyword: place.name,
      place_id: place.place_id,
      source_data: place.data
    )

    if place_id_exist?(map_url, place.place_id)
      map_url.update!(decision: 'already_exist')
    elsif name_is_blacklisted?(place.name)
      map_url.update!(decision: 'blacklist')
    elsif types_not_cafe?(place.types)
      map_url.update!(decision: 'waiting')
    else
      StoreService::Create.call(place_id: map_url.place_id)
      map_url.update!(decision: 'success')
    end

    map_url
  end

  private

  def parse_from_url!(url)
    readable_url = CGI.unescape(url)
    captured = %r{maps/place/(?<keyword>.*)/@(?<location>.*),\d+.?\d*z/}
    match = readable_url.match(captured)
    return if match.nil?

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

  def name_is_blacklisted?(name)
    STORE_BLACKLIST.any? do |blacklist|
      name.include?(blacklist)
    end
  end

  def types_not_cafe?(types)
    types.exclude?('cafe')
  end

  def place_id_exist?(map_url, place_id)
    MapUrl.where(place_id: place_id).where.not(id: map_url.id).present?
  end
end
