class UserHiddenStoreService::QueryStores < Service
  include QueryHelpers::QueryUser

  def initialize(user_id:)
    @user_id = user_id
  end

  def perform
    user = find_user_by_id(@user_id)
    user.hidden_stores
  end
end
