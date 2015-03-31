class StateMachine

  def StateMachine.alive_to_dead(now)
    Statement
      .where("state = #{StatementStates[:alive]} AND expires_at < :now", now: now)
      .each { |statement| statement.to_dead(now) }
  end

  def StateMachine.alive_to_voting(now)
    Statement
      .joins("INNER JOIN (SELECT statement_id, COUNT(*) AS c FROM supports GROUP BY statement_id) AS counts ON statements.id = counts.statement_id")
      .where("state = #{StatementStates[:alive]} AND c >= support_needed")
      .each { |statement| statement.to_voting(now) }
  end

  def StateMachine.end_votes(now)
    Statement
      .where("state = #{StatementStates[:voting]} AND vote_ends_at < :now", now: now)
      .each { |statement| statement.to_vote_over(now) }
  end

  def StateMachine.expired_memberships(now)
    ActiveMember.where("expires_at < :now", now: now).each do |active_member|
      GroupUserInfo.new(active_member.group.name, nil, active_member.user).make_member_inactive(true)
    end
  end

  def StateMachine.membership_warnings(now)
    ActiveMember.where("warned = 'f' AND warn_at < :now", now: now).each do |active_member|
      UserMailer.about_to_timeout(active_member.user, active_member.group).deliver_later
      active_member.update_attributes(warned: true)
    end
  end
  
end
