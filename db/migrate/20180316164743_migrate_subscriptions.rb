class MigrateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    User.where.not(subscriptions: {}).find_each do |user|
      ideal_temp = user.subscriptions['ideal_temp']
      extended_use = user.subscriptions['extended_use']

      if ideal_temp
        Subscription.create!(
          type: :ideal_temperature,
          user: user,
          sms_enabled: ideal_temp['sms'],
          email_enabled: ideal_temp['email'],
          metadata: { ideal_temperature: user.ideal_temperature }
        )
      end

      if extended_use
        Subscription.create!(
          type: :extended_use,
          user: user,
          sms_enabled: extended_use['sms'],
          email_enabled: extended_use['email']
        )
      end
    end
  end
end
