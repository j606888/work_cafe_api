class StoresController < ApplicationController
  def index
    stores = StoreService::QueryAll.new(**{
      page: params[:page],
      per: params[:per]
    }.compact).perform

    render 'index', locals: { stores: stores }
  end

  def show
  end
end
