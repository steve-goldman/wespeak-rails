class Vote < ActiveRecord::Base

  include Constants

  belongs_to :user
  belongs_to :statement

  def Vote.yes_count(statement)
    Vote.where(statement_id: statement.id, vote: Votes::YES).count
  end

  def Vote.num_voted_statements(group_ids, user)
    logger.info group_ids.join(", ")
    Vote
      .where(user_id: user.id)
      .where("statement_id IN (SELECT id FROM Statements WHERE group_id IN (#{group_ids.join(", ")}) AND state = :voting)", voting: StatementStates[:voting])
      .count
  end

end
