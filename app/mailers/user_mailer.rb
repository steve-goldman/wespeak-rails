class UserMailer < ApplicationMailer

  add_template_helper(Constants)
  
  def email_address_activation(user, email_address)
    @user = user
    @email_address = email_address

    mail to: email_address.email, subject: "WeSpeak: Email address activation"
  end

  def password_reset(user, email)
    @user = user
    @email = email
    
    mail to: email, subject: "WeSpeak: Password reset"
  end

  def vote_begins(user, statement)
    @user = user
    @statement = statement

    mail to: user.primary_email, subject: "WeSpeak: Voting starting in #{statement.group.name}"
  end

  def vote_ends(user, statement)
    @user = user
    @statement = statement

    mail to: user.primary_email, subject: "WeSpeak: Voting ended in #{statement.group.name}"
  end

  def dead_statement(user, statement)
    @user = user
    @statement = statement

    mail to: user.primary_email, subject: "WeSpeak: Your submission has died in #{statement.group.name}"
  end
end
