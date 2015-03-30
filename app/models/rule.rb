class Rule < ActiveRecord::Base

  include GroupsHelper

  belongs_to :statement

  # validations

  def validation_keys
    [:rule_type, :valid_rule_value, :statement_id]
  end

  validates :statement_id, { presence: { message: ValidationMessages::STATEMENT_ID_NOT_PRESENT.message } }

  validates :rule_type, { inclusion: { in: RuleTypes.values,
                                       message: ValidationMessages::RULE_TYPE_UNKNOWN.message } }

  validate :valid_rule_value

  private

  def valid_rule_value
    errors.add(:valid_rule_value, ValidationMessages::LIFESPAN_DURATION.message) if
      rule_type == RuleTypes[:lifespan] && (rule_value < Timespans::LIFESPAN_MIN || rule_value > Timespans::LIFESPAN_MAX)
    errors.add(:valid_rule_value, ValidationMessages::SUPPORT_NEEDED_BOUNDS.message) if
      rule_type == RuleTypes[:support_needed] && (rule_value < Needed::SUPPORT_MIN || rule_value > Needed::SUPPORT_MAX)
    errors.add(:valid_rule_value, ValidationMessages::VOTESPAN_DURATION.message) if
      rule_type == RuleTypes[:votespan] && (rule_value < Timespans::VOTESPAN_MIN || rule_value > Timespans::VOTESPAN_MAX)
    errors.add(:valid_rule_value, ValidationMessages::VOTES_NEEDED_BOUNDS.message) if
      rule_type == RuleTypes[:votes_needed] && (rule_value < Needed::VOTES_MIN || rule_value > Needed::VOTES_MAX)
    errors.add(:valid_rule_value, ValidationMessages::YESES_NEEDED_BOUNDS.message) if
      rule_type == RuleTypes[:yeses_needed] && (rule_value < Needed::YESES_MIN || rule_value > Needed::YESES_MAX)
    errors.add(:valid_rule_value, ValidationMessages::INACTIVITY_TIMEOUT_DURATION.message) if
      rule_type == RuleTypes[:inactivity_timeout] && (rule_value < Timespans::INACTIVITY_TIMEOUT_MIN || rule_value > Timespans::INACTIVITY_TIMEOUT_MAX)
  end
end
