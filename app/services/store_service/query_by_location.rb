class StoreService::QueryByLocation < Service
  DEFAULT_PER = 30
  VALID_MODES = ['normal', 'address']

  def initialize(lat:, lng:, per: DEFAULT_PER, offset: 0, user_id: nil, keyword: nil, open_type: 'NONE', open_week: nil, open_hour: nil, mode: 'normal', wake_up: nil,
                tag_ids: [])
    @user_id = user_id
    @lat = lat
    @lng = lng
    @per = per
    @offset = offset
    @keyword = keyword
    @open_type = open_type
    @open_week = open_week
    @open_hour = open_hour
    @mode = mode
    @wake_up = wake_up
    @tag_ids = tag_ids

    if @tag_ids.kind_of?(String)
      @tag_ids = @tag_ids.split(",")
    end
  end

  def perform
    validate_inclusion!(VALID_MODES, @mode)
    validate_inclusion!(OpeningHour::VALID_OPEN_TYPES, @open_type)
    validate_inclusion!(OpeningHour::VALID_OPEN_WEEKS, @open_week, allow_nil: true)
    validate_inclusion!(OpeningHour::VALID_OPEN_HOURS, @open_hour, allow_nil: true)
    SearchHistory.create!(user_id: @user_id, keyword: @keyword)

    with_tagged_stores = {}
    if @tag_ids.present?
      with_tagged_stores[:with] = <<-SQL
        WITH tag_stores AS (
          WITH tag_id_stores AS (
            SELECT store_id, tag_id
            FROM store_review_tags
            WHERE tag_id in (#{@tag_ids.map(&:to_i).join(',')})
            GROUP BY store_id, tag_id
            HAVING count(*) >= 1
          )
          SELECT store_id AS store_id
          FROM tag_id_stores
          GROUP BY store_id
          HAVING count(*) >= #{@tag_ids.count}
        )
      SQL

      with_tagged_stores[:join] = 'RIGHT JOIN tag_stores ON stores.id = tag_stores.store_id'
    end

    with_open_stores = {}
    if @open_type != 'NONE'
      if @open_type == 'OPEN_NOW'
        now = Time.now.in_time_zone('Taipei')
        @open_week = now.wday
        open_time = now.strftime("%H%M")
      else
        if @open_hour
          open_time = @open_hour < 10 ? "0#{@open_hour}00" : "#{@open_hour}00"
        end
      end

      if open_time.present?
        and_sql = " AND (
          (open_time < '#{open_time}' AND close_time > '#{open_time}')
          OR (open_time < '#{open_time}' AND open_day != close_day)
        )"
      end

      prefix = @tag_ids.present? ? ", " : "WITH "
      with_open_stores[:with] = <<-SQL
        #{prefix} open_stores AS (
          SELECT store_id
          FROM opening_hours
          WHERE open_day = #{@open_week.to_i}
          #{and_sql}
        )
      SQL
      with_open_stores[:join] = "RIGHT JOIN open_stores ON stores.id = open_stores.store_id"
    end

    with_wake_up_stores = {}
    if @wake_up
      prefix = (@tag_ids.present? || @open_type != 'NONE') ? ", " : "WITH "
      with_wake_up_stores[:with] = <<-SQL
        #{prefix} wake_up_stores AS (
          SELECT distinct store_id
          FROM reviews
        )
      SQL
      with_wake_up_stores[:join] = "RIGHT JOIN wake_up_stores ON stores.id = wake_up_stores.store_id"
    end

    where_sql = build_where_sql(
      mode: @mode,
      keyword: @keyword
    )

    sql = <<-SQL.squish
      #{with_tagged_stores[:with]}
      #{with_open_stores[:with]}
      #{with_wake_up_stores[:with]}
      SELECT distinct(stores.*), earth_distance(ll_to_earth(:lat, :lng), ll_to_earth(lat, lng))::INTEGER AS distance
      FROM stores
      #{with_tagged_stores[:join]}
      #{with_open_stores[:join]}
      #{with_wake_up_stores[:join]}
      #{where_sql}
      ORDER BY distance
      OFFSET :offset
      LIMIT :per
    SQL
    arg = {
      lat: @lat,
      lng: @lng,
      per: @per,
      offset: @offset
    }
    query = ActiveRecord::Base.sanitize_sql_array([sql, arg])
    {
      total_stores: count_total_stores(sql, @lat, @lng),
      stores: Store.find_by_sql(query)
    }
  end

  def count_total_stores(sql, lat, lng)
    count_sql = sql.gsub("SELECT distinct(stores.*), earth_distance(ll_to_earth(:lat, :lng), ll_to_earth(lat, lng))::INTEGER AS distance", "SELECT count(*)")
      .gsub("ORDER BY distance", "")
      .gsub("OFFSET :offset", "")
      .gsub("LIMIT :per", "")
    query = ActiveRecord::Base.sanitize_sql_array([count_sql, { lat: lat, lng: lng }])
    res = ActiveRecord::Base.connection.query(query)
    res.last.last
  end

  private

  def build_where_sql(mode:, keyword:)
    sql = "WHERE hidden = false"
    if keyword.present?
      if should_use_address_mode?(mode, keyword)
        sql += <<-SQL
          AND (
            city ILIKE '#{keyword.downcase}'
            OR district ILIKE '#{keyword.downcase}'
            OR address ILIKE '%%#{keyword.downcase}%%'
          )
        SQL
      else
        sql += " AND name ILIKE '%%#{keyword.downcase}%%'"
      end
    end

    sql
  end

  def should_use_address_mode?(mode, keyword)
    return false if mode != 'address'
    return true if Store::CITY_LIST.include?(keyword)
    return true if Store.pluck(:district).uniq.include?(keyword)
    Store::CITY_LIST.each do |city|
      return true if keyword.include?(city)
    end

    false
  end
end
