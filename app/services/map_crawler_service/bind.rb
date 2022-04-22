class MapCrawlerService::Bind < Service
  def initialize(id)
    @id = id
  end

  def perform
    map_crawler = MapCrawler.find(@id)

    if map_crawler.aasm_state != 'created'
      raise Service::PerformFailed, "Only created map_crawler can bind, id: #{@id}"
    end

    StoreService::CreateFromGoogleApi.new(
      source_type: 'MapCrawler',
      source_id: @id
    ).perform
    map_crawler.do_accept!
  end
end
