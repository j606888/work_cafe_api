class OpeningHourService::Create < Service
  include QueryHelpers::QueryStore

  def initialize(store_id:)
    @store_id = store_id
  end

  def perform
    store = find_store_by_id(@store_id)
    store_source = query_store_source!(store)

    open_periods = store_source.source_data.dig('opening_hours', 'periods')
    return if open_periods.blank? || store_never_close?(open_periods)

    open_periods.each do |period|
      OpeningHour.create!(
        store: store,
        open_day: period['open']['day'],
        open_time: period['open']['time'],
        close_day: period['close']['day'],
        close_time: period['close']['time']
      )
    end
  end

  private

  def query_store_source!(store)
    store_source = store.store_source
    return store_source if store_source.present?

    raise ActiveRecord::RecordNotFound, "StoreSource for store_id `#{store.id}` not exist"
  end

  def store_never_close?(open_periods)
    open_periods.length == 1 && open_periods.first['close'].nil?  
  end
end
