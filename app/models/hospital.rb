class Hospital < ApplicationRecord

  
   # Validations
   validates :name, presence: { message: "Hospital name can't be blank" }
   validates :location, presence: { message: "Location can't be blank" }
   validates :user_id, presence: { message: "User ID must be present" }
   validates :email, presence: { message: "Email can't be blank" },
                     format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email is not a valid format" }
   validates :license_no, presence: { message: "License number can't be blank" },
                          uniqueness: { message: "License number must be unique" }
   validates :subdomain, presence: { message: "Subdomain can't be blank" },
                         uniqueness: { message: "Subdomain must be unique" }
end
