class Statement < ActiveRecord::Base

  include StatementsHelper

  belongs_to :user

  belongs_to :group

  has_many :supports

  has_many :votes

  has_many :comments

  def validation_keys
    [:valid_statement_type,
     :valid_statement_state]
  end
  
  validate :valid_statement_type
  validate :valid_statement_state

  def get_content
    StatementTypes.table(StatementTypes.sym(statement_type)).find_by(statement_id: id)
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

  def user_vote(user)
    votes.find_by(user_id: user.id)
  end

  def cast_vote(user, vote)
    record = votes.find_by(user_id: user.id)
    if record
      record.update_attributes(vote: vote)
    else
      record = votes.create(user_id: user.id, vote: vote)
    end
    record
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
                     state:               StatementStates[:new],
                     expires_at:          now + group.lifespan_rule,
                     support_needed:      Statement.num_needed(group.active_members.count, group.support_needed_rule),
                     eligible_supporters: group.active_members.count)
  end

  def to_dead(now)
    update_attributes(state:           StatementStates[:dead],
                      expired_at:      now)

    # email the author
    UserMailer.dead_statement(user, self).deliver_later if user.user_notification.my_statement_dies
  end

  def to_voting(now)
    update_attributes(state:           StatementStates[:voting],
                      votes_needed:    Statement.num_needed(group.active_members.count, group.votes_needed_rule),
                      eligible_voters: group.active_members.count,
                      yeses_needed:    group.yeses_needed_rule,
                      vote_began_at:   now,
                      vote_ends_at:    now + group.votespan_rule)

    # email the active members
    group.active_members.each do |active_member|
      UserMailer.vote_begins(active_member.user, self).deliver_later if active_member.user.user_notification.vote_begins_active
    end

    # email the following users
    # TODO
  end

  def yeses_count
    Vote.yes_count self
  end

  def yeses_percent
    votes.count == 0 ? 0 : 100 * yeses_count / votes.count
  end

  def to_vote_over(now)
    total = votes.count
    if total < votes_needed || yeses_count < Statement.num_needed(total, yeses_needed)
      update_attributes(state:         StatementStates[:rejected],
                        vote_ended_at: now)
    else
      update_attributes(state:         StatementStates[:accepted],
                        vote_ended_at: now)
      group.statement_accepted self
    end

    # email the active members
    group.active_members.each do |active_member|
      UserMailer.vote_ends(active_member.user, self).deliver_later if active_member.user.user_notification.vote_ends_active
    end

    # email the following users
    # TODO
  end

  def statement_tab
    StatementTypes.sym(statement_type).to_s.pluralize
  end

  def confirm
    update_attributes(state: StatementStates[:alive])
  end

  def discard
    get_content.destroy
    self.destroy
  end

  def Statement.num_voting_statements(group_ids)
    Statement.where(group_id: group_ids, state: StatementStates[:voting]).count
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
