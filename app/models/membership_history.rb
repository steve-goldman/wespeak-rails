class MembershipHistory < ActiveRecord::Base
  default_scope do
    order('id')
  end

  belongs_to :user
  belongs_to :group
end
