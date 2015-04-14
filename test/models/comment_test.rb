require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "blank update should not work" do
    assert_not Comment.new(statement_id: 1, user_id: 1, payload: nil).valid?
    assert_not Comment.new(statement_id: 1, user_id: 1, payload: "").valid?
    assert_not Comment.new(statement_id: 1, user_id: 1, payload: "    ").valid?
  end

  test "max length should not be exceeded" do
    assert_not Comment.new(statement_id: 1, user_id: 1, payload: "a" * (Lengths::COMMENT_MAX + 1)).valid?
    assert     Comment.new(statement_id: 1, user_id: 1, payload: "a" * Lengths::COMMENT_MAX).valid?
  end

  test "missing ids shouldn't work" do
    assert_not Comment.new(payload: "hello", user_id: 1).valid?
    assert_not Comment.new(payload: "hello", statement_id: 1).valid?
  end
end
