class StoreService::SortedStores < Service
  def initialize(stores: [])
    @stores = stores
  end

  def perform
    id_by_review = Store.joins(:reviews)
      .where(id: @stores.map(&:id))
      .group(:id)
      .order("count_all desc")
      .count
      .keys
    id_by_google = Store.where(id: @stores.map(&:id))
      .order("user_ratings_total desc")
      .pluck(:id)
    sorted_ids = (id_by_review + id_by_google).uniq

    stores_map = @stores.index_by(&:id)
    sorted_ids.map do |id|
      stores_map[id]
    end
  end
end


