class StoreService::SearchByLocation < Service
  # 1度 100km
  # 0.1度 10km
  # 0.03度 3km
  DEFAULT_RANGE = 0.03
  def initialize(lat:, lng:, zoom:nil)
    @lat = lat
    @lng = lng
    @zoom = zoom
  end

  def perform
    min_lat, max_lat = cal_range(@lat)
    min_lng, max_lng = cal_range(@lng)

    sql = <<-SQL
      SELECT id FROM stores
      WHERE (lat BETWEEN :min_lat AND :max_lat)
      AND (lng BETWEEN :min_lng AND :max_lng)
      LIMIT 50
    SQL
    query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, {
      min_lat: min_lat,
      max_lat: max_lat,
      min_lng: min_lng,
      max_lng: max_lng
    }])
    rows = ActiveRecord::Base.connection.query(query)
    store_ids = rows.map(&:first)

    Store.where(id: store_ids)
  end

  private
  def cal_range(middle)
    [middle - DEFAULT_RANGE, middle + DEFAULT_RANGE]
  end
end
