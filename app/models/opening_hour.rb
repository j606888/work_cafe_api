class OpeningHour < ApplicationRecord
  belongs_to :store

  validates :open_day, :open_time, :close_day, :close_time, presence: true
  validates :open_day, :close_day, numericality: { in: 0..6 }
  validate :in_24_hour

  WEEKDAY_LABELS = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]

  def self.empty_weekday_map
    memo = {}
    WEEKDAY_LABELS.each_with_index do |weekday, index|
      memo[index] = {
        label: weekday,
        periods: []
      }
    end

    memo
  end

  private
  def in_24_hour
    return if open_time.nil? || close_time.nil?

    if open_time.to_i > 2400 || open_time.to_i < 0
      errors.add(:open_time, "Time period not valid")
    end

    
    if close_time.to_i > 2400 || close_time.to_i < 0
      errors.add(:close_time, "Time period not valid")
    end
  end
end
