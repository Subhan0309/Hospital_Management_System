require 'rails_helper'

RSpec.describe Comment, type: :model do

  # Use a shared hospital for consistency
  let(:hospital) { create(:hospital) }
  let(:doctor) { create(:user, :doctor, hospital: hospital, email: 'doctor@example.com') }
  let(:patient) { create(:user, :patient, hospital: hospital, email: 'patient@example.com') }
  
  let(:medical_record) { create(:medical_record, patient: patient, doctor: doctor) }

  context 'validations' do
    it 'is valid with valid attributes' do
      comment = build(:comment, created_by: doctor, associated_with: medical_record)
      expect(comment).to be_valid
    end

    it 'is invalid without a description' do
      comment = build(:comment, description: nil, created_by: doctor, associated_with: medical_record)
      expect(comment).not_to be_valid
      expect(comment.errors[:description]).to include("can't be empty")
    end

    it 'is invalid without a created_by_id' do
      comment = build(:comment, created_by: nil, associated_with: medical_record)
      expect(comment).not_to be_valid
      expect(comment.errors[:created_by_id]).to include("can't be blank")
    end
  end
end