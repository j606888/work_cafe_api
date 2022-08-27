class StoreService::QueryByLocation < Service
  DEFAULT_LIMIT = 60

  def initialize(lat:, lng:, limit: DEFAULT_LIMIT, keyword: nil, open_type: 'none', open_week: nil, open_hour: nil)
    @lat = lat
    @lng = lng
    @limit = limit
    @keyword = keyword
    @open_type = open_type
    @open_week = open_week
    @open_hour = open_hour
  end

  def perform
    validate_inclusion!(OpeningHour::VALID_OPEN_TYPES, @open_type)
    validate_inclusion!(OpeningHour::VALID_OPEN_WEEKS, @open_week, allow_nil: true)
    validate_inclusion!(OpeningHour::VALID_OPEN_HOURS, @open_hour, allow_nil: true)

    where_sql = build_where_sql(
      keyword: @keyword,
      open_type: @open_type,
      open_week: @open_week,
      open_hour: @open_hour
    )

    sql = <<-SQL
      SELECT stores.*, earth_distance(ll_to_earth(:lat, :lng), ll_to_earth(lat, lng))::INTEGER AS distance
      FROM stores
      LEFT JOIN opening_hours ON stores.id = opening_hours.store_id
      #{where_sql}
      ORDER BY distance
      LIMIT :limit
    SQL
    arg = {
      lat: @lat,
      lng: @lng,
      limit: @limit,
    }
    query = ActiveRecord::Base.sanitize_sql_array([sql, arg])
    Store.find_by_sql(query)
  end

  private

  def build_where_sql(keyword:, open_type:, open_week:, open_hour:)
    sql = "WHERE hidden = false"
    if keyword.present?
      sql += " AND name ILIKE '%#{keyword.downcase}%'"
    end

    if open_type == 'open_now'
      now = Time.now.in_time_zone('Taipei')
      open_week = now.wday
      cur_time = now.strftime("%H%M")

      sql += " AND open_day = #{open_week} AND close_day = #{open_week} and open_time <= '#{cur_time}' and close_time >='#{cur_time}'"
    end

    if open_type == 'open_at'
      sql += " AND open_day = #{open_week} AND close_day = #{open_week}"
      
      if open_hour.present?
        open_time = open_hour < 10 ? "0#{open_hour}00" : "#{open_hour}00"
        sql += "and open_time <= '#{open_time}' and close_time >= '#{open_time}'"
      end
    end

    sql
  end
end
