require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  include GroupsHelper
  
  def setup
    @user = User.create!(name:                  "Stu",
                         password:              "test123",
                         password_confirmation: "test123",
                         can_create_groups:     true)
    log_in @user
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

  private

  def get_new
    get :new
  end

  def post_create(name)
    post :create, group: { name: name }
  end
end
