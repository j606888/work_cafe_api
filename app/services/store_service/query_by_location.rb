class StoreService::QueryByLocation < Service
  DEFAULT_LIMIT = 60

  def initialize(lat:, lng:, limit: DEFAULT_LIMIT, keyword: nil)
    @lat = lat
    @lng = lng
    @limit = limit
    @keyword = keyword
  end

  def perform
    where_sql = build_where_sql(@keyword)

    sql = <<-SQL
      SELECT *, earth_distance(ll_to_earth(:lat, :lng), ll_to_earth(lat, lng))::INTEGER AS distance
      FROM stores
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

  def build_where_sql(keyword)
    sql = "WHERE hidden = false"
    if keyword.present?
      sql += " AND name ILIKE '%#{keyword.downcase}%'"
    end

    sql
  end
end
