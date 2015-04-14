class InitialGroup < ActiveRecord::Base
  belongs_to :statement
  has_many   :initial_group_email_domains
end
