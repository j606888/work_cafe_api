class MapCrawlerService::Bind < Service
  def initialize(id)
    @id = id
  end

  def perform
    map_crawler = MapCrawler.find(@id)

    if map_crawler.aasm_state != 'created'
      raise Service::PerformFailed, "Only created map_crawler can bind, id: #{@id}"
    end

    res = GoogleMap.new.place_detail(map_crawler.place_id)
    ActiveRecord::Base.transaction do
      map_crawler.do_accept!
      map_crawler.update!(
        source_data: res
      )

      store = save_store!(map_crawler, res)
      save_opening_hours(store, res['opening_hours']['periods'])

      store
    end
  end

  private
  def save_store!(map_crawler, res)
    store = Store.find_or_initialize_by(sourceable: map_crawler)
    params = {
      name: res['name'],
      address: res['formatted_address'],
      phone: res['formatted_phone_number'],
      lat: res['geometry']['location']['lat'],
      lng: res['geometry']['location']['lng'],
      rating: res['rating'],
      user_ratings_total: res['user_ratings_total'],
      url: res['url'],
      website: res['website']
    }.compact

    store.update!(params)
    store
  end

  def save_opening_hours(store, periods)
    store.opening_hours.delete_all
    return if store_never_close?(periods)

    periods.each do |period|
      OpeningHour.create!(
        store: store,
        open_day: period['open']['day'],
        open_time: period['open']['time'],
        close_day: period['close']['day'],
        close_time: period['close']['time']
      )
    end
  end

  def store_never_close?(periods)
    periods.length == 1 && periods.first['close'].nil?
  end
end
