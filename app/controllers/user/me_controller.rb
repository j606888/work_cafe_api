class User::MeController < User::ApplicationController
  def show
    render 'show', locals: { user: current_user }
  end
end
