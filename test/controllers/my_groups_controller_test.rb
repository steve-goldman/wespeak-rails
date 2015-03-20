require 'test_helper'

class MyGroupsControllerTest < ActionController::TestCase

  include MyGroupsHelper
  
  def setup
    @user = User.create!(name:                  "Stu",
                         password:              "test123",
                         password_confirmation: "test123",
                         can_create_groups:     true)
    log_in @user
    @group = @user.groups_i_created.create!(name: "added_group")
  end

  #
  # index tests
  #

  test "index when not logged in should redirect" do
    log_out
    get_index
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "index when cannot create groups should redirect" do
    @user.update_attribute(:can_create_groups, false)
    get_index
    assert_redirected_with_flash [FlashMessages::CANNOT_CREATE_GROUPS], root_url
  end

  #
  # edit tests
  #

  test "edit when not logged in should redirect" do
    log_out
    get_edit @group.id
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "edit when cannot create groups should redirect" do
    @user.update_attribute(:can_create_groups, false)
    get_edit @group.id
    assert_redirected_with_flash [FlashMessages::CANNOT_CREATE_GROUPS], root_url
  end

  test "edit for unknown group should redirect" do
    get_edit 999999
    assert_redirected_with_flash [FlashMessages::GROUP_UNKNOWN], my_groups_path
  end

  test "edit for active group should redirect" do
    @group.update_attribute(:active, true)
    get_edit @group.id
    assert_redirected_with_flash [FlashMessages::GROUP_ACTIVE], my_groups_path
  end
  
  test "edit for another user's group should redirect" do
    other_user = User.create!(name:                  "Mike",
                              password:              "test123",
                              password_confirmation: "test123",
                              can_create_groups:     true)
    other_group = other_user.groups_i_created.create!(name: "other_group")
    get_edit other_group.id
    assert_redirected_with_flash [FlashMessages::USER_MISMATCH], my_groups_path
  end

  test "edit with valid group should render edit" do
    get_edit @group.id
    assert_rendered_with_flash [], :edit
  end

  #
  # update tests
  #

  test "update when not logged in should redirect" do
    log_out
    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "update when cannot create groups should redirect" do
    @user.update_attribute(:can_create_groups, false)
    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::CANNOT_CREATE_GROUPS], root_url
  end

  test "update for unknown group should redirect" do
    patch_update(999999,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::GROUP_UNKNOWN], my_groups_path
  end

  test "update for active group should redirect" do
    @group.update_attribute(:active, true)
    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)

    assert_redirected_with_flash [FlashMessages::GROUP_ACTIVE], my_groups_path
  end
  
  test "update for another user's group should redirect" do
    other_user = User.create!(name:                  "Mike",
                              password:              "test123",
                              password_confirmation: "test123",
                              can_create_groups:     true)
    other_group = other_user.groups_i_created.create!(name: "other_group")
    patch_update(other_group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::USER_MISMATCH], my_groups_path
  end

  test "update with invalid lifespan alerts" do
    patch_update(@group.id,
                 Timespans::LIFESPAN_MIN - 1,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::LIFESPAN_DURATION], :edit

    patch_update(@group.id,
                 Timespans::LIFESPAN_MIN,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path

    patch_update(@group.id,
                 Timespans::LIFESPAN_MAX + 1,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::LIFESPAN_DURATION], :edit

    patch_update(@group.id,
                 Timespans::LIFESPAN_MAX,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path
  end

  test "update with invalid votespan alerts" do
    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 Timespans::VOTESPAN_MIN - 1,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::VOTESPAN_DURATION], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 Timespans::VOTESPAN_MIN,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 Timespans::VOTESPAN_MAX + 1,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::VOTESPAN_DURATION], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 Timespans::VOTESPAN_MAX,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path
  end

  test "update with invalid inactivity timeout alerts" do
    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 Timespans::INACTIVITY_TIMEOUT_MIN - 1)
    assert_rendered_with_flash [ValidationMessages::INACTIVITY_TIMEOUT_DURATION], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 Timespans::INACTIVITY_TIMEOUT_MIN)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 Timespans::INACTIVITY_TIMEOUT_MAX + 1)
    assert_rendered_with_flash [ValidationMessages::INACTIVITY_TIMEOUT_DURATION], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 Timespans::INACTIVITY_TIMEOUT_MAX)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path
  end

  test "update with invalid support needed alerts" do
    patch_update(@group.id,
                 @group.lifespan_rule,
                 Needed::SUPPORT_MIN - 1,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::SUPPORT_NEEDED_BOUNDS], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 Needed::SUPPORT_MIN,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path

    patch_update(@group.id,
                 @group.lifespan_rule,
                 Needed::SUPPORT_MAX + 1,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::SUPPORT_NEEDED_BOUNDS], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 Needed::SUPPORT_MAX,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path
  end
  
  test "update with invalid votes needed alerts" do
    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 Needed::VOTES_MIN - 1,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::VOTES_NEEDED_BOUNDS], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 Needed::VOTES_MIN,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 Needed::VOTES_MAX + 1,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::VOTES_NEEDED_BOUNDS], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 Needed::VOTES_MAX,
                 @group.yeses_needed_rule,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path
  end

  test "update with invalid yeses needed alerts" do
    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 Needed::YESES_MIN - 1,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::YESES_NEEDED_BOUNDS], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 Needed::YESES_MIN,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 Needed::YESES_MAX + 1,
                 @group.inactivity_timeout_rule)
    assert_rendered_with_flash [ValidationMessages::YESES_NEEDED_BOUNDS], :edit

    patch_update(@group.id,
                 @group.lifespan_rule,
                 @group.support_needed_rule,
                 @group.votespan_rule,
                 @group.votes_needed_rule,
                 Needed::YESES_MAX,
                 @group.inactivity_timeout_rule)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path
  end

  test "update with valid params updates params" do
    patch_update(@group.id,
                 Timespans::LIFESPAN_MIN,
                 Needed::SUPPORT_MIN,
                 Timespans::VOTESPAN_MIN,
                 Needed::VOTES_MIN,
                 Needed::YESES_MIN,
                 Timespans::INACTIVITY_TIMEOUT_MIN)
    assert_redirected_with_flash [FlashMessages::UPDATE_SUCCESS], my_groups_path

    @group.reload

    assert_equal Timespans::LIFESPAN_MIN,           @group.lifespan_rule 
    assert_equal Needed::SUPPORT_MIN,               @group.support_needed_rule
    assert_equal Timespans::VOTESPAN_MIN,           @group.votespan_rule
    assert_equal Needed::VOTES_MIN,                 @group.votes_needed_rule
    assert_equal Needed::YESES_MIN,                 @group.yeses_needed_rule
    assert_equal Timespans::INACTIVITY_TIMEOUT_MIN, @group.inactivity_timeout_rule 
  end

  #
  # destroy tests
  #

  test "destroy when not logged in should redirect" do
    log_out
    delete_destroy @group.id
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "destroy when cannot create groups should redirect" do
    @user.update_attribute(:can_create_groups, false)
    delete_destroy @group.id
    assert_redirected_with_flash [FlashMessages::CANNOT_CREATE_GROUPS], root_url
  end

  test "destroy for unknown group should redirect" do
    delete_destroy 999999
    assert_redirected_with_flash [FlashMessages::GROUP_UNKNOWN], my_groups_path
  end

  test "destroy for active group should redirect" do
    @group.update_attribute(:active, true)
    delete_destroy @group.id
    assert_redirected_with_flash [FlashMessages::GROUP_ACTIVE], my_groups_path
  end
  
  test "destroy for another user's group should redirect" do
    other_user = User.create!(name:                  "Mike",
                              password:              "test123",
                              password_confirmation: "test123",
                              can_create_groups:     true)
    other_group = other_user.groups_i_created.create!(name: "other_group")
    delete_destroy other_group.id
    assert_redirected_with_flash [FlashMessages::USER_MISMATCH], my_groups_path
  end

  test "destroy with valid params should work" do
    delete_destroy @group.id
    assert_redirected_with_flash [], my_groups_path
    assert_nil Group.find_by(id: @group.id)
  end

  #
  # create tests
  #

  test "create when not logged in should redirect" do
    log_out
    post_create "group_name"
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "create when cannot create groups should redirect" do
    @user.update_attribute(:can_create_groups, false)
    post_create "group_name"
    assert_redirected_with_flash [FlashMessages::CANNOT_CREATE_GROUPS], root_url
  end

  test "create with missing name should redirect" do
    [nil, "", "   "].each do |missing_name|
      post_create missing_name
      assert_rendered_with_flash [ValidationMessages::NAME_NOT_PRESENT], :index
    end
  end

  test "create with taken name should redirect" do
    post_create @group.name
    assert_rendered_with_flash [ValidationMessages::NAME_TAKEN], :index
  end

  test "create with too long name should redirect" do
    name = "a" * (Lengths::GROUP_NAME_MAX + 1)
    post_create name
    assert_rendered_with_flash [ValidationMessages::NAME_TOO_LONG], :index

    name = "a" * Lengths::GROUP_NAME_MAX
    post_create name
    assert_redirected_with_flash [FlashMessages::CREATE_SUCCESS], my_groups_path
    assert_not_nil Group.find_by(name: name)
  end

  test "create with bad format name should redirect" do
    ["has space", "has@symbol", "!#%&", "a<>b", "a::b", "a;;b"].each do |invalid_name|
      post_create invalid_name
      assert_rendered_with_flash [ValidationMessages::NAME_FORMATTING], :index
    end
  end

  test "create with valid name should redirect" do
    ["HELLO", "world", "12345", "1-2-3-4", "1_2_3_4", "a.b.c"].each do |valid_name|
      post_create valid_name
      assert_redirected_with_flash [FlashMessages::CREATE_SUCCESS], my_groups_path
      assert_not_nil Group.find_by(name: valid_name)
    end
  end

  private

  def get_index
    get :index
  end

  def get_edit(id)
    get :edit, id: id
  end

  def patch_update(id, lifespan, support_needed, votespan, votes_needed, yeses_needed, inactivity_timeout)
    patch :update, id: id, my_group: { lifespan_rule:           lifespan,
                                       support_needed_rule:     support_needed,
                                       votespan_rule:           votespan,
                                       votes_needed_rule:       votes_needed,
                                       yeses_needed_rule:       yeses_needed,
                                       inactivity_timeout_rule: inactivity_timeout }
  end

  def delete_destroy(id)
    delete :destroy, id: id
  end

  def post_create(name)
    post :create, group: { name: name }
  end
end
