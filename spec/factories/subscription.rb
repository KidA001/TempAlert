FactoryBot.define do
  factory :subscription do
    type { :extended_use }
    sms_enabled { true }
    email_enabled { true }
    metadata { Hash.new }
    user { create(:user) }
  end
end
