class MedicalRecord < ApplicationRecord
   belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
   belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
   has_many :comments, as: :associated_with, dependent: :destroy
   validates :date, :details, :patient_id, :doctor_id, presence: true

    # Active Storage association for attachments
  has_many_attached :attachments
end
