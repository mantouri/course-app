# frozen_string_literal: true

FactoryBot.define do
  # factory :user do
  #   sequence(:email) { |n| "user#{n}@example.com" }
  #   password { 'password' }
  #   password_confirmation { password }
  # end

  factory :user do
    email { Faker::Internet.email }
    password { "a00000000" }
    password_confirmation { "a00000000" }
  end
end
