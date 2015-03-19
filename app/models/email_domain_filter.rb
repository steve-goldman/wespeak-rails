class EmailDomainFilter < ActiveRecord::Base

  include ApplicationHelper

  include MyGroupsHelper

  include Constants

  # before save stuff

  before_save :downcase_domain

  # validations

  def validation_keys
    [:domain]
  end

  validates :domain, { presence: { message: ValidationMessages::DOMAIN_NOT_PRESENT.message },
                       length:   { message: ValidationMessages::DOMAIN_TOO_LONG.message,
                                   maximum: Lengths::EMAIL_DOMAIN_MAX },
                       format:   { message: ValidationMessages::DOMAIN_FORMATTING.message,
                                   with: Regex::EMAIL_DOMAIN} }

  def EmailDomainFilter.create_statement(domain, active, group, user, initial)
    email_domain_filter = get_record(domain, active)
    if email_domain_filter.nil?
      nil
    else
      Statement.create_statement(group,
                                 user,
                                 StatementTypes[:email_domain_filter],
                                 email_domain_filter.id,
                                 initial)
    end
  end

  private

  def downcase_domain
    self.domain.downcase!
  end

  def EmailDomainFilter.get_record(domain, active)
    record = EmailDomainFilter.find_by(domain: domain, active: active)
    return record if !record.nil?
    EmailDomainFilter.create(domain: domain, active: active)
  end
  
end
