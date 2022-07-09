module QueryHelpers::QueryPagination
  MAX_PER = 100
  def validate_per!(per)
    return if per <= MAX_PER
    
    raise Service::PerformFailed, "per `#{per}` over max size `100`"
  end
end
