class GoogleMapPlace
  class Nearbysearch
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def name
      @data['name']
    end

    def place_id
      @data['place_id']
    end

    def types
      @data['types']
    end

    def self.find(location, type, keyword, radius, pagetoken)
      args = {
        location: location,
        type: type,
        keyword: keyword,
        radius: radius,
        pagetoken: pagetoken
      }.compact
      result = GoogleMapPlace::Api.query(:nearbysearch_service, args)['results'].first

      Nearbysearch.new(result)
    end
  end
end
