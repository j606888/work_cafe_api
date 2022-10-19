class ReviewService::FindOrCreate < Service
  include QueryHelpers::QueryUser
  include QueryHelpers::QueryStore

  def initialize(user_id: nil, store_id:, recommend:,
    description: nil, tag_ids: []
  )
    @user_id = user_id
    @store_id = store_id
    @tag_ids = tag_ids
    @params = {
      recommend: recommend,
      description: description
    }.compact
  end

  def perform
    validate_tags!(@tag_ids)
    store = find_store_by_id(@store_id)

    if @user_id.present?
      user = find_user_by_id(@user_id)
      review = Review.find_or_initialize_by(
        user: user,
        store: store
      )
      review.store_review_tags.map(&:delete)
    else
      review = Review.new(store: store)
    end

    review.update!(@params)
    create_store_review_tags(review, @tag_ids)
    review
  end

  private

  def validate_tags!(tag_ids)
    existing_tag_ids = Tag.where(id: tag_ids).pluck(:id)
    none_exist_tag_ids = tag_ids - existing_tag_ids
    return if none_exist_tag_ids.blank?

    raise Service::PerformFailed, "Tags with id `#{none_exist_tag_ids}` not exist"
  end

  def create_store_review_tags(review, tag_ids)
    tag_ids.each do |tag_id|
      StoreReviewTag.create!(
        store_id: review.store_id,
        review_id: review.id,
        tag_id: tag_id
      )
    end
  end
end
