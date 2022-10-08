class StoreService::BuildSearchHint < Service
  SearchResult = Struct.new(:type, :name, :address, :place_id, :count)

  def initialize(keyword:, lat: 25.0418226, lng: 121.5303917, open_type: 'NONE', open_week: nil, open_hour: nil)
    @keyword = keyword
    @lat = lat
    @lng = lng
    @open_type = open_type
    @open_week = open_week
    @open_hour = open_hour
  end

  def perform
    validate_inclusion!(OpeningHour::VALID_OPEN_TYPES, @open_type)
    validate_inclusion!(OpeningHour::VALID_OPEN_WEEKS, @open_week, allow_nil: true)
    validate_inclusion!(OpeningHour::VALID_OPEN_HOURS, @open_hour, allow_nil: true)

    answer = []
    stores = StoreService::QueryByLocation.call(**{
      lat: @lat,
      lng: @lng,
      limit: 5,
      keyword: @keyword,
      open_type: @open_type,
      open_week: @open_week,
      open_hour: @open_hour
    }.compact)

    city = query_group('city', @keyword, @open_type, @open_week, @open_hour)
    answer += format_group('city', city)

    district = query_group('district', @keyword, @open_type, @open_week, @open_hour)
    answer += format_group('district', district)

    answer += format_stores(stores)
    answer.take(5)
  end

  private

  def format_stores(stores)
    stores.map do |store|
      SearchResult.new('store', store.name, store.address, store.place_id, 1)
    end
  end

  def query_group(field, keyword, open_type, open_week, open_hour)
    # sql = Store.where("#{field} ilike '%#{keyword}%'").order(count: :desc)

    sql = "#{field} ilike '%#{keyword}%' AND hidden = false"
    
    if open_type == 'NONE'
    elsif open_type == 'OPEN_NOW'
      now = Time.now.in_time_zone('Taipei')
      open_week = now.wday
      cur_hour = now.strftime("%H")
      cur_min = now.strftime("%M")
      cur_time = cur_hour + cur_min

      sql += " AND open_day = #{open_week} AND close_day = #{open_week} and open_time <= '#{cur_time}' and close_time >='#{cur_time}'"
    else
      sql += " AND open_day = #{open_week} AND close_day = #{open_week}"

      if open_hour.present?
        open_time = open_hour < 10 ? "0#{open_hour}00" : "#{open_hour}00"
        sql += " AND open_time <= '#{open_time}' and close_time >= '#{open_time}'"
      end
    end

    Store.left_joins(:opening_hours).where(sql).group(field).order(count: :desc).count
  end

  def format_group(field, result)
    result.map do |keyword, count|
      SearchResult.new(field, keyword, nil, nil, count)
    end
  end
end
