class Service
  class PerformFailed < StandardError
    attr_reader :code
    def initialize(message, code: nil)
      @code = code
      super(message)
    end
  end

  def self.call(...)
    new(...).perform
  end

  def perform
    raise "#{self.class.name} should implement #perform"
  end

  def validate_inclusion!(lists, item, allow_nil: false)
    return if allow_nil && item.nil?
    return if lists.include?(item)

    raise PerformFailed, "#{item} not include in #{lists}"
  end
end
