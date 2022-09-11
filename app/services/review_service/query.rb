class ReviewService::Query < Service
  DEFAULT_PER = 10
  DEFAULT_PAGE = 1

  def initialize(store_id: nil, per: DEFAULT_PER, page: DEFAULT_PAGE)
    @store_id = store_id
    @per = per
    @page = page
  end

  def perform
    reviews = Review.page(@page).per(@per).order(created_at: :desc)
    if @store_id.present?
      reviews = reviews.where(store_id: @store_id)
    end

    reviews
  end
end
