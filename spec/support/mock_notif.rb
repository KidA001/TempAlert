module Notification
  class MockNotif < NotificationBase

    def subscribers; end

    def notif; end

    def ready_to_send?; end

    def sms_body; end

    def key; end

    def quota; end

    def email_body; end

    def email_subject; end
  end
end
