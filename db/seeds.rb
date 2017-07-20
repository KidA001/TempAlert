Subscriber.create(
  name: 'Brian',
  email: 'KidA001@gmail.com',
  phone: '14157978944',
  ideal_temperature: 104,
  subscriptions: {
    ideal_temp: { sms: true, email: true }
  }
)
Record.create(temperature: 105, recorded_at: Time.now)
