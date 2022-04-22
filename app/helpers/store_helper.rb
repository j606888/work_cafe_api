module StoreHelper
  def store_opening_hours(opening_hours)
    return [] if opening_hours.nil?
    return [] if opening_hours['weekday_text'].nil?
    opening_hours['weekday_text']
  end
end
