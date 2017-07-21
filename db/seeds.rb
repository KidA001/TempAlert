FactoryGirl.create(:subscriber, :ideal_temp_subscription)
Record.create(temperature: 105, recorded_at: Time.now)
