require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  include GroupsHelper
  
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
    assert_redirected_with_flash [FlashMessages::GROUP_UNKNOWN], groups_path
  end

  test "edit for active group should redirect" do
    @group.update_attribute(:active, true)
    get_edit @group.id
    assert_redirected_with_flash [FlashMessages::GROUP_ACTIVE], groups_path
  end
  
  test "edit for another user's group should redirect" do
    other_user = User.create!(name:                  "Mike",
                              password:              "test123",
                              password_confirmation: "test123",
                              can_create_groups:     true)
    other_group = other_user.groups_i_created.create!(name: "other_group")
    get_edit other_group.id
    assert_redirected_with_flash [FlashMessages::USER_MISMATCH], groups_path
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
    assert_redirected_with_flash [FlashMessages::GROUP_UNKNOWN], groups_path
  end

  test "destroy for active group should redirect" do
    @group.update_attribute(:active, true)
    delete_destroy @group.id
    assert_redirected_with_flash [FlashMessages::GROUP_ACTIVE], groups_path
  end
  
  test "destroy for another user's group should redirect" do
    other_user = User.create!(name:                  "Mike",
                              password:              "test123",
                              password_confirmation: "test123",
                              can_create_groups:     true)
    other_group = other_user.groups_i_created.create!(name: "other_group")
    delete_destroy other_group.id
    assert_redirected_with_flash [FlashMessages::USER_MISMATCH], groups_path
  end

  test "destroy with valid params should work" do
    delete_destroy @group.id
    assert_redirected_with_flash [], groups_path
    assert_nil Group.find_by(id: @group.id)
  end

  #
  # new tests
  #

  test "new when not logged in should redirect" do
    log_out
    get_new
    assert_redirected_with_flash [FlashMessages::NOT_LOGGED_IN], root_url
  end

  test "new when cannot create groups should redirect" do
    @user.update_attribute(:can_create_groups, false)
    get_new
    assert_redirected_with_flash [FlashMessages::CANNOT_CREATE_GROUPS], root_url
  end

  test "new when logged in should render new" do
    get_new
    assert_template :new
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
      assert_rendered_with_flash [ValidationMessages::NAME_NOT_PRESENT], :new
    end
  end

  test "create with taken name should redirect" do
    post_create @group.name
    assert_rendered_with_flash [ValidationMessages::NAME_TAKEN], :new
  end

  test "create with too long name should redirect" do
    name = "a" * (Lengths::GROUP_NAME_MAX + 1)
    post_create name
    assert_rendered_with_flash [ValidationMessages::NAME_TOO_LONG], :new

    name = "a" * Lengths::GROUP_NAME_MAX
    post_create name
    assert_redirected_with_flash [FlashMessages::SUCCESS], root_url
    assert_not_nil Group.find_by(name: name)
  end

  test "create with bad format name should redirect" do
    ["has space", "has@symbol", "!#%&", "a<>b", "a::b", "a;;b"].each do |invalid_name|
      post_create invalid_name
      assert_rendered_with_flash [ValidationMessages::NAME_FORMATTING], :new
    end
  end

  test "create with valid name should redirect" do
    ["HELLO", "world", "12345", "1-2-3-4", "1_2_3_4", "a.b.c"].each do |valid_name|
      post_create valid_name
      assert_redirected_with_flash [FlashMessages::SUCCESS], root_url
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

  def delete_destroy(id)
    delete :destroy, id: id
  end

  def get_new
    get :new
  end

  def post_create(name)
    post :create, group: { name: name }
  end
end
