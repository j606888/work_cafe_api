class AdminService::Nearbysearch < Service
  def initialize(map_url_id:)
    @map_url_id = map_url_id
  end

  def perform
    map_url = query_map_url!(@map_url_id)
    keyword, location = parse_from_url(map_url.url)

    GoogleMap.new.place_nearbysearch(keyword, location)
  end

  private
  def query_map_url!(map_url_id)
    map_url = MapUrl.find_by(id: map_url_id)

    if map_url.nil?
      raise Service::PerformFailed, "MapUrl with id `#{map_url_id}` not found"
    end

    map_url
  end

  def parse_from_url(url)
    readable_url = CGI.unescape(url)

    if readable_url.include?('/maps/place')
      captured = /maps\/place\/(?<cap>.*),\d+\.?\d*z\//.match(readable_url)
      detail = captured['cap']
      keyword, location = detail.split('/@')
    else
      raise "Unkown Type of URL `#{readable_url}`"
    end

    [keyword, location]
  end
end
