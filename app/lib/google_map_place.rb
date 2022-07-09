require File.expand_path('google_map_place/configuration', __dir__)

class GoogleMapPlace
  extend Configuration

  def self.detail(place_id, language='zh-TW')
    Detail.find(place_id, language)
  end

  # GoogleMapPlace.nearbysearch(location: '22.9811008,120.2163941', type: 'cafe', radius: 2000)
  def self.nearbysearch(location: nil, type: nil, keyword: nil, radius: nil, pagetoken: nil)
    Nearbysearch.find(location, type, keyword, radius, pagetoken)
  end

  def self.photo(photo_reference, maxwidth: 400)
    Photo.find(photo_reference, maxwidth)
  end
end