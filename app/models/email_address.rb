class EmailAddress < ActiveRecord::Base

  include Constants

  # foreign key

  belongs_to :user


  # before save stuff

  before_save :downcase_email


  # before create stuff

  before_create :create_activation_digest


  # attr accessors

  attr_accessor :activation_token
  
  # validations

  validates :email, presence: true, length: { maximum: Lengths::EMAIL_ADDR_MAX }, format: { with: Regex::EMAIL }, uniqueness: true

  validates :user_id, presence: true


  def authenticated?(activation_token)
    BCrypt::Password.new(activation_digest).is_password?(activation_token)
  end
  
  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = ApplicationHelper.new_token
    self.activation_digest = ApplicationHelper.digest(activation_token)
  end
  
end
