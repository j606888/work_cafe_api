class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    ReviewService::Create.call(**{
      user_id: current_user.id,
      store_id: store.id,
      recommend: params.require(:recommend),
      room_volume: params[:room_volume],
      time_limit: params[:time_limit],
      socket_supply: params[:socket_supply],
      description: params[:description]
    }.compact)

    head :ok
  end

  def index
    reviews = ReviewService::Query.call(**{
      store_id: store.id,
      per: params[:per],
      page: params[:page]
    }.compact)
    report = StoreService::ReviewReport.call(
      store_id: store.id
    )

    render 'index', locals: {
      reviews: reviews,
      report: report
    }
  end

  private

  def store
    StoreService::QueryOne.call(
      place_id: params.require(:store_id)
    )
  end
end
