class Doctor < User
  acts_as_tenant :hospital
  has_many :appointments, foreign_key: :doctor_id
  has_many :patients, through: :appointments, source: :patient

  def self.default_scope
    where(role: "doctor")
  end
end

