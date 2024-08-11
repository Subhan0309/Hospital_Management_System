class User < ApplicationRecord
  attr_accessor :hospital_name, :hospital_location, :hospital_email, :license_no
  acts_as_tenant :hospital
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable , :validatable
  
  searchkick word_middle: [:name, :email, :role], highlight: [:name, :email, :role]




  has_many :hospitals, dependent: :destroy
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
 


  def self.search_users(query, options = {})
    Rails.logger.info "Current tenant in search: #{ActsAsTenant.current_tenant.inspect}"

    # Ensure options[:where] is initialized
    options[:where] ||= {}

    # Check if current tenant is present
    if ActsAsTenant.current_tenant.present?
      options[:where][:hospital_id] = ActsAsTenant.current_tenant.id
    else
      Rails.logger.error "Current tenant is not set"
      # Handle the case as needed, possibly returning an empty result
      return []
    end

    search(query, **options)
  end


  



    # Validations
    validates :name, presence: { message: "Name can't be blank" }
    validates :email, presence: { message: "Email can't be blank" },
                      format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email is not a valid format" },
                      uniqueness: { scope: :hospital_id, message: "should be unique within the same hospital" }
    validates :role, presence: { message: "Role can't be blank" }
    validates :hospital_id, presence: { message: "Hospital ID can't be blank" }
  
    # Optional: Validations for gender if applicable
    validates :gender, inclusion: { in: %w[male female], message: "%{value} is not a valid gender" }, allow_nil: true
end


