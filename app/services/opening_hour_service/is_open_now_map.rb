class OpeningHourService::IsOpenNowMap < Service
  def initialize(store_ids:)
    @store_ids = store_ids
  end

  def perform
    now = Time.now.in_time_zone('Taipei')
    open_day = now.wday
    cur_time = now.strftime("%H%M")

    open_store_ids = OpeningHour.where(store_id: @store_ids, open_day: open_day, close_day: open_day)
      .where("open_time <= ? AND close_time >= ?", cur_time, cur_time)
      .pluck(:store_id)
    open_24_store_ids = OpeningHour.where(store_id: @store_ids, open_day: 0, open_time: '0000', close_day: nil, close_time: nil).pluck(:store_id)
    is_open_map = (open_store_ids + open_24_store_ids).uniq.index_with(true)

    @store_ids.each_with_object({}) do |store_id, memo|
      memo[store_id] = is_open_map[store_id].present?
    end
  end
end
