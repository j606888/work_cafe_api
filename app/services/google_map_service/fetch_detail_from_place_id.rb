class GoogleMapService::FetchDetailFromPlaceId < Service
  def initialize(place_id:)
    @place_id = place_id
  end

  def perform
    res = GoogleMap.new.place_detail(@place_id)

    place = ActiveRecord::Base.transaction do
      place = save_place!(res)
      save_opening_hours(place, res['opening_hours']['periods'])
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
