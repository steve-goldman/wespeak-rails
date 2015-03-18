require 'test_helper'

class StatementTypesTest < ActiveSupport::TestCase

  test "[] works" do
    assert_equal 1, StatementTypes[:email_domain_filter]
    assert_equal 2, StatementTypes[:facebook_filter]
    assert_equal 3, StatementTypes[:location_filter]
    assert_nil      StatementTypes[:bogus_key]
  end

  test "key? works" do
    assert     StatementTypes.key?(:email_domain_filter)
    assert     StatementTypes.key?(:facebook_filter)
    assert     StatementTypes.key?(:location_filter)
    assert_not StatementTypes.key?(:bogus_key)
  end
  
  test "value? works" do
    assert     StatementTypes.value?(1)
    assert     StatementTypes.value?(2)
    assert     StatementTypes.value?(3)
    assert_not StatementTypes.value?(999999)
  end
  
end
