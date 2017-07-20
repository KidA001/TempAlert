class Record < ApplicationRecord
  MIN_RECORDS_PER_HOUR = 10
  validates :temperature, :recorded_at, presence: true


  def self.above_temp_since?(temp, hours)
    return ArgumentError, 'hours must be a positive integer' if hours < 1
    now = Time.now

    hours.times do |n|
      from = (n+1).hours.ago
      to = now - n.hours

      records = Record.where(
        "recorded_at BETWEEN ? and ? and temperature <= ?",
        from, to, temp
      )
      return false if records.empty? || records.count < MIN_RECORDS_PER_HOUR
    end
    true
  end

  def self.current
    Record.where(recorded_at: 10.minutes.ago..Time.now).
      order(recorded_at: :desc).
      limit(1).
      first
  end
end
