class Doctor < User
  has_one_attached :profile_picture
  acts_as_tenant :hospital
  has_many :appointments, foreign_key: :doctor_id, dependent: :destroy
  has_many :patients, through: :appointments, source: :patient
  has_many :comments, as: :associated_with, dependent: :destroy
  has_many :medical_records, foreign_key: :doctor_id, dependent: :destroy
  has_one :detail, as: :associated_with, dependent: :destroy
  accepts_nested_attributes_for :detail
  

  def self.default_scope
    where(role: "doctor")
  end
end

