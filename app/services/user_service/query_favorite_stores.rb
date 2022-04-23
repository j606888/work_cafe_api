class UserService::QueryFavoriteStores < Service
  include HelperModules::QueryUser

  def initialize(user_id:)
    @user_id = user_id
  end

  def perform
    user = query_user_by_id!(@user_id)

    user.favorite_stores
  end
end
