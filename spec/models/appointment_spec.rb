require 'rails_helper'
require 'aasm/rspec'

RSpec.describe Appointment, type: :model do
  let(:hospital) { create(:hospital) }
  let(:doctor) { create(:user, role: :doctor, hospital: hospital ,  email: 'doctor@example.com') }
  let(:patient) { create(:user, role: :patient, hospital: hospital , email: 'patient@example.com') }

  subject { create(:appointment, doctor: doctor, patient: patient) }

  context 'Validations' do
    it 'is valid with all required attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a doctor' do
      subject.doctor_id = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a patient' do
      subject.patient_id = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a start time' do
      subject.startTime = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without an end time' do
      subject.endTime = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid if end time is before start time' do
      subject.endTime = 1.day.from_now
      subject.startTime = 2.days.from_now
      expect(subject).not_to be_valid
    end
  end

  context 'AASM' do
    it 'starts in the scheduled state' do
      expect(subject).to have_state(:scheduled)
    end

    it 'can transition to completed' do
      subject.complete!
      expect(subject).to have_state(:completed)
    end

    it 'can transition to canceled' do
      subject.cancel!
      expect(subject).to have_state(:canceled)
    end

    it 'can transition back to scheduled from canceled' do
      subject.cancel!
      subject.reschedule!
      expect(subject).to have_state(:scheduled)
    end
  end
end
