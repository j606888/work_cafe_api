module QueryHelpers::QueryStore
  def find_store_by_id(id)
    store = Store.find_by(id: id)
    return store if store.present?

    raise ActiveRecord::RecordNotFound, "Store with id `#{id}` not found"
  end

  def find_store_by_place_id(place_id)
    store = Store.find_by(place_id: place_id)
    return store if store.present?

    raise ActiveRecord::RecordNotFound, "Store with place_id `#{place_id}` not found"
  end
end
