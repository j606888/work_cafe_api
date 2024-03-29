class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :me, :destroy]

  def create
    review = ReviewService::FindOrCreate.call(**{
      user_id: current_user&.id,
      store_id: store.id,
      recommend: params.require(:recommend),
      visit_day: params.require(:visit_day),
      description: params[:description],
      tag_ids: params[:tag_ids]
    }.compact)

    render json: { id: review.id }
  end

  def index
    reviews = ReviewService::Query.call(**{
      user_id: current_user.id,
      per: params[:per],
      page: params[:page]
    }.compact)

    render 'index', locals: {
      reviews: reviews
    }
  end

  def store_reviews
    reviews = ReviewService::Query.call(**{
      exclude_user_id: current_user&.id,
      store_id: store.id,
      per: params[:per],
      page: params[:page],
      description_not_nil: true
    }.compact)

    render 'store_reviews', locals: {
      reviews: reviews
    }
  end

  def me
    review = Review.find_by(
      user: current_user,
      store: store
    )

    render 'me', locals: { review: review }
  end

  def destroy
    ReviewService::Delete.call(
      user_id: current_user.id,
      store_id: store.id
    )

    head :ok
  end

  private

  def store
    StoreService::QueryOne.call(
      place_id: params.require(:store_id)
    )
  end
end
