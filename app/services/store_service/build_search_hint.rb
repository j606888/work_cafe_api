class StoreService::BuildSearchHint < Service
  SearchResult = Struct.new(:type, :name, :address, :place_id, :count)

  def initialize(keyword:, lat: 25.0418226, lng: 121.5303917)
    @keyword = keyword
    @lat = lat
    @lng = lng
  end

  def perform
    answer = []
    stores = StoreService::QueryByLocation.call(
      lat: @lat,
      lng: @lng,
      limit: 5,
      keyword: @keyword
    )
    
    city = query_group('city', @keyword)
    answer += format_group('city', city)

    district = query_group('district', @keyword)
    answer += format_group('district', district)

    answer += format_stores(stores)
    answer.take(5)
  end

  private

  def format_stores(stores)
    stores.map do |store|
      SearchResult.new('store', store.name, store.address, store.place_id, 1)
    end
  end

  def query_group(field, keyword)
    Store.where("#{field} ilike '%#{keyword}%'").group(field).order(count: :desc).count
  end

  def format_group(field, result)
    result.map do |keyword, count|
      SearchResult.new(field, keyword, nil, nil, count)
    end
  end
end
