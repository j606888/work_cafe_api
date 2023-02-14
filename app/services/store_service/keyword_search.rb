class StoreService::KeywordSearch < Service
  def initialize(keyword:, location:)
    @keyword = keyword
    @location = location
  end

  def perform
    args = {
      keyword: @keyword,
      location: @location,
      radius: 20000
    }
    result = GoogleMapPlace::Api.query(:nearbysearch_service, args)

    place_id = query_place_id(result)
    StoreService::Create.call(place_id: place_id)
  end

  private

  def query_place_id(result)
    search_result = GoogleMapPlace::CafeSearch.new(result)
    places = search_result = search_result.places
    if places.blank?
      raise Service::PerformFailed, "Store with keyword `#{@keyword}` not found"
    end

    if places.length > 1
      raise Service::PerformFailed, "Store with keyword `#{@keyword}` has more than 1 result"
    end

    places.last[:place_id]
  end
end
