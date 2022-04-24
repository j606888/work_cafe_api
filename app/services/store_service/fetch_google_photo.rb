class StoreService::FetchGooglePhoto < Service
  S3_BUCKET = 'work-cafe-staging'
  S3_PREFIX = 'https://work-cafe-staging.s3.ap-southeast-1.amazonaws.com/'

  def initialize(store_id:)
    @store_id = store_id
  end

  def perform
    store = Store.find_by(id: @store_id)
    source = store.sourceable

    photos = source.source_data['photos']
    return if photos.blank?

    photo_reference = photos.first['photo_reference']
    photo = GoogleMap.new.place_photo(photo_reference)
    place_id = source.place_id

    key = "stores/#{place_id}.jpeg"
    s3 = Aws::S3::Client.new
    s3.put_object(
      bucket: S3_BUCKET,
      key: key,
      body: photo.body,
      content_type: 'image/jpeg'
    )

    image_url = S3_PREFIX + key
    store.update!(image_url: image_url)
  end
end
