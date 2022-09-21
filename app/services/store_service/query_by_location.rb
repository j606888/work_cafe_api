class StoreService::QueryByLocation < Service
  DEFAULT_LIMIT = 60
  VALID_MODES = ['normal', 'address']

  def initialize(lat:, lng:, limit: DEFAULT_LIMIT, user_id: nil, keyword: nil, open_type: 'NONE', open_week: nil, open_hour: nil, mode: 'normal', wake_up: nil)
    @user_id = user_id
    @lat = lat
    @lng = lng
    @limit = limit
    @keyword = keyword
    @open_type = open_type
    @open_week = open_week
    @open_hour = open_hour
    @mode = mode
    @wake_up = wake_up
  end

  def perform
    validate_inclusion!(VALID_MODES, @mode)
    validate_inclusion!(OpeningHour::VALID_OPEN_TYPES, @open_type)
    validate_inclusion!(OpeningHour::VALID_OPEN_WEEKS, @open_week, allow_nil: true)
    validate_inclusion!(OpeningHour::VALID_OPEN_HOURS, @open_hour, allow_nil: true)

    if @user_id.present?
      hidden_stores = UserHiddenStoreService::QueryStores.call(user_id: @user_id)
    end

    where_sql = build_where_sql(
      mode: @mode,
      keyword: @keyword,
      open_type: @open_type,
      open_week: @open_week,
      open_hour: @open_hour,
      hidden_stores: hidden_stores,
      wake_up: @wake_up
    )

    sql = <<-SQL
      SELECT distinct(stores.*), earth_distance(ll_to_earth(:lat, :lng), ll_to_earth(lat, lng))::INTEGER AS distance
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

  def build_where_sql(mode:, keyword:, open_type:, open_week:, open_hour:, hidden_stores:, wake_up:)
    sql = "WHERE hidden = false"
    if keyword.present?
      if should_use_address_mode?(mode, keyword)
        sql += " AND (city ILIKE '#{keyword.downcase}' OR district ILIKE '#{keyword.downcase}')"
      else
        sql += " AND name ILIKE '%#{keyword.downcase}%'"
      end
    end

    if open_type == 'OPEN_NOW'
      now = Time.now.in_time_zone('Taipei')
      open_week = now.wday
      cur_time = now.strftime("%H%M")

      sql += " AND open_day = #{open_week} AND close_day = #{open_week} and open_time <= '#{cur_time}' and close_time >='#{cur_time}'"
    end

    if open_type == 'OPEN_AT'
      sql += " AND open_day = #{open_week} AND close_day = #{open_week}"

      if open_hour.present?
        open_time = open_hour < 10 ? "0#{open_hour}00" : "#{open_hour}00"
        sql += " AND open_time < '#{open_time}' and close_time > '#{open_time}'"
      end
    end

    if hidden_stores.present?
      hidden_store_ids = hidden_stores.map(&:id)

      sql += " AND stores.id NOT IN (#{hidden_store_ids.join(",")})"
    end

    if wake_up.present?
      sql += " AND stores.wake_up = true"
    end

    sql
  end

  def should_use_address_mode?(mode, keyword)
    return false if @mode != 'address'
    return true if Store::CITY_LIST.include?(keyword)
    return true if Store.pluck(:district).uniq.include?(keyword)
    false
  end
end
