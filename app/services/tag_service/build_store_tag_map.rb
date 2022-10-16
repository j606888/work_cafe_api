class TagService::BuildStoreTagMap < Service
  def initialize(store_ids:, only_primary: false)
    @store_ids = store_ids
    @only_primary = only_primary
  end

  def perform
    row_result = StoreReviewTag.where(store_id: @store_ids)
      .group(:store_id, :tag_id)
      .count

    if @only_primary
      tags = Tag.where(primary: true)
    else
      tags = Tag.all
    end

    tag_map = tags.each_with_object({}) do |tag, memo|
      memo[tag.id] = tag.name
    end

    result = {}
    row_result.each do |(store_id, tag_id), count|
      result[store_id] ||= []
      result[store_id] << {
        name: tag_map[tag_id],
        count: count
      }
    end

    result
  end
end
