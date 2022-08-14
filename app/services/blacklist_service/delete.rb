class BlacklistService::Delete < Service
  def initialize(id:)
    @id = id
  end

  def perform
    blacklist = Blacklist.find_by(id: @id)
    if blacklist.nil?
      raise Service::PerformFailed, "Blacklist with id `#{@id}` not found"
    end

    blacklist.update!(is_delete: true)
  end
end
