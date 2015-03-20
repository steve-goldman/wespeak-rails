class Statement < ActiveRecord::Base

  include StatementsHelper

  def validation_keys
    [:valid_statement_type,
     :valid_statement_state]
  end
  
  validate :valid_statement_type
  validate :valid_statement_state

  def Statement.create_statement(group, user, statement_type, content, initial)
    state = initial ? StatementStates[:accepted] : StatementStates[:alive]
    statement = Statement.create(group_id:       group.id,
                                 user_id:        user.id,
                                 statement_type: statement_type,
                                 content_id:     content.id,
                                 state:          state)
  end
  
  private

  def valid_statement_type
    errors.add(:valid_statement_type, ValidationMessages::TYPE_INVALID.message) if
      !StatementTypes.value?(statement_type)
  end

  def valid_statement_state
    errors.add(:valid_statement_state, ValidationMessages::STATE_INVALID.message) if
      !StatementStates.value?(state)
  end
end
