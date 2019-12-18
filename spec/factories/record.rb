FactoryBot.define do
  factory :record do
    temperature { rand(80..105) }
    recorded_at { DateTime.now }
  end
end
