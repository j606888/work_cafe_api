class StorePhotoService::CreatePresignedUrl < Service
  include QueryHelpers::QueryStore

  S3_BUCKET = 'work-cafe-staging'
  S3_PREFIX = 'https://work-cafe-staging.s3.ap-southeast-1.amazonaws.com/'

  def initialize(store_id:, file_extension:'jpg')
    @store_id = store_id
    @file_extension = file_extension
  end

  def perform
    store = find_store_by_id(@store_id)
    object_key = "stores/#{store.place_id}/#{SecureRandom.hex(8)}.#{@file_extension}"

    bucket = Aws::S3::Bucket.new(S3_BUCKET)
    get_presigned_url(bucket, object_key)
  end

  private
  def get_presigned_url(bucket, object_key)
    bucket.object(object_key).presigned_url(:put, acl: 'public-read')
  rescue Aws::Errors::ServiceError => e
    raise Service::PerformFailed, e
  end
end
