FactoryBot.define do
  factory :hospital do
    name { "Hospital32" }
    location { "Sample Location" }
    email { "hospital@example.com" }
    license_no { "123456" }
    sequence(:subdomain) {|n| "hospital#{n}" }
  end
end
