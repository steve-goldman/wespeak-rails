require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase

  include PasswordResetsHelper

  def setup
    @user = User.new(name: "Stu", password: "test123", password_confirmation: "test123")
    @user.create_password_reset_digest
    @user.save!
    @email_address = @user.email_addresses.create!(email: "hello@world.com", activated: true)
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

  test "missing email in create should render new" do
    post_create nil
    assert_rendered_with_flash [FlashMessages::EMAIL_MISSING], :new
  end

  test "unknown email in create should render new" do
    post_create "unknown@email.addr"
    assert_rendered_with_flash [FlashMessages::EMAIL_UNKNOWN], :new
  end

  test "inactive email in create should render new" do
    @email_address.update_attribute(:activated, false)
    post_create @email_address.email
    assert_rendered_with_flash [FlashMessages::EMAIL_NOT_ACTIVE], :new
  end

  test "valid submission in create should redirect to root" do
    post_create @email_address.email
    assert_redirected_with_flash [FlashMessages::EMAIL_SENT], root_url
  end
  
  test "create when logged in should redirect to root" do
    log_in @user
    post_create @email_address.email
    assert_redirected_with_flash [FlashMessages::LOGGED_IN], root_url
  end

  #
  # edit tests
  #

  test "missing email in edit should render new" do
    get_edit @user.password_reset_token, nil
    assert_rendered_with_flash [FlashMessages::EMAIL_MISSING], :new
  end

  test "unknown email in edit should render new" do
    get_edit @user.password_reset_token, "unknown@email.addr"
    assert_rendered_with_flash [FlashMessages::EMAIL_UNKNOWN], :new
  end

  test "inactive email in edit should render new" do
    @email_address.update_attribute(:activated, false)
    get_edit @user.password_reset_token, @email_address.email
    assert_rendered_with_flash [FlashMessages::EMAIL_NOT_ACTIVE], :new
  end

  test "expired token in edit should render new" do
    @user.update_attribute(:password_reset_sent_at, Time.zone.now - ExpirationTimes::password_reset_expiration)
    get_edit @user.password_reset_token, @email_address.email
    assert_rendered_with_flash [FlashMessages::TOKEN_EXPIRED], :new
  end

  test "valid params in edit should render edit" do
    get_edit @user.password_reset_token, @email_address.email
    assert_template :edit
  end
  
  test "edit when logged in should redirect to root" do
    log_in @user
    get_edit @user.password_reset_token, @email_address.email
    assert_redirected_with_flash [FlashMessages::LOGGED_IN], root_url
  end

  #
  # update tests
  #

  test "missing email in update should render new" do
    patch_update @user.password_reset_token, nil, nil, nil
    assert_rendered_with_flash [FlashMessages::EMAIL_MISSING], :new
  end

  test "unknown email in update should render new" do
    patch_update @user.password_reset_token, "unknown@email.addr", nil, nil
    assert_rendered_with_flash [FlashMessages::EMAIL_UNKNOWN], :new
  end

  test "inactive email in update should render new" do
    @email_address.update_attribute(:activated, false)
    patch_update @user.password_reset_token, @email_address.email, nil, nil
    assert_rendered_with_flash [FlashMessages::EMAIL_NOT_ACTIVE], :new
  end

  test "expired token in update should render new" do
    @user.update_attribute(:password_reset_sent_at, Time.zone.now - ExpirationTimes::password_reset_expiration)
    patch_update @user.password_reset_token, @email_address.email, nil, nil
    assert_rendered_with_flash [FlashMessages::TOKEN_EXPIRED], :new
  end

  test "missing password in update should render edit" do
    patch_update @user.password_reset_token, @email_address.email, nil, nil
    assert_rendered_with_flash [FlashMessages::PASSWORD_MISSING], :edit
  end

  test "blank password in update should render edit" do
    patch_update @user.password_reset_token, @email_address.email, "   ", nil
    assert_rendered_with_flash [FlashMessages::PASSWORD_BLANK], :edit
  end

  test "short password in update should render edit" do
    new_password = "a" * (Lengths::PASSWORD_MIN - 1)
    patch_update @user.password_reset_token, @email_address.email, new_password, new_password
    assert_rendered_with_flash [UsersHelper::ValidationMessages::PASSWORD_LENGTH], :edit
  end

  test "long password in update should render edit" do
    new_password = "a" * (Lengths::PASSWORD_MAX + 1)
    patch_update @user.password_reset_token, @email_address.email, new_password, new_password
    assert_rendered_with_flash [UsersHelper::ValidationMessages::PASSWORD_LENGTH], :edit
  end

  test "missing confirmation in update should render edit" do
    patch_update @user.password_reset_token, @email_address.email, "test123", "   "
    assert_rendered_with_flash [UsersHelper::ValidationMessages::CONFIRMATION_NOT_PRESENT], :edit
  end

  test "password mismatch in update should render edit" do
    patch_update @user.password_reset_token, @email_address.email, "test123", "test321"
    assert_rendered_with_flash [UsersHelper::ValidationMessages::CONFIRMATION_MISMATCH], :edit
  end

  test "valid submission in updateshould update password, log in, and redirect to root" do
    new_password = "test123"
    patch_update @user.password_reset_token, @email_address.email, new_password, new_password
    assert @user.authenticate(new_password), "password should be changed"
    assert_logged_in_as @user
    assert_redirected_with_flash [FlashMessages::SUCCESS], root_url
  end

  test "update when logged in should redirect to root" do
    log_in @user
    patch_update @user.password_reset_token, @email_address.email, "test123", "test123"
    assert_redirected_with_flash [FlashMessages::LOGGED_IN], root_url
  end

  
  private

  def get_new
    get :new
  end

  def post_create(email)
    post :create, password_reset: { email: email }
  end

  def get_edit(id, email)
    get :edit, id: id, password_reset: { email: email }
  end

  def patch_update(id, email, password, password_confirmation)
    patch :update, id: id, password_reset: { email: email, password: password, password_confirmation: password_confirmation }
  end
end
