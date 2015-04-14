require 'test_helper'

class UserTest < ActiveSupport::TestCase

  include Constants
  
  test "name, password, and confirmation should be present" do
    assert_not User.new(              password: "test123", password_confirmation: "test123").valid?
    assert_not User.new(name: "StuG",                      password_confirmation: "test123").valid?
    assert_not User.new(name: "StuG", password: "test123").valid?
    assert     User.new(name: "StuG", password: "test123", password_confirmation: "test123").valid?
  end

  test "name should not be blank" do
    assert     User.new(name: "not-blank", password: "test123", password_confirmation: "test123").valid?
    assert_not User.new(name: "         ", password: "test123", password_confirmation: "test123").valid?
  end

  test "name should not be too long" do
    not_too_long = "a" * Lengths::USER_NAME_MAX
    assert     User.new(name: not_too_long,       password: "test123", password_confirmation: "test123").valid?
    assert_not User.new(name: not_too_long + "a", password: "test123", password_confirmation: "test123").valid?
  end

  test "password should not be too short" do
    too_short = "a" * (Lengths::PASSWORD_MIN - 1)
    assert     User.new(name: "Stu", password: too_short + "a", password_confirmation: too_short + "a").valid?
    assert_not User.new(name: "Stu", password: too_short,       password_confirmation: too_short).valid?
  end

  test "password should match confirmation" do
    assert     User.new(name: "discgolfstu", password: "test123", password_confirmation: "test123").valid?
    assert_not User.new(name: "discgolfstu", password: "test123", password_confirmation: "test124").valid?
  end

  test "name should be case insensitively unique" do
    user =     User.create!(name: "discgolfstu", password: "test123", password_confirmation: "test123")
    assert_not User.new(name: "DiScGoLfStU", password: "test123", password_confirmation: "test123").valid?
  end
end
