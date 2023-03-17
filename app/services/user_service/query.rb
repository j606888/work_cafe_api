class UserService::Query < Service
  DEFAULT_PAGE = 1
  DEFAULT_PER = 10
  ALLOW_ORDER = ['asc', 'desc']
  ALLOW_ORDER_BY = ['id', 'created_at']

  def initialize(page: DEFAULT_PAGE, per: DEFAULT_PER, order: 'desc', order_by: 'id')
    @page = page
    @per = per
    @order = order
    @order_by = order_by
  end

  def perform
    validate_per!(@per)
    validate_order!(@order)
    validate_order_by!(@order_by)

    User.left_joins(:reviews)
      .group('users.id')
      .select('users.*, COUNT(reviews.id) as reviews_count')
      .order("#{@order_by} #{@order} NULLS LAST")
      .page(@page).per(@per)
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
