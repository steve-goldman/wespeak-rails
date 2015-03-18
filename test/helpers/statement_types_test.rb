require 'test_helper'

class StatementTypesTest < ActiveSupport::TestCase

  test "[] works" do
    assert_equal 1, StatementTypes[:email_domain_filter]
    assert_equal 2, StatementTypes[:facebook_filter]
    assert_equal 3, StatementTypes[:location_filter]
    assert_nil      StatementTypes[:bogus_key]
  end

  test "valid? works" do
    assert     StatementTypes.valid?(:email_domain_filter)
    assert     StatementTypes.valid?(:facebook_filter)
    assert     StatementTypes.valid?(:location_filter)
    assert_not StatementTypes.valid?(:bogus_key)
  end
  
end
