class Tagline < ActiveRecord::Base

  include GroupsHelper

  include Constants

  # validations

  def validation_keys
    [:tagline]
  end

  validates :tagline, { presence: { message: ValidationMessages::TAGLINE_NOT_PRESENT.message },
                        length:   { message: ValidationMessages::TAGLINE_TOO_LONG.message,
                                    maximum: Lengths::TAGLINE_MAX } }
end
