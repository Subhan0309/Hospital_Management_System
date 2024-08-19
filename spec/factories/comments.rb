# spec/factories/comments.rb
FactoryBot.define do
  factory :comment do
    description { "This is a test comment" }
    association :created_by, factory: :user
    association :associated_with, factory: :medical_record
  end
end
