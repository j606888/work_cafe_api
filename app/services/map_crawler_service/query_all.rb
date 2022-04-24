class MapCrawlerService::QueryAll < Service
  def initialize(page:1, per: 50, status:nil)
    @page = page
    @per = per
    @status = status
  end

  def perform
    map_crawlers = MapCrawler.order(created_at: :desc)

    if @status.present?
      map_crawlers = map_crawlers.where(aasm_state: @status)
    end

    map_crawlers.page(@page).per(@per)
  end
end
