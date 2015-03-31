class ActiveMember < ActiveRecord::Base

  include Constants
  
  belongs_to :group
  belongs_to :user

  before_save :set_initial_expires_at

  def extend_active
    now        = Time.zone.now
    expires_at = now + group.inactivity_timeout_rule
    warn_at    = expires_at - warn_before

    update_attributes(expires_at: expires_at,
                      warn_at:    warn_at,
                      warned:     false)
  end

  def can_support?(statement)
    created_at <= statement.created_at
  end
    
  def can_vote?(statement)
    created_at <= statement.vote_began_at
  end

  private

  def warn_before
    Timespans::INACTIVITY_WARN_THRESHOLD * group.inactivity_timeout_rule / 100
  end

  def set_initial_expires_at
    if expires_at.nil?
      now        = Time.zone.now
      expires_at = now + group.inactivity_timeout_rule
      warn_at    = expires_at - warn_before

      self.expires_at = expires_at
      self.warn_at    = warn_at
      self.warned     = false
    end
           # so that 'false' isn't left on the stack, which
    nil    # would prevent the record from saving
  end
end
