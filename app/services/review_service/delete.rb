class ReviewService::Delete < Service
  include QueryHelpers::QueryUser
  include QueryHelpers::QueryStore

  def initialize(user_id:, store_id:)
    @user_id = user_id
    @store_id = store_id
  end

  def perform
    user = find_user_by_id(@user_id)
    store = find_store_by_id(@store_id)

    review = Review.find_by(
      user: user,
      store: store
    )

    if review.present?
      review.destroy
      review.store_review_tags.delete_all
    end
  end
end
