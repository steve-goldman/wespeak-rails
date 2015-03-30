require 'test_helper'

class GroupEmailDomainChangeTypesTest < ActiveSupport::TestCase

  test "[] works" do
    assert_equal 1, GroupEmailDomainChangeTypes[:add]
    assert_equal 2, GroupEmailDomainChangeTypes[:remove]
    assert_equal 3, GroupEmailDomainChangeTypes[:remove_all]
  end

  test "key? works" do
    assert     GroupEmailDomainChangeTypes.key?(:add)
    assert     GroupEmailDomainChangeTypes.key?(:remove)
    assert     GroupEmailDomainChangeTypes.key?(:remove_all)
  end
  
  test "value? works" do
    assert     GroupEmailDomainChangeTypes.value?(1)
    assert     GroupEmailDomainChangeTypes.value?(1)
    assert     GroupEmailDomainChangeTypes.value?(1)
    assert_not GroupEmailDomainChangeTypes.value?(999999)
  end
  
end
