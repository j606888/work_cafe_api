class MapCrawlerService::Deny < Service
  def initialize(id)
    @id = id
  end

  def perform
    map_crawler = MapCrawler.find(@id)

    map_crawler.do_deny!
  end
end
