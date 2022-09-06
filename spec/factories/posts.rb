FactoryBot.define do
  factory :post do
    title { Faker::Lorem.question }
    context { Faker::Lorem.paragraph_by_chars }
  end
end