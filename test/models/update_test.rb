require 'test_helper'

class UpdateTest < ActiveSupport::TestCase
  test "blank update should not work" do
    assert_not Update.new(statement_id: 1, update_text: nil).valid?
    assert_not Update.new(statement_id: 1, update_text: "").valid?
    assert_not Update.new(statement_id: 1, update_text: "    ").valid?
  end

  test "max length should not be exceeded" do
    assert_not Update.new(statement_id: 1, update_text: "a" * (Lengths::UPDATE_MAX + 1)).valid?
    assert     Update.new(statement_id: 1, update_text: "a" * Lengths::UPDATE_MAX).valid?
  end

  test "missing statement_id shouldn't work" do
    assert_not Update.new(update_text: "hello").valid?
  end
end
