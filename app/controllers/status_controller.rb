class StatusController < ApplicationController
  using DayCalculator

  def index
    @current_time = Time.now.in_time_zone("Pacific Time (US & Canada)")
    @daytime = @current_time.daytime?
    @current_record = Record.current || Record.new(temperature: 103, recorded_at: Time.now)
  end
end
