class Hospital < ApplicationRecord

  
   # Validations
   validates :name, presence: { message: "Hospital name can't be blank" }, length: { 
      minimum: 4, too_short: "must have at least %{count} characters",
      maximum: 15, too_long: "must have at most %{count} characters"
    }
   validates :location, presence: { message: "Location can't be blank" }
   validates :email, presence: { message: "Email can't be blank" },
                     format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email is not a valid format" }
   validates :license_no, presence: { message: "License number can't be blank" }
   validates :subdomain, presence: { message: "Subdomain can't be blank" },
                         uniqueness: { message: "Subdomain must be unique" }
end
