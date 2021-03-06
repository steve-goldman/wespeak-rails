require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  test "name should be present" do
    assert_not Group.new.valid?
    assert_not Group.new(name: "").valid?
    assert_not Group.new(name: "   ").valid?
  end

  test "invalid group names should not be valid" do
    ["has space", "has@symbol", "!#%&", "a<>b", "a::b", "a;;b"].each do |invalid_name|
      assert_not Group.new(name: invalid_name).valid?
    end
  end

  test "valid group names should be valid" do
    ["HELLO", "world", "12345", "1-2-3-4", "1_2_3_4"].each do |valid_name|
      assert Group.new(name: valid_name).valid?
    end
  end

  test "names should be case-insentively unique" do
    Group.create!(name: "HELLO")
    assert_not Group.new(name: "hello").valid?
  end

  test "name should not be too long" do
    assert_not Group.new(name: "a" * (Lengths::GROUP_NAME_MAX + 1)).valid?
    assert     Group.new(name: "a" * Lengths::GROUP_NAME_MAX).valid?
  end

  test "display name should not be too long" do
    assert_not Group.new(name: "test", display_name: "a" * (Lengths::GROUP_DISPLAY_NAME_MAX + 1)).valid?
    assert     Group.new(name: "test", display_name: "a" * Lengths::GROUP_DISPLAY_NAME_MAX).valid?
  end

  test "lifespan should be in bounds" do
    assert_not Group.new(name: "group", lifespan_rule: Timespans::LIFESPAN_MIN - 1).valid?
    assert     Group.new(name: "group", lifespan_rule: Timespans::LIFESPAN_MIN).valid?
    assert_not Group.new(name: "group", lifespan_rule: Timespans::LIFESPAN_MAX + 1).valid?
    assert     Group.new(name: "group", lifespan_rule: Timespans::LIFESPAN_MAX).valid?
  end

  test "votespan should be in bounds" do
    assert_not Group.new(name: "group", votespan_rule: Timespans::VOTESPAN_MIN - 1).valid?
    assert     Group.new(name: "group", votespan_rule: Timespans::VOTESPAN_MIN).valid?
    assert_not Group.new(name: "group", votespan_rule: Timespans::VOTESPAN_MAX + 1).valid?
    assert     Group.new(name: "group", votespan_rule: Timespans::VOTESPAN_MAX).valid?
  end

  test "inactivity timeout should be in bounds" do
    assert_not Group.new(name: "group", inactivity_timeout_rule: Timespans::INACTIVITY_TIMEOUT_MIN - 1).valid?
    assert     Group.new(name: "group", inactivity_timeout_rule: Timespans::INACTIVITY_TIMEOUT_MIN).valid?
    assert_not Group.new(name: "group", inactivity_timeout_rule: Timespans::INACTIVITY_TIMEOUT_MAX + 1).valid?
    assert     Group.new(name: "group", inactivity_timeout_rule: Timespans::INACTIVITY_TIMEOUT_MAX).valid?
  end

  test "support needed should be in bounds" do
    assert_not Group.new(name: "group", support_needed_rule: Needed::SUPPORT_MIN - 1).valid?
    assert     Group.new(name: "group", support_needed_rule: Needed::SUPPORT_MIN).valid?
    assert_not Group.new(name: "group", support_needed_rule: Needed::SUPPORT_MAX + 1).valid?
    assert     Group.new(name: "group", support_needed_rule: Needed::SUPPORT_MAX).valid?
  end

  test "votes needed should be in bounds" do
    assert_not Group.new(name: "group", votes_needed_rule: Needed::VOTES_MIN - 1).valid?
    assert     Group.new(name: "group", votes_needed_rule: Needed::VOTES_MIN).valid?
    assert_not Group.new(name: "group", votes_needed_rule: Needed::VOTES_MAX + 1).valid?
    assert     Group.new(name: "group", votes_needed_rule: Needed::VOTES_MAX).valid?
  end

  test "yeses needed should be in bounds" do
    assert_not Group.new(name: "group", yeses_needed_rule: Needed::YESES_MIN - 1).valid?
    assert     Group.new(name: "group", yeses_needed_rule: Needed::YESES_MIN).valid?
    assert_not Group.new(name: "group", yeses_needed_rule: Needed::YESES_MAX + 1).valid?
    assert     Group.new(name: "group", yeses_needed_rule: Needed::YESES_MAX).valid?
  end

  test "invitations should be in bounds" do
    assert_not Group.new(name: "group", invitations: -2).valid?
    assert_not Group.new(name: "group", invitations: Invitations::MAX_PER_DAY + 1).valid?

    assert     Group.new(name: "group", invitations: Invitations::NOT_REQUIRED).valid?
    (0..Invitations::MAX_PER_DAY).each do |n|
          assert     Group.new(name: "group", invitations: n).valid?
    end
  end

  test "locations should be in bounds" do
    assert_not Group.new(name: "group", latitude: -91, longitude: 50, radius: 50).valid?
    assert_not Group.new(name: "group", latitude:  91, longitude: 50, radius: 50).valid?

    assert_not Group.new(name: "group", latitude: 50,  longitude: -181, radius: 50).valid?
    assert_not Group.new(name: "group", latitude: 50,  longitude:  181, radius: 50).valid?

    assert_not Group.new(name: "group", latitude: 50,  longitude: 50, radius: -1).valid?

    assert     Group.new(name: "group", latitude: 50,  longitude: 50, radius: 50).valid?
  end

  test "locations should have all fields" do
    assert_not Group.new(name: "group",                longitude: 50, radius: 50).valid?
    assert_not Group.new(name: "group", latitude: 50,                 radius: 50).valid?
    assert_not Group.new(name: "group", latitude: 50,  longitude: 50            ).valid?
    assert     Group.new(name: "group", latitude: 50,  longitude: 50, radius: 50).valid?
  end

  test "invitations required since stuff" do
    group = Group.create!(name: "group", invitations: 1)
    assert_not_nil group.reload.invitations_required_since
    t0 = group.reload.invitations_required_since

    group.update_attributes(invitations: 2)
    assert_equal t0, group.reload.invitations_required_since

    group.update_attributes(invitations: Invitations::NOT_REQUIRED)
    assert_nil     group.reload.invitations_required_since
  end

end
