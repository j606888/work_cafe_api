class GoogleMap
  class ReturnStatusInvalid < StandardError; end
  BASE_HOST = 'https://maps.googleapis.com'
  API_KEY = ENV['GOOGLE_MAP_API_KEY']

  def place_detail(place_id, language:'zh-TW')
    api_path = '/maps/api/place/details/json'
    args = {
      place_id: place_id,
      language: language
    }

    url = generate_url_with_api_key(api_path, args)
    response = send_request(:get, url)
    response['result']
  end

  def place_nearbysearch(keyword, location, radius:10000, language:'zh-TW')
    api_path = '/maps/api/place/nearbysearch/json'
    args = {
      location: location,
      keyword: keyword,
      language: language,
      radius: radius
    }

    url = generate_url_with_api_key(api_path, args)
    response = send_request(:post, url)
    response['results']
  end
  
  private
  def generate_url_with_api_key(api_path, args={})
    args[:key] = API_KEY
    uri = URI.parse("#{BASE_HOST}#{api_path}#{query_string(args)}").to_s
    uri.to_s
  end

  def query_string(args={})
    '?' + URI.encode_www_form(args) unless args.empty?
  end

  def send_request(method, url)
    if method == :get
      res = HTTParty.get(url)
    else
      res = HTTParty.post(url)
    end

    raise ReturnStatusInvalid if res['status'] != 'OK'
    res
  end
end
