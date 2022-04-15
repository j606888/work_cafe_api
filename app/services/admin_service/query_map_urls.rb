class AdminService::QueryMapUrls < Service
  VALID_STATES = ['created', 'accept', 'deny']

  def initialize(page:1, per:10, state:nil)
    @page = page
    @per = per
    @state = state
  end

  def perform
    validate_state!(@state)
    map_urls = MapUrl.order(id: :desc)
    if @state.present?
      map_urls = map_urls.where(aasm_state: @state)
    end
    
    map_urls.page(@page).per(@per)
  end

  private
  def validate_state!(state)
    return if state.nil?

    if VALID_STATES.exclude?(state)
      raise Service::PerformFailed, "State `#{state}` is not valid"
    end
  end
end
