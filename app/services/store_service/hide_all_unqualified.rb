class StoreService::HideAllUnqualified < Service
  BAD_RATING = 2.5

  def perform
    hide_blacklist_stores
    hide_zero_rating_stores
    hide_bad_rating_stores
    hide_permanently_closed_stores
  end

  private

  def hide_blacklist_stores
    blacklists = Blacklist.pluck(:keyword)
    ilike_array = blacklists.map { |b| "%#{b}%" }
    stores = Store.where(hidden: false).where("name ILIKE ANY ( array[?] )", ilike_array)
    stores.update_all(hidden: true)
  end

  def hide_zero_rating_stores
    stores = Store.where(hidden: false).where(user_ratings_total: nil)
    stores.update_all(hidden: true)
  end

  def hide_bad_rating_stores
    stores = Store.where(hidden: false).where("rating < ?", BAD_RATING)
    stores.update_all(hidden: true)
  end

  def hide_permanently_closed_stores
    stores = Store.where(hidden: false, permanently_closed: true)
    stores.update_all(hidden: true)
  end
end
