class UserHiddenStoreService::Delete < Service
  include QueryHelpers::QueryStore
  include QueryHelpers::QueryUser

  def initialize(user_id:, store_id:)
    @user_id = user_id
    @store_id = store_id
  end

  def perform
    user_hidden_store = UserHiddenStore.find_by(
      user_id: @user_id,
      store_id: @store_id
    )
    if user_hidden_store.nil?
      raise Service::PerformFailed, "UserHiddenStore not found with user_id `#{@user_id}`, store_id `#{@store_id}`"
    end

    user_hidden_store.delete
  end
end
