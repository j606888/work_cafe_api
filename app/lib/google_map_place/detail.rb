class GoogleMapPlace
  class Detail
    attr_reader :data
    
    def initialize(data)
      @data = data
    end

     def lat
      @data.dig('geometry', 'location', 'lat').to_s
    end

    def lng
      @data.dig('geometry', 'location', 'lng').to_s
    end

    def place_id
      @data['place_id']
    end

    def photos
      @data['photos']
    end

    def url
      @data['url']
    end

    def name
      @data['name']
    end

    def website
      @data['website']
    end

    def address
      @data['formatted_address']
    end

    def self.find(place_id, language = 'zh-TW')
      args = { place_id: place_id, language: language }
      result = GoogleMapPlace::Api.query(:detail_service, args)['result']

      Detail.new(result)
    end
  end
end
