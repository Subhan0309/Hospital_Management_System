class UserMailer < ApplicationMailer
  default from: 'no-reply@yourapp.com'  # Adjust this email address

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Our Hospital Management System')
  end
end
