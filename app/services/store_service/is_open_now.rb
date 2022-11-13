class StoreService::IsOpenNow < Service
  include QueryHelpers::QueryStore

  def initialize(store_id:)
    @store_id = store_id
  end

  def perform
    store = find_store_by_id(@store_id)

    current_time = Time.now.in_time_zone("Taipei")
    weekday = current_time.strftime("%w").to_i
    hour_time = current_time.strftime("%H%M").to_i

    store.opening_hours.find do |opening_hour|
      weekday_match?(opening_hour, weekday) && in_period?(opening_hour, hour_time)
    end
  end

  private

  def weekday_match?(opening_hour, weekday)
    opening_hour.open_day == weekday
  end

  def in_period?(opening_hour, hour_time)
    open_time = opening_hour.open_time.to_i
    close_time = opening_hour.close_time.to_i

    close_time += 2400 if opening_hour.open_day != opening_hour.close_day

    hour_time.between?(open_time, close_time)
  end
end
