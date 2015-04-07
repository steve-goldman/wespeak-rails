class StateMachine

  def StateMachine.alive_to_dead(now)
    statements = Statement.where("state = #{StatementStates[:alive]} AND expires_at < :now", now: now)
    count = statements.count
    statements.each { |statement| statement.to_dead(now) }
    count
  end

  def StateMachine.alive_to_voting(now)
    statements = Statement
                 .joins("INNER JOIN (SELECT statement_id, COUNT(*) AS c FROM supports GROUP BY statement_id) AS counts ON statements.id = counts.statement_id")
                 .where("state = #{StatementStates[:alive]} AND c >= support_needed")
    count = statements.count
    statements.each { |statement| statement.to_voting(now) }
    count
  end

  def StateMachine.new_to_discarded(now)
    statements = Statement.where("state = #{StatementStates[:new]} AND expires_at < :now", now: now)
    count = statements.count
    statements.each { |statement| statement.discard }
    count
  end

  def StateMachine.end_votes(now)
    statements = Statement.where("state = #{StatementStates[:voting]} AND vote_ends_at < :now", now: now)
    count = statements.count
    statements.each { |statement| statement.to_vote_over(now) }
    count
  end

  def StateMachine.expired_memberships(now)
    active_members = ActiveMember.where("expires_at < :now", now: now)
    count = active_members.count
    active_members.each do |active_member|
      GroupUserInfo.new(active_member.group.name, nil, active_member.user).make_member_inactive(true)
    end
    count
  end

  def StateMachine.membership_warnings(now)
    active_members = ActiveMember.where("warned = 'f' AND warn_at < :now", now: now)
    count = active_members.count
    active_members.each do |active_member|
      UserMailer.about_to_timeout(active_member.user, active_member.group).deliver_later
      active_member.update_attributes(warned: true)
    end
    count
  end
  
end
