class Patient < User
  acts_as_tenant :hospital
  has_many :appointments, foreign_key: :patient_id, dependent: :destroy
  has_many :doctors, through: :appointments, source: :doctor
  has_many :medical_records, foreign_key: :patient_id, dependent: :destroy
  has_many :comments, as: :associated_with, dependent: :destroy
  has_one :detail, as: :associated_with, dependent: :destroy
  accepts_nested_attributes_for :detail
  has_one_attached :profile_picture

    def self.default_scope
      where(role: "patient")
    end

end