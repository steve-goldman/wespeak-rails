require 'test_helper'

class TaglineTest < ActiveSupport::TestCase
  test "blank tagline should not work" do
    assert_not Tagline.new(tagline: nil).valid?
    assert_not Tagline.new(tagline: "").valid?
    assert_not Tagline.new(tagline: "    ").valid?
  end

  test "max length should not be exceeded" do
    assert_not Tagline.new(tagline: "a" * (Lengths::TAGLINE_MAX + 1)).valid?
    assert     Tagline.new(tagline: "a" * Lengths::TAGLINE_MAX).valid?
  end
end
