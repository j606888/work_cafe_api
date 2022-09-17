class StorePhotoService::CreateFromUser < Service
  include QueryHelpers::QueryStore
  include QueryHelpers::QueryUser

  def initialize(user_id:, store_id:, url:)
    @user_id = user_id
    @store_id = store_id
    @url = url
  end

  def perform
    user = find_user_by_id(@user_id)
    store = find_store_by_id(@store_id)

    validate_url!(store, @url)
    random_key = parse_random_key_from_url(@url)

    StorePhoto.create!(
      user: user,
      store: store,
      random_key: random_key,
      image_url: @url
    )
  end

  private

  def validate_url!(store, url)
    return if url.include?(store.place_id)

    raise Service::PerformFailed, "Url invalid"
  end

  def parse_random_key_from_url(url)
    regex = /stores\/.*\/(?<random_key>.*)\.(.+)$/
    match = url.match regex

    if match.nil?
      raise Service::PerformFailed, "Parse random_key failed"
    end

    match[:random_key]
  end
end
