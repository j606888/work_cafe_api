class StoresController < ApplicationController
  def hint
    results = StoreService::BuildSearchHint.call(**{
      lat: helpers.to_float(params[:lat]),
      lng: helpers.to_float(params[:lng]),
      keyword: params.require(:keyword),
      open_type: params[:open_type],
      open_week: helpers.to_integer(params[:open_week]),
      open_hour: helpers.to_integer(params[:open_hour]),
    }.compact)

    render json: { results: results }
  end

  def location
    stores = StoreService::QueryByLocation.call(**{
      mode: 'address',
      lat: helpers.to_float(params.require(:lat)),
      lng: helpers.to_float(params.require(:lng)),
      limit: helpers.to_integer(params[:limit]),
      keyword: params[:keyword],
      open_type: params[:open_type],
      open_week: helpers.to_integer(params[:open_week]),
      open_hour: helpers.to_integer(params[:open_hour]),
    }.compact)

    open_now_map = OpeningHourService::IsOpenNowMap.call(
      store_ids: stores.map(&:id)
    )

    render 'location', locals: { stores: stores, open_now_map: open_now_map }
  end
end
