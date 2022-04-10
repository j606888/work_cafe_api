class GoogleMapController < ApplicationController
  def parse_place_id
    place_id = GoogleMapService::ParsePlaceId.new(
      url: params.require(:url)
    ).perform

    details = GoogleMapService::FetchDetailFromPlaceId.new(
      place_id: place_id
    ).perform

    render json: details
  end
end
