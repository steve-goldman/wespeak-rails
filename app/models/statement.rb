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

  #
  # state transitions
  #

  def Statement.new_statement(now, group, user, statement_type)
    Statement.create(created_at:          now,
                     updated_at:          now,
                     group_id:            group.id,
                     user_id:             user.id,
                     statement_type:      StatementTypes[statement_type],
                     state:               StatementStates[:alive],
                     expires_at:          now + group.lifespan_rule,
                     support_needed:      Statement.num_needed(group.active_members.count, group.support_needed_rule),
                     eligible_supporters: group.active_members.count)
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

  def Statement.num_needed(count, per_hundred)
    needed, remainder = (count * per_hundred).divmod(100)
    needed += 1 if remainder != 0
    needed
  end

end
