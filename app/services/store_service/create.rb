class StoreService::Create < Service
  def initialize(place_id:)
    @place_id = place_id
  end
end
