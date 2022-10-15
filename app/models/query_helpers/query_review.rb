module QueryHelpers::QueryReview
  def find_review_by_id(id)
    review = Review.find_by(id: id)
    return review if review.present?

    raise ActiveRecord::RecordNotFound, "Review with id `#{id}` not found"
  end
end
