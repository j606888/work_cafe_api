class OpeningHourService::QueryByStore < Service
  include QueryHelpers::QueryStore

  def initialize(store_id:)
    @store_id = store_id
  end

  def perform
    store = find_store_by_id(@store_id)
    opening_hours = store.opening_hours
    formatted_opening_hours(opening_hours)
  end

  private

  def formatted_opening_hours(opening_hours)
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
