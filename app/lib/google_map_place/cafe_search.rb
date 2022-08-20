class GoogleMapPlace
  class CafeSearch
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def next_page_token
      @data['next_page_token']
    end

    def places
      @data['results'].map do |result|
        {
          place_id: result['place_id'],
          name: result['name']
        }
      end
    end

    def next_page
      return unless next_page_token.present?

      sleep(2)
      args = {
        pagetoken: next_page_token
      }
      result = GoogleMapPlace::Api.query(:nearbysearch_service, args)
      CafeSearch.new(result)
    end

    def self.find(location, radius, pagetoken)
      args = {
        type: 'cafe',
        location: location,
        radius: radius,
        pagetoken: pagetoken
      }
      result = GoogleMapPlace::Api.query(:nearbysearch_service, args)
      CafeSearch.new(result)
    end
  end
end
