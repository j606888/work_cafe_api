class UserService::QueryMapUrls < Service
  def initialize(user_id:, per: 10, page: 1)
    @user_id = user_id
    @per = per
    @page = page
  end

  def perform
    MapUrl.where(user_id: @user_id).page(@page).per(@per)
  end
end
