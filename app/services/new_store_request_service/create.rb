class NewStoreRequestService::Create < Service
  include QueryHelpers::QueryUser

  def initialize(user_id:, content:)
    @user_id = user_id
    @content = content
  end

  def perform
    user = find_user_by_id(@user_id)
    NewStoreRequest.create!(
      user: user,
      content: @content
    )
  end
end
