class ReviewService::Query < Service
  DEFAULT_PER = 10
  DEFAULT_PAGE = 1

  def initialize(store_id: nil, user_id: nil, exclude_user_id: nil, per: DEFAULT_PER, page: DEFAULT_PAGE, description_not_nil: false)
    @store_id = store_id
    @user_id = user_id
    @exclude_user_id = exclude_user_id
    @per = per
    @page = page
    @description_not_nil = description_not_nil
  end

  def perform
    reviews = Review.page(@page).per(@per).order(created_at: :desc)

    if @store_id.present?
      reviews = reviews.includes(:user, :tags).where(store_id: @store_id)
    end

    if @user_id.present?
      reviews = reviews.includes(:store).where(user_id: @user_id)
    end

    if @exclude_user_id.present?
      reviews = reviews.where.not(user_id: @exclude_user_id)
    end

    if @description_not_nil
      reviews = reviews.where.not(description: nil)
    end

    reviews
  end
end
