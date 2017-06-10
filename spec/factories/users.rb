FactoryGirl.define do
  factory :user do |f|
    f.sequence(:name) { |n| Faker::Name.name }
    f.sequence(:email) { |n| Faker::Internet.email }
    f.sequence(:password) { |n| "password" }
    f.password_confirmation { |f| f.password }
  end
end
