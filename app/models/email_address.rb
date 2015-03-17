class EmailAddress < ActiveRecord::Base

  include ApplicationHelper

  include UsersHelper

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
  
  private

  def downcase_email
    self.email.downcase!
  end

  def create_activation_digest
    self.activation_token = new_token
    self.activation_digest = digest(activation_token)
  end
  
end
