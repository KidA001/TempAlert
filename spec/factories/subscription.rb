FactoryBot.define do
  factory :subscription do
    type :extended_use
    sms_enabled true
    email_enabled true
    metadata { Hash.new }
    user { create(:user) }
  end

  trait :ideal_temperature do
    type :ideal_temperature
    transient { temperature 100 } # allows me to pass a attribute, defaults to 100

    after(:build) do |sub, eval|
      return unless sub.metadata.empty?
      sub.metadata = { ideal_temperature: eval.temperature }
    end
  end
end
