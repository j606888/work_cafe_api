class UserHiddenStoreService::Create < Service
  include QueryHelpers::QueryStore
  include QueryHelpers::QueryUser

  def initialize(user_id:, store_id:)
    @user_id = user_id
    @store_id = store_id
  end

  def perform
    user = find_user_by_id(@user_id)
    store = find_store_by_id(@store_id)

    UserHiddenStore.create!(
      user: user,
      store: store
    )
  end
end
