class AdminService::QueryMapUrls < Service
  def initialize(page:1, per:10)
    @page = page
    @per = per
  end

  def perform
    MapUrl.order(id: :desc).page(@page).per(@per)
  end
end
