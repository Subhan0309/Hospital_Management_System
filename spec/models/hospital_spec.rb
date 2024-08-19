# spec/models/hospital_spec.rb

require 'rails_helper'

RSpec.describe Hospital, type: :model do
  # Create valid and invalid hospital instances for testing
  let(:valid_hospital) do
    Hospital.new(
      name: "Valid Hospital",
      location: "Valid Location",
      email: "valid@example.com",
      license_no: "12345",
      subdomain: "valid"
    )
  end

  let(:invalid_hospital) do
    Hospital.new(
      name: nil,
      location: nil,
      email: "invalid_email",
      license_no: nil,
      subdomain: nil
    )
  end

  context "Validations" do
    it "is valid with all required attributes" do
      expect(valid_hospital).to be_valid
    end

    it "is not valid without a name" do
      invalid_hospital.name = nil
      expect(invalid_hospital).to_not be_valid
      expect(invalid_hospital.errors[:name]).to include("Hospital name can't be blank")
    end

    it "is not valid if the name is too short" do
      invalid_hospital.name = "AB"
      expect(invalid_hospital).to_not be_valid
      expect(invalid_hospital.errors[:name]).to include("must have at least 3 characters")
    end

    it "is not valid if the name is too long" do
      invalid_hospital.name = "A" * 21
      expect(invalid_hospital).to_not be_valid
      expect(invalid_hospital.errors[:name]).to include("must have at most 20 characters")
    end

    it "is not valid without a location" do
      invalid_hospital.location = nil
      expect(invalid_hospital).to_not be_valid
      expect(invalid_hospital.errors[:location]).to include("Location can't be blank")
    end

    it "is not valid with an invalid email format" do
      invalid_hospital.email = "invalid_email"
      expect(invalid_hospital).to_not be_valid
      expect(invalid_hospital.errors[:email]).to include("Email is not a valid format")
    end

    it "is not valid without a license number" do
      invalid_hospital.license_no = nil
      expect(invalid_hospital).to_not be_valid
      expect(invalid_hospital.errors[:license_no]).to include("License number can't be blank")
    end

    it "is not valid without a subdomain" do
      invalid_hospital.subdomain = nil
      expect(invalid_hospital).to_not be_valid
      expect(invalid_hospital.errors[:subdomain]).to include("Subdomain can't be blank")
    end

    it "is not valid with a non-unique subdomain" do
      valid_hospital.save
      duplicate_hospital = Hospital.new(
        name: "Another Hospital",
        location: "Another Location",
        email: "another@example.com",
        license_no: "67890",
        subdomain: valid_hospital.subdomain
      )
      expect(duplicate_hospital).to_not be_valid
      expect(duplicate_hospital.errors[:subdomain]).to include("Subdomain must be unique")
    end
  end


end
