class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { owner: 'owner', admin: 'admin', doctor: 'doctor', patient: 'patient', nurse: 'nurse', staff: 'staff' }
  # Associations
  has_many :hospitals

  
end
