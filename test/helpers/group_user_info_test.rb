require 'test_helper'

class GroupUserInfoTest < ActiveSupport::TestCase

  include GroupsHelper
  
  def setup
    @group = Group.create!(name: "the_group", active: true)
    @user = User.create!(name: "stu", password: "test123", password_confirmation: "test123")
  end
  
  test "unknown group not valid" do
    assert_not GroupUserInfo.new("unknown_group", nil, @user).valid?
  end

  test "not active group not valid" do
    @group.update_attributes(active: false)
    assert_not GroupUserInfo.new(@group.name, nil, @user).valid?
  end

  test "known group valid" do
    assert GroupUserInfo.new(@group.name, nil, @user).valid?
  end

  test "nil user has no member history" do
    assert_nil GroupUserInfo.new(@group.name, nil, nil).member_history
  end

  test "nil user has no active member data" do
    assert_nil GroupUserInfo.new(@group.name, nil, nil).active_member
  end

  test "nil user is not email eligible" do
    assert_not GroupUserInfo.new(@group.name, nil, nil).email_eligible?
  end

  test "nil user is not change eligible" do
    assert_not GroupUserInfo.new(@group.name, nil, nil).change_eligible?
  end

  test "nil user has nil invitations remaining" do
    assert_nil GroupUserInfo.new(@group.name, nil, nil).invitations_remaining
  end

  test "missing email is not email eligible" do
    @group.group_email_domains.create!(domain: "wespeakapp.com")
    assert_not GroupUserInfo.new(@group.name, nil, @user).email_eligible?
    assert_not GroupUserInfo.new(@group.name, nil, @user).change_eligible?
  end

  test "present but inactive email is not email eligible" do
    @group.group_email_domains.create!(domain: "wespeakapp.com")
    @user.email_addresses.create!(email: "stu@wespeakapp.com")
    assert_not GroupUserInfo.new(@group.name, nil, @user).email_eligible?
    assert_not GroupUserInfo.new(@group.name, nil, @user).change_eligible?
  end

  test "present and active email is email eligible" do
    @group.group_email_domains.create!(domain: "wespeakapp.com")
    @user.email_addresses.create!(email: "stu@wespeakapp.com", activated: true)
    assert GroupUserInfo.new(@group.name, nil, @user).email_eligible?
    assert GroupUserInfo.new(@group.name, nil, @user).change_eligible?
  end

  test "invitations not required and not invited should be eligible" do
    assert GroupUserInfo.new(@group.name, nil, @user).invitation_eligible?
    assert GroupUserInfo.new(@group.name, nil, @user).change_eligible?
  end
  
  test "invitations required and not invited should not be eligible" do
    @group.update_attributes(invitations: 1)
    assert_not GroupUserInfo.new(@group.name, nil, @user).invitation_eligible?
    assert_not GroupUserInfo.new(@group.name, nil, @user).change_eligible?
  end

  test "invitations required and user before should be eligible" do
    @group.membership_histories.create!(user_id: @user.id, active: true)
    @group.update_attributes(invitations: 1)
    assert GroupUserInfo.new(@group.name, nil, @user).invitation_eligible?
    assert GroupUserInfo.new(@group.name, nil, @user).change_eligible?
  end

  test "invitations and invited should be eligible" do
    @group.update_attributes(invitations: 1)
    @user.received_invitations.create!(group_id: @group.id)
    assert GroupUserInfo.new(@group.name, nil, @user).invitation_eligible?
    assert GroupUserInfo.new(@group.name, nil, @user).change_eligible?
  end

  test "should not be able to support when not active" do
    statement = @group.create_statement(@user, :tagline)
    assert_not GroupUserInfo.new(@group.name, nil, @user).support_eligible?(statement)
  end

  test "should not be able to support when active after statement" do
    info = GroupUserInfo.new(@group.name, nil, @user)
    statement = @group.create_statement(@user, :tagline)
    info.make_member_active
    assert_not info.support_eligible?(statement)
  end

  test "should be able to support statement when not active if supported before" do
    statement = @group.create_statement(@user, :tagline)
    statement.add_support(@user)
    assert GroupUserInfo.new(@group.name, nil, @user).support_eligible?(statement)
  end

  test "should be able to support when active before statement" do
    info = GroupUserInfo.new(@group.name, nil, @user)
    info.make_member_active
    statement = @group.create_statement(@user, :tagline)
    assert info.support_eligible?(statement)
  end

end
