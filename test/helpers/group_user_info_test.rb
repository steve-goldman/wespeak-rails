require 'test_helper'

class GroupUserInfoTest < ActiveSupport::TestCase

  def setup
    @group = Group.create!(name: "the_group", active: true)
    @user = User.create!(name: "stu", password: "test123", password_confirmation: "test123")
  end
  
  test "unknown group not valid" do
    assert_not GroupUserInfo.new("unknown_group", @user).valid?
  end

  test "not active group not valid" do
    @group.update_attributes(active: false)
    assert_not GroupUserInfo.new(@group.name, @user).valid?
  end

  test "known group valid" do
    assert GroupUserInfo.new(@group.name, @user).valid?
  end

  test "nil user has no member history" do
    assert_nil GroupUserInfo.new(@group.name, nil).member_history
  end

  test "nil user has no active member data" do
    assert_nil GroupUserInfo.new(@group.name, nil).active_member
  end

  test "nil user is not email eligible" do
    assert_not GroupUserInfo.new(@group.name, nil).email_eligible?
  end

  test "nil user is not change eligible" do
    assert_not GroupUserInfo.new(@group.name, nil).change_eligible?
  end

  test "nil user has nil invitations remaining" do
    assert_nil GroupUserInfo.new(@group.name, nil).invitations_remaining
  end

end
