class StoreService::QueryAll
  def initialize(city: nil, districts: [], page:1, per:50)
    @city = city
    @districts = districts
    @page = page
    @per = per
  end

  def perform
    stores = Store.includes(:opening_hours)

    if @city.present?
      stores = stores.where(city: @city)
    end

    if @districts.present?
      stores = stores.where(district: @districts)
    end

    stores.order(id: :desc).page(@page).per(@per)
  end
end
