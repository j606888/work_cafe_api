class StoreService::QueryByLocation < Service
  DEFAULT_LIMIT = 60
  VALID_MODES = ['normal', 'address']

  def initialize(lat:, lng:, limit: DEFAULT_LIMIT, user_id: nil, keyword: nil, open_type: 'NONE', open_week: nil, open_hour: nil, mode: 'normal', wake_up: nil,
                tag_ids: [])
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
    @tag_ids = tag_ids
  end

  def perform
    validate_inclusion!(VALID_MODES, @mode)
    validate_inclusion!(OpeningHour::VALID_OPEN_TYPES, @open_type)
    validate_inclusion!(OpeningHour::VALID_OPEN_WEEKS, @open_week, allow_nil: true)
    validate_inclusion!(OpeningHour::VALID_OPEN_HOURS, @open_hour, allow_nil: true)

    with_tagged_stores = {}
    if @tag_ids.present?
      with_tagged_stores[:with] = <<-SQL
        WITH tag_stores AS (
          WITH tag_id_stores AS (
            SELECT
              store_id, tag_id
            FROM
              store_review_tags
            WHERE
              tag_id in (#{@tag_ids.map(&:to_i).join(',')})
            GROUP BY
              store_id, tag_id
            HAVING
              count(*) >= 1
          )
          SELECT
            store_id AS store_id
          FROM
            tag_id_stores
          GROUP BY
            store_id
          HAVING
            count(*) >= #{@tag_ids.count}
        )
      SQL

      with_tagged_stores[:join] = "RIGHT JOIN tag_stores ON stores.id = tag_stores.store_id"
    end

    where_sql = build_where_sql(
      mode: @mode,
      keyword: @keyword,
      open_type: @open_type,
      open_week: @open_week,
      open_hour: @open_hour,
      wake_up: @wake_up
    )

    sql = <<-SQL
      #{with_tagged_stores[:with]}
      SELECT distinct(stores.*), earth_distance(ll_to_earth(:lat, :lng), ll_to_earth(lat, lng))::INTEGER AS distance
      FROM stores
      #{with_tagged_stores[:join]}
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

  def build_where_sql(mode:, keyword:, open_type:, open_week:, open_hour:, wake_up:)
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
