class StoreSummaryService::Refresh < Service
  include QueryHelpers::QueryStore

  def initialize(store_id:)
    @store_id = store_id
  end

  def perform
    store = find_store_by_id(@store_id)
    score_map = init_score_map
    store.reviews.each do |review|
      score_map["recommend_#{review.recommend}".to_sym] += 1
      if review.room_volume.present?
        score_map["room_volume_#{review.room_volume}".to_sym] += 1
      end
      if review.time_limit.present?
        score_map["time_limit_#{review.time_limit}".to_sym] += 1
      end
      if review.socket_supply.present?
        score_map["socket_supply_#{review.socket_supply}".to_sym] += 1
      end
    end

    summary = StoreSummary.find_or_create_by(store_id: store.id)
    summary.update!(score_map)
    summary
  end

  private

  def init_score_map
    {
      recommend_yes: 0,
      recommend_normal: 0,
      recommend_no: 0,
      room_volume_quiet: 0,
      room_volume_normal: 0,
      room_volume_loud: 0,
      time_limit_no: 0,
      time_limit_weekend: 0,
      time_limit_yes: 0,
      socket_supply_yes: 0,
      socket_supply_rare: 0,
      socket_supply_no: 0
    }
  end
end
