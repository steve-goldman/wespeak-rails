require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include UsersHelper

  def setup
    @user = User.new(name: "user", password: "test123", password_confirmation: "test123")
    @user.save!
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

  test "missing email in create alerts" do
    post_create "Stu", nil, "test123", "test123"
    assert_redirected_with_flash [ValidationMessages::EMAIL_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"

    post_create "Stu", "    ", "test123", "test123"
    assert_redirected_with_flash [ValidationMessages::EMAIL_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"
  end
  
  test "email too long in create alerts" do
    email = "a" * (Lengths::EMAIL_ADDR_MAX + 1 - "@world.org".length) + "@world.org"
    post_create "Stu", email, "test123", "test123"
    assert_redirected_with_flash [ValidationMessages::EMAIL_TOO_LONG], root_url
    assert_user_not_exists "Stu"

    email = "a" * (Lengths::EMAIL_ADDR_MAX - "@world.org".length) + "@world.org"
    post_create "Stu", email, "test123", "test123"
    assert_redirected_with_flash [FlashMessages::EMAIL_SENT], root_url
    assert_user_exists "Stu"
  end

  test "bad email formatting in create alerts" do
    post_create "Stu", "hello@", "test123", "test123"
    assert_redirected_with_flash [ValidationMessages::EMAIL_FORMATTING], root_url
    assert_user_not_exists "Stu"
  end

  test "email taken in create alerts" do
    EmailAddress.new(user_id: @user.id, email: "hello@world.org").save!
    post_create "Stu", "hello@world.org", "test123", "test123"
    assert_redirected_with_flash [ValidationMessages::EMAIL_TAKEN], root_url
    assert_user_not_exists "Stu"
  end

  test "missing name in create alerts" do
    post_create "  ", "hello@world.org", "test123", "test123"
    assert_redirected_with_flash [ValidationMessages::NAME_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"
  end

  test "too long name in create alerts" do
    name = "a" * (Lengths::USER_NAME_MAX + 1)
    post_create name, "hello@world.org", "test123", "test123"
    assert_redirected_with_flash [ValidationMessages::NAME_TOO_LONG], root_url
    assert_user_not_exists name

    name = "a" * Lengths::USER_NAME_MAX
    post_create name, "hello@world.org", "test123", "test123"
    assert_redirected_with_flash [FlashMessages::EMAIL_SENT], root_url
    assert_user_exists name
  end

  test "name taken in create alerts" do
    post_create "user", "hello@world.org", "test123", "test123"
    assert_redirected_with_flash [ValidationMessages::NAME_TAKEN], root_url
  end

  test "too short password in create alerts" do
    new_password = "a" * (Lengths::PASSWORD_MIN - 1)
    post_create "Stu", "hello@world.org", new_password, new_password
    assert_redirected_with_flash [ValidationMessages::PASSWORD_LENGTH], root_url
    assert_user_not_exists "Stu"
  end

  test "too long password in create alerts" do
    new_password = "a" * (Lengths::PASSWORD_MAX + 1)
    post_create "Stu", "hello@world.org", new_password, new_password
    assert_redirected_with_flash [ValidationMessages::PASSWORD_LENGTH], root_url
    assert_user_not_exists "Stu"
  end

  test "password missing in create alerts" do
    post_create "Stu", "hello@world.org", nil, nil
    assert_redirected_with_flash [ValidationMessages::PASSWORD_NOT_PRESENT, ValidationMessages::CONFIRMATION_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"
  end

  test "password blank in create alerts" do
    post_create "Stu", "hello@world.org", "        ", "        "
    assert_redirected_with_flash [ValidationMessages::PASSWORD_NOT_PRESENT, ValidationMessages::CONFIRMATION_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"
  end

  test "confirmation missing in create alerts" do
    post_create "Stu", "hello@world.org", "test123", nil
    assert_redirected_with_flash [ValidationMessages::CONFIRMATION_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"

    post_create "Stu", "hello@world.org", "test123", "    "
    assert_redirected_with_flash [ValidationMessages::CONFIRMATION_NOT_PRESENT], root_url
    assert_user_not_exists "Stu"
end

  test "confirmation mismatch in create alerts" do
    post_create "Stu", "hello@world.org", "test123", "test321"
    assert_redirected_with_flash [ValidationMessages::CONFIRMATION_MISMATCH], root_url
    assert_user_not_exists "Stu"
  end
  
  test "create with valid params should send email and redirect to root" do
    post_create "Stu", "hello@world.org", "test123", "test123"
    # TODO: how to assert the email was sent?
    assert_redirected_with_flash [FlashMessages::EMAIL_SENT], root_url
    assert_user_exists "Stu"
  end

  test "create when logged in should redirect to root" do
    log_in @user
    post_create "Stu", "hello@world.org", "test123", "test123"
    assert_redirected_with_flash [FlashMessages::LOGGED_IN], root_url
    assert_user_not_exists "Stu"
  end

  private

  def get_new
    get :new
  end

  def post_create(name, email, password, password_confirmation)
    post :create, user: { name: name, email: email, password: password, password_confirmation: password_confirmation }
  end

  def assert_user_exists(name)
    assert_not_nil User.find_by(name: name)
  end

  def assert_user_not_exists(name)
    assert_nil User.find_by(name: name)
  end

end
