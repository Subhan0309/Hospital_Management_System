class User < ApplicationRecord
  attr_accessor :hospital_name, :hospital_location, :hospital_email, :license_no
  acts_as_tenant :hospital
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable , :validatable
         
  enum role: { owner: 'owner', admin: 'admin',staff: 'staff' }
  validates :email, uniqueness: { scope: :hospital_id, message: "should be unique within the same hospital" }
end
