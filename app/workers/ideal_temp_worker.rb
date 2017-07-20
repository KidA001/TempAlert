class IdealTempWorker
  include Sidekiq::Worker

  def perform
    current_temperature = Record.current.try(:temperature)
    return if current_temperature.nil?
    Notification::IdealTemp.new(current_temperature).send_notif!
  end
end
