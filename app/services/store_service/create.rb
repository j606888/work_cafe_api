class StoreService::Create < Service
  def initialize(place_id:)
    @place_id = place_id
  end

  def perform
    validate_store_not_exist!(@place_id)

    detail = GoogleMapPlace.detail(@place_id)
    validate_detail!(detail, @place_id)

    ActiveRecord::Base.transaction do
      store = create_store!(detail)
      create_store_source!(store, detail)
      OpeningHourService::Create.call(store_id: store.id)
      StorePhotoService::CreateFromGoogle.call(store_id: store.id, limit: 1)

      store
    end
  end

  private

  def validate_store_not_exist!(place_id)
    return unless Store.exists?(place_id: place_id)

    raise Service::PerformFailed, "place_id `#{place_id}` already exist"
  end

  def validate_detail!(detail, place_id)
    return if detail.data.present?

    raise Service::PerformFailed, "Fetch detail failed with place_id `#{place_id}`"
  end

  def create_store_source!(store, detail)
    StoreSource.create!(
      store: store,
      source_data: detail.data
    )
  end

  def create_store!(detail)
    city = Store::CITY_LIST.find do |city_name|
      detail.address.include?(city_name)
    end

    Store.create!(
      place_id: detail.place_id,
      name: detail.name,
      address: detail.address,
      vicinity: detail.vicinity,
      phone: detail.phone,
      url: detail.url,
      website: detail.website,
      rating: detail.rating,
      user_ratings_total: detail.user_ratings_total,
      lat: detail.lat,
      lng: detail.lng,
      city: city || detail.city,
      district: detail.district,
      permanently_closed: detail.permanently_closed,
      hidden: detail.user_ratings_total.nil?
    )
  end
end
