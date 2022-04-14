class StoreService::QueryAll
  def initialize(page:1, per:10)
    @page = page
    @per = per
  end

  def perform
    Store.all.page(@page).per(@per)
  end
end
