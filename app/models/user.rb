class User < ApplicationRecord
  has_many :hospitals, dependent: :destroy
  attr_accessor :hospital_name, :hospital_location, :hospital_email, :license_no
  acts_as_tenant :hospital
  scope :patients, -> { where(role: 'patient') }
  scope :doctors, -> { where(role: 'doctor') }
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable 
  searchkick word_middle: [:name, :email, :role], highlight: [:name, :email, :role]
  
  has_many :comments, as: :associated_with, dependent: :destroy
  has_one_attached :profile_picture
  enum role:
  {
    owner: 'owner',
    admin: 'admin',
    staff: 'staff' ,
    doctor: 'doctor' ,
    patient: 'patient'
 }
  # Customize the indexed fields if needed (optional)
  def search_data
    {
      name: name,
      email: email,
      role: role
    }
  end
    # Validations
    validates :name, presence: { message: "Name can't be blank" }, length: { 
      minimum: 3, too_short: "must have at least %{count} characters",
      maximum: 20, too_long: "must have at most %{count} characters"
    }
    validates :email, presence: { message: "Email can't be blank" },
                      format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email is not a valid format" },
                      uniqueness: { scope: :hospital_id, message: "should be unique within the same hospital" }
    validates :role, presence: { message: "Role can't be blank" }
    validates :hospital_id, presence: { message: "Hospital ID can't be blank" }
    validates :gender, inclusion: { in: %w[male female], message: "%{value} is not a valid gender" }
end