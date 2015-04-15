require 'test_helper'

class DisplayNameTest < ActiveSupport::TestCase
  test "blank display_name should not work" do
    assert_not DisplayName.new(statement_id: 1, display_name: nil).valid?
    assert_not DisplayName.new(statement_id: 1, display_name: "").valid?
    assert_not DisplayName.new(statement_id: 1, display_name: "    ").valid?
  end

  test "max length should not be exceeded" do
    assert_not DisplayName.new(statement_id: 1, display_name: "a" * (Lengths::GROUP_DISPLAY_NAME_MAX + 1)).valid?
    assert     DisplayName.new(statement_id: 1, display_name: "a" * Lengths::GROUP_DISPLAY_NAME_MAX).valid?
  end

  test "missing statement_id shouldn't work" do
    assert_not DisplayName.new(display_name: "hello").valid?
  end
end
