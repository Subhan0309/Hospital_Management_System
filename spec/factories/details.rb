FactoryBot.define do
  factory :detail do
    association :associated_with, factory: :doctor
    specialization { "Cardiology" }
    qualification { "MD" }
    disease { "Heart Disease" }
    status { "active" }
  end
end
