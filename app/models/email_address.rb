class EmailAddress < ActiveRecord::Base

  include ApplicationHelper

  include UsersHelper

  include Constants

  # foreign key

  belongs_to :user


  # before save stuff

  before_save :downcase_email
  before_save :set_domain


  # attr accessors

  attr_accessor :activation_token
  
  # validations

  def validation_keys
    [:email, :user_id]
  end

  validates :email, { presence:   { message: ValidationMessages::EMAIL_NOT_PRESENT.message },
                      length:     { message: ValidationMessages::EMAIL_TOO_LONG.message,
                                    maximum: Lengths::EMAIL_ADDR_MAX },
                      format:     { message: ValidationMessages::EMAIL_FORMATTING.message,
                                    with: Regex::EMAIL },
                      uniqueness: { message: ValidationMessages::EMAIL_TAKEN.message,
                                    case_sensitive: false } }

  validates :user_id, presence: { message: ValidationMessages::EMAIL_MISSING_USER_ID.message }


  def authenticated?(activation_token)
    BCrypt::Password.new(activation_digest).is_password?(activation_token)
  end

  def activate
    update_attributes(activated: true, activated_at: Time.zone.now)
    pending_invitations = PendingInvitation.where(email: email)
    pending_invitations.each do |pending_invitation|
      user.received_invitations.find_or_create_by(created_at: pending_invitation.created_at,
                                                  group_id:   pending_invitation.group_id)
    end
    pending_invitations.destroy_all
    user.set_primary_email(self) if !user.primary_email_address_id
  end

  def send_activation_email
    create_activation_digest
    UserMailer.email_address_activation(user, self).deliver_now
  end
  
  private

  def downcase_email
    self.email.downcase!
  end

  def set_domain
    self.domain = email.split("@")[1]
  end

  def create_activation_digest
    self.activation_token = new_token
    update_attributes(activation_digest: digest(activation_token))
  end
  
end
