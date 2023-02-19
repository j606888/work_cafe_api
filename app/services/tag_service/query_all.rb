class TagService::QueryAll < Service
  def perform
    Tag.left_joins(:store_review_tags)
      .group('tags.id')
      .select('tags.*, COALESCE(COUNT(store_review_tags.id), 0) as store_review_tags_count')
      .order('tags.id asc')
  end
end

