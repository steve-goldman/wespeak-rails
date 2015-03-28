require 'test_helper'

class StateMachineTest < ActiveSupport::TestCase

  def setup
    @group = Group.create!(name:                "the_group",
                           active:              true,
                           support_needed_rule: 10,
                           votes_needed_rule:   50,
                           yeses_needed_rule:   50)
    @user = User.create!(name: "stu", password: "test123", password_confirmation: "test123")
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

  private

  def make_active_users(n)
    users = []
    n.times do |i|
      users[i] = User.create!(name: "#{i}", password: "test123", password_confirmation: "test123")
      GroupUserInfo.new(@group.name, nil, users[i]).make_member_active
    end
    users
  end

end
