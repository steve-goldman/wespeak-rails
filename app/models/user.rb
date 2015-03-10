class User < ActiveRecord::Base

  include Constants

  # foreign key relationships

  has_many :email_addresses

  # attr_accessors

  attr_accessor :email
  attr_accessor :remember_token

  # password stuff

  has_secure_password

  
  # validations

  validates :name, presence: true, length: { maximum: Lengths::USER_NAME_MAX }, uniqueness: true

  validates :password, length: { minimum: Lengths::PASSWORD_MIN }

  def remember
    self.remember_token = ApplicationHelper.new_token
    update_attribute(:remember_digest, ApplicationHelper.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
