class GroupEmailDomain < ActiveRecord::Base

  include GroupsHelper
  
  # foreign key

  belongs_to :group


  # before save stuff

  before_save :downcase_domain


  # validations
  
  def validation_keys
    [:domain]
  end
  
  validates :domain, { presence:   { message: ValidationMessages::DOMAIN_NOT_PRESENT.message },
                       length:     { message: ValidationMessages::DOMAIN_TOO_LONG.message,
                                     maximum: Lengths::EMAIL_DOMAIN_MAX },
                       format:     { message: ValidationMessages::DOMAIN_FORMATTING.message,
                                     with: Regex::EMAIL_DOMAIN} }

  private
  
  def downcase_domain
    self.domain.downcase!
  end
  
end
