class BlacklistService::Create < Service
  def initialize(keyword:)
    @keyword = keyword
  end

  def perform
    Blacklist.create!(keyword: @keyword)
  end
end
