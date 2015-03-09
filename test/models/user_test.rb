require 'test_helper'

class UserTest < ActiveSupport::TestCase

  include Constants
  
  def setup
    @user = User.new(name: "Example User", primary_email: nil, password: "test123", password_confirmation: "test123")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * (Lengths::USER_NAME_MAX + 1)
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * (Lengths::PASSWORD_MIN - 1)
    assert_not @user.valid?
  end
end
