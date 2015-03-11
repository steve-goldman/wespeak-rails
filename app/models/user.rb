class User < ActiveRecord::Base

  include Constants

  # foreign key relationships

  has_many :email_addresses

  # attr_accessors

  attr_accessor :email
  attr_accessor :remember_token
  attr_accessor :password_reset_token

  # password stuff

  has_secure_password

  
  # validations

  validates :name, presence: true, length: { maximum: Lengths::USER_NAME_MAX }, uniqueness: true

  validates :password, length: { minimum: Lengths::PASSWORD_MIN }

  def remember
    self.remember_token = ApplicationHelper.new_token
    update_attribute(:remember_digest, ApplicationHelper.digest(remember_token))
  end

  def remember_authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def password_reset_authenticated?(password_reset_token)
    return false if password_reset_digest.nil?
    BCrypt::Password.new(password_reset_digest).is_password?(password_reset_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_password_reset_digest
    self.password_reset_token = ApplicationHelper.new_token
    update_attribute(:password_reset_digest, ApplicationHelper.digest(password_reset_token))
    update_attribute(:password_reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email(email)
    UserMailer.password_reset(self, email).deliver_now
  end
  
  def password_reset_expired?
    password_reset_sent_at < ExpirationTimes.password_reset_expiration
  end
end
