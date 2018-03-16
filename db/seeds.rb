Record.create(temperature: 100, recorded_at: 1.hour.ago)
Record.create(temperature: 101, recorded_at: Time.now)
user = FactoryGirl.create(:user)
FactoryGirl.create(:subscription, :ideal_temperature, user: user, temperature: 101)
