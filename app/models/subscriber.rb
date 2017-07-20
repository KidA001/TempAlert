class Subscriber < ApplicationRecord
  validates :google_id, presence: true
  validates :name, presence: true
  validates :email, presence: true

  def sms?(notif)
    !!subscriptions.dig(notif, 'sms')
  end

  def email?(notif)
    !!subscriptions.dig(notif, 'email')
  end

  def self.subscribed_to(notif)
    Subscriber.
      where('subscriptions @> ?', { "#{notif}" => { "sms" => true } }.to_json).
    or(Subscriber.
      where('subscriptions @> ?', { "#{notif}" => { "email" => true } }.to_json))
  end

  def update_subscription!(notifs)
    subscription = subscriptions
    notifs.each do |notif|
      new_subscription = {
        "#{notif[:name]}" => { sms: notif[:sms], email: notif[:email] }
      }

      subscriptions.merge!(new_subscription)
    end
    update(subscriptions: subscription)
  end
end
