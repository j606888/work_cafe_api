class StorePhotoService::Query < Service
  include QueryHelpers::QueryUser

  def initialize(user_id:, per: 10, page: 1)
    @user_id = user_id
    @per = per
    @page = page
  end

  def perform
    user = find_user_by_id(@user_id)

    StorePhoto.includes(:store).where(user: user).page(@page).per(@per).order(created_at: :desc)
  end
end
