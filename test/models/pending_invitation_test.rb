require 'test_helper'

class PendingInvitationTest < ActiveSupport::TestCase
  test "invitation should be waiting" do
    group = Group.create!(name: "the_group")
    group.activate
    group.send_invitation("stu@wespeakapp.com", false)

    user = User.create!(name: "Stu", password: "foobar", password_confirmation: "foobar")
    email_address = user.email_addresses.create!(email: "stu@wespeakapp.com")

    assert_not user.new_invitations.exists?(group_id: group.id)

    email_address.activate

    assert     user.new_invitations.exists?(group_id: group.id)
  end
end
