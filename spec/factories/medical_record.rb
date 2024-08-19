# spec/factories/medical_records.rb

FactoryBot.define do
  factory :medical_record do
    date { Date.today }
    details { "Patient diagnosed with condition X. Follow-up required." }

    association :doctor, factory: [:user, :doctor, :with_hospital]
    association :patient, factory: [:user, :patient, :with_hospital]
  end
end
