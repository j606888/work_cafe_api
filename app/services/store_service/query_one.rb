class StoreService::QueryOne < Service
  include HelperModules::QueryStore

  def initialize(id:)
    @id = id
  end

  def perform
    query_store_by_id!(@id)
  end
end
