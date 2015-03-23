class Tagline < ActiveRecord::Base

  include GroupsHelper

  include Constants

  belongs_to :statement

  # validations

  def validation_keys
    [:tagline, :statement_id]
  end

  validates :tagline, { presence: { message: ValidationMessages::TAGLINE_NOT_PRESENT.message },
                        length:   { message: ValidationMessages::TAGLINE_TOO_LONG.message,
                                    maximum: Lengths::TAGLINE_MAX } }

  validates :statement_id, { presence: { message: ValidationMessages::STATEMENT_ID_NOT_PRESENT.message } }
end
