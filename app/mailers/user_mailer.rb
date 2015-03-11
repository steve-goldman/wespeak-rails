class UserMailer < ApplicationMailer

  add_template_helper(Constants)
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.email_address_activation.subject
  #
  def email_address_activation(user, email_address)
    @user = user
    @email_address = email_address

    mail to: email_address.email, subject: "WeSpeak email address activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user, email)
    @user = user
    @email = email
    
    mail to: email, subject: "WeSpeak password reset"
  end
end
