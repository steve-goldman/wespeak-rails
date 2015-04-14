class Comment < ActiveRecord::Base

  include GroupsHelper

  include Constants

  belongs_to :user
  belongs_to :statement

  # validations

  def validation_keys
    [:payload, :user_id, :statement_id]
  end

  validates :payload, { presence: { message: ValidationMessages::COMMENT_NOT_PRESENT.message },
                        length:   { message: ValidationMessages::COMMENT_TOO_LONG.message,
                                    maximum: Lengths::COMMENT_MAX } }

  validates :statement_id, { presence: { message: ValidationMessages::STATEMENT_ID_NOT_PRESENT.message } }

  validates :user_id,      { presence: { message: ValidationMessages::USER_ID_NOT_PRESENT.message } }

end
