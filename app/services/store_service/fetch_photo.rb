class StoreService::FetchPhoto < Service
  include QueryHelpers::QueryStore

  S3_BUCKET = 'work-cafe-staging'
  S3_PREFIX = 'https://work-cafe-staging.s3.ap-southeast-1.amazonaws.com/'

  def initialize(store_id:)
    @store_id = store_id
  end

  def perform
    store = find_store_by_id(@store_id)
    photo_references = query_photo_references(store)
    return if photo_references.blank?

    photo_reference = photo_references.first
    photo = GoogleMapPlace.photo(photo_reference)

    key = "stores/#{store.place_id}.jpeg"
    s3 = Aws::S3::Client.new
    s3.put_object(
      bucket: S3_BUCKET,
      key: key,
      body: photo,
      content_type: 'image/jpeg'
    )

    image_url = S3_PREFIX + key
    store.update!(image_url: image_url)
    store
  end

  private

  def query_photo_references(store)
    store_source = store.store_source
    if store_source.nil?
      raise Service::PerformFailed, "StoreSource from store_id `#{store.id}` not found"
    end

    photos = store_source.source_data['photos']
    return [] if photos.blank?

    photos.map { |photo| photo['photo_reference'] }
  end
end
