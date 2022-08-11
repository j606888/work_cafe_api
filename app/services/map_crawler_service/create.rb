class MapCrawlerService::Create < Service
  MAX_LOOP_COUNT = 5

  def initialize(user_id:, lat:, lng:, radius:)
    @user_id = user_id
    @lat = lat
    @lng = lng
    @radius = radius
  end

  def perform
    total_found = 0
    new_store_count = 0
    repeat_store_count = 0
    blacklist_store_count = 0

    response = GoogleMapPlace.cafe_search(
      location: "#{@lat},#{@lng}",
      radius: @radius
    )

    loop_count = 0
    loop do
      response.places.each do |place|
        total_found += 1

        if name_is_blacklisted?(place[:name])
          blacklist_store_count += 1
        elsif place_id_exist?(place[:place_id])
          repeat_store_count += 1
        else
          new_store_count += 1
          StoreService::Create.call(place_id: place[:place_id])
        end
      end

      response = response.next_page
      break if response.nil?

      loop_count += 1
      raise Service::PerformFailed, "Over max loop count" if loop_count > MAX_LOOP_COUNT
    end

    MapCrawler.create!(
      user_id: @user_id,
      lat: @lat,
      lng: @lng,
      radius: @radius,
      total_found: total_found,
      new_store_count: new_store_count,
      repeat_store_count: repeat_store_count,
      blacklist_store_count: blacklist_store_count
    )
  end

  private

  def name_is_blacklisted?(name)
    STORE_BLACKLIST.any? do |blacklist|
      name.include?(blacklist)
    end
  end

  def place_id_exist?(place_id)
    Store.exists?(place_id: place_id)
  end
end
