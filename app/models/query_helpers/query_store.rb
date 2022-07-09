module QueryHelpers::QueryStore
  def find_store_by_id(id)
    store = Store.find_by(id: id)
    return store if store.present?

    raise ActiveRecord::RecordNotFound, "Store with id `#{id}` not found"
  end
end
