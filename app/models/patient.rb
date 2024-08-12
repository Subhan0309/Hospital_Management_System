class Patient < User
  acts_as_tenant :hospital
  has_many :appointments, foreign_key: :patient_id, dependent: :destroy
  has_many :doctors, through: :appointments, source: :doctor
  has_many :medical_records, foreign_key: :patient_id, dependent: :destroy
  # has_many :details, dependent: :destroy
  

 def self.default_scope
  where(role: "patient")
end

end