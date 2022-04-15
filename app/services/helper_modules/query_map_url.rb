module HelperModules::QueryMapUrl
  def query_map_url_by_id!(id)
    map_url = MapUrl.find_by(id: id)
    if map_url.nil?
      raise Service::PerformFailed, "MapUrl with id `#{id}` not found"
    end

    map_url
  end
end
