class CrawlerService::SearchByType < Service
  # Radius, maximum 50,000 M
  # https://developers.google.com/maps/documentation/places/web-service/search-nearby#radius
  DEFAULT_RADIUS = 3000
  MAX_NEXT_PAGE_COUNT = 10
  PLACE_TYPE = 'cafe'

  # format: 23.0104722,120.2349625
  def initialize(location)
    @location = location
  end

  def perform
    res = GoogleMap.new.place_nearbysearch(
      location: @location,
      type: PLACE_TYPE,
      language: 'zh-TW',
      radius: DEFAULT_RADIUS,
    )
    places = res['results']
    create_map_crawlers(places)

    next_page_token = res['next_page_token']

    while next_page_token.present?
      puts "again"
      sleep(2)
      res = GoogleMap.new.place_nearbysearch(
        pagetoken: next_page_token
      )
      create_map_crawlers(res['results'])
      next_page_token = res['next_page_token']
    end
  end

  private
  def create_map_crawlers(places)
    places.each do |place|
      map_crawler = MapCrawler.find_or_initialize_by(
        place_id: place['place_id']
      )
      map_crawler.update!(
        name: place['name'],
        lat: place['geometry']['location']['lat'],
        lng: place['geometry']['location']['lng'],
        source_data: place
      )
    end

  end
end
