FactoryGirl.define do
  factory :book do |f|
    title Faker::Lorem.sentence
    author_id 1
    description Faker::Lorem.paragraph(10)
    content Faker::Lorem.paragraph(50)
    status "published"
  end
end