class ReviewService::FindOrCreate < Service
  include QueryHelpers::QueryUser
  include QueryHelpers::QueryStore

  def initialize(user_id: nil, store_id:, recommend:,
    room_volume: nil, time_limit: nil, socket_supply: nil,
    description: nil
  )
    @user_id = user_id
    @store_id = store_id
    @params = {
      recommend: recommend,
      room_volume: room_volume,
      time_limit: time_limit,
      socket_supply: socket_supply,
      description: description
    }.compact
  end

  def perform
    store = find_store_by_id(@store_id)
    StoreService::WakeUp.call(store_id: store.id)

    if @user_id.present?
      user = find_user_by_id(@user_id)
      review = Review.find_or_initialize_by(
        user: user,
        store: store
      )
    else
      review = Review.new(store: store)
    end

    review.update!(@params)
    review
  end
end
