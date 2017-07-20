module Notification
  class LeftOn < NotificationBase
    attr_reader :temperature, :time

    def initialize(temperature, time)
      @temperature = temperature
      @time = time
    end

    def subscribers
      Subscriber.subscribed_to(notif)
    end

    def notif
      'left_on'
    end

    def ready_to_send?
      subscribers.present? && !exceeded_quota?
    end

    def sms_body
      "Hot has been over #{temperature} for #{time.to_words}"
    end

    def key
      notif
    end

    def quota
      6.hours
    end

    def email_body
      sms_body
    end

    def email_subject
      "Hot tub has been left on for #{time.to_words}!"
    end

    private

    def exceeded_quota?
      $redis.exists(key)
    end
  end
end
