require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  test "name should be present" do
    assert_not Group.new.valid?
    assert_not Group.new(name: "").valid?
    assert_not Group.new(name: "   ").valid?
  end

  test "invalid group names should not be valid" do
    ["has space", "has@symbol", "!#%&", "a<>b", "a::b", "a;;b"].each do |invalid_name|
      assert_not Group.new(name: invalid_name).valid?
    end
  end

  test "valid group names should be valid" do
    ["HELLO", "world", "12345", "1-2-3-4", "1_2_3_4", "a.b.c"].each do |valid_name|
      assert Group.new(name: valid_name).valid?
    end
  end

  test "names should be case-insentively unique" do
    Group.new(name: "HELLO").save!
    assert_not Group.new(name: "hello").valid?
  end

  test "name should not be too long" do
    assert_not Group.new(name: "a" * (Lengths::GROUP_NAME_MAX + 1)).valid?
    assert     Group.new(name: "a" * Lengths::GROUP_NAME_MAX).valid?
  end
end
