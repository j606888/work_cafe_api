class UserService::HideStore < Service
  include HelperModules::QueryUser
  include HelperModules::QueryStore

  def initialize(user_id:, store_id:, reason: nil)
    @user_id = user_id
    @store_id = store_id
    @reason = reason
  end

  def perform
    user = query_user_by_id!(@user_id)
    store = query_store_by_id!(@store_id)

    Hidden.create!(
      user: user,
      store: store,
      reason: @reason
    )
  end
end
