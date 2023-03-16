
class StoreService::KeywordSearch < Service
  def initialize(keyword:, location:)
    @keyword = keyword
    @location = location
  end

  def perform
    args = {
      keyword: @keyword,
      location: @location,
      radius: 40000
    }
    response = GoogleMapPlace::Api.query(:nearbysearch_service, args)
    response['results'].map do |result|
      parse_result(result)
    end.reject{ |result| result[:already_exist] }
  end

  private

  def parse_result(result)
    {
      place_id: result['place_id'],
      name: result['name'],
      rating: result['rating'],
      user_ratings_total: result['user_ratings_total'],
      already_exist: Store.exists?(place_id: result['place_id'])
    }
  end

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
