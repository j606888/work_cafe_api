class StoreService::QueryOne < Service

  def initialize(place_id:)
    @place_id = place_id
  end

  def perform
    store = find_store!(@place_id)
    opening_hours = store.opening_hours

    {
      store: store,
      opening_hours: opening_hours_with_format(opening_hours)
    }
  end

  private

  def find_store!(place_id)
    store = Store.find_by(place_id: place_id)
    return store if store.present?

    raise Service::PerformFailed, "Store with place_id `#{place_id}` not found"
  end

  def opening_hours_with_format(opening_hours)
    # TODO, have to deal with overnight
    weekday_map = OpeningHour.empty_weekday_map
    
    opening_hours.each do |open_hour|
      period = {
        start: open_hour.open_time.insert(2, ":"),
        end: open_hour.close_time.insert(2, ":")
      }
      weekday_map[open_hour.open_day][:periods] << period
    end

    weekday_map.values
  end
end
