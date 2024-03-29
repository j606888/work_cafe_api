class StorePhotoService::CreateFromGoogle < Service
  include QueryHelpers::QueryStore

  S3_BUCKET = 'work-cafe-staging'
  S3_PREFIX = 'https://work-cafe-staging.s3.ap-southeast-1.amazonaws.com/'

  def initialize(store_id:, limit: 10)
    @store_id = store_id
    @limit = limit
  end

  def perform
    store = find_store_by_id(@store_id)
    photo_references = query_photo_references(store)
    return if photo_references.blank?

    existing_reference_map = build_reference_map(store)

    fetch_count = 0
    photo_references.each do |photo_reference|
      break if fetch_count > @limit
      next if existing_reference_map[photo_reference].present?
      ActiveRecord::Base.transaction do

        photo = GoogleMapPlace.photo(photo_reference)
        store_photo = StorePhoto.create!(
          store: store,
          photo_reference: photo_reference
        )

        key = "stores/#{store.place_id}/#{store_photo.random_key}.jpeg"
        upload_to_s3(key, photo)

        image_url = S3_PREFIX + key
        store_photo.update!(image_url: image_url)
      end
      fetch_count += 1
    end

    first_store_photo = store.store_photos.first
    store.update!(image_url: first_store_photo.image_url)
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

  def build_reference_map(store)
    StorePhoto.where(store: store).pluck(:photo_reference).index_with(true)
  end

  def upload_to_s3(key, photo)
    s3 = Aws::S3::Client.new
    s3.put_object(
      bucket: S3_BUCKET,
      key: key,
      body: photo,
      content_type: 'image/jpeg'
    )
  end
end
