# spec/factories/patients.rb
FactoryBot.define do
  factory :patient, class: 'Patient' do
    name { "Patient Name" }
    email { "patient@example.com" }
    gender { "female" }
    password { "password" }
    password_confirmation { "password" }
    hospital # Ensure you have a hospital factory or specify a hospital if needed
    role { "patient" } # Set the role to "patient" to match your default scope
    
    after(:create) do |patient|
      create(:detail, associated_with: patient)
    end
  end
end
