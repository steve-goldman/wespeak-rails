class SentInvitation < ActiveRecord::Base

  # TODO: figure out a better way to keep these validation
  # messages organized such that they can be reused across
  # models
  include UsersHelper

  # foreign key

  belongs_to :user


  # before save stuff

  before_save :downcase_email

  # validations

  def validation_keys
    [:email, :user_id, :group_id]
  end

  validates :email, { presence:   { message: ValidationMessages::EMAIL_NOT_PRESENT.message },
                      length:     { message: ValidationMessages::EMAIL_TOO_LONG.message,
                                    maximum: Lengths::EMAIL_ADDR_MAX },
                      format:     { message: ValidationMessages::EMAIL_FORMATTING.message,
                                    with: Regex::EMAIL },
                      uniqueness: { message: ValidationMessages::EMAIL_TAKEN.message,
                                    case_sensitive: false } }

  validates :user_id, presence: { message: ValidationMessages::EMAIL_MISSING_USER_ID.message }

  validates :group_id, presence: { message: ValidationMessages::EMAIL_MISSING_GROUP_ID.message }
  
  private

  def downcase_email
    self.email.downcase!
  end
end
