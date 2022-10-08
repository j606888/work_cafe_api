class StoreService::ReviewReport < Service
  include QueryHelpers::QueryStore

  def initialize(store_id:)
    @store_id = store_id
  end

  def perform
    store = find_store_by_id(@store_id)
    report = {
      recommend: init_count(Review::VALID_RECOMMENDS),
      room_volume: init_count(Review::VALID_ROOM_VOLUMES),
      time_limit: init_count(Review::VALID_TIME_LIMITS),
      socket_supply: init_count(Review::VALID_SOCKET_SUPPLIES)
    }

    store.reviews.each do |review|
      report[:recommend][review.recommend.to_sym] += 1
      report[:room_volume][review.room_volume.to_sym] += 1 if review.room_volume
      report[:time_limit][review.time_limit.to_sym] += 1 if review.time_limit
      report[:socket_supply][review.socket_supply.to_sym] += 1 if review.socket_supply
    end

    tags_array = build_tags_array(store)

    report[:primary_tags] = tags_array.filter do |tag_info|
      tag_info[:primary]
    end
    report[:secondary_tags] = tags_array.filter do |tag_info|
      !tag_info[:primary]
    end

    report
  end

  private

  def init_count(options)
    options.map(&:to_sym).index_with(0)
  end

  def build_tags_array(store)
    tags = store.tags
    tag_map = tags.each_with_object({}) do |tag, memo|
      memo[tag.id] = {
        primary: tag.primary,
        name: tag.name,
        count: 0
      }
      memo
    end

    store.store_review_tags.each do |store_review_tag|
      tag_map[store_review_tag.tag_id][:count] += 1
    end

    tag_map.values
  end
end
