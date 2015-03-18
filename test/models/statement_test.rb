require 'test_helper'

class StatementTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Stu", password: "test123", password_confirmation: "test123")
    @user.save!
    @group = Group.new(name: "the_group")
    @group.save!
  end

  test "creating from user should work" do
    statement = @user.statements.create(group_id: @group.id, statement_type: StatementTypes[:email_domain_filter])
    assert statement.valid?, statement.errors.full_messages
    assert_equal @user.id,  statement.user_id
    assert_equal @group.id, statement.group_id
  end

  test "creating from group should work" do
    statement = @group.statements.create(user_id: @user.id, statement_type: StatementTypes[:email_domain_filter])
    assert statement.valid?, statement.errors.full_messages
    assert_equal @user.id,  statement.user_id
    assert_equal @group.id, statement.group_id
  end
end
