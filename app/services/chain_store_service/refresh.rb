class ChainStoreService::Refresh < Service
  def perform
    ChainStore.all.each do |chain_store|
      Store.where("name ilike ?", "%#{chain_store.name}%").each do |store|
        ChainStoreMap.find_or_create_by!(chain_store: chain_store, store_id: store.id)
        if chain_store.is_blacklist && !store.hidden
          store.update!(hidden: true)
        end
      end
    end
  end
end
