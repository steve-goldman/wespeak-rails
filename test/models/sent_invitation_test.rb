require 'test_helper'

class SentInvitationTest < ActiveSupport::TestCase

  test "user_id, group_id, and email address should be present" do
    assert_not SentInvitation.new(            group_id: 1, email: "hello@world.org").valid?
    assert_not SentInvitation.new(user_id: 1, group_id: 1).valid?
    assert     SentInvitation.new(user_id: 1, group_id: 1, email: "hello@world.org").valid?
  end

  test "email should not be blank" do
    assert     SentInvitation.new(user_id: 1, group_id: 1, email: "not@blank.org").valid?
    assert_not SentInvitation.new(user_id: 1, group_id: 1, email: "             ").valid?
    assert_not SentInvitation.new(user_id: 1, group_id: 1, email: "").valid?
  end

  test "invalid email address should not be valid" do
    %w[@hello.com s@ s@.com.com twodots@a..com].each do |invalid_address|
      assert_not SentInvitation.new(user_id: 1, group_id: 1, email: invalid_address).valid?,
                 "#{invalid_address.inspect} should not be valid"
    end
  end

  test "valid email should be valid" do
    %w[user@hello.com s@a.b S@com.COM 1@email.com two+s@a.c.o.m].each do |valid_address|
      assert SentInvitation.new(user_id: 1, group_id: 1, email: valid_address).valid?,
             "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be case-insensitively unique" do
    email_address = SentInvitation.create!(user_id: 1, group_id: 1, email: "valid@email.org").valid?
    assert_not      SentInvitation.new(user_id: 2, group_id: 1, email: "VaLiD@eMaIl.OrG").valid?
  end

  test "email should be saved as lower case" do
    email_address = SentInvitation.create!(user_id: 1, group_id: 1, email: "VALID@EMAIL.ORG")
    assert_equal "valid@email.org", email_address.reload.email
  end

  test "email should not be too long" do
    email = "a" * (Lengths::EMAIL_ADDR_MAX + 1 - "@email.addr".length) + "@email.addr"
    assert_not SentInvitation.new(user_id: 1, group_id: 1, email: email).valid?

    email = "a" * (Lengths::EMAIL_ADDR_MAX - "@email.addr".length) + "@email.addr"
    assert SentInvitation.new(user_id: 1, group_id: 1, email: email).valid?
  end
end
