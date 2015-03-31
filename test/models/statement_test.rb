require 'test_helper'

class StatementTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Stu", password: "test123", password_confirmation: "test123")
    @group = Group.create!(name: "the_group")
  end

  test "creating from user should work" do
    statement = @user.statements.create(group_id:       @group.id,
                                        statement_type: StatementTypes[:group_email_domain_change],
                                        state:          StatementStates[:alive])
    assert statement.valid?, statement.errors.full_messages
    assert_equal @user.id,  statement.user_id
    assert_equal @group.id, statement.group_id
  end

  test "creating from group should work" do
    statement = @group.statements.create(user_id:        @user.id,
                                         statement_type: StatementTypes[:group_email_domain_change],
                                         state:          StatementStates[:alive])
    assert statement.valid?, statement.errors.full_messages
    assert_equal @user.id,  statement.user_id
    assert_equal @group.id, statement.group_id
  end

  test "invalid type should not work" do
    assert_not @user.statements.new(group_id:       @group.id,
                                    statement_type: 999999,
                                    state:          StatementStates[:alive]).valid?
  end

  test "invalid state should not work" do
    assert_not @user.statements.new(group_id:       @group.id,
                                    statement_type: StatementTypes[:add_email_domain_filter],
                                    state:          999999).valid?
  end

    test "needed tests" do
    assert_equal 1, Statement.num_needed(1, 1)
    assert_equal 1, Statement.num_needed(1, 10)
    assert_equal 1, Statement.num_needed(1, 50)

    assert_equal 1, Statement.num_needed(2, 1)
    assert_equal 1, Statement.num_needed(2, 50)
    assert_equal 2, Statement.num_needed(2, 51)

    assert_equal 1, Statement.num_needed(10, 9)
    assert_equal 1, Statement.num_needed(10, 10)
    assert_equal 2, Statement.num_needed(10, 11)
    assert_equal 2, Statement.num_needed(10, 20)
    assert_equal 3, Statement.num_needed(10, 21)
  end
  
end
