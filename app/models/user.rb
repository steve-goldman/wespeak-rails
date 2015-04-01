class User < ActiveRecord::Base

  include ApplicationHelper

  include UsersHelper

  include Constants

  # foreign key relationships

  has_many :email_addresses, dependent: :destroy

  has_many :statements

  has_many :groups_i_created, class_name: "Group"

  has_many :received_invitations, dependent: :destroy

  has_many :sent_invitations, dependent: :destroy

  has_one  :user_notification, dependent: :destroy

  has_many :followers, dependent: :destroy

  has_many :active_members, dependent: :destroy

  # attr_accessors

  attr_accessor :email
  attr_accessor :remember_token
  attr_accessor :password_reset_token

  # password stuff

  has_secure_password validations: false


  # create the notifications prefs
  after_save :init_user_notification

  
  # validations

  def validation_keys
    [:name, :password, :password_confirmation]
  end

  validates :name, { presence:   { message: ValidationMessages::NAME_NOT_PRESENT.message },
                     length:     { message: ValidationMessages::NAME_TOO_LONG.message,
                                   maximum: Lengths::USER_NAME_MAX },
                     uniqueness: { message: ValidationMessages::NAME_TAKEN.message,
                                   case_sensitive: false } }

  validates :password, { presence:     { message: ValidationMessages::PASSWORD_NOT_PRESENT.message },
                         length:       { message: ValidationMessages::PASSWORD_LENGTH.message,
                                         minimum: Lengths::PASSWORD_MIN,
                                         maximum: Lengths::PASSWORD_MAX } }

  validates :password_confirmation, presence: { message: ValidationMessages::CONFIRMATION_NOT_PRESENT.message }

  validates :password, confirmation: { message: ValidationMessages::CONFIRMATION_MISMATCH.message }
  
  def remember
    self.remember_token = new_token
    update_attribute(:remember_digest, digest(remember_token))
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
    self.password_reset_token = new_token
    update_attribute(:password_reset_digest, digest(password_reset_token))
    update_attribute(:password_reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email(email)
    UserMailer.password_reset(self, email).deliver_now
  end

  def update_password(password, password_confirmation)
    return self.update_attributes(password: password,
                                  password_confirmation: password_confirmation,
                                  password_reset_sent_at: Time.zone.now - ExpirationTimes.password_reset_expiration)
  end
  
  def password_reset_expired?
    password_reset_sent_at.nil? || password_reset_sent_at < ExpirationTimes.password_reset_expiration
  end

  def groups_pending_configuration_i_created
    groups_i_created.where(active: false)
  end

  def active_groups_i_created
    groups_i_created.where(active: true)
  end

  def primary_email
    email_addresses.find(primary_email_address_id).email
  end

  def follow(group)
    followers.find_or_create_by(group_id: group.id)
  end

  def unfollow(group)
    follower = followers.find_by(group_id: group.id)
    follower.destroy if follower
  end

  def new_invitations
    group_ids = "SELECT DISTINCT(group_id) FROM membership_histories WHERE user_id = :id"
    received_invitations.where("group_id NOT IN (#{group_ids})", id: id)
  end

  def old_invitations
    group_ids = "SELECT DISTINCT(group_id) FROM membership_histories WHERE user_id = :id"
    received_invitations.where("group_id IN (#{group_ids})", id: id)
  end

  private

  def init_user_notification
    UserNotification.find_or_create_by(user_id: id)
  end
end
