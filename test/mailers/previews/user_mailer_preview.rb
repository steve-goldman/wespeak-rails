# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  include ApplicationHelper
  
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/email_address_activation
  def email_address_activation
    user = User.first
    email_address = EmailAddress.find_by(id: user.primary_email_address_id)
    email_address.activation_token = new_token
    UserMailer.email_address_activation(user, email_address)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.password_reset_token = new_token
    email = EmailAddress.find_by(id: user.primary_email_address_id).email
    UserMailer.password_reset(user, email)
  end

  def vote_begins
    user = User.first
    statement = Statement.first
    UserMailer.vote_begins(user, statement)
  end

  def vote_ends
    user = User.first
    statement = Statement.first
    UserMailer.vote_ends(user, statement)
  end

  def dead_statement
    user = User.first
    statement = Statement.first
    UserMailer.dead_statement(user, statement)
  end

  def about_to_timeout
    active_member = ActiveMember.first
    UserMailer.about_to_timeout(active_member.user, active_member.group)
  end

  def timed_out
    user = User.first
    group = Group.first
    UserMailer.timed_out(user, group)
  end

end
