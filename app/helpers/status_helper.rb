# frozen_string_literal: true

module StatusHelper
  def self.daytime?
    now = Time.now.in_time_zone("Pacific Time (US & Canada)")
    latitude = 37.871
    longitude = -122.258423
    sunrise = SunTimes.new.rise(now, latitude, longitude).in_time_zone("Pacific Time (US & Canada)")
    sunset =  SunTimes.new.set(now, latitude, longitude).in_time_zone("Pacific Time (US & Canada)")
    now.hour < sunset.hour && now.hour > sunrise.hour
  end
end
