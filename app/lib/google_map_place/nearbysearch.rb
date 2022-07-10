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

    def self.find(location, keyword, radius)
      args = {
        location: location,
        keyword: keyword,
        radius: radius,
      }
      result = GoogleMapPlace::Api.query(:nearbysearch_service, args)['results'].first
      Nearbysearch.new(result)
    end
  end
end
