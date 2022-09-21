class StoreService::WakeUp < Service
  include QueryHelpers::QueryStore

  def initialize(store_id:)
    @store_id = store_id
  end

  def perform
    store = find_store_by_id(@store_id)
    store.update!(wake_up: true)
  end
end
