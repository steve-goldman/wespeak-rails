class Update < ActiveRecord::Base

  include GroupsHelper

  include Constants

  belongs_to :statement

  # validations

  def validation_keys
    [:update_text, :statement_id]
  end

  validates :update_text, { presence: { message: ValidationMessages::UPDATE_NOT_PRESENT.message },
                            length:   { message: ValidationMessages::UPDATE_TOO_LONG.message,
                                        maximum: Lengths::UPDATE_MAX } }

  validates :statement_id, { presence: { message: ValidationMessages::STATEMENT_ID_NOT_PRESENT.message } }
end
