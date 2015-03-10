# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/email_address_activation
  def email_address_activation
    user = User.first
    email_address = EmailAddress.find_by(id: user.primary_email_address_id)
    email_address.activation_token = ApplicationHelper.new_token
    UserMailer.email_address_activation(user, email_address)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
