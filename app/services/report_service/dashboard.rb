class ReportService::Dashboard < Service
  def perform
    {
      store_count: Store.count,
      user_count: User.count,
      store_photo_count: StorePhoto.count,
      review_count: Review.count
    }
  end
end
