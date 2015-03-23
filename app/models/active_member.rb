class ActiveMember < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  def active_until
    updated_at + active_seconds
  end
end
