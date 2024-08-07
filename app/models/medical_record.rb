class MedicalRecord < ApplicationRecord
   belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
end
