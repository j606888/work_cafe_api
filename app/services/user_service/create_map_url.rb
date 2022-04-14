class UserService::CreateMapUrl < Service
  GOOGLE_MAP_PREFIX = "https://www.google.com.tw/maps/place"

  def initialize(user_id:, url:)
    @user_id = user_id
    @url = url
  end

  def perform
    keyword = extract_keyword_from_url!(@url)
    map_url = MapUrl.create!(
      user_id: @user_id,
      url: @url,
      keyword: keyword
    )
    map_url
  end

  private
  def extract_keyword_from_url!(url)
    if url.exclude?(GOOGLE_MAP_PREFIX)
      raise Service::PerformFailed, "Url `#{url}` not from google_map"
    end

    readable_url = CGI.unescape(url)
    captured = /maps\/place\/(?<keyword>.*)\/@/.match(readable_url)
    keyword = captured['keyword']
    if keyword.empty?
      raise Service::PerformFailed, "Nothing was extract from url `#{url}`"
    end

    keyword
  end
end
