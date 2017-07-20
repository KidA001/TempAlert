module Notification
  class NotificationBase

    def send_notif!
      return unless ready_to_send?
      subscribers.each do |sub|
        SMS.send(sub.phone, sms_body) if sub.sms?(notif)
        Email.send(sub.email, email_subject, email_body) if sub.email?(notif)
      end
      set_quota!
      true
    end

    private

    def set_quota!
      $redis.setex(key, quota.to_s.to_i, nil)
    end
  end
end
