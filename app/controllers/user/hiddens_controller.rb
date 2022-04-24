class User::HiddensController < User::ApplicationController
  def index
    stores = UserService::QueryHiddenStores.new(
      user_id: current_user.id
    ).perform

    render 'stores/index', locals: { stores: stores }
  end

  def create
    UserService::HideStore.new(**{
      user_id: current_user.id,
      store_id: params.require(:store_id),
      reason: params[:reason]
    }.compact).perform

    head :ok
  end
end
