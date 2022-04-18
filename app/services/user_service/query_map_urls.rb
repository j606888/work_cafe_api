class UserService::QueryMapUrls < Service
  def initialize(user_id:, per: 10, page: 1, status:)
    @user_id = user_id
    @per = per
    @page = page
    @status = status
  end

  def perform
    MapUrl.where(
      user_id: @user_id,
      aasm_state: @status
    ).order(id: :desc).page(@page).per(@per)
  end
end
