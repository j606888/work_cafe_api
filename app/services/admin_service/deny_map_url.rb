class AdminService::DenyMapUrl < Service
  include HelperModules::QueryMapUrl

  def initialize(map_url_id:)
    @map_url_id = map_url_id
  end

  def perform
    map_url = query_map_url_by_id!(@map_url_id)
    map_url.do_deny!
  end
end
