require 'test_helper'

class StateMachineTest < ActiveSupport::TestCase

  def setup
    @group = Group.create!(name:                "the_group",
                           active:              true,
                           support_needed_rule: 10,
                           votes_needed_rule:   50,
                           yeses_needed_rule:   50)
    @user = User.create!(name: "stu", password: "test123", password_confirmation: "test123")
    primary = @user.email_addresses.create!(email: "stu@wespeakapp.com")
    @user.update_attributes(primary_email_address_id: primary.id)
  end

  #
  # alive to dead tests
  #

  test "expired should be killed" do
    statement = @group.create_statement(@user, :tagline)
    StateMachine.alive_to_dead(statement.expires_at + 1)
    statement.reload
    assert_equal StatementStates[:dead], statement.state
  end

  test "unexpired should not be killed" do
    statement = @group.create_statement(@user, :tagline)
    StateMachine.alive_to_dead(statement.expires_at)
    statement.reload
    assert_equal StatementStates[:alive], statement.state
  end

  #
  # alive to voting tests
  #

  test "not enough support should not be voting" do
    users = make_active_users(100)
    statement = @group.create_statement(users[0], :tagline)
    (Statement.num_needed(@group.active_members.count, @group.support_needed_rule) - 1).times do |i|
      statement.add_support(users[i])
    end
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    assert_equal StatementStates[:alive], statement.state
  end

  test "enough support should be voting" do
    users = make_active_users(100)
    statement = @group.create_statement(users[0], :tagline)
    Statement.num_needed(@group.active_members.count, @group.support_needed_rule).times do |i|
      statement.add_support(users[i])
    end
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    assert_equal StatementStates[:voting], statement.state
  end

  test "more than enough support should be voting" do
    users = make_active_users(100)
    statement = @group.create_statement(users[0], :tagline)
    (Statement.num_needed(@group.active_members.count, @group.support_needed_rule) + 1).times do |i|
      statement.add_support(users[i])
    end
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    assert_equal StatementStates[:voting], statement.state
  end

  #
  # end votes tests
  #

  test "not enough votes should be rejected" do
    users = make_active_users(100)
    statement = @group.create_statement(users[0], :tagline)
    Statement.num_needed(@group.active_members.count, @group.support_needed_rule).times do |i|
      statement.add_support(users[i])
    end
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    # voting now
    (Statement.num_needed(@group.active_members.count, @group.votes_needed_rule) - 1).times do |i|
      statement.cast_vote(users[i], Votes::YES)
    end
    StateMachine.end_votes(statement.vote_ends_at + 1)
    statement.reload
    assert_equal StatementStates[:rejected], statement.state
  end

  test "not enough yeses should be rejected" do
    users = make_active_users(100)
    statement = @group.create_statement(users[0], :tagline)
    Statement.num_needed(@group.active_members.count, @group.support_needed_rule).times do |i|
      statement.add_support(users[i])
    end
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    # voting now
    votes_needed = Statement.num_needed(@group.active_members.count, @group.votes_needed_rule)
    yeses_needed = Statement.num_needed(votes_needed, @group.yeses_needed_rule)
    (yeses_needed - 1).times do |i|
      statement.cast_vote(users[i], Votes::YES)
    end
    (votes_needed - (yeses_needed - 1)).times do |i|
      statement.cast_vote(users[(yeses_needed - 1) + i], Votes::NO)
    end
    StateMachine.end_votes(statement.vote_ends_at + 1)
    statement.reload
    assert_equal StatementStates[:rejected], statement.state
  end

  test "enough votes and yeses should be accepted" do
    users = make_active_users(100)
    statement = @group.create_statement(users[0], :tagline)
    Tagline.create!(statement_id: statement.id, tagline: "All of western thought")
    Statement.num_needed(@group.active_members.count, @group.support_needed_rule).times do |i|
      statement.add_support(users[i])
    end
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    # voting now
    votes_needed = Statement.num_needed(@group.active_members.count, @group.votes_needed_rule)
    yeses_needed = Statement.num_needed(votes_needed, @group.yeses_needed_rule)
    yeses_needed.times do |i|
      statement.cast_vote(users[i], Votes::YES)
    end
    (votes_needed - yeses_needed).times do |i|
      statement.cast_vote(users[yeses_needed + i], Votes::NO)
    end
    StateMachine.end_votes(statement.vote_ends_at + 1)
    statement.reload
    assert_equal StatementStates[:accepted], statement.state
  end

  test "accepted tagline updates" do
    GroupUserInfo.new(@group.name, nil, @user).make_member_active
    statement = @group.create_statement(@user, :tagline)
    tagline   = Tagline.create!(statement_id: statement.id, tagline: "All of western thought")
    statement.add_support(@user)
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    # voting now
    statement.cast_vote(@user, Votes::YES)
    StateMachine.end_votes(statement.vote_ends_at + 1)
    @group.reload    
    assert_equal tagline.tagline, @group.tagline
  end

  test "accepted lifespan updates" do
    accepted_rule_updates(:lifespan, Timespans::LIFESPAN_MIN)
  end

  test "accepted support needed updates" do
    accepted_rule_updates(:support_needed, Needed::SUPPORT_MIN)
  end

  test "accepted votespan updates" do
    accepted_rule_updates(:votespan, Timespans::VOTESPAN_MIN)
  end

  test "accepted votes needed updates" do
    accepted_rule_updates(:votes_needed, Needed::VOTES_MIN)
  end

  test "accepted yeses needed updates" do
    accepted_rule_updates(:yeses_needed, Needed::YESES_MIN)
  end

  test "accepted inactivity_timeout updates" do
    accepted_rule_updates(:inactivity_timeout, Timespans::INACTIVITY_TIMEOUT_MIN)
  end

  test "accepted invitations updates" do
    GroupUserInfo.new(@group.name, nil, @user).make_member_active
    statement = @group.create_statement(@user, :invitation)
    invitation= Invitation.create!(statement_id: statement.id, invitations: Invitations::MAX_PER_DAY)
    statement.add_support(@user)
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    # voting now
    statement.cast_vote(@user, Votes::YES)
    StateMachine.end_votes(statement.vote_ends_at + 1)
    @group.reload    
    assert_equal invitation.invitations, @group.invitations
  end

  test "add group email domain updates" do
    GroupUserInfo.new(@group.name, nil, @user).make_member_active
    statement = @group.create_statement(@user, :group_email_domain_change)
    GroupEmailDomainChange.create!(statement_id: statement.id, change_type: GroupEmailDomainChangeTypes[:add], domain: "wespeakapp.com")
    statement.add_support(@user)
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    # voting now
    statement.cast_vote(@user, Votes::YES)
    StateMachine.end_votes(statement.vote_ends_at + 1)
    @group.reload    
    assert @group.group_email_domains.exists?(domain: "wespeakapp.com")

    # another accepted statement wouldn't add the same domain again
    statement2 = @group.create_statement(@user, :group_email_domain_change)
    GroupEmailDomainChange.create!(statement_id: statement2.id, change_type: GroupEmailDomainChangeTypes[:add], domain: "wespeakapp.com")
    statement2.add_support(@user)
    StateMachine.alive_to_voting(Time.zone.now)
    statement2.reload
    # voting now
    statement2.cast_vote(@user, Votes::YES)
    StateMachine.end_votes(statement.vote_ends_at + 1)
    @group.reload    
    assert_equal 1, @group.group_email_domains.where(domain: "wespeakapp.com").count
  end

  test "remove group email domain updates" do
    GroupUserInfo.new(@group.name, nil, @user).make_member_active
    @group.group_email_domains.create!(domain: "wespeakapp.com")
    assert @group.group_email_domains.exists?(domain: "wespeakapp.com")
    
    statement = @group.create_statement(@user, :group_email_domain_change)
    GroupEmailDomainChange.create!(statement_id: statement.id, change_type: GroupEmailDomainChangeTypes[:remove], domain: "wespeakapp.com")
    statement.add_support(@user)
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    # voting now
    statement.cast_vote(@user, Votes::YES)
    StateMachine.end_votes(statement.vote_ends_at + 1)
    @group.reload    
    assert_not @group.group_email_domains.exists?(domain: "wespeakapp.com")

    # another accepted statement for the same domain wouldn't cause a problem
    statement2 = @group.create_statement(@user, :group_email_domain_change)
    GroupEmailDomainChange.create!(statement_id: statement2.id, change_type: GroupEmailDomainChangeTypes[:remove], domain: "wespeakapp.com")
    statement2.add_support(@user)
    StateMachine.alive_to_voting(Time.zone.now)
    statement2.reload
    # voting now
    statement2.cast_vote(@user, Votes::YES)
    StateMachine.end_votes(statement.vote_ends_at + 1)
    @group.reload
    assert_equal 0, @group.group_email_domains.count
  end

  test "remove all group email domain updates" do
    GroupUserInfo.new(@group.name, nil, @user).make_member_active
    @group.group_email_domains.create!(domain: "wespeakapp.com")
    @group.group_email_domains.create!(domain: "gmail.com")
    assert_equal 2, @group.group_email_domains.count
    
    statement = @group.create_statement(@user, :group_email_domain_change)
    GroupEmailDomainChange.create!(statement_id: statement.id, change_type: GroupEmailDomainChangeTypes[:remove_all], domain: "bogus.com")
    statement.add_support(@user)
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    # voting now
    statement.cast_vote(@user, Votes::YES)
    StateMachine.end_votes(statement.vote_ends_at + 1)
    @group.reload    
    assert_equal 0, @group.group_email_domains.count

    # another accepted statement when list is empty wouldn't cause a problem
    statement2 = @group.create_statement(@user, :group_email_domain_change)
    GroupEmailDomainChange.create!(statement_id: statement2.id, change_type: GroupEmailDomainChangeTypes[:remove_all], domain: "bogus.com")
    statement2.add_support(@user)
    StateMachine.alive_to_voting(Time.zone.now)
    statement2.reload
    # voting now
    statement2.cast_vote(@user, Votes::YES)
    StateMachine.end_votes(statement.vote_ends_at + 1)
    @group.reload
    assert_equal 0, @group.group_email_domains.count
  end

  #
  # expired memberships tests
  #

  test "expired membership should time out" do
    GroupUserInfo.new(@group.name, nil, @user).make_member_active
    StateMachine.expired_memberships(Time.zone.now + @group.inactivity_timeout_rule - 1.minute)
    assert_not_nil GroupUserInfo.new(@group.name, nil, @user).active_member
    StateMachine.expired_memberships(Time.zone.now + @group.inactivity_timeout_rule)
    assert_nil     GroupUserInfo.new(@group.name, nil, @user).active_member
  end

  test "nearly expired membership should be warned once" do
    GroupUserInfo.new(@group.name, nil, @user).make_member_active
    StateMachine.membership_warnings(Time.zone.now + (100 - Timespans::INACTIVITY_WARN_THRESHOLD) * @group.inactivity_timeout_rule / 100 - 1.minute)
    assert_not GroupUserInfo.new(@group.name, nil, @user).active_member.warned
    StateMachine.membership_warnings(Time.zone.now + (100 - Timespans::INACTIVITY_WARN_THRESHOLD) * @group.inactivity_timeout_rule / 100 + 1.minute)
    assert     GroupUserInfo.new(@group.name, nil, @user).active_member.warned

    # TODO, warn again a minute later and make sure another email doesn't go out
  end
    
  private

  def make_active_users(n)
    users = []
    n.times do |i|
      users[i] = User.create!(name: "#{i}", password: "test123", password_confirmation: "test123")
      primary = users[i].email_addresses.create!(email: "addr-#{i}@wespeakapp.com")
      users[i].update_attributes(primary_email_address_id: primary.id)
      GroupUserInfo.new(@group.name, nil, users[i]).make_member_active
    end
    users
  end

  def accepted_rule_updates(rule_type_key, value)
    GroupUserInfo.new(@group.name, nil, @user).make_member_active
    statement = @group.create_statement(@user, :rule)
    rule      = Rule.create!(statement_id: statement.id, rule_type: RuleTypes[rule_type_key], rule_value: value)
    statement.add_support(@user)
    StateMachine.alive_to_voting(Time.zone.now)
    statement.reload
    # voting now
    statement.cast_vote(@user, Votes::YES)
    StateMachine.end_votes(statement.vote_ends_at + 1)
    @group.reload    
    assert_equal value, @group.send(rule_type_key.to_s + "_rule")
  end
end
