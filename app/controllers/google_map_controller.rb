class GoogleMapController < ApplicationController
  def parse_place_id

    render json: { message: params[:url] }
  end
end
