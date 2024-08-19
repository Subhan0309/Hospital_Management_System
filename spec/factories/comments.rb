# spec/factories/comments.rb
FactoryBot.define do
  factory :comment do
    description { "This is a test comment" }
    association :created_by, factory: :user
    association :associated_with, factory: :medical_record
  end
end


# # spec/factories/comments.rb
# FactoryBot.define do
#   factory :comment do
#     description { "This is a test comment" }
#     association :created_by, factory: :user

#     # Trait for using an existing medical record
#     trait :with_existing_medical_record do
#       association :associated_with, factory: :medical_record
#     end

#     # Trait for creating a new medical record
#     trait :with_new_medical_record do
#       after(:build) do |comment|
#         # Create a medical record if not provided
#         comment.associated_with ||= create(:medical_record)
#       end
#     end
#   end
# end
