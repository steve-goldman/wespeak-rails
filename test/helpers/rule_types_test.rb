require 'test_helper'

class RuleTypesTest < ActiveSupport::TestCase

  test "[] works" do
    assert_equal 1001, RuleTypes[:lifespan]
    assert_equal 1002, RuleTypes[:support_needed]
    assert_equal 1003, RuleTypes[:votespan]
    assert_equal 1004, RuleTypes[:votes_needed]
    assert_equal 1005, RuleTypes[:yeses_needed]
    assert_equal 1006, RuleTypes[:inactivity_timeout]
    assert_nil         RuleTypes[:bogus_key]
  end

  test "key? works" do
    assert     RuleTypes.key?(:lifespan)
    assert     RuleTypes.key?(:support_needed)
    assert     RuleTypes.key?(:votespan)
    assert     RuleTypes.key?(:votes_needed)
    assert     RuleTypes.key?(:yeses_needed)
    assert     RuleTypes.key?(:inactivity_timeout)
    assert_not RuleTypes.key?(:bogus_key)
  end
  
  test "value? works" do
    assert     RuleTypes.value?(1001)
    assert     RuleTypes.value?(1002)
    assert     RuleTypes.value?(1003)
    assert     RuleTypes.value?(1004)
    assert     RuleTypes.value?(1005)
    assert     RuleTypes.value?(1006)
    assert_not RuleTypes.value?(999999)
  end
  
end
