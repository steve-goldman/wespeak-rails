require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include UsersHelper

  def setup
    @user = User.create!(name: "user", password: "test123", password_confirmation: "test123")
  end

  #
  # new tests
  #

  test "new should render new" do
    get_new
    assert_template :new
  end

  test "new when logged in should redirect to root" do
    log_in @user
    get_new
    assert_redirected_with_flash [FlashMessages::LOGGED_IN], root_url
  end

  #
  # create tests
  #

  test "missing name in create alerts" do
    post_create "  ", "test123"
    assert_redirected_with_flash [ValidationMessages::NAME_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"
  end

  test "too long name in create alerts" do
    name = "a" * (Lengths::USER_NAME_MAX + 1)
    post_create name, "test123"
    assert_redirected_with_flash [ValidationMessages::NAME_TOO_LONG], root_url
    assert_user_not_exists name

    name = "a" * Lengths::USER_NAME_MAX
    post_create name, "test123"
    assert_redirected_with_flash [FlashMessages::USER_CREATED], root_url
    assert_user_exists name
  end

  test "name taken in create alerts" do
    post_create "user", "test123"
    assert_redirected_with_flash [ValidationMessages::NAME_TAKEN], root_url
  end

  test "too short password in create alerts" do
    new_password = "a" * (Lengths::PASSWORD_MIN - 1)
    post_create "Stu", new_password
    assert_redirected_with_flash [ValidationMessages::PASSWORD_LENGTH], root_url
    assert_user_not_exists "Stu"
  end

  test "too long password in create alerts" do
    new_password = "a" * (Lengths::PASSWORD_MAX + 1)
    post_create "Stu", new_password
    assert_redirected_with_flash [ValidationMessages::PASSWORD_LENGTH], root_url
    assert_user_not_exists "Stu"
  end

  test "password missing in create alerts" do
    post_create "Stu", nil
    assert_redirected_with_flash [ValidationMessages::PASSWORD_NOT_PRESENT, ValidationMessages::CONFIRMATION_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"
  end

  test "password blank in create alerts" do
    post_create "Stu", "        "
    assert_redirected_with_flash [ValidationMessages::PASSWORD_NOT_PRESENT, ValidationMessages::CONFIRMATION_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"
  end

  test "create with valid params should send email and redirect to root" do
    post_create "Stu", "test123"
    assert_redirected_with_flash [FlashMessages::USER_CREATED], root_url
    assert_user_exists "Stu"
  end

  test "create when logged in should redirect to root" do
    log_in @user
    post_create "Stu", "test123"
    assert_redirected_with_flash [FlashMessages::LOGGED_IN], root_url
    assert_user_not_exists "Stu"
  end

  private

  def get_new
    get :new
  end

  def post_create(name, password)
    post :create, user: { name: name, password: password }
  end

  def assert_user_exists(name)
    assert_not_nil User.find_by(name: name)
  end

  def assert_user_not_exists(name)
    assert_nil User.find_by(name: name)
  end

end
