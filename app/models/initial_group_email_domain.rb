class InitialGroupEmailDomain < ActiveRecord::Base
  belongs_to :initial_group
  belongs_to :group_email_domain
end
