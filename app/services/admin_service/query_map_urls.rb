class AdminService::QueryMapUrls < Service
  VALID_STATUS = ['created', 'accept', 'deny']

  def initialize(page:1, per:10, status:nil)
    @page = page
    @per = per
    @status = status
  end

  def perform
    validate_status!(@status)
    map_urls = MapUrl.order(id: :desc)
    if @status.present?
      map_urls = map_urls.where(aasm_state: @status)
    end
    
    map_urls.page(@page).per(@per)
  end

  private
  def validate_status!(status)
    return if status.nil?

    if VALID_STATUS.exclude?(status)
      raise Service::PerformFailed, "status `#{status}` is not valid"
    end
  end
end
