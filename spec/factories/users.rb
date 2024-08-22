FactoryBot.define do
  factory :user do
    name { "John Doe" }
    sequence(:email) { |n| "doctor#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    role { :doctor } # or :patient, :admin, etc.
    gender { "male" } # or "female"
    association :hospital
  end
end

# FactoryBot.define do
#   factory :user do
#     name { "John Doe" }
#     email { "user@example.com" }
#     password { "password" }
#     role { :owner } 
#     association :hospital,factory: :hospital
#     gender { "male" } # or "female"

#     trait :doctor do
#       role { :doctor }
#     end

#     trait :patient do
#       role { :patient }
#     end

#     # Use this trait to set up a hospital
#     trait :with_hospital do
#       association :hospital,factory: :hospital
#     end
#   end
# end

