class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { owner: 'owner', admin: 'admin', doctor: 'doctor', patient: 'patient', nurse: 'nurse', staff: 'staff' }
  # Associations
  belongs_to :hospital, optional: true  # optional because owners might not belong to a hospital

  
end
