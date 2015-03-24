class Statement < ActiveRecord::Base

  include StatementsHelper

  belongs_to :user

  def validation_keys
    [:valid_statement_type,
     :valid_statement_state]
  end
  
  validate :valid_statement_type
  validate :valid_statement_state

  def alive_until
    created_at + lifespan
  end

  def get_tagline
    Tagline.find_by(statement_id: id)
  end

  def get_update
    Update.find_by(statement_id: id)
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
