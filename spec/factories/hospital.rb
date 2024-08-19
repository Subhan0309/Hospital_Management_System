FactoryBot.define do
  factory :hospital do
    name { "Hospital32" }
    location { "Sample Location" }
    email { "hospital@example.com" }
    license_no { "123456" }
    subdomain {"123hospital7vals"}
  end
end
