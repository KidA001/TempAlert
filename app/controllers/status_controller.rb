# frozen_string_literal: true

class StatusController < ApplicationController
  def index
    @current_time = Time.now.in_time_zone("Pacific Time (US & Canada)")
    @daytime = daytime?
    @current_record = Record.current
  end

  private

  def daytime?
    now = DateTime.current.in_time_zone(SECRET[:local_timezone])
    lat, lon = SECRET[:lat_lon].split(',').map(&:to_f)
    sun_times = SunTimes.new
    rise = sun_times.rise(now, lat, lon).in_time_zone(SECRET[:local_timezone])
    set = sun_times.set(now, lat, lon).in_time_zone(SECRET[:local_timezone])

    now.between?(rise, set)
  end
end
