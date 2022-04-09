class GoogleMapService::ParsePlaceId < Service
  HOST = 'https://maps.googleapis.com'
  PATH = '/maps/api/place/nearbysearch/json'
  KEY = ENV['GOOGLE_MAP_API_KEY']

  def initialize(url:)
    @url = url
  end

  def perform
    query_string = parse_from_url(@url)
    res = HTTParty.post("#{HOST}#{PATH}?#{query_string}")
    place_ids = res['results'].map { |result| result['place_id'] }
    
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

    {
      location: location,
      keyword: keyword,
      radius: 10000,
      language: 'zh-TW',
      key: KEY
  }.to_param
  end
end

# url = 'https://www.google.com.tw/maps/place/%E5%8D%97%E5%B3%B6%E5%A4%A2%E9%81%8A/@23.0091775,120.207344,17z/data=!3m1!4b1!4m5!3m4!1s0x346e76f73ddc049d:0x3b110d61f9464261!8m2!3d23.0091292!4d120.2095332?hl=zh-TW'
# {"html_attributions"=>[],
#  "results"=>
#   [{"business_status"=>"OPERATIONAL",
#     "geometry"=>{"location"=>{"lat"=>23.0084985, "lng"=>120.2102036}, "viewport"=>{"northeast"=>{"lat"=>23.00986177989272, "lng"=>120.2115037298927}, "southwest"=>{"lat"=>23.00716212010728, "lng"=>120.2088040701073}}},
#     "icon"=>"https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/shopping-71.png",
#     "icon_background_color"=>"#4B96F3",
#     "icon_mask_base_uri"=>"https://maps.gstatic.com/mapfiles/place_api/icons/v2/convenience_pinlet",
#     "name"=>"7-ELEVEN 公平門市",
#     "opening_hours"=>{"open_now"=>true},
#     "photos"=>
#      [{"height"=>2268,
#        "html_attributions"=>["<a href=\"https://maps.google.com/maps/contrib/106268905277744536242\">黃成功</a>"],
#        "photo_reference"=>"Aap_uEDFTm-5nFGgIjGCAXrabTxYh2dvyguMU2blVY52E4nmjCX15amVrHTyfuPr1XQs0JoOlccxyp6i5OzbVicmsNgpVOBAdP0lEDQg64WUN0uFocsEbdvkVLw0LGe0XzvFqEx_S_D8v0BmwNPpQ_BorZn_PlSQQ1B70nBsuRhsRCx8l2QP",
#        "width"=>4032}],
#     "place_id"=>"ChIJE790L_d2bjQR8KkXvvOqArs",
#     "plus_code"=>{"compound_code"=>"2656+93 北區 台南市", "global_code"=>"7QM22656+93"},
#     "rating"=>2.3,
#     "reference"=>"ChIJE790L_d2bjQR8KkXvvOqArs",
#     "scope"=>"GOOGLE",
#     "types"=>["convenience_store", "food", "point_of_interest", "store", "establishment"],
#     "user_ratings_total"=>46,
#     "vicinity"=>"北區公園路694號"}],
#  "status"=>"OK"}
