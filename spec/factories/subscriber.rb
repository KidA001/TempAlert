FactoryGirl.define do
  factory :subscriber do
    name Faker::Name.first_name
    email Faker::Internet.email
    phone 5555555555
    ideal_temperature { rand(100..105) }
    subscriptions { {} }
    google_id '123456'
    photo_url 'http://coparentcoalition.org/wp-content/uploads/2012/09/blank-profile-of-woman.jpg'

    trait :ideal_temp_subscription do
      subscriptions {{ ideal_temp: { sms: true, email: true } }}
    end

    trait :extended_use_subscription do
      subscriptions {{ extended_use: { sms: true, email: true } }}
    end
  end
end
