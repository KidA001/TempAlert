Record.create(temperature: 100, recorded_at: 1.hour.ago)
Record.create(temperature: 101, recorded_at: Time.now)
user = FactoryBot.create(:user)
FactoryBot.create(:subscription, :ideal_temperature, user: user, temperature: 101)
