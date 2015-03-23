require 'test_helper'

class TaglineTest < ActiveSupport::TestCase
  test "blank tagline should not work" do
    assert_not Tagline.new(statement_id: 1, tagline: nil).valid?
    assert_not Tagline.new(statement_id: 1, tagline: "").valid?
    assert_not Tagline.new(statement_id: 1, tagline: "    ").valid?
  end

  test "max length should not be exceeded" do
    assert_not Tagline.new(statement_id: 1, tagline: "a" * (Lengths::TAGLINE_MAX + 1)).valid?
    assert     Tagline.new(statement_id: 1, tagline: "a" * Lengths::TAGLINE_MAX).valid?
  end

  test "missing statement_id shouldn't work" do
    assert_not Tagline.new(tagline: "hello").valid?
  end
end
