FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "john.doe@example.com" }
    password { "password" }
    password_confirmation { "password" }
    role { :doctor } # or :patient, :admin, etc.
    gender { "male" } # or "female"
    association :hospital ,factory: :hospital
  end
end
