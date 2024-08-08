class User < ApplicationRecord
  attr_accessor :hospital_name, :hospital_location, :hospital_email, :license_no
  acts_as_tenant :hospital
  
  scope :patients, -> { where(role: 'patient') }
  scope :doctors, -> { where(role: 'doctor') }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
         
  enum role: { owner: 'owner', admin: 'admin',staff: 'staff',doctor: 'doctor',patient: 'patient' }

end
