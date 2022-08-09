class StoreService::Query < Service
  DEFAULT_PAGE = 1
  DEFAULT_PER = 10

  def initialize(page: DEFAULT_PAGE, per: DEFAULT_PER, cities: [])
    @page = page
    @per = per
    @cities = cities
  end

  def perform
    validate_per!(@per)
    query = Store.includes(:store_photos).page(@page).per(@per).order(created_at: :desc)
    query = query.where(city: @cities) if @cities.present?

    query
  end

  private

  def validate_per!(per)
    return if per <= 100

    raise Service::PerformFailed, "Over Maximum per"
  end
end
