class Vote < ActiveRecord::Base

  include Constants

  belongs_to :user
  belongs_to :statement

  def Vote.yes_count(statement)
    Vote.where(statement_id: statement.id, vote: Votes::YES).count
  end
end
