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

  test "missing email is not email eligible" do
    @group.group_email_domains.create!(domain: "wespeakapp.com")
    assert_not GroupUserInfo.new(@group.name, @user).email_eligible?
    assert_not GroupUserInfo.new(@group.name, @user).change_eligible?
  end

  test "present but inactive email is not email eligible" do
    @group.group_email_domains.create!(domain: "wespeakapp.com")
    @user.email_addresses.create!(email: "stu@wespeakapp.com")
    assert_not GroupUserInfo.new(@group.name, @user).email_eligible?
    assert_not GroupUserInfo.new(@group.name, @user).change_eligible?
  end

  test "present and active email is email eligible" do
    @group.group_email_domains.create!(domain: "wespeakapp.com")
    @user.email_addresses.create!(email: "stu@wespeakapp.com", activated: true)
    assert GroupUserInfo.new(@group.name, @user).email_eligible?
    assert GroupUserInfo.new(@group.name, @user).change_eligible?
  end

  test "invitations not required and not invited should be eligible" do
    assert GroupUserInfo.new(@group.name, @user).invitation_eligible?
    assert GroupUserInfo.new(@group.name, @user).change_eligible?
  end
  
  test "invitations required and not invited should not be eligible" do
    @group.update_attributes(invitations: 1)
    assert_not GroupUserInfo.new(@group.name, @user).invitation_eligible?
    assert_not GroupUserInfo.new(@group.name, @user).change_eligible?
  end

  test "invitations required and user before should be eligible" do
    @group.membership_histories.create!(user_id: @user.id, active: true)
    @group.update_attributes(invitations: 1)
    assert GroupUserInfo.new(@group.name, @user).invitation_eligible?
    assert GroupUserInfo.new(@group.name, @user).change_eligible?
  end

  test "invitations and invited should be eligible" do
    @group.update_attributes(invitations: 1)
    @user.received_invitations.create!(group_id: @group.id)
    assert GroupUserInfo.new(@group.name, @user).invitation_eligible?
    assert GroupUserInfo.new(@group.name, @user).change_eligible?
  end

end
