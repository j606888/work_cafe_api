class GoogleMapPlace
  class Detail
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

    def lat
      @data.dig('geometry', 'location', 'lat').to_s
    end

    def lng
      @data.dig('geometry', 'location', 'lng').to_s
    end

    def photos
      @data['photos'].map { |photo| photo['photo_reference'] }
    end

    def url
      @data['url']
    end


    def website
      @data['website']
    end

    def address
      @data['formatted_address']
    end

    def rating
      @data['rating']
    end

    def phone
      @data['formatted_phone_number']
    end

    def user_ratings_total
      @data['user_ratings_total']
    end

    def city
      parse_address('administrative_area_level_1')
    end

    def district
      parse_address('administrative_area_level_2') || parse_address('administrative_area_level_3')
    end

    def parse_address(type)
      components = @data['address_components']
      target = components.find { |c| c['types'] == [type, 'political'] }
      return if target.nil?

      target['long_name']
    end

    def open_periods
      @data.dig('opening_hours', 'periods')
    end

    def self.find(place_id, language = 'zh-TW')
      args = { place_id: place_id, language: language }
      result = GoogleMapPlace::Api.query(:detail_service, args)['result']

      Detail.new(result)
    end
  end
end
