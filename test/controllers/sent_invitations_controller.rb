require 'test_helper'

class SentInvitationsControllerTest < ActionController::TestCase

  include GroupsHelper

  def setup
    @user1 = User.create!(name:                  "Stu",
                          password:              "test123",
                          password_confirmation: "test123")
    log_in @user1

    @user2 = User.create!(name:                  "Mike",
                          password:              "test123",
                          password_confirmation: "test123")
    primary_email_address = @user2.email_addresses.create!(email: "mike@mikenet.com")
    @user2.update_attributes(primary_email_address_id: primary_email_address.id)

    @user3 = User.create!(name:                  "Ssor",
                          password:              "test123",
                          password_confirmation: "test123")
    primary_email_address = @user3.email_addresses.create!(email: "ssor@mikenet.com")
    @user3.update_attributes(primary_email_address_id: primary_email_address.id)

    @group = Group.create!(name: "group", invitations: 1)
    @group.activate
  end

  test "send invitation to existing user" do
    post_create(@user2.primary_email)
    assert_redirected_with_flash [FlashMessages::INVITATION_SENT], root_url
    assert_equal 1, @user1.sent_invitations.where(group_id: @group.id, email: @user2.primary_email).count
    assert_equal 1, @user2.received_invitations.where(group_id: @group.id).count

    # second should not work
    post_create(@user3.primary_email)
    assert_redirected_with_flash [FlashMessages::NO_INVITES], root_url
    assert_equal 0, @user1.sent_invitations.where(group_id: @group.id, email: @user3.primary_email).count
    assert_equal 0, @user3.received_invitations.where(group_id: @group.id).count

    # allow one more
    @group.update_attributes(invitations: 2)

    # sending to the same address should be a no-op for the received table
    post_create(@user2.primary_email)
    assert_equal 2, @user1.sent_invitations.where(group_id: @group.id, email: @user2.primary_email).count
    assert_equal 1, @user2.received_invitations.where(group_id: @group.id).count
  end

  private

  def post_create(email)
    post :create, name: @group.name, sent_invitations: { email: email }
  end
end
