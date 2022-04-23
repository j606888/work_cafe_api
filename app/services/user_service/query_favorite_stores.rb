class UserService::QueryFavoriteStores < Service
  include HelperModules::QueryUser

  def initialize(user_id:, page: 1, per: 50)
    @user_id = user_id
    @page = page
    @per = per
  end

  def perform
    user = query_user_by_id!(@user_id)

    user.favorite_stores.page(@page).per(@per)
  end
end
