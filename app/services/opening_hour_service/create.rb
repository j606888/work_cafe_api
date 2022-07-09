class OpeningHourService::Create < Service
  def initialize(store_id:)
    @store_id = store_id
  end
end
