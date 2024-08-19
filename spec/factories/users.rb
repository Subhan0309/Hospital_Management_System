FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "user@example.com" }
    password { "password" }
    role { :owner } 
    association :hospital,factory: :hospital
    gender { "male" }

    trait :doctor do
      role { :doctor }
    end

    trait :patient do
      role { :patient }
    end

    # Use this trait to set up a hospital
    trait :with_hospital do
      association :hospital,factory: :hospital
    end
  end
end

