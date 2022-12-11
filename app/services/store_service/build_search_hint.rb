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
      per: 5,
      keyword: @keyword,
      open_type: @open_type,
      open_week: @open_week,
      open_hour: @open_hour
    }.compact)[:stores]

    city = query_group('city', @keyword, @open_type, @open_week, @open_hour)
    answer += format_city(city)

    district = query_group('district', @keyword, @open_type, @open_week, @open_hour)
    answer += format_district(district)

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
    where_sql = "#{field} ilike '%#{keyword}%' AND hidden = false"
    if open_type == 'NONE'
    elsif open_type == 'OPEN_NOW'
      now = Time.now.in_time_zone('Taipei')
      open_week = now.wday
      cur_hour = now.strftime("%H")
      cur_min = now.strftime("%M")
      cur_time = cur_hour + cur_min

      where_sql += " AND open_day = #{open_week} AND close_day = #{open_week} and open_time <= '#{cur_time}' and close_time >='#{cur_time}'"
    else
      where_sql += " AND open_day = #{open_week} AND close_day = #{open_week}"

      if open_hour.present?
        open_time = open_hour < 10 ? "0#{open_hour}00" : "#{open_hour}00"
        where_sql += " AND open_time <= '#{open_time}' and close_time >= '#{open_time}'"
      end
    end

    with_sql = <<-SQL
      WITH match_stores AS (
        SELECT
          distinct stores.id AS id
        FROM stores
        LEFT JOIN opening_hours ON opening_hours.store_id = stores.id
        WHERE #{where_sql}
      )
    SQL

    if field == 'district'
      sql = <<-SQL
        #{with_sql}
        SELECT
          COUNT(*),
          stores.city,
          stores.district
        FROM
          match_stores
          JOIN stores on stores.id = match_stores.id
        GROUP BY
          stores.city,
          stores.district
        ORDER BY
          stores.count DESC
      SQL
    else
      sql = <<-SQL
        #{with_sql}
        SELECT
          COUNT(*),
          stores.city
        FROM
          match_stores
          JOIN stores on stores.id = match_stores.id
        GROUP BY
          stores.city
        ORDER BY
          stores.count DESC
      SQL
    end

    ActiveRecord::Base.connection.query(sql)
  end

  def format_city(result)
    result.map do |(count, city)|
      SearchResult.new('city', city, nil, nil, count)
    end
  end

  def format_district(result)
    result.map do |(count, city, district)|
      SearchResult.new('district', district, city, nil, count)
    end
  end
end
