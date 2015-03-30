require 'test_helper'

class InvitationTest < ActiveSupport::TestCase

  include GroupsHelper
  
  test "statement_id should be present" do
    assert_not Invitation.new(invitations: 1).valid?
  end

  test "invitations should be in bounds" do
    assert_not Invitation.new(statement_id: 1, invitations: -2).valid?
    assert     Invitation.new(statement_id: 1, invitations: Invitations::NOT_REQUIRED).valid?
    (0..Invitations::MAX_PER_DAY).to_a.each { |i| assert Invitation.new(statement_id: 1, invitations: i).valid? }
    assert_not Invitation.new(statement_id: 1, invitations: Invitations::MAX_PER_DAY + 1).valid?
  end

end
