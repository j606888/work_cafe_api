class GoogleMapPlace
  class Photo
    def self.find(photo_reference, maxwidth)
      args = {
        photo_reference: photo_reference,
        maxwidth: maxwidth
      }
      GoogleMapPlace::Api.query(:photo_service, args)
    end
  end
end
