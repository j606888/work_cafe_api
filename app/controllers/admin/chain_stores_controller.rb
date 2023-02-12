class Admin::ChainStoresController < Admin::ApplicationController
  def index
    chain_stores = ChainStoreService::QueryAll.call

    render json: chain_stores
  end
end
