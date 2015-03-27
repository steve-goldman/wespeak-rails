class Statement < ActiveRecord::Base

  include StatementsHelper

  belongs_to :user

  has_many :supports

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

  def user_supports?(user)
    supports.exists?(user_id: user.id)
  end

  def add_support(user)
    supports.create(user_id: user.id)
  end

  def remove_support(user)
    supports.find_by(user_id: user.id).destroy
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
