class ActiveMember < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  def active_until
    updated_at + active_seconds
  end

  def extend_active(active_seconds)
    update_attributes(active_seconds: active_seconds,  # include updated_at or the
                      updated_at:     Time.zone.now)   # write could be optimized out
  end

  def can_support?(statement)
    created_at <= statement.created_at
  end
    
end
