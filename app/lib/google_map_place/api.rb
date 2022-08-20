class GoogleMapPlace
  class Api
    STATUS_OK = 'OK'
    STATUS_ZERO_RESULTS = 'ZERO_RESULTS'

    class << self
      def query(service, args = {})
        url = base_url(service, args.merge(key: GoogleMapPlace.api_key))
        response(url)
      end

      private

      def response(url)
        result = HTTParty.post(url).parsed_response
        raise ZeroResultsException, "Google did not return ay results" if result['status'] == STATUS_ZERO_RESULTS
        # raise InvalidResponseException, "Google returned an error status: #{result['status']}" if result['status'] != STATUS_OK

        result
      end

      def base_url(service, args = {})
        url = URI.parse("#{GoogleMapPlace.end_point}/#{GoogleMapPlace.send(service)}#{query_string(args)}")
        url.to_s
      end

      def query_string(args = {})
        '?' + URI.encode_www_form(args) unless args.empty?
      end
    end
  end
end
