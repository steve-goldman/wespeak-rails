class Group < ActiveRecord::Base

  include MyGroupsHelper

  # foreign key relationships

  has_many :group_email_domains, dependent: :destroy
  has_many :statements

  # after initialize section

  after_initialize :set_rules_to_defaults
  
  def validation_keys
    [:name, :rules]
  end

  validates :name, { presence:   { message: ValidationMessages::NAME_NOT_PRESENT.message },
                     length:     { message: ValidationMessages::NAME_TOO_LONG.message,
                                   maximum: Lengths::GROUP_NAME_MAX },
                     uniqueness: { message: ValidationMessages::NAME_TAKEN.message,
                                   case_sensitive: false },
                     format:     { message: ValidationMessages::NAME_FORMATTING.message,
                                   with: Regex::GROUP } }

  validate :rules

  private

  def set_rules_to_defaults
    self.lifespan_rule           ||= RuleDefaults[:lifespan]
    self.support_needed_rule     ||= RuleDefaults[:support_needed]
    self.votespan_rule           ||= RuleDefaults[:votespan]
    self.votes_needed_rule       ||= RuleDefaults[:votes_needed]
    self.yeses_needed_rule       ||= RuleDefaults[:yeses_needed]
    self.inactivity_timeout_rule ||= RuleDefaults[:inactivity_timeout]
  end

  def rules
    errors.add(:rules, ValidationMessages::LIFESPAN_DURATION.message) if
      lifespan_rule < Timespans::LIFESPAN_MIN || lifespan_rule > Timespans::LIFESPAN_MAX
    errors.add(:rules, ValidationMessages::SUPPORT_NEEDED_BOUNDS.message) if
      support_needed_rule < Needed::SUPPORT_MIN || support_needed_rule > Needed::SUPPORT_MAX
    errors.add(:rules, ValidationMessages::VOTESPAN_DURATION.message) if
      votespan_rule < Timespans::VOTESPAN_MIN || votespan_rule > Timespans::VOTESPAN_MAX
    errors.add(:rules, ValidationMessages::VOTES_NEEDED_BOUNDS.message) if
      votes_needed_rule < Needed::VOTES_MIN || votes_needed_rule > Needed::VOTES_MAX
    errors.add(:rules, ValidationMessages::YESES_NEEDED_BOUNDS.message) if
      yeses_needed_rule < Needed::YESES_MIN || yeses_needed_rule > Needed::YESES_MAX
    errors.add(:rules, ValidationMessages::INACTIVITY_TIMEOUT_DURATION.message) if
      inactivity_timeout_rule < Timespans::INACTIVITY_TIMEOUT_MIN || inactivity_timeout_rule > Timespans::INACTIVITY_TIMEOUT_MAX
  end
end
