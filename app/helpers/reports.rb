class Reports

  def Reports.new_users(now)
    new_users = User.where("created_at BETWEEN :start AND :end", start: now - 1.day, end: now)
    AdminMailer.new_users_report(now, new_users, "steve@wespeakapp.com").deliver_now
  end
  
  def Reports.new_groups(now)
    new_groups = Group.where("created_at BETWEEN :start AND :end", start: now - 1.day, end: now)
    AdminMailer.new_groups_report(now, new_groups, "steve@wespeakapp.com").deliver_now
  end
  
end
