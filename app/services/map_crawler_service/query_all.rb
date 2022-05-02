class MapCrawlerService::QueryAll < Service
  # 0.02 = 2km
  def initialize(page: 1, per: 50, status: nil, lat: nil, lng: nil, radius: 0.01)
    @page = page
    @per = per
    @status = status
    @lat = lat
    @lng = lng
    @radius = radius
  end

  def perform
    map_crawlers = MapCrawler.order(created_at: :desc)

    if @status.present?
      map_crawlers = map_crawlers.where(aasm_state: @status)
    end

    if @lat.present? && @lng.present?
      max_lat, min_lat = location_range(@lat, @radius)
      max_lng, min_lng = location_range(@lng, @radius)

      map_crawlers = map_crawlers.where("lat BETWEEN ? AND ?", min_lat, max_lat)
      map_crawlers = map_crawlers.where("lng BETWEEN ? AND ?", min_lng, max_lng)
    end

    map_crawlers.page(@page).per(@per)
  end

  private

  def location_range(location, radius)
    [location.to_f + radius, location.to_f - radius]
  end
end
