class User::FavoritesController < User::ApplicationController
  def index
    stores = UserService::QueryFavoriteStores.new(
      user_id: current_user.id
    ).perform

    render 'stores/index', locals: { stores: stores }
  end

  def toggle
    UserService::ToggleFavorite.new(
      user_id: current_user.id,
      store_id: params.require(:store_id)
    ).perform

    head :ok
  end

  def show
    
  end
end
