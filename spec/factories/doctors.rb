# spec/factories/doctors.rb
FactoryBot.define do
  factory :doctor, class: 'Doctor' do
    name { "Doctor Name" }
    sequence(:email) { |n| "doctor#{n}@example.com" }
    gender { "male" }
    password { "password" }
    password_confirmation { "password" }
    association :hospital
    role { "doctor" } 
    
    after(:create) do |doctor|
      create(:detail, associated_with: doctor)
    end
  end
end
