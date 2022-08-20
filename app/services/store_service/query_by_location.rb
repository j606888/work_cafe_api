class StoreService::QueryByLocation < Service
  DEFAULT_LIMIT = 60

  def initialize(lat:, lng:, limit: DEFAULT_LIMIT)
    @lat = lat
    @lng = lng
    @limit = limit
  end

  def perform
    sql = <<-SQL
      SELECT *, earth_distance(ll_to_earth(:lat, :lng), ll_to_earth(lat, lng))::INTEGER AS distance
      FROM stores
      WHERE hidden = false
      ORDER BY distance
      LIMIT :limit
    SQL
    arg = {
      lat: @lat,
      lng: @lng,
      limit: @limit
    }
    query = ActiveRecord::Base.sanitize_sql_array([sql, arg])
    Store.find_by_sql(query)
  end
end
