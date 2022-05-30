# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    title { 'Course Name' }
    description { 'Description.' }
    user
  end
end
