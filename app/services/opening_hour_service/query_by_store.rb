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
    weekday_map = OpeningHour.empty_weekday_map

    if open_24_hour?(opening_hours)
      weekday_map.each do |key, value|
        weekday_map[key][:period_texts] << "24 小時營業"
      end
    else
      opening_hours.each do |open_hour|
        open_text = open_hour.open_time.insert(2, ":")
        close_text = open_hour.close_time.insert(2, ":")
        period = {
          start: open_text,
          close: close_text
        }
        weekday_map[open_hour.open_day][:periods] << period
        weekday_map[open_hour.open_day][:period_texts] << "#{open_text} - #{close_text}"
      end
    end

    weekday_map.values
  end

  def open_24_hour?(opening_hours)
    return false if opening_hours.length != 1

    opening_hour = opening_hours.last
    opening_hour.open_day == 0 && opening_hour.open_time == "0000" &&
      opening_hour.close_day.nil? && opening_hour.close_time.nil?
  end
end
