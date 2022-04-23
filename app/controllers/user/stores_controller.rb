class User::StoresController < User::ApplicationController
  def favorites
    stores = UserService::QueryFavoriteStores.new(
      user_id: current_user.id
    ).perform

    render 'stores/index', locals: { stores: stores }
  end

  def toggle_favorite
    UserService::ToggleFavorite.new(
      user_id: current_user.id,
      store_id: params.require(:id)
    ).perform

    head :ok
  end
end
