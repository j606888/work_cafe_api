class StoreService::QueryOne < Service
  include QueryHelpers::QueryStore


  def initialize(place_id:)
    @place_id = place_id
  end

  def perform
    find_store_by_place_id(@place_id)
  end
end
