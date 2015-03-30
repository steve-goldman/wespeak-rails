class GroupEmailDomainChange < ActiveRecord::Base

  belongs_to :statement

  include GroupsHelper

  include Constants

  belongs_to :statement

  # validations

  def validation_keys
    [:domain, :statement_id]
  end

  validates :domain, { presence:   { message: ValidationMessages::DOMAIN_NOT_PRESENT.message },
                       length:     { message: ValidationMessages::DOMAIN_TOO_LONG.message,
                                     maximum: Lengths::EMAIL_DOMAIN_MAX },
                       format:     { message: ValidationMessages::DOMAIN_FORMATTING.message,
                                     with: Regex::EMAIL_DOMAIN} }

  validates :statement_id, { presence: { message: ValidationMessages::STATEMENT_ID_NOT_PRESENT.message } }
end
