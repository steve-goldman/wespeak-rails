class UserMailer < ApplicationMailer

  add_template_helper(Constants)
  
  def email_address_activation(user, email_address)
    @user = user
    @email_address = email_address
    @email = email_address.email

    mail to: @email, subject: "WeSpeak: Email address activation"
  end

  def password_reset(user, email)
    @user = user
    @email = email
    
    mail to: @email, subject: "WeSpeak: Password reset"
  end

  def vote_begins(user, statement)
    if user.primary_email
      @user = user
      @email = user.primary_email
      @statement = statement
      
      mail to: @email, subject: "WeSpeak: Voting starting in #{statement.group.name}"
    end
  end

  def vote_ends(user, statement)
    if user.primary_email
      @user = user
      @email = user.primary_email
      @statement = statement

      mail to: @email, subject: "WeSpeak: Voting ended in #{statement.group.name}"
    end
  end

  def dead_statement(user, statement)
    if user.primary_email
      @user = user
      @email = user.primary_email
      @statement = statement

      mail to: @email, subject: "WeSpeak: Your submission has died in #{statement.group.name}"
    end
  end

  def about_to_timeout(user, group)
    if user.primary_email
      @user = user
      @email = user.primary_email
      @group = group
      @expires_at = group.active_members.find_by(user_id: user.id).expires_at

      mail to: @email, subject: "WeSpeak: Your membership in #{group.name} will expire soon!"
    end
  end

  def timed_out(user, group)
    @user = user
    @email = user.primary_email
    @group = group

    mail to: @email, subject: "WeSpeak: Your membership has expired in #{group.name}"
  end

  def invited(user, group)
    if user.primary_email
      @user = user
      @email = user.primary_email
      @group = group
      
      mail to: @email, subject: "WeSpeak: You have been invited to join #{group.name}"
    end
  end

  def invited_signup(email, group)
    @email = email
    @group = group

    mail to: @email, subject: "WeSpeak: You have been invited to join #{group.name}"
  end
end
