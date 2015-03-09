require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  test "blank email" do
    assert_not EmailAddress.new(user_id: 1, email: "   ").valid?
  end

  test "invalid email" do
    assert_not EmailAddress.new(user_id: 1, email: "stu").valid?
  end

  test "valid email" do
    assert EmailAddress.new(user_id: 1, email: "stu@stu.com").valid?
  end
end
