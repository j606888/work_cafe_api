class User::StoreSourcesController < User::ApplicationController
  def create
    store_source = StoreSourceService::CreateFromUrl.call(
      url: params.require(:url)
    )

    render 'store_sources/_store_source', locals: { store_source: store_source }
  end
end
