class UserService::ToggleFavorite < Service
  include HelperModules::QueryUser
  include HelperModules::QueryStore

  def initialize(user_id:, store_id:)
    @user_id = user_id
    @store_id = store_id
  end

  def perform
    user = query_user_by_id!(@user_id)
    store = query_store_by_id!(@store_id)

    favorite = Favorite.find_or_initialize_by(
      user: user,
      store: store
    )

    if favorite.persisted?
      favorite.delete
    else
      favorite.save!
    end
  end
end
