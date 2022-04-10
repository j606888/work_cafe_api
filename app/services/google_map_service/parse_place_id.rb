class GoogleMapService::ParsePlaceId < Service
  def initialize(url:)
    @url = url
  end

  def perform
    keyword, location = parse_from_url(@url)

    results = GoogleMap.new.place_nearbysearch(keyword, location)
    place_ids = results.map { |result| result['place_id'] }
    
    if place_ids.length != 1
      raise Service::PerformFailed, "Should find exact 1 result, but instead find `#{place_ids.length}`"
    end

    place_ids.first
  end

  private
  def parse_from_url(url)
    readable_url = CGI.unescape(url)

    if readable_url.include?('/maps/place')
      captured = /maps\/place\/(?<cap>.*),\d+z\//.match(readable_url)
      detail = captured['cap']
      keyword, location = detail.split('/@')
    else
      raise "Unkown Type of URL `#{readable_url}`"
    end

    [keyword, location]
  end
end
