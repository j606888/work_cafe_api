class MapCrawlerService::QueryAll < Service
  def initialize(page:1, per: 50, status: 'created')
    @page = page
    @per = per
    @status = status
  end

  def perform
    MapCrawler.where(aasm_state: @status).order(created_at: :desc).page(@page).per(@per)
  end
end
