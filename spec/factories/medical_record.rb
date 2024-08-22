# spec/factories/medical_records.rb
FactoryBot.define do
  factory :medical_record do
    date { Date.today }
    details { "Patient diagnosed with condition X. Follow-up required." }
    association :patient, factory: :user
    association :doctor, factory: :user
   
  end
end
