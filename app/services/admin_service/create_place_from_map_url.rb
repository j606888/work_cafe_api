class AdminService::CreatePlaceFromMapUrl < Service
  def initialize(map_url_id:, place_id:)
    @map_url_id = map_url_id
    @place_id = place_id
  end

  def perform
    map_url = query_map_url!(@map_url_id)
    validate_map_url!(map_url, @name)

    map_url.update!(place_id: @place_id)

    StoreService::CreateFromGoogleApi.new(
      source_type: 'MapUrl',
      source_id: map_url.id
    ).perform
    map_url.do_accept!
  end

  private
  def query_map_url!(map_url_id)
    map_url = MapUrl.find_by(id: map_url_id)

    if map_url.nil?
      raise Service::PerformFailed, "MapUrl with id `#{map_url_id}` not found"
    end

    map_url
  end

  def validate_map_url!(map_url, name)
    if map_url.store.present?
      raise Service::PerformFailed, "map_url with id `#{map_url.id}` already bind store"
    end
  end
end
