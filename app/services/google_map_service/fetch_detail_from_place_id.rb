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
  end
end
