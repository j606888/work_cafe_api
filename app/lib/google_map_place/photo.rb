class GoogleMapPlace
  class Photo
    def self.find(photo_reference, maxwidth)
      args = {
        photo_reference: photo_reference,
        maxwidth: maxwidth
      }
      result = GoogleMapPlace::Api.query(:photo_service, args)

      # Detail.new(result)
    end
  end
end
