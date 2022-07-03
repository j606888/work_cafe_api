class MigrationService::CopyCafeNomad < Service
  # TODO, change tainan to more countries
  def perform
    existing_store_map = build_store_map

    res = HTTParty.get('https://cafenomad.tw/api/v1.2/cafes/tainan')
    cafenomads = res.parsed_response
    cafenomads.each do |cafenomad|
      next if existing_store_map[cafenomad['name']].present?

      find_and_create_store(
        name: cafenomad['name'],
        lat: cafenomad['latitude'],
        lng: cafenomad['longitude']
      )
    end
  end

  private
  
  def build_store_map
    Store.where(city: '台南市').to_h { |store| [store.name, true] }
  end

  def find_and_create_store(name:, lat:, lng:)
    search_res = GoogleMap.new.place_nearbysearch(
      keyword: name,
      location: "#{lat},#{lng}",
      radius: 500
    )

    place = search_res['results'].first
    map_crawler = MapCrawler.find_or_initialize_by(
      place_id: place['place_id']
    )
    map_crawler.update!(
      name: place['name'],
      lat: place['geometry']['location']['lat'],
      lng: place['geometry']['location']['lng'],
      source_data: place
    )
    StoreService::CreateFromGoogleApi.call(
      source_type: 'MapCrawler',
      source_id: map_crawler.id
    )
  rescue Service::PerformFailed => e
    puts "Name with `#{name}` not found"
  end
end
