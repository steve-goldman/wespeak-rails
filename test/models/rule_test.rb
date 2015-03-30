require 'test_helper'

class RuleTest < ActiveSupport::TestCase
  test "statement_id should be present" do
    assert_not Rule.new(rule_type: RuleTypes[:lifespan], rule_value: 50).valid?
  end

  test "rule_type should be valid" do
    assert_not Rule.new(rule_type: 999999, rule_value: 50).valid?
  end

  test "lifespan should be in bounds" do
    in_bounds(RuleTypes[:lifespan], Timespans::LIFESPAN_MIN, Timespans::LIFESPAN_MAX)
  end

  test "votespan should be in bounds" do
    in_bounds(RuleTypes[:votespan], Timespans::VOTESPAN_MIN, Timespans::VOTESPAN_MAX)
  end

  test "inactivity_timeout should be in bounds" do
    in_bounds(RuleTypes[:inactivity_timeout], Timespans::INACTIVITY_TIMEOUT_MIN, Timespans::INACTIVITY_TIMEOUT_MAX)
  end

  test "support_needed should be in bounds" do
    in_bounds(RuleTypes[:support_needed], Needed::SUPPORT_MIN, Needed::SUPPORT_MAX)
  end

  test "votes_needed should be in bounds" do
    in_bounds(RuleTypes[:votes_needed], Needed::VOTES_MIN, Needed::VOTES_MAX)
  end

  test "yeses_needed should be in bounds" do
    in_bounds(RuleTypes[:yeses_needed], Needed::YESES_MIN, Needed::YESES_MAX)
  end

  private

  def in_bounds(rule_type, min_value, max_value)
    assert_not Rule.new(statement_id: 1, rule_type: rule_type, rule_value: min_value - 1).valid?
    assert     Rule.new(statement_id: 1, rule_type: rule_type, rule_value: min_value).valid?
    assert_not Rule.new(statement_id: 1, rule_type: rule_type, rule_value: max_value + 1).valid?
    assert     Rule.new(statement_id: 1, rule_type: rule_type, rule_value: max_value).valid?
  end

end
