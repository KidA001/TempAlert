module Notification
  class LeftOn < NotificationBase
    include ActionView::Helpers::DateHelper
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
      "Hot has been over #{temperature} for #{distance_of_time_in_words(time, Time.now)}"
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
      "Hot tub has been left on for #{distance_of_time_in_words(time, Time.now)}!"
    end

    private

    def exceeded_quota?
      $redis.exists(key)
    end
  end
end
