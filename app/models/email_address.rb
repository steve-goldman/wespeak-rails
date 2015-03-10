class EmailAddress < ActiveRecord::Base

  include Constants

  # foreign key

  belongs_to :user


  # before save stuff

  before_save { self.email.downcase! }
  
  # validations

  validates :email, presence: true, length: { maximum: Lengths::EMAIL_ADDR_MAX }, format: { with: Regex::EMAIL }, uniqueness: true

  validates :user_id, presence: true
  
end
