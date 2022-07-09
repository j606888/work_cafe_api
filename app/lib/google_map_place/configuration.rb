class GoogleMapPlace
  class InvalidConfigurationError < StandardError; end

  module Configuration
    VALID_OPTIONS_KEYS = %i[
      end_point format language api_key
      detail_service nearbysearch_service photo_service
    ]

    DEFAULT_END_POINT = 'https://maps.googleapis.com/maps/api/place'
    DEFAULT_FORMAT = 'json'
    DEFAULT_LANGUAGE = 'zh-TW'

    DEFAULT_DETAIL_SERVICE = 'details/json'
    DEFAULT_NEARBYSEARCH_SERVICE = 'nearbysearch/json'
    DEFAULT_PHOTO_SERVICE = 'photo'

    attr_accessor(*VALID_OPTIONS_KEYS)

    def configure
      reset
      yield self
      validate_config
    end

    def validate_config
      raise GoogleMapPlace::InvalidConfigurationError, 'No API key provide' unless api_key
    end

    def reset
      self.end_point = DEFAULT_END_POINT
      self.format = DEFAULT_FORMAT
      self.language = DEFAULT_LANGUAGE
      self.detail_service = DEFAULT_DETAIL_SERVICE
      self.nearbysearch_service = DEFAULT_NEARBYSEARCH_SERVICE
      self.photo_service = DEFAULT_PHOTO_SERVICE
      self.api_key = nil
    end
  end
end
