module Notification
  class IdealTemp < NotificationBase
    attr_reader :temperature

    def initialize(temperature)
      @temperature = temperature
    end

    def subscribers
      Subscriber.subscribed_to(notif).
        where('ideal_temperature <= ?', temperature)
    end

    def notif
      'ideal_temp'
    end

    def ready_to_send?
      subscribers.present? && !exceeded_quota?
    end

    def sms_body
      "✨Hot tub is at #{temperature.to_i}✨"
    end

    def key
      "ideal_temp_#{temperature}"
    end

    def quota
      6.hours
    end

    def email_body
      " "
    end

    def email_subject
      sms_body
    end

    private

    def exceeded_quota?
      $redis.exists(key)
    end
  end
end
