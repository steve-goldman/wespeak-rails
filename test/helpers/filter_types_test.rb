require 'test_helper'

class FilterTypesTest < ActiveSupport::TestCase

  test "[] works" do
    assert_equal 1001, FilterTypes[:email_domain]
    assert_equal 1002, FilterTypes[:facebook]
    assert_equal 1003, FilterTypes[:location]
    assert_nil         FilterTypes[:bogus_key]
  end

  test "key? works" do
    assert     FilterTypes.key?(:email_domain)
    assert     FilterTypes.key?(:facebook)
    assert     FilterTypes.key?(:location)
    assert_not FilterTypes.key?(:bogus_key)
  end
  
  test "value? works" do
    assert     FilterTypes.value?(1001)
    assert     FilterTypes.value?(1002)
    assert     FilterTypes.value?(1003)
    assert_not FilterTypes.value?(999999)
  end
  
end
