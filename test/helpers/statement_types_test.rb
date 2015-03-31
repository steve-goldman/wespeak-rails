require 'test_helper'

class StatementTypesTest < ActiveSupport::TestCase

  test "[] works" do
    assert_equal 1001, StatementTypes[:group_email_domain_change]
    assert_equal 1003, StatementTypes[:add_facebook_filter]
    assert_equal 1004, StatementTypes[:rem_facebook_filter]
    assert_equal 1005, StatementTypes[:add_location_filter]
    assert_equal 1006, StatementTypes[:rem_location_filter]
    assert_nil         StatementTypes[:bogus_key]
  end

  test "key? works" do
    assert     StatementTypes.key?(:group_email_domain_change)
    assert     StatementTypes.key?(:add_facebook_filter)
    assert     StatementTypes.key?(:rem_facebook_filter)
    assert     StatementTypes.key?(:add_location_filter)
    assert     StatementTypes.key?(:rem_location_filter)
    assert_not StatementTypes.key?(:bogus_key)
  end
  
  test "value? works" do
    assert     StatementTypes.value?(1001)
    assert     StatementTypes.value?(1003)
    assert     StatementTypes.value?(1004)
    assert     StatementTypes.value?(1005)
    assert     StatementTypes.value?(1006)
    assert_not StatementTypes.value?(999999)
  end
  
end
