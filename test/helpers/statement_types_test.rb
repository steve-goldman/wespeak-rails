require 'test_helper'

class StatementTypesTes < ActiveSupport::TestCase

  test "[] works" do
    assert_equal 1, StatementTypes[:email_domain_filter]
    assert_equal 2, StatementTypes[:facebook_filter]
    assert_equal 3, StatementTypes[:location_filter]
    assert_nil      StatementTypes[:bogus_key]
  end
  
end
