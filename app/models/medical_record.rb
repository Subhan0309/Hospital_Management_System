class MedicalRecord < ApplicationRecord
   belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
   belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
   has_many :comments, as: :associated_with, dependent: :destroy
   validates :date, presence: { message: "Date can't be blank" }
   validates :details, presence: { message: "Details can't be blank" }
   validates :patient_id, presence: { message: "Patient can't be blank" }
   validates :doctor_id, presence: { message: "Doctor can't be blank" }

    # Active Storage association for attachments
  has_many_attached :attachments
end
