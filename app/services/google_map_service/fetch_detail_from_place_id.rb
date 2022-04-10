class GoogleMapService::FetchDetailFromPlaceId < Service
  HOST = 'https://maps.googleapis.com'
  PATH = '/maps/api/place/details/json'
  KEY = ENV['GOOGLE_MAP_API_KEY']

  def initialize(place_id:)
    @place_id = place_id
  end

  def perform
    query_string = {
      place_id: @place_id,
      key: KEY,
      language: 'zh-TW'
    }.to_param

    res = HTTParty.get("#{HOST}#{PATH}?#{query_string}")
    place = ActiveRecord::Base.transaction do
      place = save_place!(res['result'])
      save_opening_hours(place, res['result']['opening_hours']['periods'])
      place
    end
    place
  end

  private
  def save_place!(res)
    place = Place.find_or_initialize_by(external_id: res['place_id'])
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

    place.update!(params)
    place
  end

  def save_opening_hours(place, periods)
    place.opening_hours.delete_all
    periods.each do |period|
      OpeningHour.create!(
        place: place,
        open_day: period['open']['day'],
        open_time: period['open']['time'],
        close_day: period['close']['day'],
        close_time: period['close']['time']
      )
    end
  end
end
