module HelperModules::QueryStore
  def query_store_by_id!(id)
    store = Store.find_by(id: id)
    if store.nil?
      raise Service::PerformFailed, "Store with id `#{id}` not found"
    end

    store
  end
end
