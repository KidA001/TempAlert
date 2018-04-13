# frozen_string_literal: true

class Notification::ExtendedUse
  include ActionView::Helpers::DateHelper
  attr_reader :temperature, :time
  QUOTA = 6.hours

  def initialize(temperature, time)
    @temperature = temperature
    @time = time
  end

  def send_notif!
    Subscription.extended_use.active.each do |sub|
      next if exceeds_quota?(sub.user)
      set_quota!(sub.user)
      SMS.send(sub.user.phone, sms_body) if sub.sms_enabled
      Email.send(sub.user.email, email_subject, email_body) if sub.email_enabled
    end
  end

  private

  def sms_body
    "Hot has been over #{temperature} for #{distance_of_time_in_words(time, Time.now)}"
  end

  def email_subject
    "Hot tub has been left on for #{distance_of_time_in_words(time, Time.now)}!"
  end

  def email_body
    ' '
  end

  def key(user)
    "#{user.id}_ideal_temp"
  end

  def set_quota!(user)
    $redis.setex(key(user), QUOTA.to_s.to_i, nil)
  end

  def exceeds_quota?(user)
    $redis.exists(key(user))
  end
end
