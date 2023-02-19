class ChainStoreService::QueryAll < Service
  def perform
    ChainStore.left_joins(:chain_store_maps)
      .group('chain_stores.id')
      .select('chain_stores.*, COUNT(chain_store_maps.id) as chain_store_maps_count')
      .order('chain_store_maps_count desc')
  end
end
