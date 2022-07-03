class StoreService::SearchByLocation < Service
  def initialize(lat:, lng:, max_distance: 10000)
    @lat = lat
    @lng = lng
    @max_distance = max_distance
  end

  def perform
    sql = <<-SQL
      SELECT *, earth_distance(ll_to_earth(:lat, :lng), ll_to_earth(lat, lng))::INTEGER AS distance
      FROM stores
      WHERE earth_box(ll_to_earth (:lat, :lng), :max_distance) @> ll_to_earth (lat, lng)
        AND earth_distance(ll_to_earth (:lat, :lng), ll_to_earth (lat, lng)) < :max_distance
      ORDER BY distance
      LIMIT 50
    SQL
    arg = {
      lat: @lat,
      lng: @lng,
      max_distance: @max_distance
    }
    query = ActiveRecord::Base.sanitize_sql_array([sql, arg])
    Store.find_by_sql(query)
  end
end
