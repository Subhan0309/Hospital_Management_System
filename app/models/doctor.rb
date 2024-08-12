class Doctor < User
  acts_as_tenant :hospital
  has_many :appointments, foreign_key: :doctor_id, dependent: :destroy
  has_many :patients, through: :appointments, source: :patient 

  has_many :medical_records, foreign_key: :doctor_id, dependent: :destroy
  # has_many :details, dependent: :destroy
  

  def self.default_scope
    where(role: "doctor")
  end
end

