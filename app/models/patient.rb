class Patient < User
  acts_as_tenant :hospital
  has_many :appointments, foreign_key: :patient_id
  has_many :doctors, through: :appointments, source: :doctor



 def self.default_scope
  where(role: "patient")
end

end