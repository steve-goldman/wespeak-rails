class DisplayName < ActiveRecord::Base

  include GroupsHelper

  include Constants

  belongs_to :statement

  # validations

  def validation_keys
    [:display_name, :statement_id]
  end

  validates :display_name, { presence: { message: ValidationMessages::DISPLAY_NAME_NOT_PRESENT.message },
                             length:   { message: ValidationMessages::DISPLAY_NAME_TOO_LONG.message,
                                         maximum: Lengths::GROUP_DISPLAY_NAME_MAX } }

  validates :statement_id, { presence: { message: ValidationMessages::STATEMENT_ID_NOT_PRESENT.message } }

end
