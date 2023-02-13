class NotCafeReportsController < ApplicationController
  def create
    NotCafeReport.create!(
      user_id: current_user&.id,
      store: store
    )
    if current_user&.role == 'admin'
      store.update!(hidden: true)
    end

    head :ok
  end

  private

  def store
    StoreService::QueryOne.call(
      place_id: params.require(:store_id)
    )
  end
end
