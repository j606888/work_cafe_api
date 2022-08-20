class StoreService::Query < Service
  DEFAULT_PAGE = 1
  DEFAULT_PER = 10
  ALLOW_ORDER = ['asc', 'desc']
  ALLOW_ORDER_BY = ['id', 'name', 'city', 'rating', 'user_ratings_total']

  def initialize(page: DEFAULT_PAGE, per: DEFAULT_PER, cities: [], rating: nil, order: 'desc', order_by: 'id', ignore_hidden: false)
    @page = page
    @per = per
    @cities = cities
    @rating = rating
    @order = order
    @order_by = order_by
    @ignore_hidden = ignore_hidden
  end

  def perform
    validate_per!(@per)
    validate_order!(@order)
    validate_order_by!(@order_by)

    query = Store.includes(:store_photos).order("#{@order_by} #{@order} NULLS LAST").page(@page).per(@per)
    query = query.where(city: @cities) if @cities.present?
    query = query.where("rating > ?", @rating) if @rating.present?
    query = query.where(hidden: false) if @ignore_hidden

    query
  end

  private

  def validate_per!(per)
    return if per <= 100

    raise Service::PerformFailed, "Over Maximum per"
  end

  def validate_order!(order)
    return if ALLOW_ORDER.include?(order)

    raise Service::PerformFailed, "Invalid order `#{order}`"
  end

  def validate_order_by!(order_by)
    return if ALLOW_ORDER_BY.include?(order_by)

    raise Service::PerformFailed, "Invalid order_by `#{order_by}`"
  end
end
