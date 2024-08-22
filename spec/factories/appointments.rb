FactoryBot.define do
  factory :appointment do
    startTime { 1.day.from_now }
    endTime { 2.days.from_now }
    association :doctor, factory: :user
    association :patient, factory: :user
    status { :scheduled }
    association :hospital 
  end
end
