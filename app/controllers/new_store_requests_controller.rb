class NewStoreRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    NewStoreRequestService::Create.call(
      user_id: current_user.id,
      content: params.require(:content)
    )

    head :ok
  end
end
