class ExtendedUseWorker
  include Sidekiq::Worker

  def perform
    return unless Record.above_temp_since?(EXTENDED_USE_TEMP, EXTENDED_USE_HOURS)
    Notification::ExtendedUse.new(EXTENDED_USE_TEMP, EXTENDED_USE_HOURS).send_notif!
  end
end
