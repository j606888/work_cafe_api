class PlacesController < ApplicationController
  def index
    places = PlaceService::QueryAll.new(**{
      page: params[:page],
      per: params[:per]
    }.compact).perform

    render 'index', locals: { places: places }
  end

  def show
  end
end
