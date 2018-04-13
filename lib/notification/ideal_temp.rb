# frozen_string_literal: true

class Notification::IdealTemp
  attr_reader :temperature
  QUOTA = 6.hours

  def initialize(temperature)
    @temperature = temperature
  end

  def send_notif!
    Subscription.ideal_temp(temperature).each do |sub|
      next if exceeds_quota?(sub.user)
      set_quota!(sub.user)
      SMS.send(sub.user.phone, sms_body) if sub.sms_enabled
      Email.send(sub.user.email, email_subject, email_body) if sub.email_enabled
    end
  end

  private

  def sms_body
    "✨Hot tub is at #{temperature.to_i}✨"
  end


  def email_body
    " "
  end

  def email_subject
    sms_body
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
