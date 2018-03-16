FactoryGirl.define do
  factory :user do
    name Faker::Name.first_name
    email Faker::Internet.email
    phone 5555555555
    google_id '123456'
    photo_url 'http://coparentcoalition.org/wp-content/uploads/2012/09/blank-profile-of-woman.jpg'
  end
end
