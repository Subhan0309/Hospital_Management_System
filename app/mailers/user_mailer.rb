class UserMailer < ApplicationMailer
  default from: 'no-reply@yourapp.com'  # Adjust this email address

  def welcome_email(user)
    @user = user
    @url  = 'http://yourapp.com/login'  # Adjust this URL
    mail(to: @user.email, subject: 'Welcome to Our Hospital Management System')
  end
end
