require 'test_helper'

class RuleDefaultsTest < ActiveSupport::TestCase

  test "[] works" do
    assert_equal 3.days.to_i, RuleDefaults[:lifespan]
    assert_equal 10,           RuleDefaults[:support_needed]
    assert_equal 1.day.to_i,  RuleDefaults[:votespan]
    assert_equal 40,          RuleDefaults[:votes_needed]
    assert_equal 50,          RuleDefaults[:yeses_needed]
    assert_equal 5.days.to_i, RuleDefaults[:inactivity_timeout]
    assert_nil                RuleDefaults[:bogus_key]
  end

  test "key? works" do
    assert     RuleDefaults.key?(:lifespan)
    assert     RuleDefaults.key?(:support_needed)
    assert     RuleDefaults.key?(:votespan)
    assert     RuleDefaults.key?(:votes_needed)
    assert     RuleDefaults.key?(:yeses_needed)
    assert     RuleDefaults.key?(:inactivity_timeout)
    assert_not RuleDefaults.key?(:bogus_key)
  end

end
