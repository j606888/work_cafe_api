class MigrationService::CopyCafeNomad < Service
  def perform
    place_id_map = build_place_id_map

    res = HTTParty.get('https://cafenomad.tw/api/v1.2/cafes/tainan')
    cafenomads = res.parsed_response
    cafenomads.each do |cafenomad|
      print '.'
      store = find_and_create_store(
        name: cafenomad['name'],
        lat: cafenomad['latitude'],
        lng: cafenomad['longitude'],
        place_id_map: place_id_map
      )
      next if store.nil?

      place_id_map[store.place_id] = true
    end
  end

  private
  
  def build_place_id_map
    Store.where(city: '台南市').to_h { |store| [store.place_id, true] }
  end

  def find_and_create_store(name:, lat:, lng:, place_id_map:)
    place = GoogleMapPlace.nearbysearch(
      keyword: name,
      location: "#{lat},#{lng}",
      radius: 500
    )

    return if place_id_map[place.place_id].present?
    StoreService::Create.call(place_id: place.place_id)
  rescue GoogleMapPlace::ZeroResultsException => e
    print 'x'
  end
end
