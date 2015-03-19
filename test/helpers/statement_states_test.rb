require 'test_helper'

class StatementStatesTest < ActiveSupport::TestCase

  test "[] works" do
    assert_equal 1, StatementStates[:alive]
    assert_equal 2, StatementStates[:dead]
    assert_equal 3, StatementStates[:voting]
    assert_equal 4, StatementStates[:accepted]
    assert_equal 5, StatementStates[:rejected]
    assert_nil      StatementStates[:bogus_key]
  end

  test "key? works" do
    assert     StatementStates.key?(:alive)
    assert     StatementStates.key?(:dead)
    assert     StatementStates.key?(:voting)
    assert     StatementStates.key?(:accepted)
    assert     StatementStates.key?(:rejected)
    assert_not StatementStates.key?(:bogus_key)
  end
  
  test "value? works" do
    assert     StatementStates.value?(1)
    assert     StatementStates.value?(2)
    assert     StatementStates.value?(3)
    assert     StatementStates.value?(4)
    assert     StatementStates.value?(5)
    assert_not StatementStates.value?(999999)
  end
  
end
