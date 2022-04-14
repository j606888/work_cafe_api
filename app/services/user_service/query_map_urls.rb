class UserService::QueryMapUrls < Service
  def initialize(user_id:)
    @user_id = user_id
  end

  def perform
    MapUrl.where(user_id: @user_id)
  end
end
