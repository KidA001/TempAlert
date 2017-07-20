class LeftOnWorker
  include Sidekiq::Worker

  def perform
    return unless Record.above_temp_since?(LEFT_ON_TEMP, LEFT_ON_HOURS)
    Notification::LeftOn.new(LEFT_ON_TEMP, LEFT_ON_HOURS).send_notif!
  end
end
