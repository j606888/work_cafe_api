module HelperModules::QueryStore
  def query_store_by_id!(id)
    store = Store.find_by(id: id)
    return store if store.present?

    raise Service::PerformFailed, "Store with id `#{id}` not found"
  end
end
