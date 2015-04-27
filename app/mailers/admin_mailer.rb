class AdminMailer < ApplicationMailer

  add_template_helper(Constants)

  def new_users_report(now, new_users, email)
    @new_users = new_users

    mail to: email, subject: "WeSpeak: New users report for #{now.strftime '%b %e %Y at %l:%M:%S %p'}"
  end

  def new_groups_report(now, new_groups, email)
    @new_groups = new_groups

    mail to: email, subject: "WeSpeak: New groups report for #{now.strftime '%b %e %Y at %l:%M:%S %p'}"
  end
end
