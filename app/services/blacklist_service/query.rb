class BlacklistService::Query < Service
  MAX_LIMIT = 200

  def initialize(limit: MAX_LIMIT)
    @limit = limit
  end

  def perform
    validate_limit!(@limit)
    Blacklist.where(is_delete: false).limit(@limit)
  end

  private

  def validate_limit!(limit)
    return if limit <= MAX_LIMIT

    raise Service::PerformFailed, "Over max limit"
  end
end
