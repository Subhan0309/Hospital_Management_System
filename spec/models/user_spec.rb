require 'rails_helper'

RSpec.describe User, type: :model do
  let(:hospital1) {Hospital.create(
    name: "Sample Hospital 1",
    location: "Sample 1 Location",
    email: "info@samplehospital1.com",
    license_no: "123456789",
    subdomain: "sample-hospital-1"
  )}
  let(:hospital2) { Hospital.create(
    name: "Sample Hospital 2",
    location: "Sample 2 Location",
    email: "info@samplehospital2.com",
    license_no: "1234567890",
    subdomain: "sample-hospital-2"
  ) }

 

  let(:user) { User.create(
    name: "John Doe",
    email: "johndoe@example.com",
    role: "owner",
    hospital_id: hospital1.id,  # Assuming hospital_id is used for the primary hospital
    gender: "male",
    password: "password",
    password_confirmation: "password"
  ) }

  subject { user }

  context "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid if the name is too short" do
      subject.name = "Jo"
      expect(subject).to_not be_valid
    end

    it "is not valid if the name is too long" do
      subject.name = "J" * 21
      expect(subject).to_not be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with an invalid email format" do
      subject.email = "invalid_email_format"
      expect(subject).to_not be_valid
    end

    it "is not valid if the email is not unique within the same hospital" do
      User.create(
        name: "Jane Doe",
        email: "johndoe@example.com",
        role: "doctor",
        hospital_id: hospital1.id,
        gender: "female",
        password: "password",
        password_confirmation: "password"
      )
      expect(subject).to_not be_valid
    end

   

    it "is not valid without a role" do
      subject.role = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a hospital_id" do
      expect {
        subject.update(hospital_id: nil)
      }.to raise_error(ActsAsTenant::Errors::TenantIsImmutable)
    end
    

    it "is not valid without a gender" do
      subject.gender = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with an invalid gender" do
      subject.gender = "invalid_gender"
      expect(subject).to_not be_valid
    end
  end

  context "Associations" do
    it "can have many hospitals" do
      # Create more hospitals and associate them with the user
      user.hospitals << hospital2
      expect(user.hospitals).to include(hospital2)
    end

    it "should have one attached profile picture" do
      should respond_to(:profile_picture)
    end
  end

  context "Searchkick" do
    it "should respond to search_data method" do
      expect(subject).to respond_to(:search_data)
    end

    it "should have searchkick options configured" do
      expect(User).to respond_to(:searchkick)
    end
  end
end
