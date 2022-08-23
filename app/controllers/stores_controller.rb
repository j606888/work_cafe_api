class StoresController < ApplicationController
  def hint
    results = StoreService::BuildSearchHint.call(**{
      lat: helpers.to_float(params[:lat]),
      lng: helpers.to_float(params[:lng]),
      keyword: params.require(:keyword)
    }.compact)

    render json: { results: results }
  end
end
