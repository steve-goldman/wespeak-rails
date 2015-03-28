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
  
end
