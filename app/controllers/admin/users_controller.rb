class Admin::UsersController < Admin::ApplicationController
  def index
    users = UserService::Query.call(**{
      page: helpers.to_integer(params[:page]),
      per: helpers.to_integer(params[:per]),
      order: params[:order],
      order_by: params[:order_by],
    }.compact)

    render 'index', locals: { users: users }
  end
end
