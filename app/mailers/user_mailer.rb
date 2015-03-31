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

  def about_to_timeout(user, group)
    @user = user
    @group = group
    @expires_at = group.active_members.find_by(user_id: user.id).expires_at

    mail to: user.primary_email, subject: "WeSpeak: Your membership in #{group.name} will expire soon!"
  end

  def timed_out(user, group)
    @user = user
    @group = group

    mail to: user.primary_email, subject: "WeSpeak: Your membership has expired in #{group.name}"
  end
end
