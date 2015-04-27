# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  include ApplicationHelper
  
  def new_users_report
    AdminMailer.new_users_report(Time.zone.now, [User.first, User.last], "steve@wespeakapp.com")
  end

  def new_groups_report
    AdminMailer.new_groups_report(Time.zone.now, [Group.first, Group.last], "steve@wespeakapp.com")
  end
end
