require 'rails_helper'

RSpec.describe MedicalRecord, type: :model do
  # Setup a shared hospital and users for consistency in tests
  let(:hospital) { create(:hospital) }
  let(:doctor) { create(:user, :doctor, hospital: hospital, email: 'doctor@example.com') }
  let(:patient) { create(:user, :patient, hospital: hospital, email: 'patient@example.com') }

  let(:medical_record) { create(:medical_record, patient: patient, doctor: doctor) }

  # Validations
  context 'validations' do
    it 'is valid with valid attributes' do
      expect(medical_record).to be_valid
    end

    it 'is invalid without a date' do
      medical_record.date = nil
      expect(medical_record).not_to be_valid
      expect(medical_record.errors[:date]).to include("Date can't be blank")
    end

    it 'is invalid without details' do
      medical_record.details = nil
      expect(medical_record).not_to be_valid
      expect(medical_record.errors[:details]).to include("Details can't be blank")
    end

    it 'is invalid without a patient_id' do
      medical_record.patient_id = nil
      expect(medical_record).not_to be_valid
      expect(medical_record.errors[:patient_id]).to include("Patient can't be blank")
    end

    it 'is invalid without a doctor_id' do
      medical_record.doctor_id = nil
      expect(medical_record).not_to be_valid
      expect(medical_record.errors[:doctor_id]).to include("Doctor can't be blank")
    end
  end


  # Associations
  context 'associations' do
    it { should belong_to(:patient).class_name('User').with_foreign_key('patient_id') }
    it { should belong_to(:doctor).class_name('User').with_foreign_key('doctor_id') }
    
    it 'can have many comments with an existing medical record' do
      comment1 = create(:comment, associated_with: medical_record)
      comment2 = create(:comment, associated_with: medical_record)
      
      expect(medical_record.comments).to include(comment1, comment2)
      expect(medical_record.comments.count).to eq(2)
    end

   
  end




end

