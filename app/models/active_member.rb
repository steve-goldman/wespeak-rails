class ActiveMember < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  before_save :set_initial_expires_at

  def extend_active
    update_attributes(expires_at: Time.zone.now + group.inactivity_timeout_rule)
  end

  def can_support?(statement)
    created_at <= statement.created_at
  end
    
  def can_vote?(statement)
    created_at <= statement.vote_began_at
  end

  private

  def set_initial_expires_at
    self.expires_at = Time.zone.now + group.inactivity_timeout_rule if expires_at.nil?
  end
end
