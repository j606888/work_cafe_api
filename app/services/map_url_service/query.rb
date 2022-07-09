class MapUrlService::Query < Service
  include QueryHelpers::QueryPagination

  def initialize(user_id: nil, decision: nil, page: 1, per: 10)
    @user_id = user_id
    @decision = decision
    @page = page
    @per = per
  end

  def perform
    validate_per!(@per)

    map_urls = MapUrl.all.order(id: :desc)

    if @user_id.present?
      map_urls = map_urls.where(user_id: @user_id)
    end

    if @decision.present?
      map_urls = map_urls.where(decision: @decision)
    end

    map_urls
  end
end
