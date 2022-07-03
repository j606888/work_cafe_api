class GoogleMapPlace
  class Nearbysearch
    def self.find(location, type, keyword, radius, pagetoken)
      args = {
        location: location,
        type: type,
        keyword: keyword,
        radius: radius,
        pagetoken: pagetoken
      }.compact
      result = GoogleMapPlace::Api.query(:nearbysearch_service, args)

      # Detail.new(result)
    end
  end
end
