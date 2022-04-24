class StoreService::CreateFromGoogleApi < Service
  def initialize(source_type:, source_id:)
    @source_type = source_type
    @source_id = source_id
  end

  def perform
    source = query_source!(@source_type, @source_id)
    place_id = source.place_id

    res = GoogleMap.new.place_detail(place_id)
    ActiveRecord::Base.transaction do
      source.update!(
        source_data: res
      )

      store = save_store!(source, res)

      # Some store don't have opening_hours
      if res['opening_hours'].present?
        save_opening_hours(store, res['opening_hours']['periods'])
      end
    end
  end

  private

  def query_source! source_type, source_id
    source = if source_type == 'MapCrawler'
      MapCrawler.find_by(id: source_id)
    elsif source_type == 'MapUrl'
      MapUrl.find_by(id: source_id)
    else
      raise Service::PerformFailed, "Unknown Type for #{source_type}"
    end

    if source.nil?
      raise Service::PerformFailed, "#{source_type} with id `#{source_id}` not found"
    end

    source
  end

  def save_store!(source, res)
    store = Store.find_or_initialize_by(sourceable: source)

    params = {
      name: res['name'],
      address: res['formatted_address'],
      phone: res['formatted_phone_number'],
      lat: res['geometry']['location']['lat'],
      lng: res['geometry']['location']['lng'],
      rating: res['rating'],
      user_ratings_total: res['user_ratings_total'],
      url: res['url'],
      website: res['website'],
      city: parse_address(res, 'administrative_area_level_1'),
      district: parse_address(res, 'administrative_area_level_3')
    }.compact

    store.update!(params)
    store
  end

  def parse_address(res, type)
    components = res['address_components']
    target = components.find { |c| c['types'] == [type, 'political'] }
    return if target.nil?

    target['long_name']
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
