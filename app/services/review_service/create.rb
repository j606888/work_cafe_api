class ReviewService::Create < Service
  include QueryHelpers::QueryUser
  include QueryHelpers::QueryStore

  def initialize(user_id:, store_id:, recommend:,
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
    user = find_user_by_id(@user_id)
    store = find_store_by_id(@store_id)

    Review.create!(**{
      user: user,
      store: store,
    }.merge(@params))
  end
end
