class PlaceService::QueryAll
  def initialize(page:1, per:10)
    @page = page
    @per = per
  end

  def perform
    Place.all.page(@page).per(@per)
  end
end
